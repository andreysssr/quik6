--- Timer

local Timer = {
    --
    name = "Timer",

    -- хранилище таймеров
    dataTimer = {},

    currentTime = 0,

    -- конструктор
    new = function(self)
        return self
    end,

    -- устанавливает имя и время таймера в секундах
    set = function(self, name, intervalSeconds)
        if not_number(intervalSeconds) then
            error("Временной интервал должен быть числом - в секундах")
        end

        -- последнее время вызова таймера
        -- os.time() - возвращает время в секундах, прошедших с полуночи 1 января 1970 года,
        self.dataTimer[name] = os.time() + intervalSeconds
    end,

    -- позволяет работать (если установленное время истекло)
    allows = function(self, name)
        if not isset(self.dataTimer[name]) then
            error("Такого таймера не существует - " .. name)
        end

        -- время таймера меньше чем текущее - можно работать
        -- установленное время прошло
        if self.dataTimer[name] <= os.time() then
            return true
        else
            return false
        end
    end
}

return Timer
