--- Action UpdateBasePrice обновляет basePrice для всех инструментов

local Action = {
    --
    name = "Action_UpdateBasePrice",

    --
    timer = {},

    --
    nameTimer = "",

    --
    pauseTime = 0,

    --
    entityService = {},

    --
    countRun = 1,

    --
    new = function(self, container)
        self.timer = container:get("Timer")
        self.nameTimer = container:get("config").basePrice.nameTimer
        self.pauseTime = container:get("config").basePrice.pauseTime
        self.entityService = container:get("EntityService_BasePrice")

        -- запускаем таймер
        self.timer:set(self.nameTimer, self.pauseTime)

        return self
    end,

    --
    handle = function(self, event)
        -- если Action вызывается первый раз - тогда не ждём заданный таймаут
        if self.countRun == 1 then
            -- обновление данных для всех инструментов
            self.entityService:checkLevels()

            -- меняем значение запуска
            self.countRun = 2
        end

        -- обновление происходит с частотой записанной в конфиге (basePrice.pauseTime)
        if self.timer:allows(self.nameTimer) then

            -- обновление данных для всех инструментов
            self.entityService:checkLevels()

            -- снова устанавливаем таймер
            self.timer:set(self.nameTimer, self.pauseTime)
        end
    end,

}

return Action
