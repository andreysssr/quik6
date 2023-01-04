--- EventHandler

local EventHandler = {
    --
    name = "EventHandler_TimerUpdateMirrorLinesToChart",

    --
    container = {},

    --
    timer = {},

    --
    timerName = "",

    --
    timerPause = 0,

    --
    microserviceMarkerMirrorLineHiToChart = {},

    --
    microserviceMarkerMirrorLineLowToChart = {},

    --
    sender = {},

    --
    new = function(self, container)
        self.container = container
        self.timer = container:get("Timer")
        self.microserviceMarkerMirrorLineHiToChart = container:get("MicroService_MarkerMirrorLineHiToChart")
        self.microserviceMarkerMirrorLineLowToChart = container:get("MicroService_MarkerMirrorLineLowToChart")

        self.sender = container:get("AppService_EventSender")

        self.timerName = container:get("config").timerUpdateMirrorLinesToChart.timerName
        self.timerPause = container:get("config").timerUpdateMirrorLinesToChart.timerPause

        -- ��������� ������
        self.timer:set(self.timerName, self.timerPause)

        return self
    end,


    -- ������ ���� ���� � �������� ������
    handle = function(self, event)
        -- ���������� ���������� � �������� ���������� � ������� (updatePoleLine.timerPause)
        if self.timer:allows(self.timerName) then
            self.microserviceMarkerMirrorLineHiToChart:updateLocation()
            self.microserviceMarkerMirrorLineLowToChart:updateLocation()

            -- ��������� ������
            self.timer:set(self.timerName, self.timerPause)
        end
    end,
}

return EventHandler
