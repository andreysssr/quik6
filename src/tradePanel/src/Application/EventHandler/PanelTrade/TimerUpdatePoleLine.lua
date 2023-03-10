--- EventHandler PanelTrade

local EventHandler = {
    --
    name = "EventHandler_PanelTrade_TimerUpdatePoleLine",

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
        self.handlerPoleLine = container:get("Handler_PoleLine")

        self.timerName = container:get("config").timerUpdatePoleLine.timerName
        self.timerPause = container:get("config").timerUpdatePoleLine.timerPause

        -- ????????? ??????
        self.timer:set(self.timerName, self.timerPause)

        return self
    end,

    --
    updatePole = function(self, idStock)
        local dto = {}

        local line = self.container:get("Handler_PoleLine"):getParams(idStock)
        array_merge(dto, line)

        self.panelTrade:update(idStock, dto)
    end,

    -- ?????? ???? ???? ? ???????? ??????
    handle = function(self, event)
        -- ?????????? ?????????? ? ???????? ?????????? ? ??????? (updatePoleLine.timerPause)
        if self.timer:allows(self.timerName) then
            -- ???????? ?????? ??????? ?? ???????
            local arrayTickers = self.storage:getHomeworkId()

            -- ? ????? ???????? ???????? Entity BasePrice
            for i = 1, #arrayTickers do
                self:updatePole(arrayTickers[i])
            end

            -- ????????? ??????
            self.timer:set(self.timerName, self.timerPause)
        end
    end,
}

return EventHandler
