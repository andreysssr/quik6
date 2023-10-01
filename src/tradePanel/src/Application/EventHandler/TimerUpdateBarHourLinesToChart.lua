--- EventHandler

local EventHandler = {
    --
    name = "EventHandler_TimerUpdateBarHourLinesToChart",

    --
    container = {},

    --
    timer = {},

    --
    timerName = "",

    --
    timerPause = 0,

    --
    microserviceMarkerBarHourLineHiToChart = {},

    --
    microserviceMarkerBarHourLineLowToChart = {},

    --
    sender = {},

    --
    new = function(self, container)
        self.container = container
        self.timer = container:get("Timer")
        self.microserviceMarkerBarHourLineHiToChart = container:get("MicroService_MarkerBarHourLineHiToChart")
        self.microserviceMarkerBarHourLineLowToChart = container:get("MicroService_MarkerBarHourLineLowToChart")

        self.sender = container:get("AppService_EventSender")

        self.timerName = container:get("config").timerUpdateBarHourLinesToChart.timerName
        self.timerPause = container:get("config").timerUpdateBarHourLinesToChart.timerPause

        -- запускаем таймер
        self.timer:set(self.timerName, self.timerPause)

        return self
    end,


    -- меняем цвет поля в торговой панели
    handle = function(self, event)
        -- обновление происходит с частотой записанной в конфиге (updatePoleLine.timerPause)
        if self.timer:allows(self.timerName) then
            self.microserviceMarkerBarHourLineHiToChart:updateLocation()
            self.microserviceMarkerBarHourLineLowToChart:updateLocation()

            -- запускаем таймер
            self.timer:set(self.timerName, self.timerPause)

            self.sender:send("ChangedLinesInCharts", { name = self.name })
        end
    end,
}

return EventHandler
