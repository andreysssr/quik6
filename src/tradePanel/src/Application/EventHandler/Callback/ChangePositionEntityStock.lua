--- EventHandler ChangedPosition

local EventHandler = {
    --
    name = "EventHandler_ChangedTrade",

    --
    entityService = {},

    --
    filter = {},

    --
    new = function(self, container)
        self.entityService = container:get("EntityService_Stock")

        return self
    end,

    -- вызывает изменение позиций в (EntityStock)
    changePosition = function(self, event)
        local data = event:getParams()

        self.entityService:changePosition(data.sec_code)
    end,
}

return EventHandler
