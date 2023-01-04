--- EventHandler

local EventHandler = {
    --
    name = "EventHandler_ClickedPanelTrade_PoleMarkerDayBar",

    --
    microService = {},

    --
    panelTrade = {},

    --
    new = function(self, container)
        self.microService = container:get("MicroService_ConditionPanelTrade")
        self.panelTrade = container:get("Panels_PanelTrade")

        return self
    end,

    --
    handle = function(self, event)
        local idStock = event:getParam("id")

        local dto = {}

        self.microService:changeMarkerDayBar(idStock)
        local result = self.microService:getMarkerDayBar(idStock)
        array_merge(dto, result)

        self.panelTrade:update(idStock, dto)
    end,
}

return EventHandler
