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
    sender = {},

    --
    status = false,

    --
    new = function(self, container)
        self.storage = container:get("Storage")
        self.microServiceConditionPanelTrade = container:get("MicroService_ConditionPanelTrade")
        self.microserviceMarkerBarDayLineCloseToChart = container:get("MicroService_MarkerBarDayLineCloseToChart")
        self.microserviceMarkerBarDayLineHiToChart = container:get("MicroService_MarkerBarDayLineHiToChart")
        self.microserviceMarkerBarDayLineLowToChart = container:get("MicroService_MarkerBarDayLineLowToChart")
        self.panelTrade = container:get("Panels_PanelTrade")

        self.sender = container:get("AppService_EventSender")

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


    show = function(self, idStock)
        --
        self:updatePanelPole(idStock)

        --
        self:addMarkerToChart(idStock)
    end,

    --
    reset = function(self, idStock)
        -- получить значение condition
        -- если включен - выключить и поменять в панели
        local status = self.microServiceConditionPanelTrade:getMarkerDayBarStatus(idStock)

        if status then
            self.microserviceMarkerBarDayLineCloseToChart:removeMarker(idStock)
            self.microserviceMarkerBarDayLineHiToChart:removeMarker(idStock)
            self.microserviceMarkerBarDayLineLowToChart:removeMarker(idStock)

            local dto = {}

            self.microServiceConditionPanelTrade:changeMarkerDayBar(idStock)
            local result = self.microServiceConditionPanelTrade:getMarkerDayBar(idStock)
            array_merge(dto, result)

            self.panelTrade:update(idStock, dto)
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

            self.sender:send("ChangedLinesInCharts", { name = self.name })
        end
    end,


}

return EventHandler
