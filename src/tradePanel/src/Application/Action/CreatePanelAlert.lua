--- Action CreatePanelTrade

local Action = {
    --
    name = "Action_CreatePanelTrade",

    --
    panelAlert = {},

    --
    eventSender = {},

    --
    new = function(self, container)
        self.panelAlert = container:get("Panels_PanelAlert")
        self.eventSender = container:get("AppService_EventSender")

        return self
    end,

    --
    handle = function(self)
        -- выводим формируем таблицу, показываем
        self.panelAlert:show()

        -- регистрируем обработчик кликов
        self:registerClickHandler(self.panelAlert)
    end,

    -- регистрация обработчика кликов для каждой панели
    registerClickHandler = function(self, panel)
        local panelClickHandler = function(table_id, typeClick, row, col)
            -- обработка закрытия панели - обработать через событие
            if typeClick == QTABLE_CLOSE then
                self.eventSender:send("ClosedPanelAlert", { panelName = panel:getName() })
            end
        end

        SetTableNotificationCallback(panel:getId(), panelClickHandler)
    end

}

return Action
