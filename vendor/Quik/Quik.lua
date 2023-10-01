-- класс для работы с Quik

local Quik = {
    --
    name = "Quik",

    new = function(self)

        return self
    end,

    -- проверка преданного id - тикера инструмента
    checkingId = function(self, id)
        if not_string(id) then
            error("\r\n" .. "Error: Id (бумаги) должен быть (строкой). Получено: (" .. type(id) .. ") - (" .. tostring(id) .. ")", 3)
        end
    end,

    -- проверка переданного класса
    checkingClass = function(self, class)
        if not_string(class) then
            error("\r\n" .. "Error: Class (бумаги) должен быть (строкой). Получено: (" .. type(class) .. ") - (" .. tostring(class) .. ")", 3)
        end
    end,

    -- вернуть стоимость шага для фьючерсов
    getStepPrice = function(self, id, class)
        self:checkingId(id)
        self:checkingClass(class)

        local stepPrice = getParamEx2(class, id, "STEPPRICE").param_value
        return tonumber(stepPrice)
    end,

    -- вернуть минимальный шаг инструмента
    getStepSize = function(self, id, class)
        self:checkingId(id)
        self:checkingClass(class)

        local status, retval = pcall(getSecurityInfo, class, id)

        if is_nil(retval) then
            error("\n\n" .. "Error: для инструмента (" .. id .. "), class - (" .. class .. ") нет данных о размере шага. \n" ..
                "- если это (акция) или (валюта) - возможно была опечатка в названии тикера \n" ..
                "- если это (фьючерс) - возможно истекла дата экспирации и нужно в (homework.csv) заменить название тикера"
            )
        end

        return getSecurityInfo(class, id).min_price_step
    end,

    -- вернуть размер лота
    getLotSize = function(self, id, class)
        self:checkingId(id)
        self:checkingClass(class)

        return getSecurityInfo(class, id).lot_size
    end,

    -- вернуть наименование инструмента
    getName = function(self, id, class)
        self:checkingId(id)
        self:checkingClass(class)

        return getSecurityInfo(class, id).name
    end,

    -- вернуть короткое наименование инструмента
    getNameShort = function(self, id, class)
        self:checkingId(id)
        self:checkingClass(class)

        return getSecurityInfo(class, id).short_name
    end,

    -- вернуть дату погашения
    getNameShort = function(self, id, class)
        self:checkingId(id)
        self:checkingClass(class)

        return getSecurityInfo(class, id).mat_date
    end,

    --
    getLastPrice = function(self, id, class)
        self:checkingId(id)
        self:checkingClass(class)

        return tonumber(getParamEx(class, id, "last").param_value)
    end,
}

return Quik
