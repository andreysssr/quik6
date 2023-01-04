--- EventHandler PanelTrade

local EventHandler = {
    --
    name = "EventHandler_PanelTrade_TimerUpdatePoleCenter",

    --
    container = {},

    --
    panelTrade = {},

    --
    timer = {},

    --
    storage = {},

    --
    handlerPoleCenter = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")
        self.timer = container:get("Timer")
        self.panelTrade = container:get("Panels_PanelTrade")
        self.handlerPoleCenter = container:get("Handler_PoleCenter")

        self.timerName = container:get("config").timerUpdatePoleCenter.timerName
        self.timerPause = container:get("config").timerUpdatePoleCenter.timerPause

        -- ��������� ������
        self.timer:set(self.timerName, self.timerPause)

        return self
    end,

    --
    updatePole = function(self, idStock)
        local dto = {}

        local level = self.container:get("Handler_PoleCenter"):getParams(idStock)
        array_merge(dto, level)

        self.panelTrade:update(idStock, dto)
    end,

    -- ������ ���� ���� � �������� ������
    handle = function(self, event)
        -- ���������� ���������� � �������� ���������� � ������� (updatePoleCenter.timerPause)
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
