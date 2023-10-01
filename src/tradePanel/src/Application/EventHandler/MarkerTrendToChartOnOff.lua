--- EventHandler MarkerTrendToChartOnOff - включает и выключает текст тренда на графике

local EventHandler = {
    --
    name = "_MarkerTrendToChartOnOff",

    --
    storage = {},

    --
    panelTrade = {},

    --
    microserviceMarkerTrendToChart = {},

    --
    microServiceConditionPanelTrade = {},

    --
    status = true,

    --
    new = function(self, container)
        self.storage = container:get("Storage")
        self.panelTrade = container:get("Panels_PanelTrade")
        self.microserviceMarkerTrendToChart = container:get("MicroService_MarkerTrendToChart")
        self.microServiceConditionPanelTrade = container:get("MicroService_ConditionPanelTrade")

        return self
    end,

    -- меняем значение в панели
    updatePanelPole = function(self, idStock)
        local dto = {}

        self.microServiceConditionPanelTrade:changeMarkerTrend(idStock)
        local result = self.microServiceConditionPanelTrade:getMarkerTrend(idStock)
        array_merge(dto, result)

        self.panelTrade:update(idStock, dto)
    end,

    -- добавляем тренд на график бумаги при изминении нажатия на (markerTrend)
    addMarkerToChart = function(self, idStock)
        self.microserviceMarkerTrendToChart:addMarkerToChart(idStock)
    end,

    --
    show = function(self, idStock)
        local comment = self.storage:getCommentToId(idStock)

        if comment ~= "" then
            self:updatePanelPole(idStock)

            self:addMarkerToChart(idStock)
        end
    end,

    --
    reset = function(self, idStock)
        local status = self.microServiceConditionPanelTrade:getMarkerTrendStatus(idStock)

        if status then
            local dto = {}

            self.microServiceConditionPanelTrade:changeMarkerTrend(idStock)
            local result = self.microServiceConditionPanelTrade:getMarkerTrend(idStock)
            array_merge(dto, result)

            self.panelTrade:update(idStock, dto)

            --
            self.microserviceMarkerTrendToChart:removeMarker(idStock)
        end
    end,

    -- показать линии для всех бумаг
    resetAll = function(self)
        local listHomework = self.storage:getHomeworkId()

        for i = 1, #listHomework do
            self:reset(listHomework[i])
        end
    end,

    --
    showAll = function(self)
        local listHomework = self.storage:getHomeworkId()

        for i = 1, #listHomework do
            self:show(listHomework[i])
        end
    end,

    --
    handle = function(self)
        if self.status then
            self.status = false

            self:resetAll()
        else
            self.status = true

            self:resetAll()
            self:showAll()
        end
    end,

}

return EventHandler
