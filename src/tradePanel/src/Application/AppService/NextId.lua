--- AppService NextId

local AppService = {

    --
    name = "AppService_NextId",

    --
    new = function(self)
        return self
    end,

    -- Функция добавляет 0 к переданному значению,
    -- если количество переданных символов = 1, "1" -> "01"
    -- добавляет 0 к минутам от 1 - 9
    -- для минут и секунд
    addZero = function(self, number_str)
        local numberStr = tostring(number_str)

        if #numberStr == 1 then
            return "0" .. numberStr
        else
            return numberStr
        end
    end,

    -- добавляет 00 к микросекундам чтобы число было 3-х значным
    -- обычно микросекунды: 324, 798, 621,
    -- могут быть: 10, 79, 5, 8,
    addZeroMcs = function(self, number_str)
        -- число должно быть 3-х значным
        local numberStr = tostring(number_str)

        -- если число состоит из 2 символов
        if #numberStr == 2 then
            return "0" .. numberStr
        end

        -- если число состоит из 1 символа
        if #numberStr == 1 then
            return "00" .. numberStr
        end

        return numberStr
    end,

    -- возвращает новый id транзакции
    getId = function(self)
        sleep(1)

        local id = tostring(os.sysdate().hour) .. self:addZero(os.sysdate().min) .. self:addZero(os.sysdate().sec) .. self:addZeroMcs(os.sysdate().ms)

        return tonumber(id)
    end,

}

return AppService
