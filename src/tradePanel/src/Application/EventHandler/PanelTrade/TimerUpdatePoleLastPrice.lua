--- EventHandler PanelTrade

local EventHandler = {
    --
    name = "EventHandler_PanelTrade_TimerUpdatePoleLastPrice",

    --
    container = {},

    --
    panelTrade = {},

    --
    timer = {},

    --
    storage = {},

    --
    handlerPoleLastPrice = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")
        self.timer = container:get("Timer")
        self.panelTrade = container:get("Panels_PanelTrade")
        self.handlerPoleLastPrice = container:get("Handler_PoleLastPrice")

        self.timerName = container:get("config").timerUpdatePoleLastPrice.timerName
        self.timerPause = container:get("config").timerUpdatePoleLastPrice.timerPause

        -- ��������� ������
        self.timer:set(self.timerName, self.timerPause)

        return self
    end,

    --
    updatePole = function(self, idStock)
        local dto = {}

        local lastPrice = self.container:get("Handler_PoleLastPrice"):getParams(idStock)
        array_merge(dto, lastPrice)

        self.panelTrade:update(idStock, dto)
    end,

    -- ������ ���� ���� � �������� ������
    handle = function(self, event)
        -- ���������� ���������� � �������� ���������� � ������� (updatePoleLastPrice.timerPause)
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
