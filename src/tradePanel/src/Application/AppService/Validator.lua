--- AppService Validating

local AppService = {
    --
    name = "AppService_Validating",

    --
    new = function(self)
        return self
    end,

    -- значение не должно быть nil
    checkParamNotNil = function(self, val, name)
        if is_nil(val) then
            error("Error: Ошибка: параметр (" .. name .. ") не передан.", 3)
        end
    end,

    -- значение не должно быть nil
    checkParamNumber = function(self, value, name)
        if not_number(value) then
            error("Error: Ошибка: параметр (" .. name .. ") должен быть числом. " ..
                "Получено: (" .. type(value) .. ") - " .. tostring(value), 3)
        end
    end,

    -- значение не должно быть nil
    checkParamString = function(self, value, name)
        if not_string(value) then
            error("Error: Ошибка: параметр (" .. name .. ") должен быть строкой. " ..
                "Получено: (" .. type(value) .. ") - " .. tostring(value), 3)
        end
    end,

    -- значение не должно быть nil
    checkParamBoolean = function(self, value, name)
        if not_boolean(value) then
            error("Error: Ошибка: параметр (" .. name .. ") должен быть boolean значением. " ..
                "Получено: (" .. type(value) .. ") - " .. tostring(value), 3)
        end
    end,

    -- значение должно быть: "limit" или "market" - иначе ошибка
    checkId = function(self, value)
        if not_string(value) then
            error("\r\n\r\n" .. "Error: id должен быть строкой. " ..
                "Получено: (" .. type(value) .. ") - " .. tostring(value), 3)
        end
    end,

    -- значение должно быть: "limit" или "market" - иначе ошибка
    checkClass = function(self, value)
        if not_string(value) then
            error("\r\n\r\n" .. "Error: class должен быть строкой. " ..
                "Получено: (" .. type(value) .. ") - " .. tostring(value), 3)
        end
    end,

    -- значение должно быть: "limit" или "market" - иначе ошибка
    checkPrice = function(self, value)
        if not_number(value) then
            error("\r\n\r\n" .. "Error: Цена должна быть числом " ..
                "Получено: (" .. type(value) .. ") - " .. tostring(value), 3)
        end
    end,

    -- значение должно быть: "limit" или "market" - иначе ошибка
    check_limit_market = function(self, value)
        if value ~= "limit" and value ~= "market" then
            error("\r\n\r\n" .. "Error: Значение (typeOrder) должно быть (limit) или (market). " ..
                "Получено: (" .. type(value) .. ") - " .. tostring(value), 3)
        end
    end,

    -- значение должно быть: "buy" или "sell" - иначе ошибка
    check_buy_sell = function(self, value)
        if value ~= "buy" and value ~= "sell" then
            error("\r\n\r\n" .. "Error: Значение (operation) должно быть (buy) или (sell)." ..
                "Получено: (" .. type(value) .. ") - " .. tostring(value), 3)
        end
    end,

    -- значение должно быть: 0, или 5, или 10 - иначе ошибка
    checkRange = function(self, value)
        if value ~= 0 and value ~= 5 and value ~= 10 and value ~= 105 and value ~= 110 then
            error("\r\n\r\n" .. "Error: Значение (range) должно быть (0) или (5) или (10)." ..
                "Получено: (" .. type(value) .. ") - " .. tostring(value), 3)
        end
    end,

    -- значение должно быть: 20, или 30, или 40, или 50, или 60, или 70 - иначе ошибка
    checkTake = function(self, value)
        if value ~= 2 and value ~= 3 and value ~= 4 and value ~= 5 and value ~= 6 and value ~= 7 and value ~= 8 and value ~= 9 and value ~= 10 then
            error("\r\n\r\n" .. "Error: Значение (тейка) должно быть (2) или (3) или (4) или (5) или (6)." ..
                "Получено: (" .. type(value) .. ") - " .. tostring(value), 3)
        end
    end,
}

return AppService
