--- AppService - возвращает параметры цены

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

    -- проверка преданного idStock - тикера инструмента
    checkingId = function(self, idStock)
        if not_string(idStock) then
            error("\r\n" .. "Error: Id (бумаги) должен быть (строкой). Получено: (" .. type(idStock) .. ") - (" .. tostring(idStock) .. ")", 3)
        end
    end,

    -- проверка переданного класса
    checkingClass = function(self, class)
        if not_string(class) then
            error("\r\n" .. "Error: Class (бумаги) должен быть (строкой). Получено: (" .. type(class) .. ") - (" .. tostring(class) .. ")", 3)
        end
    end,

    -- вернуть лучшие цены покупки и продажи
    getGoodPrices = function(self, idStock, class)
        self:checkingId(idStock)
        self:checkingClass(class)

        local prices = {
            buyPrice = d0(getParamEx(class, idStock, "BID").param_value),
            sellPrice = d0(getParamEx(class, idStock, "OFFER").param_value),
        }

        return prices
    end,

    -- вернуть минимальную и максимальную цену
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

    -- вернуть последнюю цену инструмента
    getLastPrice = function(self, idStock, class)
        self:checkingId(idStock)
        self:checkingClass(class)

        return d0(tonumber(getParamEx(class, idStock, "last").param_value))
    end,

    -- вернуть цену hi low предыдущего дня
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
