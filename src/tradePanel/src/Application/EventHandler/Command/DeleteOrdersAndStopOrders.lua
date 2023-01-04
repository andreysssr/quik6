--- EventHandler Command

local EventHandler = {
    --
    name = "EventHandler_Command_DeleteOrdersAndStopOrders",

    --
    container = {},

    --
    useCase = {},

    --
    new = function(self, container)
        self.useCase = container:get("UseCase_DeleteOrdersAndStopOrders")

        return self
    end,

    -- открыть позицию по лучшей цене
    handle = function(self, event)
        local idStock = event:getParam("idStock")

        self.useCase:delete(idStock, idStock)
    end,

}

return EventHandler
