--- AppService CalculateLotsToMoneyRisk

local AppService = {
    --
    name = "AppService_CalculateLotsToMoneyRisk",

    --
    container = {},

    -- размер риска в рублях,
    -- зависит от режима торговли:
    -- test - 1 лотом, но не больше риска
    -- norm - количество лотов зависит от риска
    -- для тестового режима сначала проверяем по риску
    -- если больше 0 - тогда 1 лот
    trade = 0,

    --
    storage = {},

    --
    quik = {},

    --
    new = function(self, container)
        self.container = container

        self.trade = container:get("Config_trade")
        self.storage = container:get("Storage")
        self.quik = container:get("Quik")

        return self
    end,

    -- возвращает количество лотов для акций
    getLotsStock = function(self, id, class)
        -- формула расчёта количества лотов для акций
        -- размер риска / (размер стопа * количество акций в 1 лоте)
        -- (размер стопа) = интервал * 7%

        -- интервал инструмента
        local interval = self.storage:getIntervalToId(id)

        -- стоп в процентах - 7%
        local stopSizePercent = self.container:get("config").stop.size.default

        -- находим стоп от интервала
        local sizeStop = interval / 100 * stopSizePercent

        -- количество акций в 1 лотое
        local lotSize = self.quik:getLotSize(id, class)

        -- риск на сделку
        local moneyRisk = self.trade.moneyRisk

        -- количество лотов на 1 риск
        local lots = moneyRisk / (sizeStop * lotSize)

        -- округляем в меньшую сторону
        lots = math.floor(lots)

        -- если это тестовая торговля и укладываемся в риск
        -- тогда торговать будем 1 лотом
        if self.trade.mode == "test" and lots > 0 then
            return 1
        end

        return d0(lots)
    end,

    -- возвращает количество лотов для фьючерсов
    getLotsFutures = function(self, id, class)
        -- Рассчитываем допустимый риск на сделку в рублях,
        -- риск на сделку
        local moneyRisk = self.trade.moneyRisk
        -- ----------------------------------------------------
        -- рассчитываем стоп-лосс в пунктах
        -- Стоп-лосс в пунктах = (цена входа — цена стопа)
        -- интервал инструмента
        local interval = self.storage:getIntervalToId(id)

        -- стоп в процентах - 7%
        local stopSizePercent = self.container:get("config").stop.size.default

        -- находим стоп от интервала
        local sizeStop = interval / 100 * stopSizePercent
        -- ----------------------------------------------------
        -- рассчитываем стоп в рублях - для 1 лота фьючерса
        -- Стоп-лосс в рублях = (стоп-лосс в пунктах / шаг цены) * стоимость пункта
        -- local sizeRub = (sizeStop / шаг цены) * стоимость шага цены

        -- шаг цены
        local stepSize = self.quik:getStepSize(id, class)

        -- цена 1 шага
        local stepPrice = self.quik:getStepPrice(id, class)

        -- 1 стоп в рублях
        -- (размер стопа в пунктах) делим на (размер шага) = количество шагов в стопе
        -- (количество шагов в стопе) умножаем на (цену шага) = цена стопа 1 лота в рублях
        local sizeStopRubles = (sizeStop / stepSize) * stepPrice
        -- ----------------------------------------------------
        -- Количество контрактов = допустимый риск на сделку в рублях / стоп-лосс в рублях 1 лота фьючерса
        local lots = moneyRisk / sizeStopRubles

        -- округляем в меньшую сторону
        lots = math.floor(lots)

        -- если это тестовая торговля и укладываемся в риск
        -- тогда торговать будем 1 лотом
        if self.trade.mode == "test" and lots > 0 then
            return 1
        end

        return d0(lots)
    end,


    -- возвращает количество лотов для валюты
    getLotsCurrency = function(self, id, class)
        -- Рассчитываем допустимый риск на сделку в рублях,
        -- риск на сделку
        local moneyRisk = self.trade.moneyRisk
        -- ----------------------------------------------------
        -- рассчитываем стоп-лосс в пунктах
        -- Стоп-лосс в пунктах = (цена входа — цена стопа)
        -- интервал инструмента
        local interval = self.storage:getIntervalToId(id)

        -- стоп в процентах - 7%
        local stopSizePercent = self.container:get("config").stop.size.default

        -- находим стоп от интервала
        local sizeStop = interval / 100 * stopSizePercent

        -- ----------------------------------------------------
        -- полученный стоп в пунктах * на количество бумаг в 1 лоте (1000) - стандарное количество для валюты
        -- получится размер стопа для 1 лота
        local sizeStopLot = sizeStop * 1000

        -- ----------------------------------------------------
        -- (риск на сделку) делим на (размер стопа 1 лота)
        local lots = moneyRisk / sizeStopLot

        -- округляем в меньшую сторону
        lots = math.floor(lots)

        -- если это тестовая торговля и укладываемся в риск
        -- тогда торговать будем 1 лотом
        if self.trade.mode == "test" and lots > 0 then
            return 1
        end

        return d0(lots)
    end,


    getLots = function(self, id, class)
        if class == "TQBR" or class == "QJSIM" then
            return self:getLotsStock(id, class)
        end

        if class == "SPBFUT" then
            return self:getLotsFutures(id, class)
        end

        if class == "CETS" then
            return self:getLotsCurrency(id, class)
        end
    end,
}

return AppService
