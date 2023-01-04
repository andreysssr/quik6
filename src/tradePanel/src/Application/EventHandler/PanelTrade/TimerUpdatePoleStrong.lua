--- EventHandler PanelTrade

local EventHandler = {
    --
    name = "EventHandler_PanelTrade_TimerUpdatePoleStrong",

    --
    container = {},

    --
    panelTrade = {},

    --
    timer = {},

    --
    storage = {},

    --
    handlerPoleStrong = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")
        self.timer = container:get("Timer")
        self.panelTrade = container:get("Panels_PanelTrade")
        self.handlerPoleStrong = container:get("Handler_PoleStrong")

        self.timerName = container:get("config").timerUpdatePoleStrong.timerName
        self.timerPause = container:get("config").timerUpdatePoleStrong.timerPause

        -- ��������� ������
        self.timer:set(self.timerName, self.timerPause)

        return self
    end,

    --
    updatePole = function(self, idStock)
        local dto = {}

        local strong = self.container:get("Handler_PoleStrong"):getParams(idStock)
        array_merge(dto, strong)

        self.panelTrade:update(idStock, dto)
    end,

    -- ������ ���� ���� � �������� ������
    handle = function(self, event)
        -- ���������� ���������� � �������� ���������� � ������� (updatePoleStrong.timerPause)
        if self.timer:allows(self.timerName) then
            -- �������� ������ ������� �� �������
            local arrayTickers = self.storage:getHomeworkId()

            -- � ����� �������� �������� Entity BasePrice
            for i = 1, #arrayTickers do
                self:updatePole(arrayTickers[i])
            end

            -- ��������� ������
            self.timer:set(self.timerName, self.timerPause)
        end
    end,
}

return EventHandler
