--- EventHandler ViewLevelsToChart

local EventHandler = {
    --
    name = "EventHandler_ViewLevelsToChart",

    --
    storage = {},

    --
    status = false,

    --
    arrayStock = {},

    --
    levelsToChart = {},

    --
    timerName = {},

    --
    timerPause = {},

    --
    new = function(self, container)
        self.storage = container:get("Storage")

        self.arrayStock = self.storage:getHomeworkId()
        self.levelsToChart = container:get("MicroService_LevelsToChart")

        self.timer = container:get("Timer")
        self.timerName = container:get("config").timerViewLevelsToChart.timerName
        self.timerPause = container:get("config").timerViewLevelsToChart.timerPause

        self.timer:set(self.timerName, self.timerPause)
        return self
    end,

    --
    showAll = function(self)
        for i = 1, #self.arrayStock do
            -- добавляем на график уровни и линии
            self.levelsToChart:addLevelToId(self.arrayStock[i])
        end
    end,

    --
    resetAll = function(self)
        self.levelsToChart:removeAll()
    end,

    --
    handle = function(self)
        if self.status then
            self.status = false

            self:resetAll()
        else
            self.status = true

            self:showAll()
        end
    end,

    -- перерисовка (сдвиг линий в право)
    updateLocation = function(self)
        -- таймер
        if self.timer:allows(self.timerName) and self.status then
            -- обновление 1 раз в установленное время
            self.timer:set(self.timerName, self.timerPause)

            -- обновить уровни
            self.levelsToChart:updateLocation()
        end
    end,
}

return EventHandler
