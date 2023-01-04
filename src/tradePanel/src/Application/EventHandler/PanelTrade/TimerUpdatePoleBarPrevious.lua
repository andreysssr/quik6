--- EventHandler PanelTrade

local EventHandler = {
    --
    name = "EventHandler_PanelTrade_TimerUpdatePoleBarPrevious",

    --
    container = {},

    --
    panelTrade = {},

    --
    timer = {},

    --
    storage = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")
        self.timer = container:get("Timer")
        self.panelTrade = container:get("Panels_PanelTrade")

        self.timerName = container:get("config").timerUpdatePoleBarPrevious.timerName
        self.timerPause = container:get("config").timerUpdatePoleBarPrevious.timerPause

        -- ��������� ������
        self.timer:set(self.timerName, self.timerPause)

        return self
    end,

    --
    updatePole = function(self, idStock)
        local dto = {}

        local barPrevious = self.container:get("Handler_PoleBarPrevious"):getParams(idStock)
        array_merge(dto, barPrevious)

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
