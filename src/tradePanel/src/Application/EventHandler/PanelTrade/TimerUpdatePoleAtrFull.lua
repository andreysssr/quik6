--- EventHandler PanelTrade

local EventHandler = {
    --
    name = "EventHandler_PanelTrade_TimerUpdatePoleAtrFull",

    --
    container = {},

    --
    panelTrade = {},

    --
    timer = {},

    --
    storage = {},

    --
    handlerPoleLevel = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")
        self.timer = container:get("Timer")
        self.panelTrade = container:get("Panels_PanelTrade")
        self.handlerPoleLevel = container:get("Handler_PoleLevel")

        self.timerName = container:get("config").timerUpdatePoleAtrFull.timerName
        self.timerPause = container:get("config").timerUpdatePoleAtrFull.timerPause

        -- ��������� ������
        self.timer:set(self.timerName, self.timerPause)

        return self
    end,

    --
    updatePole = function(self, idStock)
        local dto = {}

        local atrFull = self.container:get("Handler_PoleAtrFull"):getParams(idStock)
        array_merge(dto, atrFull)

        self.panelTrade:update(idStock, dto)
    end,

    -- ������ ���� ���� � �������� ������
    handle = function(self, event)
        -- ���������� ���������� � �������� ���������� � ������� (updatePoleLevel.timerPause)
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
