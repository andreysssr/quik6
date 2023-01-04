--- EventHandler UpdateBaseLinesInCharts

local EventHandler = {
    --
    name = "EventHandler_UpdateBaseLinesInCharts",

    --
    storage = {},

    --
    basePriceToChart = {},

    --
    new = function(self, container)
        self.storage = container:get("Storage")
        self.basePriceToChart = container:get("MicroService_BasePriceToChart")

        return self
    end,

    --
    handle = function(self, event)
        local listStock = self.storage:getHomeworkId()

        for i = 1, #listStock do
            -- меняем положение линии basePrice
            self.basePriceToChart:updateLocationToId(listStock[i])
        end
    end,
}

return EventHandler
