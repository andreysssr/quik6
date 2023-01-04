--- EventHandler

local EventHandler = {
    --
    name = "EventHandler_PanelTrade_TimerUpdatePoleVolume",

    --
    container = {},

    --
    timer = {},

    --
    timerName = "",

    --
    timerPause = 0,

    --
    storage = {},

    --
    microserviceMarkerBarDayLineCloseToChart = {},

    --
    microserviceMarkerBarDayLineHiToChart = {},

    --
    microserviceMarkerBarDayLineLowToChart = {},

    --
    basePriceToChart = {},

    --
    sender = {},

    --
    new = function(self, container)
        self.container = container
        self.timer = container:get("Timer")
        self.storage = container:get("Storage")
        self.microserviceMarkerBarDayLineCloseToChart = container:get("MicroService_MarkerBarDayLineCloseToChart")
        self.microserviceMarkerBarDayLineHiToChart = container:get("MicroService_MarkerBarDayLineHiToChart")
        self.microserviceMarkerBarDayLineLowToChart = container:get("MicroService_MarkerBarDayLineLowToChart")

        self.basePriceToChart = container:get("MicroService_BasePriceToChart")

        self.sender = container:get("AppService_EventSender")

        self.timerName = container:get("config").timerUpdateBarLinesToChart.timerName
        self.timerPause = container:get("config").timerUpdateBarLinesToChart.timerPause

        -- запускаем таймер
        self.timer:set(self.timerName, self.timerPause)

        return self
    end,


    -- меняем цвет поля в торговой панели
    handle = function(self, event)
        -- обновление происходит с частотой записанной в конфиге (updatePoleLine.timerPause)
        if self.timer:allows(self.timerName) then
            self.microserviceMarkerBarDayLineCloseToChart:updateLocation()
            self.microserviceMarkerBarDayLineHiToChart:updateLocation()
            self.microserviceMarkerBarDayLineLowToChart:updateLocation()

            -- запускаем таймер
            self.timer:set(self.timerName, self.timerPause)

            self.sender:send("ChangedLinesInCharts", { name = self.name })
        end
    end,
}

return EventHandler
