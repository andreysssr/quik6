--- Entity Params

local Entity = {
    --
    name = "Entity_Params",

    -- ����������� ��� ���������� ���������� �����
    -- ��� ��������� � ������������ ����������� ����� ��� �������
    ratio = 0,

    -- ������ �������� ������������� ���������� �����
    serviceMaxLots = {},

    -- ������ ������� ����
    serviceBasePrice = {},

    -- ������ ��������� ����
    serviceCorrectPrice = {},

    -- ��������� ��� �������
    settingZapros = {},

    -- ��������� ��� ����� ������� ��� - StopOrderLimit
    settingZaprosOffset = {},

    -- ��������� ��� �����
    settingStop = {},

    -- ��������� ��� �������� �����
    settingStopMove = {},

    -- ��������� ��� �����
    settingTake = {},

    --
    validator = {},

    --
    new = function(self, container)
        self.ratio = container:get("Config_ratio")
        self.serviceMaxLots = container:get("DomainService_CalculateMaxLots")
        self.serviceBasePrice = container:get("DomainService_GetBasePrice")
        self.serviceCorrectPrice = container:get("DomainService_CorrectPrice")

        self.settingZapros = container:get("config").zapros
        self.settingZaprosOffset = container:get("config").zaprosOffset
        self.settingStop = container:get("config").stop
        self.settingStopMove = container:get("config").stopMove
        self.settingTake = container:get("config").take

        self.validator = container:get("AppService_Validator")

        local trait = container:get("Entity_TraitEvent")
        extended(self, trait)

        return self
    end,

    --
    newChild = function(self, params)
        local object = {
            id = params.idStock,
            class = params.class,

            basePrice = {},

            data = {},

            events = {},

            -- ������������� ������ ��������
            tmpResult = {
                zapros = {},
                stop = {},
                stopMove = {},
                take = {},
            },
        }

        extended(object, self)

        return object
    end,

    -- ������� id Entity_Params - "SBER"
    getId = function(self)
        return self.id
    end,

    -- ������� �����
    getClass = function(self)
        return self.class
    end,

    -- ������������ ������ ����� �������� ���������
    recoveryParams = function(self, params)
        self.data = params
    end,

    -- ��������� ��� ��������� �� ������
    hasParams = function(self)
        if not_empty(self.data) then
            return true
        end

        return false
    end,

    -- ������� ��������� ��� id
    getParamsZapros = function(self)
        if self:hasParams() then
            return copy(self.data.zapros)
        end

        -- ���� ������ ��� ����� id ��� - ����� ������ ������
        return {}
    end,

    -- ������� ��������� ��� id
    getParamsStop = function(self)
        if self:hasParams() then
            return copy(self.data.stop)
        end

        -- ���� ������ ��� - ����� ������ ������
        return {}
    end,

    -- ������� ��������� ���
    getParamsStopMove = function(self)
        if self:hasParams() then
            return copy(self.data.stopMove)
        end

        -- ���� ������ ��� - ����� ������ ������
        return {}
    end,

    -- ������� ��������� ���
    getParamsTake = function(self)
        if self:hasParams() then
            return copy(self.data.take)
        end

        -- ���� ������ ��� - ����� ������ ������
        return {}
    end,

    -- ������� ��������� ���
    getParams = function(self)
        if self:hasParams() then
            return copy(self.data)
        end

        -- ���� ������ ��� - ����� ������ ������
        return {}
    end,

    -- ���������� ��������������� �������� ��������
    getReverseOperation = function(self, operation)
        self.validator:check_buy_sell(operation)

        if operation == "sell" then
            return "buy"
        end

        if operation == "buy" then
            return "sell"
        end

        return operation
    end,

    -- ��������� ������� ���� ��� �������
    -- ������������ � (updateParams) - ����� ��������
    updateBasePrice = function(self)
        self.basePrice = self.serviceBasePrice:getBasePrice(self.id)

        if empty(self.basePrice) then
            error("\r\n" .. "Error: ����������� ��������� (BasePrice) ��� ����������� (" .. self.id .. ")")
        end
    end,

    -- ���������� ��������� ��� �������
    -- range = 0, 5, 10,
    calculateParamsZapros = function(self, operation, range)
        self.validator:check_buy_sell(operation)
        self.validator:checkRange(range)

        -- �������� ������� ����� ���� ���������
        local partStepInterval = self.basePrice.interval / 8 / 10

        -- �������� ����-���� �������� ����������
        local price = self.basePrice.price + (partStepInterval * self.settingZapros[operation][range])
        local stopPrice = self.basePrice.price + (partStepInterval * self.settingZaprosOffset[operation][range])

        local marketPrice = 0

        -- ������������ ���� �� ���� �����������
        if operation == "buy" then
            price = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, price)
            stopPrice = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, stopPrice)

            marketPrice = price + (self.basePrice.interval / 2)
            marketPrice = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, marketPrice)
        else
            price = self.serviceCorrectPrice:getPriceSell(self.id, self.class, price)
            stopPrice = self.serviceCorrectPrice:getPriceSell(self.id, self.class, stopPrice)

            marketPrice = price - (self.basePrice.interval / 2)
            marketPrice = self.serviceCorrectPrice:getPriceSell(self.id, self.class, marketPrice)
        end

        -- ��������� ���������
        self.tmpResult.zapros.price = d0(price)
        self.tmpResult.zapros.stopPrice = d0(stopPrice)
        self.tmpResult.zapros.marketPrice = d0(marketPrice)
        self.tmpResult.zapros.operation = operation
    end,

    -- ���������� ��������� ��� �����
    calculateParamStop = function(self, operation, range)
        -- �������� ������� ����� ���� ���������
        local partStepInterval = self.basePrice.interval / 8 / 10

        -- �������� ����-���� �������� ����������
        local stopPrice = self.basePrice.price + (partStepInterval * self.settingStop[operation][range])
        local price = 0

        -- �������� ����� �������������� ��������
        local _operation = self:getReverseOperation(operation)

        -- ������������ ���� �� ���� �����������
        if _operation == "buy" then
            stopPrice = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, stopPrice)

            price = self.basePrice.price + (self.basePrice.interval / 2)
            price = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, price)
        else
            stopPrice = self.serviceCorrectPrice:getPriceSell(self.id, self.class, stopPrice)

            price = self.basePrice.price - (self.basePrice.interval / 2)
            price = self.serviceCorrectPrice:getPriceSell(self.id, self.class, price)
        end

        -- ��������� ���������
        self.tmpResult.stop.stopPrice = d0(stopPrice)
        self.tmpResult.stop.price = d0(price)
        self.tmpResult.stop.operation = _operation
    end,

    -- ���������� ��������� ��� �������� �����
    calculateParamStopMove = function(self, operation, range)
        -- �������� ������� ����� ���� ���������
        local partStepInterval = self.basePrice.interval / 8 / 10

        -- �������� ����-���� �������� ����������
        local stopPrice = self.basePrice.price + (partStepInterval * self.settingStopMove[operation][range])
        local price = 0

        -- �������� ����� �������������� ��������
        local _operation = self:getReverseOperation(operation)

        -- ������������ ���� �� ���� �����������
        if _operation == "buy" then
            stopPrice = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, stopPrice)

            price = self.basePrice.price + (self.basePrice.interval / 2)
            price = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, price)
        else
            stopPrice = self.serviceCorrectPrice:getPriceSell(self.id, self.class, stopPrice)

            price = self.basePrice.price - (self.basePrice.interval / 2)
            price = self.serviceCorrectPrice:getPriceSell(self.id, self.class, price)
        end

        -- ��������� ���������
        self.tmpResult.stopMove.stopPrice = d0(stopPrice)
        self.tmpResult.stopMove.price = d0(price)
        self.tmpResult.stopMove.operation = _operation
    end,

    -- ���������� ��������� ��� �����
    calculateParamTake = function(self, operation)
        -- �������� ��� ���������
        local stepInterval = self.basePrice.interval / 8

        -- �������� ����� ���� ���������
        local partStepInterval = self.basePrice.interval / 8 / 10

        -- �������� ����-���� �������� ����������
        local price = {}

        for i = 2, 10 do
            price[i] = self.basePrice.price + (stepInterval * self.settingTake[operation][i])
        end

        -- �������� ����� �������������� ��������
        local _operation = self:getReverseOperation(operation)

        -- ������������ ���� �� ���� �����������
        if _operation == "buy" then
            for i = 2, 10 do
                price[i] = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, price[i] + (partStepInterval * self.settingTake.offsetPartStepInterval))
            end
        else
            for i = 2, 10 do
                price[i] = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, price[i] - (partStepInterval * self.settingTake.offsetPartStepInterval))
            end
        end

        -- �������� ������ ���� ��� ������� �����
        -- �������� ���� ��� ����� �����
        for i = 2, 10 do
            price[i] = d0(price[i])
        end

        -- ��������� ���������
        self.tmpResult.take.price = price
        self.tmpResult.take.operation = _operation
    end,

    -- ��������� ���������� �������� ��� ���������� idParams
    _saveResult = function(self, idParams)
        self.data[idParams] = copy(self.tmpResult)

        self.tmpResult = {
            zapros = {},
            stop = {},
            stopMove = {},
            take = {},
        }
    end,

    -- ��������� ���������� �������� ��� ���������� idParams
    saveResult = function(self)
        self.data = copy(self.tmpResult)

        self.tmpResult = {
            zapros = {},
            stop = {},
            stopMove = {},
            take = {},
        }

        self:registerEvent("EntityParams_UpdatedParams", {
            idStock = self.id,
        })
    end,

    -- ������� ������
    resetResult = function(self)
        self.data = {}
    end,

    -- ���������� ������ �� ������� ����
    -- operation - "buy", "sell
    -- range - 0, 5, 10
    calculateParams = function(self, operation, range)
        -- ��������� idParams
        self.validator:check_buy_sell(operation)
        self.validator:checkRange(range)

        -- ��������� ��������� (basePrice) ��� ��������
        self:updateBasePrice()

        -- buy, 5 (������)
        -- ���������� ��������� ��� �������
        self:calculateParamsZapros(operation, range)

        -- sell, 5 (������� ����)
        -- ���������� ��������� ��� �����
        self:calculateParamStop(operation, range)

        -- sell, 5 (������� ���� ����)
        -- ���������� ��������� ��� �������� �����
        self:calculateParamStopMove(operation, range)

        -- sell, (������� ���� �� ������ �����)
        -- ���������� � ���������� ��������� � take
        self:calculateParamTake(operation)

        -- ��������� ���������� ������� ��� idParams
        self:saveResult()
    end,

    -- ���������� ��������� ��� ������� �� ���������� ���� �������
    -- ��� �������� ���� - ��������� ���� ������
    -- ��� ������ ���� ������ - ������ ���� �� ������� (���� ask, bid)
    calculateParamsZaprosToPrice = function(self, operation, price)
        self.validator:check_buy_sell(operation)

        -- �������� ������� ����� ���� ���������
        local partStepInterval = self.basePrice.interval / 8 / 10

        -- �������� ����-���� �������� ����������
        local stopPrice = price + (partStepInterval * self.settingZaprosOffset.offset[operation])

        local marketPrice = 0

        local priceLoc

        -- ������������ ���� �� ���� �����������
        if operation == "buy" then
            priceLoc = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, price)
            stopPrice = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, stopPrice)

            marketPrice = price + (self.basePrice.interval / 2)
            marketPrice = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, marketPrice)
        else
            priceLoc = self.serviceCorrectPrice:getPriceSell(self.id, self.class, price)
            stopPrice = self.serviceCorrectPrice:getPriceSell(self.id, self.class, stopPrice)

            marketPrice = price - (self.basePrice.interval / 2)
            marketPrice = self.serviceCorrectPrice:getPriceSell(self.id, self.class, marketPrice)
        end

        -- ��������� ���������
        self.tmpResult.zapros.price = d0(priceLoc)
        self.tmpResult.zapros.stopPrice = d0(stopPrice)
        self.tmpResult.zapros.marketPrice = d0(marketPrice)
        self.tmpResult.zapros.operation = operation
    end,

    -- ���������� ��������� ��� ����� �� ���������� ���� �������
    calculateParamStopToPrice = function(self, operation, priceZapros)
        -- ���� ���������� �� 7% �� ���� ������� � ��������������� �������

        -- �������� ������� ����� ���� ���������
        local partStepInterval = self.basePrice.interval / 8 / 10

        -- ��� ������� buy - ����� price - 11%, sell
        -- ��� ������� sell - ����� price + 11%, buy
        local stopPrice = priceZapros + (partStepInterval * self.settingStop["size"][operation])
        local price = 0

        -- �������� ����� �������������� ��������
        local _operation = self:getReverseOperation(operation)

        -- ������������ ���� �� ���� �����������
        if _operation == "buy" then
            stopPrice = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, stopPrice)

            price = priceZapros + (self.basePrice.interval / 2)
            price = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, price)
        else
            stopPrice = self.serviceCorrectPrice:getPriceSell(self.id, self.class, stopPrice)

            price = priceZapros - (self.basePrice.interval / 2)
            price = self.serviceCorrectPrice:getPriceSell(self.id, self.class, price)
        end

        -- ��������� ���������
        self.tmpResult.stop.stopPrice = d0(stopPrice)
        self.tmpResult.stop.price = d0(price)
        self.tmpResult.stop.operation = _operation
    end,

    -- ���������� ��������� ��� �������� ����� �� ���������� ���� �������
    -- ������������ ��� �������� � ���������
    calculateParamStopMoveToPrice = function(self, operation, priceZapros)
        -- ���� ���������� �� 2% �� ���� ������� � �� �� �������

        -- �������� ������� ����� ���� ���������
        local partStepInterval = self.basePrice.interval / 8 / 10

        -- ��� ������� buy - ����� price + 2%, sell
        -- ��� ������� sell - ����� price - 2%, buy
        local stopPrice = priceZapros + (partStepInterval * self.settingStopMove["size"][operation])
        local price = 0

        -- �������� ����� �������������� ��������
        local _operation = self:getReverseOperation(operation)

        -- ������������ ���� �� ���� �����������
        if _operation == "buy" then
            stopPrice = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, stopPrice)

            price = priceZapros + (self.basePrice.interval / 2)
            price = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, price)
        else
            stopPrice = self.serviceCorrectPrice:getPriceSell(self.id, self.class, stopPrice)

            price = priceZapros - (self.basePrice.interval / 2)
            price = self.serviceCorrectPrice:getPriceSell(self.id, self.class, price)
        end

        -- ��������� ���������
        self.tmpResult.stopMove.stopPrice = d0(stopPrice)
        self.tmpResult.stopMove.price = d0(price)
        self.tmpResult.stopMove.operation = _operation
    end,

    -- ���������� ��������� ��� ����� �� ���������� ���� �������
    calculateParamTakeToPrice = function(self, operation, priceZapros)
        -- �������� ��� ���������
        local stepInterval = self.basePrice.interval / 8

        -- �������� ������� ����� ���� ���������
        local partStepInterval = self.basePrice.interval / 8 / 10

        -- �������� ����-���� �������� ����������
        local price = {}

        for i = 2, 10 do
            price[i] = priceZapros + (stepInterval * self.settingTake[operation][i])
        end

        -- �������� ����� �������������� ��������
        local _operation = self:getReverseOperation(operation)

        -- ������������ ���� �� ���� �����������
        if _operation == "buy" then
            for i = 2, 10 do
                price[i] = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, price[i] + (partStepInterval * self.settingTake.offsetPartStepInterval))
            end
        else
            for i = 2, 10 do
                price[i] = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, price[i] - (partStepInterval * self.settingTake.offsetPartStepInterval))
            end
        end

        -- �������� ������ ���� ��� ������� �����
        -- �������� ���� ��� ����� �����
        for i = 2, 10 do
            price[i] = d0(price[i])
        end

        -- ��������� ���������
        self.tmpResult.take.price = price
        self.tmpResult.take.operation = _operation
    end,

    -- ���������� ������ �� ���������� ����
    calculateParamsToPrice = function(self, operation, price)
        -- ��������� ���������� ���������

        -- ��������� ��������� (basePrice) ��� ��������
        self:updateBasePrice()

        -- buy, 5
        -- ���������� ��������� ��� ������� �� ���������� ���� �������
        self:calculateParamsZaprosToPrice(operation, price)

        -- sell, 5
        -- ���������� ��������� ��� ����� �� ���������� ���� �������
        self:calculateParamStopToPrice(operation, price)

        -- ���������� ��������� ��� �������� ����� �� ���������� ���� �������
        self:calculateParamStopMoveToPrice(operation, price)

        -- sell, 5
        -- ���������� ��������� ��� ����� �� ���������� ���� �������
        self:calculateParamTakeToPrice(operation, price)

        -- ��������� ���������� ������� ��� idParams
        self:saveResult()
    end,

}

return Entity
