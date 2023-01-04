--- EventHandler ChangeConditionEntityStock - поменялся статус транзакции (состояние заявок)

local EventHandler = {
    --
    name = "EventHandler_ChangeConditionEntityStock",

    --
    container = {},

    --
    entityService = {},

    --
    new = function(self, container)
        self.container = container
        self.entityService = container:get("EntityService_Stock")

        return self
    end,

    --
    handle = function(self, event)
        local idStock = event:getParam("idStock")
        local params = event:getParam("params")

        self.entityService:changeCondition(idStock, params)
    end,

}

return EventHandler
