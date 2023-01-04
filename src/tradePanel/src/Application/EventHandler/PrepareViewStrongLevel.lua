--- EventHandler PrepareViewStrongLevel

local EventHandler = {
    --
    name = "EventHandler_PrepareViewStrongLevel",

    --
    storage = {},

    --
    microServiceConditionPanelTrade = {},

    --
    microserviceMarkerStrongLineToChart = {},

    --
    panelTrade = {},

    --
    new = function(self, container)
        self.storage = container:get("Storage")
        self.microServiceConditionPanelTrade = container:get("MicroService_ConditionPanelTrade")
        self.microserviceMarkerStrongLineToChart = container:get("MicroService_MarkerStrongLineToChart")
        self.panelTrade = container:get("Panels_PanelTrade")

        return self
    end,

    --
    prepare = function(self, idStock)
        -- если есть сильный уровень тогда меняем значение
        if self.storage:hasStrongLevel(idStock) then
            self.microserviceMarkerStrongLineToChart:addMarkerToChart(idStock)
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
