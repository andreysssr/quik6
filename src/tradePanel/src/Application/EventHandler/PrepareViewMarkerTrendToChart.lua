--- EventHandler PrepareViewStrongLevel

local EventHandler = {
    --
    name = "EventHandler_",

    --
    storage = {},

    --
    microServiceConditionPanelTrade = {},

    --
    microserviceMarkerTrendToChart = {},

    --
    panelTrade = {},

    --
    new = function(self, container)
        self.storage = container:get("Storage")
        self.microServiceConditionPanelTrade = container:get("MicroService_ConditionPanelTrade")
        self.microserviceMarkerTrendToChart = container:get("MicroService_MarkerTrendToChart")
        self.panelTrade = container:get("Panels_PanelTrade")

        return self
    end,

    --
    updatePanelPole = function(self, idStock)
        local dto = {}

        self.microServiceConditionPanelTrade:changeMarkerTrend(idStock)
        local result = self.microServiceConditionPanelTrade:getMarkerTrend(idStock)
        array_merge(dto, result)

        self.panelTrade:update(idStock, dto)
    end,

    --
    addMarkerToChart = function(self, idStock)
        local status = self.microServiceConditionPanelTrade:getMarkerTrendStatus(idStock)

        if status == true then
            self.microserviceMarkerTrendToChart:addMarkerToChart(idStock)
        end
    end,

    --
    prepare = function(self, idStock)
        local comment = self.storage:getCommentToId(idStock)

        if comment ~= "" then
            self:updatePanelPole(idStock)

            self:addMarkerToChart(idStock)

        end
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
