--- EventHandler PrepareViewStrongLevel

local EventHandler = {
    --
    name = "EventHandler_PrepareViewStrongLevel",

    --
    storage = {},

    --
    microServiceConditionPanelTrade = {},

    --
    microserviceMarkerBarDayLineCloseToChart = {},

    --
    microserviceMarkerBarDayLineHiToChart = {},

    --
    microserviceMarkerBarDayLineLowToChart = {},

    --
    panelTrade = {},

    --
    entityServiceDSD = {},

    --
    new = function(self, container)
        self.storage = container:get("Storage")
        self.microServiceConditionPanelTrade = container:get("MicroService_ConditionPanelTrade")
        self.microserviceMarkerBarDayLineCloseToChart = container:get("MicroService_MarkerBarDayLineCloseToChart")
        self.microserviceMarkerBarDayLineHiToChart = container:get("MicroService_MarkerBarDayLineHiToChart")
        self.microserviceMarkerBarDayLineLowToChart = container:get("MicroService_MarkerBarDayLineLowToChart")
        self.panelTrade = container:get("Panels_PanelTrade")

        self.entityServiceDSD = container:get("EntityService_DsD")

        return self
    end,

    --
    updatePanelPole = function(self, idStock)
        local dto = {}

        self.microServiceConditionPanelTrade:changeMarkerDayBar(idStock)
        local result = self.microServiceConditionPanelTrade:getMarkerDayBar(idStock)
        array_merge(dto, result)

        self.panelTrade:update(idStock, dto)
    end,

    --
    addMarkerToChart = function(self, idStock)
        local status = self.microServiceConditionPanelTrade:getMarkerDayBarStatus(idStock)

        if status == true then
            self.microserviceMarkerBarDayLineCloseToChart:addMarkerToChart(idStock)
            self.microserviceMarkerBarDayLineHiToChart:addMarkerToChart(idStock)
            self.microserviceMarkerBarDayLineLowToChart:addMarkerToChart(idStock)
        end
    end,

    --
    _prepare = function(self, idStock)
        --
        local interval = self.storage:getIntervalToId(idStock)

        -- шаг интервала
        local stepInterval = interval / 6

        local paramsBarDay = self.entityServiceDSD:getHiLowClosePreviousBar(idStock)

        local hiPrev = paramsBarDay.hi
        local lowPrev = paramsBarDay.low
        local closePrev = paramsBarDay.close

        local hiOffset = hiPrev - closePrev
        local lowOffset = closePrev - lowPrev

        if hiOffset <= (stepInterval * 1.1) or lowOffset <= (stepInterval * 1.1) then
            --
            self:updatePanelPole(idStock)

            --
            self:addMarkerToChart(idStock)
        end

    end,

    --
    prepare = function(self, idStock)
        --
        self:updatePanelPole(idStock)

        --
        self:addMarkerToChart(idStock)
    end,

    --
    handle = function(self)
        local listHomework = self.storage:getHomeworkId()

        for i = 1, #listHomework do
            self:prepare(listHomework[i])
        end
    end,

}

return EventHandler
