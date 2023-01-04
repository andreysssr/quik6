--- EventHandler UpdateTrendToChart

local EventHandler = {
    --
    name = "EventHandler_ClickedPanelTrade_UpdateBarLinesToChart",

    --
    microServiceConditionPanelTrade = {},

    --
    microserviceMarkerBarDayLineCloseToChart = {},

    --
    microserviceMarkerBarDayLineHiToChart = {},

    --
    microserviceMarkerBarDayLineLowToChart = {},

    --
    new = function(self, container)
        self.microServiceConditionPanelTrade = container:get("MicroService_ConditionPanelTrade")
        self.microserviceMarkerBarDayLineCloseToChart = container:get("MicroService_MarkerBarDayLineCloseToChart")
        self.microserviceMarkerBarDayLineHiToChart = container:get("MicroService_MarkerBarDayLineHiToChart")
        self.microserviceMarkerBarDayLineLowToChart = container:get("MicroService_MarkerBarDayLineLowToChart")

        return self
    end,

    --
    handle = function(self, event)
        local idStock = event:getParam("id")

        local status = self.microServiceConditionPanelTrade:getMarkerDayBarStatus(idStock)

        if status == true then
            self.microserviceMarkerBarDayLineCloseToChart:addMarkerToChart(idStock)
            self.microserviceMarkerBarDayLineHiToChart:addMarkerToChart(idStock)
            self.microserviceMarkerBarDayLineLowToChart:addMarkerToChart(idStock)
        else
            self.microserviceMarkerBarDayLineCloseToChart:removeMarker(idStock)
            self.microserviceMarkerBarDayLineHiToChart:removeMarker(idStock)
            self.microserviceMarkerBarDayLineLowToChart:removeMarker(idStock)
        end
    end,

}

return EventHandler
