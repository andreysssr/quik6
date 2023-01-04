--- EventHandler Key

local EventHandler = {
    --
    name = "EventHandler_Key_OpenPositionLimit",

    --
    container = {},

    --
    microservice = {},

    --
    useCase = {},

    --
    new = function(self, container)
        self.container = container
        self.microservice = container:get("MicroService_ActiveStockPanelTrade")
        self.useCase = container:get("UseCase_OpenPositionLimit")

        return self
    end,

    -- получить активный инструмент
    getCurrentId = function(self)
        return self.microservice:getCurrentIdStock()
    end,

    -- открыть позицию по лучщей цене
    openPositionSell = function(self, event)
        local id = self:getCurrentId()

        if id == "" then
            return
        end

        self.useCase:openPosition(id, "sell")
    end,

    -- открыть позицию по лучщей цене
    openPositionBuy = function(self, event)
        local id = self:getCurrentId()

        if id == "" then
            return
        end

        self.useCase:openPosition(id, "buy")
    end,
}

return EventHandler
