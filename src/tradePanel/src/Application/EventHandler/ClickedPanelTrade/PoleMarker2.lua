--- EventHandler

local EventHandler = {
    --
    name = "EventHandler_ClickedPanelTrade_PoleMarker1",

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

        self.microService:ChangeMarker2(idStock)
        local result = self.microService:getMarker2(idStock)
        array_merge(dto, result)

        self.panelTrade:update(idStock, dto)
    end,
}

return EventHandler
