--- EventHandler Key

local EventHandler = {
    --
    name = "EventHandler_Key_ClosePositionMarket",

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
        self.useCase = container:get("UseCase_ClosePositionMarket")

        return self
    end,

    -- получить активный инструмент
    getCurrentId = function(self)
        return self.microservice:getCurrentIdStock()
    end,

    -- закрыть позицию по рынку
    closePosition = function(self, event)
        local id = self:getCurrentId()

        if id == "" then
            return
        end

        self.useCase:closePosition(id)
    end,
}

return EventHandler
