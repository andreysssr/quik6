--- Расширение языка Lua пользовательскими функциями

--- Проверка на соответствие

-- проверяет, что значение равно nil
is_nil = function(value)
    return type(value) == "nil"
end

-- проверяет, что значение является числом
is_number = function(value)
    return type(value) == "number"
end

-- проверяет что значение является строкой
is_string = function(value)
    return type(value) == "string"
end

-- проверяет что значение является функцией
is_function = function(value)
    return type(value) == "function"
end

-- проверяет, что значение является таблицей
is_table = function(value)
    return type(value) == "table"
end

-- проверяет, что значение является массивом
is_array = function(value)
    return type(value) == "table"
end

-- проверяет, что значение является объектом
is_object = function(value)
    return type(value) == "table"
end

-- проверяет, что значение является логическим типом
is_boolean = function(value)
    return type(value) == "boolean"
end

-- проверяет, что значение равно true
is_true = function(value)
    if not_boolean(value) then
        error("\r\n" .. "Error: Ожидалось логическое значение (boolean). Получено: " .. getType(value) .. "] - " .. tostring(value), 2)
    end

    return value == true
end

-- проверяет, что значение равно false
is_false = function(value)
    if not_boolean(value) then
        error("\r\n" .. "Error: Ожидалось логическое значение (boolean). Получено: " .. getType(value) .. "] - " .. tostring(value), 2)
    end

    return value == false
end

-- проверяет, что в массиве существует ключ
key_exists = function(array, key)
    if not_array(array) then
        error("\r\n" .. "Error: Ожидался (массив) - в первом параметре. Получено: [" .. getType(array) .. "] - " .. tostring(array), 2)
    end

    if is_nil(key) then
        error("\r\n" .. "Error: Ожидалась (значение кроме nil) - во втором параметре. Получено: [" .. getType(key) .. "] - " .. tostring(key), 2)
    end

    return array[key] ~= nil
end

-- проверяет, что в массиве присутствует значение
in_array = function(array, value)
    if not_array(array) then
        error("\r\n" .. "Error: Ожидался (массив) - в первом параметре. Получено: [" .. getType(array) .. "] - " .. tostring(array), 2)
    end

    if is_nil(value) then
        error("\r\n" .. "Error: Ожидалось (значение кроме nil) - во втором параметре. Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
    end

    local inArray = false

    for _, val in pairs(array) do
        if value == val then
            inArray = true
        end
    end

    return inArray
end

-- проверяет наличие всех ключей из массива "keysArray" в массиве "array"
-- если все ключи есть - вернёт "true", иначе "false"
keys_in_array = function(array, keysArray)
    if not_array(array) then
        error("\r\n" .. "Error: Ожидался (массив) - в первом параметре. Получено: [" .. getType(array) .. "] - " .. tostring(array), 2)
    end

    if not_array(keysArray) then
        error("\r\n" .. "Error: Ожидался (массив) - во втором параметре. Получено: [" .. getType(keysArray) .. "] - " .. tostring(keysArray), 2)
    end

    local keys_in_array = true

    for key, _ in pairs(keysArray) do
        if not_key_exists(array, key) then
            keys_in_array = false
        end
    end

    return keys_in_array
end

-- проверяет существует ли переменная (не равна "nil")
isset = function(value)
    return value ~= nil
end

-- проверяет, пуста ли переменная/массив
empty = function(value)
    if is_table(value) then
        return next(value) == nil
    end

    return value == nil
end

-- проверяет, что одно значение равно другому (==)
eq = function(value1, value2)
    return value1 == value2
end

-- проверяет, что метод существует в классе/объекте
method_exists = function(object, method)
    if not_object(object) then
        error("\r\n" .. "Error: Ожидался (объект) - в первом параметре. Получено: [" .. getType(object) .. "] - " .. tostring(object), 2)
    end

    if is_nil(method) then
        error("\r\n" .. "Error: Ожидался (значение кроме nil) - во втором параметре. Получено: [" .. getType(method) .. "] - " .. tostring(method), 2)
    end

    return type(object[method]) == "function"
end

-- проверяет, что свойство существует в классе/объекте
property_exists = function(object, property)
    if not_object(object) then
        error("\r\n" .. "Error: Ожидался (объект) - в первом параметре. Получено: [" .. getType(object) .. "] - " .. tostring(object), 2)
    end

    if is_nil(property) then
        error("\r\n" .. "Error: Ожидался (значение кроме nil) - во втором параметре. Получено: [" .. getType(property) .. "] - " .. tostring(property), 2)
    end

    return object[property] ~= nil
end

--- Проверка на НЕ соответствие

-- проверяет, что значение не равно nil
not_nil = function(value)
    return type(value) ~= "nil"
end

-- проверяет, что значение не является числом
not_number = function(value)
    return type(value) ~= "number"
end

-- проверяет что значение не является строкой
not_string = function(value)
    return type(value) ~= "string"
end

-- проверяет что значение не является функцией
not_function = function(value)
    return type(value) ~= "function"
end

-- проверяет, что значение не является таблицей
not_table = function(value)
    return type(value) ~= "table"
end

-- проверяет, что значение не является массивом
not_array = function(value)
    return type(value) ~= "table"
end

-- проверяет, что значение не является объектом
not_object = function(value)
    return type(value) ~= "table"
end

-- проверяет, что значение не является логическим типом
not_boolean = function(value)
    return type(value) ~= "boolean"
end

-- проверяет, что значение не равно true
not_true = function(value)
    if not_boolean(value) then
        error("\r\n" .. "Error: Ожидалось логическое значение (boolean). Получено: " .. getType(value) .. "] - " .. tostring(value), 2)
    end

    return value ~= true
end

-- проверяет, что значение не равно false
not_false = function(value)
    if not_boolean(value) then
        error("\r\n" .. "Error: Ожидалось логическое значение (boolean). Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
    end

    return value ~= false
end

-- проверяет, что в массиве не существует ключ
not_key_exists = function(array, key)
    if not_array(array) then
        error("\r\n" .. "Error: Ожидался (массив) - в первом параметре. Получено: [" .. getType(array) .. "] - " .. tostring(array), 2)
    end

    if is_nil(key) then
        error("\r\n" .. "Error: Ожидался (любое значение кроме nil) - во втором параметре. Получено: [" .. getType(key) .. "] - " .. tostring(key), 2)
    end

    return array[key] == nil
end

-- проверяет, что в массиве не присутствует значение
not_in_array = function(array, value)
    if not_array(array) then
        error("\r\n" .. "Error: Ожидался (массив) - в первом параметре. Получено: [" .. getType(array) .. "] - " .. tostring(array), 2)
    end

    if is_nil(value) then
        error("\r\n" .. "Error: Ожидался (любое значение кроме nil) - во втором параметре. Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
    end

    local not_in_array = true

    for _, val in pairs(array) do
        if value == val then
            not_in_array = false
        end
    end

    return not_in_array
end

-- проверяет отсутствие всех ключей из массива "keysArray" в массиве "array"
-- если все ключи есть - вернёт "true", иначе "false"
not_keys_in_array = function(array, keysArray)
    if not_array(array) then
        error("\r\n" .. "Error: Ожидался (массив) - в первом параметре. Получено: [" .. getType(array) .. "] - " .. tostring(array), 2)
    end

    if not_array(keysArray) then
        error("\r\n" .. "Error: Ожидался (массив) - во втором параметре. Получено: [" .. getType(keysArray) .. "] - " .. tostring(keysArray), 2)
    end

    local not_keys_in_array = true

    for key, _ in pairs(keysArray) do
        if key_exists(array, key) then
            not_keys_in_array = false
        end
    end

    return not_keys_in_array
end

-- проверяет не существует ли переменная (не равна "nil")
not_isset = function(value)
    return value == nil
end

-- проверяет, не пуста ли переменная/массив
not_empty = function(value)
    if is_table(value) then
        return next(value) ~= nil
    end

    return value ~= nil
end

-- проверяет, что одно значение не равно другому (==)
not_eq = function(value1, value2)
    return value1 ~= value2
end

-- проверяет, что метод не существует в классе/объекте
not_method_exists = function(object, method)
    if not_object(object) then
        error("\r\n" .. "Error: Ожидался (объект) - в первом параметре. Получено: [" .. getType(object) .. "] - " .. tostring(object), 2)
    end

    if is_nil(method) then
        error("\r\n" .. "Error: Ожидалось (любое значение кроме nil) - во втором параметре. Получено: [" .. getType(method) .. "] - " .. tostring(method), 2)
    end

    return type(object[method]) ~= "function"
end

-- проверяет, что свойство не существует в классе/объекте
not_property_exists = function(object, property)
    if not_object(object) then
        error("\r\n" .. "Error: Ожидался (объект) - в первом параметре. Получено: [" .. getType(object) .. "] - " .. tostring(object), 2)
    end

    if is_nil(property) then
        error("\r\n" .. "Error: Ожидалось (любое значение кроме nil) - во втором параметре. Получено: [" .. getType(property) .. "] - " .. tostring(property), 2)
    end

    return object[property] == nil
end

Assert = {
    --- Проверка на соответсвтие

    -- проверяет, что значение равно nil
    is_nil = function(self, value)
        if not_nil(value) then
            error("\r\n" .. "Assert: Ожидалось (nil). Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- проверяет, что значение является числом
    is_number = function(self, value)
        if not_number(value) then
            error("\r\n" .. "Assert: Ожидалось (число). Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- проверяет что значение является строкой
    is_string = function(self, value)
        if not_string(value) then
            error("\r\n" .. "Assert: Ожидалась (строка). Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- проверяет что значение является функцией
    is_function = function(self, value)
        if not_function(value) then
            error("\r\n" .. "Assert: Ожидалась (функция). Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- проверяет, что значение является таблицей
    is_table = function(self, value)
        if not_table(value) then
            error("\r\n" .. "Assert: Ожидалась (таблица). Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- проверяет, что значение является массивом
    is_array = function(self, value)
        if not_array(value) then
            error("\r\n" .. "Assert: Ожидался (массив). Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- проверяет, что значение является объектом
    is_object = function(self, value)
        if not_object(value) then
            error("\r\n" .. "Assert: Ожидался (объект). Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- проверяет, что значение является логическим типом
    is_boolean = function(self, value)
        if not_boolean(value) then
            error("\r\n" .. "Assert: Ожидалось логическое значение (boolean). Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- проверяет, что значение равно true
    is_true = function(self, value)
        if not_boolean(value) then
            error("\r\n" .. "Error: Ожидалось логическое значение (boolean). Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end

        if not_true(value) then
            error("\r\n" .. "Assert: Ожидалось логическое значение (boolean = true). Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- проверяет, что значение равно false
    is_false = function(self, value)
        if not_boolean(value) then
            error("\r\n" .. "Error: Ожидалось логическое значение (boolean). Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end

        if not_false(value) then
            error("\r\n" .. "Assert: Ожидалось логическое значение (boolean = false). Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- проверяет, что в массиве существует ключ
    key_exists = function(self, array, key)
        if not_array(array) then
            error("\r\n" .. "Error: Ожидался (массив) - в первом параметре. Получено: [" .. getType(array) .. "] - " .. tostring(array), 2)
        end

        if is_nil(key) then
            error("\r\n" .. "Error: Ожидалась (значение кроме nil) - во втором параметре. Получено: [" .. getType(key) .. "] - " .. tostring(key), 2)
        end

        if not key_exists(array, key) then
            error("\r\n" .. "Assert: Ожидалась (в массиве): [" .. getType(array) .. "] - " .. tostring(array) .. " (наличие ключа): [" .. getType(key) .. "] - " .. tostring(key), 2)
        end
    end,

    -- проверяет, что в массиве присутствует значение
    in_array = function(self, array, value)
        if not_array(array) then
            error("\r\n" .. "Error: Ожидался (массив) - в первом параметре. Получено: [" .. getType(array) .. "] - " .. tostring(array), 2)
        end

        if is_nil(value) then
            error("\r\n" .. "Error: Ожидалась (значение кроме nil) - во втором параметре. Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end

        if not in_array(array, value) then
            error("\r\n" .. "Assert: Ожидалась (в массиве): [" .. getType(array) .. "] - " .. tostring(array) .. " (наличие значения): [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- проверяет наличие всех ключей из массива "keysArray" в массиве "array"
    -- если все ключи есть - вернёт "true", иначе "false"
    keys_in_array = function(self, array, keysArray)
        if not is_table(array) then
            error("\r\n" .. "Error: Ожидался (массив). Получено: [" .. getType(array) .. "] - " .. tostring(array), 2)
        end

        if not is_table(keysArray) then
            error("\r\n" .. "Error: Ожидался (массив). Получено: [" .. getType(keysArray) .. "] - " .. tostring(keysArray), 2)
        end

        if not keys_in_array(array, keysArray) then
            error("\r\n" .. "Assert: Ожидалась (в массиве): [" .. getType(array) .. "] - " .. tostring(array) .. " (наличие всех ключей): [" .. getType(keysArray) .. "] - " .. tostring(keysArray), 2)
        end
    end,

    -- проверяет существует ли переменная (не равна "nil")
    isset = function(self, value)
        if not_isset(value) then
            error("\r\n" .. "Assert: Ожидалось существование элемента. Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- проверяет, пуста ли переменная/массив
    empty = function(self, value)
        if not_empty(value) then
            error("\r\n" .. "Assert: Ожидалось пустое значение. Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- проверяет, что одно значение равно другому (==)
    eq = function(self, value1, value2)
        if not_eq(value1, value2) then
            error("\r\n" .. "Assert: Ожидалось равенство в значениях. Получено [value 1]:  [" .. getType(value1) .. "] - " .. tostring(value1) .. ", [value 2]: " .. getType(value2) .. "] - " .. tostring(value2), 2)
        end
    end,

    -- проверяет, что метод существует в классе/объекте
    method_exists = function(self, object, method)
        if not method_exists(object, method) then
            error("\r\n" .. "Assert: Ожидалось в (объекте): [" .. getType(object) .. "], (наличие метода): [" .. getType(method) .. "] - " .. tostring(method), 2)
        end
    end,

    -- проверяет, что свойство существует в классе/объекте
    property_exists = function(self, object, property)
        if not property_exists(object, property) then
            error("\r\n" .. "Assert: Ожидалось в (объекте): [" .. getType(object) .. "], (наличие свойства): [" .. getType(property) .. "] - " .. tostring(property), 2)
        end
    end,

    --- Проверка на НЕ соответствие

    -- проверяет, что значение равно nil
    not_nil = function(self, value)
        if is_nil(value) then
            error("\r\n" .. "Assert: Ожидалось (не nil). Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- проверяет, что значение является числом
    not_number = function(self, value)
        if is_number(value) then
            error("\r\n" .. "Assert: Ожидалось (не число). Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- проверяет что значение является строкой
    not_string = function(self, value)
        if is_string(value) then
            error("\r\n" .. "Assert: Ожидалась (не строка). Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- проверяет что значение является функцией
    not_function = function(self, value)
        if is_function(value) then
            error("\r\n" .. "Assert: Ожидалась (не функция). Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- проверяет, что значение является таблицей
    not_table = function(self, value)
        if is_table(value) then
            error("\r\n" .. "Assert: Ожидалась (не таблица). Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- проверяет, что значение является массивом
    not_array = function(self, value)
        if is_array(value) then
            error("\r\n" .. "Assert: Ожидался (не массив). Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- проверяет, что значение является объектом
    not_object = function(self, value)
        if is_object(value) then
            error("\r\n" .. "Assert: Ожидался (не объект). Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- проверяет, что значение является логическим типом
    not_boolean = function(self, value)
        if is_boolean(value) then
            error("\r\n" .. "Assert: Ожидалось не логическое значение (boolean). Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- проверяет, что значение равно true
    not_true = function(self, value)
        if not_boolean(value) then
            error("\r\n" .. "Error: Ожидалось логическое значение (boolean). Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end

        if is_true(value) then
            error("\r\n" .. "Assert: Ожидалось логическое значение (boolean = false). Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- проверяет, что значение равно false
    not_false = function(self, value)
        if not_boolean(value) then
            error("\r\n" .. "Error: Ожидалось логическое значение (boolean). Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end

        if is_false(value) then
            error("\r\n" .. "Assert: Ожидалось логическое значение (boolean = true). Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- проверяет, что в массиве существует ключ
    not_key_exists = function(self, array, key)
        if not_array(array) then
            error("\r\n" .. "Error: Ожидался (массив) - в первом параметре. Получено: [" .. getType(array) .. "] - " .. tostring(array), 2)
        end

        if is_nil(key) then
            error("\r\n" .. "Error: Ожидалась (значение кроме nil) - во втором параметре. Получено: [" .. getType(key) .. "] - " .. tostring(key), 2)
        end

        if key_exists(array, key) then
            error("\r\n" .. "Assert: Ожидалась (отсутствие в массиве): [" .. getType(array) .. "] - " .. tostring(array) .. " (ключа): [" .. getType(key) .. "] - " .. tostring(key), 2)
        end
    end,

    -- проверяет, что в массиве присутствует значение
    not_in_array = function(self, array, value)
        if not_array(array) then
            error("\r\n" .. "Error: Ожидался (массив) - в первом параметре. Получено: [" .. getType(array) .. "] - " .. tostring(array), 2)
        end

        if is_nil(value) then
            error("\r\n" .. "Error: Ожидалась (значение кроме nil) - во втором параметре. Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end

        if in_array(array, value) then
            error("\r\n" .. "Assert: Ожидалась (отсутствие в массиве): [" .. getType(array) .. "] - " .. tostring(array) .. " (значения): [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- проверяет отсутствие всех ключей из массива "keysArray" в массиве "array"
    -- если все ключи есть - вернёт "true", иначе "false"
    not_keys_in_array = function(self, array, keysArray)
        if not is_table(array) then
            error("\r\n" .. "Error: Ожидался (массив). Получено: [" .. getType(array) .. "] - " .. tostring(array), 2)
        end

        if not is_table(keysArray) then
            error("\r\n" .. "Error: Ожидался (массив). Получено: [" .. getType(keysArray) .. "] - " .. tostring(keysArray), 2)
        end

        if keys_in_array(array, keysArray) then
            error("\r\n" .. "Assert: Ожидалась (отсутствие в массиве): [" .. getType(array) .. "] - " .. tostring(array) .. " (всех ключей): [" .. getType(keysArray) .. "] - " .. tostring(keysArray), 2)
        end
    end,

    -- проверяет существует ли переменная (не равна "nil")
    not_isset = function(self, value)
        if isset(value) then
            error("\r\n" .. "Assert: Ожидалось отсутствие элемента. Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- проверяет, пуста ли переменная/массив
    not_empty = function(self, value)
        if empty(value) then
            error("\r\n" .. "Assert: Ожидалось не пустое значение. Получено: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- проверяет, что одно значение равно другому (==)
    not_eq = function(self, value1, value2)
        if eq(value1, value2) then
            error("\r\n" .. "Assert: Ожидалось не равенство в значениях. Получено [value 1]:  [" .. getType(value1) .. "] - " .. tostring(value1) .. ", [value 2]: " .. getType(value2) .. "] - " .. tostring(value2), 2)
        end
    end,

    -- проверяет, что метод не существует в классе/объекте
    not_method_exists = function(self, object, method)
        if method_exists(object, method) then
            error("\r\n" .. "Assert: Ожидалось в (объекте): [" .. getType(object) .. "] - " .. tostring(object) .. ", (отсутствие метода): " .. getType(method) .. "] - " .. tostring(method), 2)
        end
    end,

    -- проверяет, что свойство существует в классе/объекте
    not_property_exists = function(self, object, property)
        if property_exists(object, property) then
            error("\r\n" .. "Assert: Ожидалось в (объекте): [" .. getType(object) .. "] - " .. tostring(object) .. ", (отсутствие свойства): " .. getType(property) .. "] - " .. tostring(property), 2)
        end
    end
}
