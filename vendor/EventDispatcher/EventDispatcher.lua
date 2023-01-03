--- EventDispatcher диспетчер событий Entity

local EventDispatcher = {
    --
    name = "EventDispatcher",

    -- обработчик событий
    eventSender = {},

    -- конструктор
    new = function(self, container)
        self.eventSender = container:get("AppService_EventSender")

        return self
    end,

    -- поочерёдно вызываем события и передаём в них данные
    dispatchEvents = function(self, arrayEvents)
        for i = 1, #arrayEvents do
            self.eventSender:send(arrayEvents[i].eventName, arrayEvents[i].params)
        end

        arrayEvents = nil
    end,
}

return EventDispatcher
