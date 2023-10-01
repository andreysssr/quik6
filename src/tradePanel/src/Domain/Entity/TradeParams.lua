--- Entity Params

local Entity = {
    --
    name = "Entity_Params",

    -- коэффициент для увеличения количества лотов
    -- при сравнении с максимальным количеством лотов для покупки
    ratio = 0,

    -- сервис подсчёта максимального количества лотов
    serviceMaxLots = {},

    -- сервис базовой цены
    serviceBasePrice = {},

    -- сервис коррекции цены
    serviceCorrectPrice = {},

    -- настройки для запроса
    settingZapros = {},

    -- настройки для стопа запроса для - StopOrderLimit
    settingZaprosOffset = {},

    -- настройки для стопа
    settingStop = {},

    -- настройки для переноса стопа
    settingStopMove = {},

    -- настройки для тейка
    settingTake = {},

    --
    validator = {},

    --
    new = function(self, container)
        self.ratio = container:get("Config_ratio")
        self.serviceMaxLots = container:get("DomainService_CalculateMaxLots")
        self.serviceBasePrice = container:get("DomainService_GetBasePrice")
        self.serviceCorrectPrice = container:get("DomainService_CorrectPrice")

        self.settingZapros = container:get("config").zapros
        self.settingZaprosOffset = container:get("config").zaprosOffset
        self.settingStop = container:get("config").stop
        self.settingStopMove = container:get("config").stopMove
        self.settingTake = container:get("config").take

        self.validator = container:get("AppService_Validator")

        local trait = container:get("Entity_TraitEvent")
        extended(self, trait)

        return self
    end,

    --
    newChild = function(self, params)
        local object = {
            id = params.idStock,
            class = params.class,

            basePrice = {},

            data = {},

            events = {},

            -- промежуточные данные расчётов
            tmpResult = {
                zapros = {},
                stop = {},
                stopMove = {},
                take = {},
            },
        }

        extended(object, self)

        return object
    end,

    -- вернуть id Entity_Params - "SBER"
    getId = function(self)
        return self.id
    end,

    -- вернуть класс
    getClass = function(self)
        return self.class
    end,

    -- восстановить данные после загрузки программы
    recoveryParams = function(self, params)
        self.data = params
    end,

    -- проверить что параметры не пустые
    hasParams = function(self)
        if not_empty(self.data) then
            return true
        end

        return false
    end,

    -- вернуть параметры под id
    getParamsZapros = function(self)
        if self:hasParams() then
            return copy(self.data.zapros)
        end

        -- если данных под таким id нет - вернём пустой массив
        return {}
    end,

    -- вернуть параметры под id
    getParamsStop = function(self)
        if self:hasParams() then
            return copy(self.data.stop)
        end

        -- если данных нет - вернём пустой массив
        return {}
    end,

    -- вернуть параметры под
    getParamsStopMove = function(self)
        if self:hasParams() then
            return copy(self.data.stopMove)
        end

        -- если данных нет - вернём пустой массив
        return {}
    end,

    -- вернуть параметры под
    getParamsTake = function(self)
        if self:hasParams() then
            return copy(self.data.take)
        end

        -- если данных нет - вернём пустой массив
        return {}
    end,

    -- вернуть параметры для
    getParams = function(self)
        if self:hasParams() then
            return copy(self.data)
        end

        -- если данных нет - вернём пустой массив
        return {}
    end,

    -- возвращает противоположное значение операции
    getReverseOperation = function(self, operation)
        self.validator:check_buy_sell(operation)

        if operation == "sell" then
            return "buy"
        end

        if operation == "buy" then
            return "sell"
        end

        return operation
    end,

    -- обновляет базовую цену для расчёта
    -- используется в (updateParams) - перед расчётом
    updateBasePrice = function(self)
        self.basePrice = self.serviceBasePrice:getBasePrice(self.id)

        if empty(self.basePrice) then
            error("\r\n" .. "Error: Отсутствуют параметры (BasePrice) для инструмента (" .. self.id .. ")")
        end
    end,

    -- рассчитать параметры для запроса
    -- range = 0, 5, 10,
    calculateParamsZapros = function(self, operation, range)
        self.validator:check_buy_sell(operation)
        self.validator:checkRange(range)

        -- получаем десятую часть шага интервала
        local partStepInterval = self.basePrice.interval / 8 / 10

        -- получаем стоп-цену согласно настройкам
        local price = self.basePrice.price + (partStepInterval * self.settingZapros[operation][range])
        local stopPrice = self.basePrice.price + (partStepInterval * self.settingZaprosOffset[operation][range])

        local marketPrice = 0

        -- корректируем цену по шагу инструмента
        if operation == "buy" then
            price = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, price)
            stopPrice = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, stopPrice)

            marketPrice = price + (self.basePrice.interval / 2)
            marketPrice = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, marketPrice)
        else
            price = self.serviceCorrectPrice:getPriceSell(self.id, self.class, price)
            stopPrice = self.serviceCorrectPrice:getPriceSell(self.id, self.class, stopPrice)

            marketPrice = price - (self.basePrice.interval / 2)
            marketPrice = self.serviceCorrectPrice:getPriceSell(self.id, self.class, marketPrice)
        end

        -- добавляем параметры
        self.tmpResult.zapros.price = d0(price)
        self.tmpResult.zapros.stopPrice = d0(stopPrice)
        self.tmpResult.zapros.marketPrice = d0(marketPrice)
        self.tmpResult.zapros.operation = operation
    end,

    -- рассчитать параметры для стопа
    calculateParamStop = function(self, operation, range)
        -- получаем десятую часть шага интервала
        local partStepInterval = self.basePrice.interval / 8 / 10

        -- получаем стоп-цену согласно настройкам
        local stopPrice = self.basePrice.price + (partStepInterval * self.settingStop[operation][range])
        local price = 0

        -- операция стопа противоположна открытию
        local _operation = self:getReverseOperation(operation)

        -- корректируем цену по шагу инструмента
        if _operation == "buy" then
            stopPrice = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, stopPrice)

            price = self.basePrice.price + (self.basePrice.interval / 2)
            price = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, price)
        else
            stopPrice = self.serviceCorrectPrice:getPriceSell(self.id, self.class, stopPrice)

            price = self.basePrice.price - (self.basePrice.interval / 2)
            price = self.serviceCorrectPrice:getPriceSell(self.id, self.class, price)
        end

        -- добавляем параметры
        self.tmpResult.stop.stopPrice = d0(stopPrice)
        self.tmpResult.stop.price = d0(price)
        self.tmpResult.stop.operation = _operation
    end,

    -- рассчитать параметры для переноса стопа
    calculateParamStopMove = function(self, operation, range)
        -- получаем десятую часть шага интервала
        local partStepInterval = self.basePrice.interval / 8 / 10

        -- получаем стоп-цену согласно настройкам
        local stopPrice = self.basePrice.price + (partStepInterval * self.settingStopMove[operation][range])
        local price = 0

        -- операция стопа противоположна открытию
        local _operation = self:getReverseOperation(operation)

        -- корректируем цену по шагу инструмента
        if _operation == "buy" then
            stopPrice = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, stopPrice)

            price = self.basePrice.price + (self.basePrice.interval / 2)
            price = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, price)
        else
            stopPrice = self.serviceCorrectPrice:getPriceSell(self.id, self.class, stopPrice)

            price = self.basePrice.price - (self.basePrice.interval / 2)
            price = self.serviceCorrectPrice:getPriceSell(self.id, self.class, price)
        end

        -- добавляем параметры
        self.tmpResult.stopMove.stopPrice = d0(stopPrice)
        self.tmpResult.stopMove.price = d0(price)
        self.tmpResult.stopMove.operation = _operation
    end,

    -- рассчитать параметры для тейка
    calculateParamTake = function(self, operation)
        -- получаем шаг интервала
        local stepInterval = self.basePrice.interval / 8

        -- получаем часть шага интервала
        local partStepInterval = self.basePrice.interval / 8 / 10

        -- получаем стоп-цену согласно настройкам
        local price = {}

        for i = 2, 10 do
            price[i] = self.basePrice.price + (stepInterval * self.settingTake[operation][i])
        end

        -- операция тейка противоположна открытию
        local _operation = self:getReverseOperation(operation)

        -- корректируем цену по шагу инструмента
        if _operation == "buy" then
            for i = 2, 10 do
                price[i] = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, price[i] + (partStepInterval * self.settingTake.offsetPartStepInterval))
            end
        else
            for i = 2, 10 do
                price[i] = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, price[i] - (partStepInterval * self.settingTake.offsetPartStepInterval))
            end
        end

        -- обрезаем лишние нули для дробных чисел
        -- обрезаем нули для целых чисел
        for i = 2, 10 do
            price[i] = d0(price[i])
        end

        -- добавляем параметры
        self.tmpResult.take.price = price
        self.tmpResult.take.operation = _operation
    end,

    -- сохранить результаты расчётов под переданным idParams
    _saveResult = function(self, idParams)
        self.data[idParams] = copy(self.tmpResult)

        self.tmpResult = {
            zapros = {},
            stop = {},
            stopMove = {},
            take = {},
        }
    end,

    -- сохранить результаты расчётов под переданным idParams
    saveResult = function(self)
        self.data = copy(self.tmpResult)

        self.tmpResult = {
            zapros = {},
            stop = {},
            stopMove = {},
            take = {},
        }

        self:registerEvent("EntityParams_UpdatedParams", {
            idStock = self.id,
        })
    end,

    -- удалить данные
    resetResult = function(self)
        self.data = {}
    end,

    -- рассчитать данные по базовой цене
    -- operation - "buy", "sell
    -- range - 0, 5, 10
    calculateParams = function(self, operation, range)
        -- проверить idParams
        self.validator:check_buy_sell(operation)
        self.validator:checkRange(range)

        -- обновляем параметры (basePrice) для расчётов
        self:updateBasePrice()

        -- buy, 5 (купить)
        -- рассчитать параметры для запроса
        self:calculateParamsZapros(operation, range)

        -- sell, 5 (продать ниже)
        -- рассчитать параметры для стопа
        self:calculateParamStop(operation, range)

        -- sell, 5 (продать чуть выше)
        -- рассчитать параметры для переноса стопа
        self:calculateParamStopMove(operation, range)

        -- sell, (продать выше на размер тейка)
        -- рассчитать и записываем параметры в take
        self:calculateParamTake(operation)

        -- сохранить результаты расчёта под idParams
        self:saveResult()
    end,

    -- рассчитать параметры для запроса по переданной цене запроса
    -- для рыночной цены - последняя цена сделки
    -- для лучшей цены сделки - лучшие цены по стакану (цена ask, bid)
    calculateParamsZaprosToPrice = function(self, operation, price)
        self.validator:check_buy_sell(operation)

        -- получаем десятую часть шага интервала
        local partStepInterval = self.basePrice.interval / 8 / 10

        -- получаем стоп-цену согласно настройкам
        local stopPrice = price + (partStepInterval * self.settingZaprosOffset.offset[operation])

        local marketPrice = 0

        local priceLoc

        -- корректируем цену по шагу инструмента
        if operation == "buy" then
            priceLoc = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, price)
            stopPrice = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, stopPrice)

            marketPrice = price + (self.basePrice.interval / 2)
            marketPrice = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, marketPrice)
        else
            priceLoc = self.serviceCorrectPrice:getPriceSell(self.id, self.class, price)
            stopPrice = self.serviceCorrectPrice:getPriceSell(self.id, self.class, stopPrice)

            marketPrice = price - (self.basePrice.interval / 2)
            marketPrice = self.serviceCorrectPrice:getPriceSell(self.id, self.class, marketPrice)
        end

        -- добавляем параметры
        self.tmpResult.zapros.price = d0(priceLoc)
        self.tmpResult.zapros.stopPrice = d0(stopPrice)
        self.tmpResult.zapros.marketPrice = d0(marketPrice)
        self.tmpResult.zapros.operation = operation
    end,

    -- рассчитать параметры для стопа по переданной цене запроса
    calculateParamStopToPrice = function(self, operation, priceZapros)
        -- стоп отличается на 7% от цены запроса в противоположную сторону

        -- получаем десятую часть шага интервала
        local partStepInterval = self.basePrice.interval / 8 / 10

        -- для запроса buy - будет price - 11%, sell
        -- для запроса sell - будет price + 11%, buy
        local stopPrice = priceZapros + (partStepInterval * self.settingStop["size"][operation])
        local price = 0

        -- операция стопа противоположна открытию
        local _operation = self:getReverseOperation(operation)

        -- корректируем цену по шагу инструмента
        if _operation == "buy" then
            stopPrice = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, stopPrice)

            price = priceZapros + (self.basePrice.interval / 2)
            price = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, price)
        else
            stopPrice = self.serviceCorrectPrice:getPriceSell(self.id, self.class, stopPrice)

            price = priceZapros - (self.basePrice.interval / 2)
            price = self.serviceCorrectPrice:getPriceSell(self.id, self.class, price)
        end

        -- добавляем параметры
        self.tmpResult.stop.stopPrice = d0(stopPrice)
        self.tmpResult.stop.price = d0(price)
        self.tmpResult.stop.operation = _operation
    end,

    -- рассчитать параметры для переноса стопа по переданной цене запроса
    -- используется для переноса в безубыток
    calculateParamStopMoveToPrice = function(self, operation, priceZapros)
        -- стоп отличается на 2% от цены запроса в ту же сторону

        -- получаем десятую часть шага интервала
        local partStepInterval = self.basePrice.interval / 8 / 10

        -- для запроса buy - будет price + 2%, sell
        -- для запроса sell - будет price - 2%, buy
        local stopPrice = priceZapros + (partStepInterval * self.settingStopMove["size"][operation])
        local price = 0

        -- операция стопа противоположна открытию
        local _operation = self:getReverseOperation(operation)

        -- корректируем цену по шагу инструмента
        if _operation == "buy" then
            stopPrice = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, stopPrice)

            price = priceZapros + (self.basePrice.interval / 2)
            price = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, price)
        else
            stopPrice = self.serviceCorrectPrice:getPriceSell(self.id, self.class, stopPrice)

            price = priceZapros - (self.basePrice.interval / 2)
            price = self.serviceCorrectPrice:getPriceSell(self.id, self.class, price)
        end

        -- добавляем параметры
        self.tmpResult.stopMove.stopPrice = d0(stopPrice)
        self.tmpResult.stopMove.price = d0(price)
        self.tmpResult.stopMove.operation = _operation
    end,

    -- рассчитать параметры для тейка по переданной цене запроса
    calculateParamTakeToPrice = function(self, operation, priceZapros)
        -- получаем шаг интервала
        local stepInterval = self.basePrice.interval / 8

        -- получаем десятую часть шага интервала
        local partStepInterval = self.basePrice.interval / 8 / 10

        -- получаем стоп-цену согласно настройкам
        local price = {}

        for i = 2, 10 do
            price[i] = priceZapros + (stepInterval * self.settingTake[operation][i])
        end

        -- операция тейка противоположна открытию
        local _operation = self:getReverseOperation(operation)

        -- корректируем цену по шагу инструмента
        if _operation == "buy" then
            for i = 2, 10 do
                price[i] = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, price[i] + (partStepInterval * self.settingTake.offsetPartStepInterval))
            end
        else
            for i = 2, 10 do
                price[i] = self.serviceCorrectPrice:getPriceBuy(self.id, self.class, price[i] - (partStepInterval * self.settingTake.offsetPartStepInterval))
            end
        end

        -- обрезаем лишние нули для дробных чисел
        -- обрезаем нули для целых чисел
        for i = 2, 10 do
            price[i] = d0(price[i])
        end

        -- добавляем параметры
        self.tmpResult.take.price = price
        self.tmpResult.take.operation = _operation
    end,

    -- рассчитать данные по переданной цене
    calculateParamsToPrice = function(self, operation, price)
        -- проверяем полученные параметры

        -- обновляем параметры (basePrice) для расчётов
        self:updateBasePrice()

        -- buy, 5
        -- рассчитать параметры для запроса по переданной цене запроса
        self:calculateParamsZaprosToPrice(operation, price)

        -- sell, 5
        -- рассчитать параметры для стопа по переданной цене запроса
        self:calculateParamStopToPrice(operation, price)

        -- рассчитать параметры для переноса стопа по переданной цене запроса
        self:calculateParamStopMoveToPrice(operation, price)

        -- sell, 5
        -- рассчитать параметры для тейка по переданной цене запроса
        self:calculateParamTakeToPrice(operation, price)

        -- сохранить результаты расчёта под idParams
        self:saveResult()
    end,

}

return Entity
