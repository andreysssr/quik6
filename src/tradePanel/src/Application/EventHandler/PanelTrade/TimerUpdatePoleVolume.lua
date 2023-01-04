--- EventHandler PanelTrade

local EventHandler = {
    --
    name = "EventHandler_PanelTrade_TimerUpdatePoleVolume",

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

        self.timerName = container:get("config").timerUpdatePoleVolume.timerName
        self.timerPause = container:get("config").timerUpdatePoleVolume.timerPause

        -- запускаем таймер
        self.timer:set(self.timerName, self.timerPause)

        return self
    end,

    --
    updatePole = function(self, idStock)
        local dto = {}

        local volume = self.container:get("Handler_PoleVolume"):getParams(idStock)
        array_merge(dto, volume)

        self.panelTrade:update(idStock, dto)
    end,

    -- меняем цвет поля в торговой панели
    handle = function(self, event)
        -- обновление происходит с частотой записанной в конфиге (updatePoleLine.timerPause)
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
