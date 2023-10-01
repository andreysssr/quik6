--- EventHandler PanelTrade

local EventHandler = {
    --
    name = "EventHandler_PanelTrade_TimerUpdatePoleAtrClose",

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

        self.timerName = container:get("config").timerUpdatePoleAtrClose.timerName
        self.timerPause = container:get("config").timerUpdatePoleAtrClose.timerPause

        -- запускаем таймер
        self.timer:set(self.timerName, self.timerPause)

        return self
    end,

    --
    updatePole = function(self, idStock)
        local dto = {}

        local atrClose = self.container:get("Handler_PoleAtrClose"):getParams(idStock)
        array_merge(dto, atrClose)

        self.panelTrade:update(idStock, dto)
    end,

    -- меняем цвет поля в торговой панели
    handle = function(self, event)
        -- обновление происходит с частотой записанной в конфиге (updatePoleLevel.timerPause)
        if self.timer:allows(self.timerName) then
            -- получаем массив тикеров по домашке
            local arrayTickers = self.storage:getHomeworkId()

            -- в цикле вызываем создание Entity BasePrice
            for i = 1, #arrayTickers do
                self:updatePole(arrayTickers[i])
            end

            -- запускаем таймер
            self.timer:set(self.timerName, self.timerPause)
        end
    end,
}

return EventHandler
