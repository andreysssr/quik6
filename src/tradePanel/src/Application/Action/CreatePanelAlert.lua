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
        -- ������� ��������� �������, ����������
        self.panelAlert:show()

        -- ������������ ���������� ������
        self:registerClickHandler(self.panelAlert)
    end,

    -- ����������� ����������� ������ ��� ������ ������
    registerClickHandler = function(self, panel)
        local panelClickHandler = function(table_id, typeClick, row, col)
            -- ��������� �������� ������ - ���������� ����� �������
            if typeClick == QTABLE_CLOSE then
                self.eventSender:send("ClosedPanelAlert", { panelName = panel:getName() })
            end
        end

        SetTableNotificationCallback(panel:getId(), panelClickHandler)
    end

}

return Action
