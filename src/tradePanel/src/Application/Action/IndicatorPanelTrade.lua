--- Action IndicatorPanelTrade обновляет индикатор в торгвой панели

local Action = {
    --
    name = "Action_IndicatorPanelTrade",

    --
    timer = {},

    --
    timerName = "",

    --
    timerPause = 0,

    --
    panelTrade = {},


    --
    mode = "on",

    --
    new = function(self, container)
        self.timer = container:get("Timer")
        self.timerName = container:get("config").timerIndicatorPanelTrade.timerName
        self.timerPause = container:get("config").timerIndicatorPanelTrade.timerPause
        self.panelTrade = container:get("Panels_PanelTrade")

        -- запускаем таймер
        self.timer:set(self.timerName, self.timerPause)

        return self
    end,

    --
    handle = function(self, event)
        -- обновление происходит с частотой записанной в конфиге (basePrice.timerPause)
        if self.timer:allows(self.timerName) then

            if self.mode == "on" then
                self.mode = "off"
            else
                self.mode = "on"
            end

            self.panelTrade:updateIndicator(self.mode)

            -- снова устанавливаем таймер
            self.timer:set(self.timerName, self.timerPause)
        end
    end,

}

return Action
