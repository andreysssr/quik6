--- EventHandler Command

local EventHandler = {
    --
    name = "EventHandler_Command_AddStop",

    --
    container = {},

    --
    useCase = {},

    --
    new = function(self, container)
        self.useCase = container:get("UseCase_AddStopLinked")

        return self
    end,

    -- открыть позицию по лучшей цене
    handle = function(self, event)
        local idStock = event:getParam("idStock")
        local idParams = event:getParam("idParams")

        self.useCase:addStop(idStock, idParams)
    end,

}

return EventHandler
