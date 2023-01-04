--- AppService EventSender

local AppService = {
    --
    name = "AppService_EventSender",

    app = {},

    new = function(self, container)
        self.app = container:get("Application")

        return self
    end,

    send = function(self, name, event)
        self.app:trigger(name, event)
    end,
}

return AppService
