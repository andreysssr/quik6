--- Action CreatePanelTrade

local Action = {
    --
    name = "Action_CreatePanelTrade",

    --
    panelTrade = {},

    --
    eventSender = {},

    --
    eventKeyboardManager = {},

    --
    new = function(self, container)
        self.panelTrade = container:get("Panels_PanelTrade")
        self.eventSender = container:get("AppService_EventSender")
        self.eventKeyboardManager = container:get("EventKeyboardManager")

        return self
    end,

    --
    handle = function(self)
        -- выводим формируем таблицу, показываем
        self.panelTrade:show()

        -- регистрируем обработчик кликов
        self:registerClickHandler(self.panelTrade)


        -- создаём событие - Торговая панель создана
        self.eventSender:send("CreatedPanelTrade", {})
    end,

    -- регистрация обработчика кликов для каждой панели
    registerClickHandler = function(self, panel)
        local panelClickHandler = function(table_id, typeClick, row, col)
            --- обработка кликов мышью по ячейки панели (таблицы)
            -- один клик левой кнопкой или двойной клик левой кнопкой миши
            if typeClick == QTABLE_LBUTTONDBLCLK or typeClick == QTABLE_LBUTTONDOWN then
                panel:clickHandler(row, col)
            end

            --- обработка закрытия панели - обработать через событие
            if typeClick == QTABLE_CLOSE then
                self.eventSender:send("ClosedPanelTrade", { panelName = panel:getName() })
            end

            --- обработка кликов клавиатуры QTABLE_VKEY
            if typeClick == QTABLE_VKEY then
                self.eventKeyboardManager:trigger(col)
            end
        end

        SetTableNotificationCallback(panel:getId(), panelClickHandler)
    end

}

return Action
