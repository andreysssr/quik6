--- EventHandler Key

local EventHandler = {
    --
    name = "EventHandler_Key_ZaprosLimitHiLow",

    --
    microservice = {},

    --
    useCase = {},

    --
    new = function(self, container)
        self.microservice = container:get("MicroService_ActiveStockPanelTrade")
        self.useCase = container:get("UseCase_AddZaprosLimitHiLow")

        return self
    end,

    -- получить активный инструмент
    getCurrentId = function(self)
        return self.microservice:getCurrentIdStock()
    end,

    -- купить по hi
    buy = function(self, event)
        local idStock = self:getCurrentId()

        if idStock == "" then
            return
        end

        self.useCase:addZapros(idStock, "buy")
    end,

    -- продать по low
    sell = function(self, event)
        local idStock = self:getCurrentId()

        if idStock == "" then
            return
        end

        self.useCase:addZapros(idStock, "sell")
    end,
}

return EventHandler
