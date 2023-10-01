--- EventHandler Key

local EventHandler = {
    --
    name = "EventHandler_Key_DeleteOrdersAndStopOrders",

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
        self.useCase = container:get("UseCase_DeleteOrdersAndStopOrders")

        return self
    end,

    -- получить активный инструмент
    getCurrentId = function(self)
        return self.microservice:getCurrentIdStock()
    end,

    -- удалить все order и stopOrder
    delete = function(self, event)
        local id = self:getCurrentId()

        if id == "" then
            return
        end

        self.useCase:delete(id)
    end,
}

return EventHandler
