--- Entity Ds

local Entity = {
    --
    name = "Entity_Ds",

    --
    storage = {},

    --
    servicePrices = {},

    --
    new = function(self, container)
        self.storage = container:get("Storage")
        self.servicePrices = container:get("AppService_ServicePrices")

        local trait = container:get("Entity_TraitEvent")

        extended(self, trait)

        return self
    end,

    -- вернуть id
    getId = function(self)
        return self.id
    end,

    -- удаляет источник данных, отписывается от получения данных
    removeDs = function(self)
        self.ds:Close()
    end,

    -- вернуть посчитанное значение в % от интервала
    getRangeInterval = function(self, offsetPrice)
        local result = offsetPrice / (self.interval / 100)
        return dCrop(result, 1)
    end,

    -- вернуть посчитанное значение в % от интервала
    getRangeDay = function(self, offsetPrice)
        local result = offsetPrice / ((self.interval / 2) / 100)
        return dCrop(result, 1)
    end,

    -- проверяет - обновился ли бар
    -- если бар обновился - создаётся событие
    checkNewBar = function(self)
        if self.numLastBar ~= self.ds:Size() then
            self.numLastBar = self.ds:Size()

            -- регистрируем событие - изменение номер текущего бара
            self:registerEvent("DS_UpdatedNumBar", {
                idStock = self.id
            })
        end
    end,

    -- вернуть Atr последнего бара
    -- (текущий Hi) - (текущий Low)
    getAtrBarCurrent = function(self)
        local numBar = self.ds:Size()

        if is_nil(numBar) then
            return "notBar"
        end

        local atr = self.ds:H(numBar) - self.ds:L(numBar)

        return self:getRangeInterval(atr)
    end,

    -- вернуть Atr предыдущего бара
    -- (предыдущий Hi) - (предыдущий low)
    getAtrBarPrev = function(self)
        local numBar = self.ds:Size() - 1

        if is_nil(numBar) then
            return "notBar"
        end

        local atr = self.ds:H(numBar) - self.ds:L(numBar)

        return self:getRangeInterval(atr)
    end,

    -- вернуть Гэп
    -- (вчерашнее закрытие) - (сегодняшнее открытие)
    -- абсолютная величина
    getGap = function(self)
        local currentBar = self.ds:Size()
        local prevBar = self.ds:Size() - 1

        if is_nil(prevBar) then
            return "notBar"
        end

        local gap = self.ds:C(prevBar) - self.ds:O(currentBar)

        gap = math.abs(gap)

        return self:getRangeDay(gap)
    end,

    -- ATR от вчерашнего закрытия
    -- (вчерашнее закрытие) - (текущая цена)
    getAtrClose = function(self)
        local prevBar = self.ds:Size() - 1

        if is_nil(prevBar) then
            return "notBar"
        end

        local idStock = self.id
        local class = self.storage:getClassToId(idStock)

        -- поучаем текущую цену
        local lastPrice = self.servicePrices:getLastPrice(idStock, class)

        local closePrevBar = self.ds:C(prevBar)

        -- находим разницу между вчерашним закрытием и текущей ценой
        local atrClose = math.abs(closePrevBar - lastPrice)

        return self:getRangeDay(atrClose)
    end,

    --
    -- (цена открытия) - (текущая цена)
    getAtrOpen = function(self)
        local idStock = self.id
        local class = self.storage:getClassToId(idStock)

        local lastPrice = self.servicePrices:getLastPrice(idStock, class)

        local currentBar = self.ds:Size()

        local openPrice = self.ds:O(currentBar)

        -- находим разницу между открытием и текущей ценой
        local atrOpen = math.abs(openPrice - lastPrice)

        return self:getRangeDay(atrOpen)
    end,

    -- вернуть полный Atr текущего дневного бара
    -- (текущий Hi) - (текущий Low)
    getAtrFull = function(self)
        local numBar = self.ds:Size()

        if is_nil(numBar) then
            return "notBar"
        end

        local atr = self.ds:H(numBar) - self.ds:L(numBar)

        return self:getRangeDay(atr)
    end,

    -- вернуть hi low последних 3 баров
    getHiLow = function(self)
        local numBar = self.ds:Size()

        if is_nil(numBar) then
            return "notBar"
        end

        local result = {
            bar1 = {
                hi = self.ds:H(numBar),
                low = self.ds:L(numBar),
            },
            bar2 = {
                hi = self.ds:H(numBar - 1),
                low = self.ds:L(numBar - 1),
            },
            bar3 = {
                hi = self.ds:H(numBar - 2),
                low = self.ds:L(numBar - 2),
            },
            bar4 = {
                hi = self.ds:H(numBar - 3),
                low = self.ds:L(numBar - 3),
            },
        }

        return result
    end,

    -- вернуть объём последних 3 баров
    getVolume = function(self)
        local numBar = self.ds:Size()

        if is_nil(numBar) then
            return "notBar"
        end

        local result = {
            bar1 = self.ds:V(numBar),
            bar2 = self.ds:V(numBar - 1),
            bar3 = self.ds:V(numBar - 2),
        }

        return result
    end,

    -- вернуть hi, low, close предыдущего дня
    getHiLowClosePreviousBar = function(self)
        local numBar = self.ds:Size() - 1

        local dto = {
            hi = self.ds:H(numBar),
            low = self.ds:L(numBar),
            close = self.ds:C(numBar),
        }

        return dto
    end,

    -- для часовика (10 часов - для акций)
    getHiLowBarHour10 = function(self)
        local result = {
            hi = 0,
            low = 0,
        }

        for i = self.ds:Size(), 20, -1 do
            if self.ds:T(i).hour == 10 then
                result.hi = self.ds:H(i)
                result.low = self.ds:L(i)

                break
            end
        end

        return result
    end,

    -- для часовика (9 часов - для фьючерсов)
    getHiLowBarHour9 = function(self)
        local result = {
            hi = 0,
            low = 0,
        }

        for i = self.ds:Size(), 20, -1 do
            if self.ds:T(i).hour == 9 then
                result.hi = self.ds:H(i)
                result.low = self.ds:L(i)

                break
            end
        end

        return result
    end,
}

return Entity
