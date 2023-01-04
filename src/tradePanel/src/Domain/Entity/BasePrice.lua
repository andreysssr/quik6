---

local Entity_BasePrice = {
    --
    name = "Entity_BasePrice",

    --[[
        --
        id = "",

        --
        class = "",

        --
        events = {},

        --
        lastPrice = {},

        --
        params = {},

        -- здесь хранятся все значения уроней - в цифромвом массиве
        data = {},

        -- параметры текущего уровня
        basePrice = {
            --price = 0,
            ---- strong, line, level
            --type = "strong",
            --lines = {120, 125, 135, 140,}
        },

        ---
        -- сильные уровни
        strong = {},

        -- линии (30, 50, 70)
        levels = {},

        -- уровни интервалов
        lines = {},

        -- уровни середины
        centers = {}

        -- вспомогательные данные для расчётов
        -- заполненные уровни интервалов
        levelsTmp = {},

        -- вспомогательные данные для расчётов
        -- заполненные уровни (30%, 70%)
        linesTMP = {},

        -- вспомогательные данные для расчётов
        -- заполненные уровни (50%)
        centersTMP = {},

        ]]

    --
    lastPrice = {},

    --
    new = function(self, container)
        self.lastPrice = container:get("DomainService_LastPrice")

        local trait = container:get("Entity_TraitEvent")
        extended(self, trait)

        return self
    end,

    --
    newChild = function(self, params)
        local obj = {
            id = params.id,
            class = params.class,
            events = {},

            params = params,
            data = {}, -- массив для определения активного уровня
            dataView = {}, -- массив для отображения линий на графике
            basePrice = {},

            strong = {},
            levels = {},
            lines = {},
            centers = {},

            levelsTmp = {},
            linesTMP = {},
            centersTMP = {},

            intervalStep = 0,
        }

        extended(obj, self)

        return obj
    end,

    --
    init = function(self)
        self:createDataLevel()         -- создаёт структуру для интервальных уровней
        self:createDataLine()          -- создаёт структуру для линий (30%, 50%, 70%,)

        self:joinData()                -- объединяет все структуры в общую (в порядке важности)
    end,

    -- вернуть id
    getId = function(self)
        return self.id
    end,

    -- вернуть массив lines - состоит из 4 линий (-10%, -5%, 5%, 10%) от переданной цены
    -- price - базовая цена, минимальная граница, максимальная граница, шаг в 5% от интервала
    getLines = function(self, price, min, max, step)
        local lines = {}

        for i = min, max, step do
            if i ~= price then
                lines[#lines + 1] = i
            end
        end

        return lines
    end,

    -- рассчитывает параметры для интервальных уровней
    createDataLevel = function(self)
        -- количество уровней интервала (в значение цена уровня интервала)
        for price = self.params.minPrice, self.params.maxPrice, self.params.interval do
            self.levelsTmp[#self.levelsTmp + 1] = price
        end

        -- шаг интервала для смены активного уровня
        local intervalStep = self.params.interval / 2

        local viewLinesBasePrice = self.params.interval / 8

        for i = 1, #self.levelsTmp do
            self.levels[#self.levels + 1] = {
                price = self.levelsTmp[i],

                -- 1 шаг интервала
                minBorder = self.levelsTmp[i] - intervalStep, -- минимальная граница для уровня: -1 шаг интервала
                maxBorder = self.levelsTmp[i] + intervalStep, -- максимальная граница для уровня: 1 шаг интервала

                type = "level",
                interval = self.params.interval,
                lines = self:getLines(
                    self.levelsTmp[i], -- цена базовой линии
                    self.levelsTmp[i] - viewLinesBasePrice, -- минимальная граница: 1/6 часть интервала
                    self.levelsTmp[i] + viewLinesBasePrice, -- максимальная граница: 1/6 часть интервала
                    viewLinesBasePrice    -- половина шага интервала
                )
            }
        end
    end,

    createDataLine = function(self)
        -- шаг интервала
        local intervalStep = self.params.interval / 6

        local viewLinesBasePrice = self.params.interval / 3 / 8

        -- добавляем остальные линии
        for i = 1, #self.levelsTmp do
            self.linesTMP[#self.linesTMP + 1] = self.levelsTmp[i] - (intervalStep * 2) -- минус 2 шага интервала
            self.linesTMP[#self.linesTMP + 1] = self.levelsTmp[i] + (intervalStep * 2) -- минус 2 шага интервала
        end

        for i = 1, #self.linesTMP do
            self.lines[#self.lines + 1] = {
                price = self.linesTMP[i],

                -- 1 шаг интервала
                minBorder = self.linesTMP[i] - intervalStep, -- минимальная граница для уровня: -1 шаг интервала
                maxBorder = self.linesTMP[i] + intervalStep, -- максимальная граница для уровня: 1 шаг интервала

                type = "line",
                interval = self.params.interval,
                lines = self:getLines(
                    self.linesTMP[i], -- цена базовой линии
                    self.linesTMP[i] - viewLinesBasePrice, -- минимальная граница: 1/6 часть интервала
                    self.linesTMP[i] + viewLinesBasePrice, -- максимальная граница: 1/6 часть интервала
                    viewLinesBasePrice    -- половина шага интервала
                )
            }
        end
    end,

    -- объединить структуры в 1
    joinData = function(self)
        -- добавляем структуру levels в массив для проверки цены
        for i = 1, #self.levels do
            self.data[#self.data + 1] = self.levels[i]
        end
    end,

    -- сверяет записанное значение с текущим
    updateBasePrice = function(self, price, params, range)
        -- если значения не было (запущено и проверка прошла первый раз - тогда устанавливаем)
        if empty(self.basePrice) then
            -- записываем данные
            self.basePrice = copy(params)
            self.basePrice.range = range

            local dto = copy(params)
            dto.id = self.id
            dto.class = self.class
            dto.range = range

            dto.blockEvents = 1

            self:registerEvent("BasePrice_ChangedBasePrice", dto)

            return
        end

        -- если записанная цена не равна найденой базовой цене
        if self.basePrice.price ~= price then
            -- записываем данные
            self.basePrice = copy(params)
            self.basePrice.range = range

            local dto = copy(params)
            dto.id = self.id
            dto.class = self.class
            dto.range = range

            dto.blockEvents = 2

            self:registerEvent("BasePrice_ChangedBasePrice", dto)
        end
    end,

    -- вернёт дипапзон в котором находится цена относительно лиинии/уровня
    -- 5%, 10%, 15%, 20%
    getRange = function(self, currentPrice, basePrice)
        local range_5 = self.params.interval / 100 * 5
        local range_10 = self.params.interval / 100 * 10

        -- если (ТЕКУЩАЯ ЦЕНА) больше или равна (НИЖНЕГО ДИАПАЗОНА БАЗОВОЙ ЦЕНЫ)
        --									И
        -- (ТЕКУЩАЯ ЦЕНА) меньше или равна (ВЕРХНЕГО ДИАПАЗОНА БАЗОВОЙ ЦЕНЫ)
        -- будет рассчитываться для - "strong", "line", "level"
        if currentPrice >= (basePrice - range_5) and currentPrice <= (basePrice + range_5) then
            return 5
        end

        -- будет рассчитываться для - "strong", "line", "level"
        if currentPrice >= (basePrice - range_10) and currentPrice <= (basePrice + range_10) then
            return 10
        end

        return 0
    end,

    -- проверяем в диапазоне каких линий нахотся цена
    checkLevel = function(self)
        -- получаем последнюю цену
        local price = self.lastPrice:getPrice(self.id, self.class)

        -- значение дальности цены от линии/уровня - диапазон
        -- цена в диапазоне:
        --		5%
        --		10%
        local range = 0

        -- проходим по всей структуре данных и проверяем
        for i = 1, #self.data do
            -- (цена > минимальной граници) и (цена < максимальной границы)
            if price > self.data[i].minBorder and price < self.data[i].maxBorder then
                range = self:getRange(price, self.data[i].price)
                self:updateBasePrice(self.data[i].price, self.data[i], range)

                break
            end
        end
    end,

    -- вернуть построенную структуру
    getData = function(self)
        return self.data
    end,

    -- вернуть базовую цену
    getPrice = function(self)
        if not_empty(self.basePrice) then
            return self.basePrice.price
        end

        return nil
    end,

    -- возвращает массив текущих данных basePrice
    getBasePrice = function(self)
        return self.basePrice
    end,
}

return Entity_BasePrice
