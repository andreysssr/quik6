--- EventHandler PanelTrade

local EventHandler = {
    --
    name = "EventHandler_PanelTrade_UpdatePoleOrdersAll",

    --
    container = {},

    --
    storage = {},

    --
    panelTrade = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")
        self.panelTrade = container:get("Panels_PanelTrade")

        return self
    end,

    --
    handle = function(self, event)
        local idStock = event:getParam("sec_code")

        local dto = {}

        local ordersAll = self.container:get("Handler_PoleOrdersAll"):getParams(idStock)
        array_merge(dto, ordersAll)

        self.panelTrade:update(idStock, dto)
    end,

}

return EventHandler
