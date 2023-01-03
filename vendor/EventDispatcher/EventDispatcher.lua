--- EventDispatcher ��������� ������� Entity

local EventDispatcher = {
    --
    name = "EventDispatcher",

    -- ���������� �������
    eventSender = {},

    -- �����������
    new = function(self, container)
        self.eventSender = container:get("AppService_EventSender")

        return self
    end,

    -- ��������� �������� ������� � ������� � ��� ������
    dispatchEvents = function(self, arrayEvents)
        for i = 1, #arrayEvents do
            self.eventSender:send(arrayEvents[i].eventName, arrayEvents[i].params)
        end

        arrayEvents = nil
    end,
}

return EventDispatcher
