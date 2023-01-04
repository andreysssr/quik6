--- EventHandler

local EventHandler = {
    --
    name = "EventHandler_ClickedPanelTrade_UpdateBarHourLinesToChart",

    --
    microServiceConditionPanelTrade = {},

    --
    microserviceMarkerBarHourLineHiToChart = {},

    --
    microserviceMarkerBarHourLineLowToChart = {},

    --
    new = function(self, container)
        self.microServiceConditionPanelTrade = container:get("MicroService_ConditionPanelTrade")
        self.microserviceMarkerBarHourLineHiToChart = container:get("MicroService_MarkerBarHourLineHiToChart")
        self.microserviceMarkerBarHourLineLowToChart = container:get("MicroService_MarkerBarHourLineLowToChart")

        return self
    end,

    --
    handle = function(self, event)
        local idStock = event:getParam("id")

        local status = self.microServiceConditionPanelTrade:getMarkerHourBarStatus(idStock)

        if status == true then
            self.microserviceMarkerBarHourLineHiToChart:addMarkerToChart(idStock)
            self.microserviceMarkerBarHourLineLowToChart:addMarkerToChart(idStock)
        else
            self.microserviceMarkerBarHourLineHiToChart:removeMarker(idStock)
            self.microserviceMarkerBarHourLineLowToChart:removeMarker(idStock)
        end
    end,

}

return EventHandler
