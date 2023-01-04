--- EventHandler

local EventHandler = {
    --
    name = "EventHandler_ClickedPanelTrade_UpdateBarHourLinesToChart",

    --
    microServiceConditionPanelTrade = {},

    --
    microserviceMarkerMirrorLineHiToChart = {},

    --
    microserviceMarkerMirrorLineLowToChart = {},

    --
    new = function(self, container)
        self.microServiceConditionPanelTrade = container:get("MicroService_ConditionPanelTrade")

        self.microserviceMarkerMirrorLineHiToChart = container:get("MicroService_MarkerMirrorLineHiToChart")
        self.microserviceMarkerMirrorLineLowToChart = container:get("MicroService_MarkerMirrorLineLowToChart")

        return self
    end,

    --
    handle = function(self, event)
        local idStock = event:getParam("id")

        local status = self.microServiceConditionPanelTrade:getMarkerMirrorLineHiLowStatus(idStock)

        if status == true then
            self.microserviceMarkerMirrorLineHiToChart:addMarkerToChart(idStock)
            self.microserviceMarkerMirrorLineLowToChart:addMarkerToChart(idStock)
        else
            self.microserviceMarkerMirrorLineHiToChart:removeMarker(idStock)
            self.microserviceMarkerMirrorLineLowToChart:removeMarker(idStock)
        end
    end,

}

return EventHandler
