--- AppService - ���������� ��������� ����

local AppService = {
    --
    name = "AppService_ServicePrices",

    --
    storage = {},

    --
    serviceCorrectPrice = {},

    --
    entityServiceDsD = {},

    --
    new = function(self, container)
        self.storage = container:get("Storage")
        self.serviceCorrectPrice = container:get("DomainService_CorrectPrice")
        self.entityServiceDsD = container:get("EntityService_DsD")

        return self
    end,

    -- �������� ���������� idStock - ������ �����������
    checkingId = function(self, idStock)
        if not_string(idStock) then
            error("\r\n" .. "Error: Id (������) ������ ���� (�������). ��������: (" .. type(idStock) .. ") - (" .. tostring(idStock) .. ")", 3)
        end
    end,

    -- �������� ����������� ������
    checkingClass = function(self, class)
        if not_string(class) then
            error("\r\n" .. "Error: Class (������) ������ ���� (�������). ��������: (" .. type(class) .. ") - (" .. tostring(class) .. ")", 3)
        end
    end,

    -- ������� ������ ���� ������� � �������
    getGoodPrices = function(self, idStock, class)
        self:checkingId(idStock)
        self:checkingClass(class)

        local prices = {
            buyPrice = d0(getParamEx(class, idStock, "BID").param_value),
            sellPrice = d0(getParamEx(class, idStock, "OFFER").param_value),
        }

        return prices
    end,

    -- ������� ����������� � ������������ ����
    getMinMaxPrices = function(self, idStock, class)
        self:checkingId(idStock)
        self:checkingClass(class)

        local interval = self.storage:getIntervalToId(idStock)
        local step = interval / 2

        local maxPrice = getParamEx(class, idStock, "PRICEMAX").param_value - step
        local minPrice = getParamEx(class, idStock, "PRICEMIN").param_value + step

        local prices = {
            maxPrice = self.serviceCorrectPrice:getPriceSell(idStock, class, maxPrice),
            minPrice = self.serviceCorrectPrice:getPriceBuy(idStock, class, minPrice),
        }

        return prices
    end,

    -- ������� ��������� ���� �����������
    getLastPrice = function(self, idStock, class)
        self:checkingId(idStock)
        self:checkingClass(class)

        return d0(tonumber(getParamEx(class, idStock, "last").param_value))
    end,

    -- ������� ���� hi low ����������� ���
    getPricesHiLow = function(self, idStock)
        self:checkingId(idStock)

        local prices = {
            buyPrice = self.entityServiceDsD:getHiLowClosePreviousBar(idStock).hi,
            sellPrice = self.entityServiceDsD:getHiLowClosePreviousBar(idStock).low,
        }

        return prices
    end
}

return AppService
