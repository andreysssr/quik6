--- работа с переменными

-- возвращает тип переменной
-- @return string "number", "string", "function", "boolean", "nil", "table"
getType = function(value)
    return type(value)
end

--unset - удаление переменной (присваиваем переменной значение nil)
unset = function(value)
    value = nil
end
