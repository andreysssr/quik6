--- EventHandler

local EventHandler = {
    --
    name = "EventHandler_ClickedPanelTrade_UpdateTrendToChart",

    --
    microserviceMarkerTrendToChart = {},

    --
    microServiceConditionPanelTrade = {},

    --
    new = function(self, container)
        self.microserviceMarkerTrendToChart = container:get("MicroService_MarkerTrendToChart")
        self.microServiceConditionPanelTrade = container:get("MicroService_ConditionPanelTrade")

        return self
    end,

    --
    handle = function(self, event)
        local idStock = event:getParam("id")

        local status = self.microServiceConditionPanelTrade:getMarkerTrendStatus(idStock)

        if status == true then
            self.microserviceMarkerTrendToChart:addMarkerToChart(idStock)
        else
            self.microserviceMarkerTrendToChart:removeMarker(idStock)
        end
    end,

}

return EventHandler
