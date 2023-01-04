--- DomainService CalculateMaxLots

local DomainService = {

    --
    name = "DomainService_CalculateMaxLots",

    --
    container = {},

    --
    lastPrice = {},

    --
    configStock = {},

    --
    configFutures = {},

    --
    configCurrency = {},

    --
    new = function(self, container)
        self.container = container
        self.lastPrice = container:get("DomainService_LastPrice")

        self.configStock = container:get("Config_stock")
        self.configFutures = container:get("Config_futures")
        self.configCurrency = container:get("Config_currency")

        return self
    end,

    -- вернуть максимальное колличество лотов для покупки
    getMaxLots = function(self, id, class, operation)
        local _id = id
        local _class = class
        local lastPrice = self.lastPrice:getPrice(_id, _class)

        -- направление расчёта операции
        -- true - на покупку, false - на продажу
        local calculateOperation = true

        if operation == "sell" then
            calculateOperation = false
        end

        if class == "TQBR" or class == 'QJSIM' then
            return CalcBuySell(class, id, self.configStock.client_code, self.configStock.account, lastPrice, calculateOperation, false)
        end

        if class == "SPBFUT" or class == 'SPBOPT' then
            return CalcBuySell(class, id, self.configFutures.client_code, self.configFutures.account, lastPrice, calculateOperation, false)
        end

        if class == "CETS" then
            return CalcBuySell(class, id, self.configCurrency.client_code, self.configCurrency.account, lastPrice, calculateOperation, false)
        end
    end
}

return DomainService
