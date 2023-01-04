--- EventHandler PrepareViewStrongLevel

local EventHandler = {
    --
    name = "EventHandler_PrepareViewStrongLevel",

    --
    storage = {},

    --
    microServiceConditionPanelTrade = {},

    --
    microserviceMarkerMirrorLineCloseToChart = {},

    --
    microserviceMarkerMirrorLineHiToChart = {},

    --
    microserviceMarkerMirrorLineLowToChart = {},

    --
    panelTrade = {},

    --
    entityServiceDSD = {},

    --
    new = function(self, container)
        self.storage = container:get("Storage")
        self.microServiceConditionPanelTrade = container:get("MicroService_ConditionPanelTrade")
        self.microserviceMarkerMirrorLineHiToChart = container:get("MicroService_MarkerMirrorLineHiToChart")
        self.microserviceMarkerMirrorLineLowToChart = container:get("MicroService_MarkerMirrorLineLowToChart")
        self.panelTrade = container:get("Panels_PanelTrade")

        self.entityServiceDSD = container:get("EntityService_DsD")

        return self
    end,

    --
    updatePanelPole = function(self, idStock)
        local dto = {}

        self.microServiceConditionPanelTrade:changeMarkerMirrorLineHiLow(idStock)
        local result = self.microServiceConditionPanelTrade:getMarkerMirrorLineHiLow(idStock)
        array_merge(dto, result)

        self.panelTrade:update(idStock, dto)
    end,

    --
    addMarkerToChart = function(self, idStock)
        local status = self.microServiceConditionPanelTrade:getMarkerMirrorLineHiLowStatus(idStock)

        if status == true then
            self.microserviceMarkerMirrorLineHiToChart:addMarkerToChart(idStock)
            self.microserviceMarkerMirrorLineLowToChart:addMarkerToChart(idStock)
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
