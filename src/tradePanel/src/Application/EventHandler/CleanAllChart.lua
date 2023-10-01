--- EventHandler CleanAllChart - удаляет все метки с графиков

local EventHandler = {
    --
    name = "EventHandler_CleanAllChart",

    --
    storage = {},

    --
    serviceClean = {},

    --
    new = function(self, container)
        self.storage = container:get("Storage")
        self.serviceClean = container:get("AppService_CleanChart")

        return self
    end,

    --
    handle = function(self)
        local arrayStock = self.storage:getHomeworkId()

        for i = 1, #arrayStock do
            -- при первом запуске - очищаем графики
            self.serviceClean:clean(arrayStock[i])
        end
    end,
}

return EventHandler
