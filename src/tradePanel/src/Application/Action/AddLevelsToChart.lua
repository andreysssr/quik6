--- Action AddLevelsToChart

local Action = {
    --
    name = "Action_AddLevelsToChart",

    --
    container = {},

    --
    storage = {},

    -- сервис отчистки графика от всех меток и линий размещёных ранее
    serviceClean = {},

    -- microservice
    levelsToChart = {},

    -- microservice
    basePriceToChart = {},

    --
    timer = {},

    --
    timerName = "",

    --
    timerPause = 0,

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")
        self.serviceClean = container:get("AppService_CleanChart")
        self.levelsToChart = container:get("MicroService_LevelsToChart")
        self.basePriceToChart = container:get("MicroService_BasePriceToChart")
        self.timer = container:get("Timer")
        self.timerName = container:get("config").chartTimer.timerName
        self.timerPause = container:get("config").chartTimer.timerPause

        return self
    end,

    -- добавление уровней на графики
    handle = function(self)
        local arrayStock = self.storage:getHomeworkId()

        for i = 1, #arrayStock do
            -- при первом запуске - очищаем график
            self.serviceClean:clean(arrayStock[i])

            -- добавляем на график уровни и линии
            self.levelsToChart:addLevelToId(arrayStock[i])

            -- добавляем на график линию basePrice и линии 5% и 10% по краям от базовой линии
            self.basePriceToChart:addBasePriceToId(arrayStock[i])
        end

        -- обновление 1 раз в 4 минуты
        self.timer:set(self.timerName, self.timerPause)

    end,

    -- перерисовка (сдвиг линий в право)
    updateLocation = function(self)
        -- таймер
        if self.timer:allows(self.timerName) then
            -- обновить уровни
            self.levelsToChart:updateLocation()

            -- обновить линию basePrice и прилегающие линии на графике
            self.basePriceToChart:updateLocation()

            -- обновление 1 раз в 4 минуты
            self.timer:set(self.timerName, self.timerPause)
        end
    end,
}

return Action
