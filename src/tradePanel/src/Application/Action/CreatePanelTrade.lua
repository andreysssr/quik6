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
        -- ������� ��������� �������, ����������
        self.panelTrade:show()

        -- ������������ ���������� ������
        self:registerClickHandler(self.panelTrade)


        -- ������ ������� - �������� ������ �������
        self.eventSender:send("CreatedPanelTrade", {})
    end,

    -- ����������� ����������� ������ ��� ������ ������
    registerClickHandler = function(self, panel)
        local panelClickHandler = function(table_id, typeClick, row, col)
            --- ��������� ������ ����� �� ������ ������ (�������)
            -- ���� ���� ����� ������� ��� ������� ���� ����� ������� ����
            if typeClick == QTABLE_LBUTTONDBLCLK or typeClick == QTABLE_LBUTTONDOWN then
                panel:clickHandler(row, col)
            end

            --- ��������� �������� ������ - ���������� ����� �������
            if typeClick == QTABLE_CLOSE then
                self.eventSender:send("ClosedPanelTrade", { panelName = panel:getName() })
            end

            --- ��������� ������ ���������� QTABLE_VKEY
            if typeClick == QTABLE_VKEY then
                self.eventKeyboardManager:trigger(col)
            end
        end

        SetTableNotificationCallback(panel:getId(), panelClickHandler)
    end

}

return Action
