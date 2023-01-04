--- EventHandler

local EventHandler = {
    --
    name = "EventHandler_PanelTrade_TimerUpdatePoleVolume",

    --
    container = {},

    --
    timer = {},

    --
    storage = {},

    --
    microserviceMarkerTrendToChart = {},

    --
    new = function(self, container)
        self.container = container
        self.timer = container:get("Timer")
        self.storage = container:get("Storage")
        self.microserviceMarkerTrendToChart = container:get("MicroService_MarkerTrendToChart")

        self.timerName = container:get("config").timerUpdateTrendToChart.timerName
        self.timerPause = container:get("config").timerUpdateTrendToChart.timerPause

        -- ��������� ������
        self.timer:set(self.timerName, self.timerPause)

        return self
    end,

    -- ������ ���� ���� � �������� ������
    handle = function(self, event)
        -- ���������� ���������� � �������� ���������� � ������� (updatePoleLine.timerPause)
        if self.timer:allows(self.timerName) then
            self.microserviceMarkerTrendToChart:updateLocation()

            -- ��������� ������
            self.timer:set(self.timerName, self.timerPause)
        end
    end,
}

return EventHandler
