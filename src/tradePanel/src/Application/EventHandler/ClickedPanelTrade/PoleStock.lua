--- EventHandler

local EventHandler = {
    --
    name = "EventHandler_ClickedPanelTrade_PoleStock",

    --
    microservice = {},

    --
    container = {},

    --
    new = function(self, container)
        self.microservice = container:get("MicroService_ActiveStockPanelTrade")

        return self
    end,

    --
    handle = function(self, event)
        local idStock = event:getParam("id")

        -- в микросервисе меняем активную бумагу
        self.microservice:changeActive(idStock)
    end,
}

return EventHandler
