local db_levels = {
    --
    data = {},

    new = function(self)
        local dataPath = basePath .. "data\\lua\\levels.lua"

        self.data = dofile(dataPath)

        return self
    end,

    -- значение не должно быть nil
    checkParamNotNil = function(self, value, name)
        if type(value) == "nil" then
            error("Error: Ошибка: параметр (" .. name .. ") не передан.", 3)
        end
    end,

    -- значение не должно быть nil
    checkParamNumber = function(self, value, name)
        if type(value) ~= "number" then
            error("Error: Ошибка: параметр (" .. name .. ") должен быть числом. " ..
                "Получено: (" .. type(value) .. ") - " .. tostring(value), 3)
        end
    end,

    -- значение не должно быть nil
    checkParamString = function(self, value, name)
        if type(value) ~= "string" then
            error("Error: Ошибка: параметр (" .. name .. ") должен быть строкой. " ..
                "Получено: (" .. type(value) .. ") - " .. tostring(value), 3)
        end
    end,

    -- значение не должно быть nil
    checkParamBoolean = function(self, value, name)
        if type(value) ~= "boolean" then
            error("Error: Ошибка: параметр (" .. name .. ") должен быть boolean значением. " ..
                "Получено: (" .. type(value) .. ") - " .. tostring(value), 3)
        end
    end,

    -- проверка существования инструмента в базе данных
    exist = function(self, id, class)
        if class ~= "TQBR" and class ~= "SPBFUT" and class ~= "CETS" and class ~= "QJSIM" and class ~= "SPBOPT" and class ~= "INDX" then
            error("\n" .. "Error: Ошибка: параметр (class) должен быть: (TQBR) или (SPBFUT) или (CETS). " ..
                "Получено: (" .. type(class) .. ") - " .. tostring(class), 3)
        end

        -- для демо версии меняем для акций
        if class == "QJSIM" then
            class = "TQBR"
        end

        -- для демо версии меняем для фьючерсов
        if class == "SPBOPT" then
            class = "SPBFUT"
        end

        if self.data[class][id] then
            return true
        end

        return false
    end,

    -- высчитывает цену для построения уровней
    -- возвращает начальную цену, конечную цену, интервал
    getCalculateStartStopPrice = function(self, lastPrice, interval, countInterval, offset)
        -- цена с которой начнётся переборка
        local startPrice = 0 + offset

        -- цена на которой остановится переборка
        local stopPrice = lastPrice + (interval * countInterval)

        -- результат который буде возвращён
        local result = {}

        -- временный массив для сохранения цен с шагом интервала
        local arrayPrice = {}

        -- записывает все цены от 0 до максимальной
        for i = startPrice, stopPrice, interval do
            arrayPrice[#arrayPrice + 1] = i
        end

        -- максимальный номер индекса массива
        local lastNumber = #arrayPrice

        -- максимальная цена для уровня - последняя добавленная цена в массив
        -- получаем последнюю добавленную запись
        result.maxPrice = arrayPrice[lastNumber]

        -- если количество интервалов больше чем размер массива с интервалами цен - тогда стартовой ценой будет цена старта
        -- получаем минимальную цену линий интервалов
        -- arrayPrice - массив со списком интервалов от 0 до максимального, допустим там последний номер = 20
        -- теперь от 20 - countInterval (количество интервалов допустим 3) * 2(3 количество вверх, и 3 количества вниз, посередине последняя цена)
        -- тогда будет 20 - 6 + 1 = 15, это индекс записи интервала с нулевой цены,
        -- номер записи 15 буден минимальной ценой наших диапазонов,
        -- а максимальная цена - это последняя запись наших диапазонов
        local minPrice = arrayPrice[lastNumber - (countInterval * 2) + 1]

        -- бывает когда интервал большой и расчёт уходит в минус
        -- поскольку индекса с минусом нет - вернёт nil
        if minPrice == nil then
            result.minPrice = startPrice
        else
            result.minPrice = minPrice
        end

        -- добавляем в полученный результат интервал
        result.interval = interval

        return result
    end,

    -- возвращает параметры интервала, начала цены, окончания цены - для уровней
    -- class, id - класс и код инструмента
    -- lastPrice последняя цена инструмента (будет центром отсчёта для интервалов)
    -- countInterval - количество интервалов которое нужно получить
    -- mode - режим работы:
    -- dev - режим разработчика, тестирование, используется если нет последней цены
    -- prod - режим работы, используется переданная цена
    --[[
        return возвращает nil - если такого инструмента нет
        или возвращает структуру
        {
            maxPrice = 200,
            minPrice = 180,
        }
    ]]
    getParamsLevel = function(self, id, class, lastPrice, countInterval)
        self:checkParamString(id, "id")
        self:checkParamString(class, "class")
        self:checkParamNumber(lastPrice, "lastPrice")
        self:checkParamNumber(countInterval, "countInterval")

        if not self:exist(id, class) then
            return false
        end

        -- для демо версии меняем для акций
        if class == "QJSIM" then
            class = "TQBR"
        end

        -- для демо версии меняем для фьючерсов
        if class == "SPBOPT" then
            class = "SPBFUT"
        end

        -- интервал инструмента записанный в базе
        local interval = self.data[class][id].interval

        -- смещение цены если
        local offset = 0

        -- если у инструмента есть смещение в базе - тогда записываем его, иначе оно равно 0
        if self.data[class][id].offset then
            offset = self.data[class][id].offset
        end

        -- получает параметры для построения уровней
        local result = self:getCalculateStartStopPrice(lastPrice, interval, countInterval, offset)

        -- если есть настройки для сильных уровней - добавляем их параметры
        if self.data[class][id].strongLevels then
            result.strongLevels = self.data[class][id].strongLevels
        end

        return result
    end,

    -- вернуть интервал бумаги
    getInterval = function(self, id, class)
        self:checkParamString(id, "id")
        self:checkParamString(class, "class")

        if not self:exist(id, class) then
            return false
        end

        -- интервал инструмента записанный в базе
        return self.data[class][id].interval
    end,
}

return db_levels
