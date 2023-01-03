--- ���������� ����� Lua ����������������� ���������

--- �������� �� ������������

-- ���������, ��� �������� ����� nil
is_nil = function(value)
    return type(value) == "nil"
end

-- ���������, ��� �������� �������� ������
is_number = function(value)
    return type(value) == "number"
end

-- ��������� ��� �������� �������� �������
is_string = function(value)
    return type(value) == "string"
end

-- ��������� ��� �������� �������� ��������
is_function = function(value)
    return type(value) == "function"
end

-- ���������, ��� �������� �������� ��������
is_table = function(value)
    return type(value) == "table"
end

-- ���������, ��� �������� �������� ��������
is_array = function(value)
    return type(value) == "table"
end

-- ���������, ��� �������� �������� ��������
is_object = function(value)
    return type(value) == "table"
end

-- ���������, ��� �������� �������� ���������� �����
is_boolean = function(value)
    return type(value) == "boolean"
end

-- ���������, ��� �������� ����� true
is_true = function(value)
    if not_boolean(value) then
        error("\r\n" .. "Error: ��������� ���������� �������� (boolean). ��������: " .. getType(value) .. "] - " .. tostring(value), 2)
    end

    return value == true
end

-- ���������, ��� �������� ����� false
is_false = function(value)
    if not_boolean(value) then
        error("\r\n" .. "Error: ��������� ���������� �������� (boolean). ��������: " .. getType(value) .. "] - " .. tostring(value), 2)
    end

    return value == false
end

-- ���������, ��� � ������� ���������� ����
key_exists = function(array, key)
    if not_array(array) then
        error("\r\n" .. "Error: �������� (������) - � ������ ���������. ��������: [" .. getType(array) .. "] - " .. tostring(array), 2)
    end

    if is_nil(key) then
        error("\r\n" .. "Error: ��������� (�������� ����� nil) - �� ������ ���������. ��������: [" .. getType(key) .. "] - " .. tostring(key), 2)
    end

    return array[key] ~= nil
end

-- ���������, ��� � ������� ������������ ��������
in_array = function(array, value)
    if not_array(array) then
        error("\r\n" .. "Error: �������� (������) - � ������ ���������. ��������: [" .. getType(array) .. "] - " .. tostring(array), 2)
    end

    if is_nil(value) then
        error("\r\n" .. "Error: ��������� (�������� ����� nil) - �� ������ ���������. ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
    end

    local inArray = false

    for _, val in pairs(array) do
        if value == val then
            inArray = true
        end
    end

    return inArray
end

-- ��������� ������� ���� ������ �� ������� "keysArray" � ������� "array"
-- ���� ��� ����� ���� - ����� "true", ����� "false"
keys_in_array = function(array, keysArray)
    if not_array(array) then
        error("\r\n" .. "Error: �������� (������) - � ������ ���������. ��������: [" .. getType(array) .. "] - " .. tostring(array), 2)
    end

    if not_array(keysArray) then
        error("\r\n" .. "Error: �������� (������) - �� ������ ���������. ��������: [" .. getType(keysArray) .. "] - " .. tostring(keysArray), 2)
    end

    local keys_in_array = true

    for key, _ in pairs(keysArray) do
        if not_key_exists(array, key) then
            keys_in_array = false
        end
    end

    return keys_in_array
end

-- ��������� ���������� �� ���������� (�� ����� "nil")
isset = function(value)
    return value ~= nil
end

-- ���������, ����� �� ����������/������
empty = function(value)
    if is_table(value) then
        return next(value) == nil
    end

    return value == nil
end

-- ���������, ��� ���� �������� ����� ������� (==)
eq = function(value1, value2)
    return value1 == value2
end

-- ���������, ��� ����� ���������� � ������/�������
method_exists = function(object, method)
    if not_object(object) then
        error("\r\n" .. "Error: �������� (������) - � ������ ���������. ��������: [" .. getType(object) .. "] - " .. tostring(object), 2)
    end

    if is_nil(method) then
        error("\r\n" .. "Error: �������� (�������� ����� nil) - �� ������ ���������. ��������: [" .. getType(method) .. "] - " .. tostring(method), 2)
    end

    return type(object[method]) == "function"
end

-- ���������, ��� �������� ���������� � ������/�������
property_exists = function(object, property)
    if not_object(object) then
        error("\r\n" .. "Error: �������� (������) - � ������ ���������. ��������: [" .. getType(object) .. "] - " .. tostring(object), 2)
    end

    if is_nil(property) then
        error("\r\n" .. "Error: �������� (�������� ����� nil) - �� ������ ���������. ��������: [" .. getType(property) .. "] - " .. tostring(property), 2)
    end

    return object[property] ~= nil
end

--- �������� �� �� ������������

-- ���������, ��� �������� �� ����� nil
not_nil = function(value)
    return type(value) ~= "nil"
end

-- ���������, ��� �������� �� �������� ������
not_number = function(value)
    return type(value) ~= "number"
end

-- ��������� ��� �������� �� �������� �������
not_string = function(value)
    return type(value) ~= "string"
end

-- ��������� ��� �������� �� �������� ��������
not_function = function(value)
    return type(value) ~= "function"
end

-- ���������, ��� �������� �� �������� ��������
not_table = function(value)
    return type(value) ~= "table"
end

-- ���������, ��� �������� �� �������� ��������
not_array = function(value)
    return type(value) ~= "table"
end

-- ���������, ��� �������� �� �������� ��������
not_object = function(value)
    return type(value) ~= "table"
end

-- ���������, ��� �������� �� �������� ���������� �����
not_boolean = function(value)
    return type(value) ~= "boolean"
end

-- ���������, ��� �������� �� ����� true
not_true = function(value)
    if not_boolean(value) then
        error("\r\n" .. "Error: ��������� ���������� �������� (boolean). ��������: " .. getType(value) .. "] - " .. tostring(value), 2)
    end

    return value ~= true
end

-- ���������, ��� �������� �� ����� false
not_false = function(value)
    if not_boolean(value) then
        error("\r\n" .. "Error: ��������� ���������� �������� (boolean). ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
    end

    return value ~= false
end

-- ���������, ��� � ������� �� ���������� ����
not_key_exists = function(array, key)
    if not_array(array) then
        error("\r\n" .. "Error: �������� (������) - � ������ ���������. ��������: [" .. getType(array) .. "] - " .. tostring(array), 2)
    end

    if is_nil(key) then
        error("\r\n" .. "Error: �������� (����� �������� ����� nil) - �� ������ ���������. ��������: [" .. getType(key) .. "] - " .. tostring(key), 2)
    end

    return array[key] == nil
end

-- ���������, ��� � ������� �� ������������ ��������
not_in_array = function(array, value)
    if not_array(array) then
        error("\r\n" .. "Error: �������� (������) - � ������ ���������. ��������: [" .. getType(array) .. "] - " .. tostring(array), 2)
    end

    if is_nil(value) then
        error("\r\n" .. "Error: �������� (����� �������� ����� nil) - �� ������ ���������. ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
    end

    local not_in_array = true

    for _, val in pairs(array) do
        if value == val then
            not_in_array = false
        end
    end

    return not_in_array
end

-- ��������� ���������� ���� ������ �� ������� "keysArray" � ������� "array"
-- ���� ��� ����� ���� - ����� "true", ����� "false"
not_keys_in_array = function(array, keysArray)
    if not_array(array) then
        error("\r\n" .. "Error: �������� (������) - � ������ ���������. ��������: [" .. getType(array) .. "] - " .. tostring(array), 2)
    end

    if not_array(keysArray) then
        error("\r\n" .. "Error: �������� (������) - �� ������ ���������. ��������: [" .. getType(keysArray) .. "] - " .. tostring(keysArray), 2)
    end

    local not_keys_in_array = true

    for key, _ in pairs(keysArray) do
        if key_exists(array, key) then
            not_keys_in_array = false
        end
    end

    return not_keys_in_array
end

-- ��������� �� ���������� �� ���������� (�� ����� "nil")
not_isset = function(value)
    return value == nil
end

-- ���������, �� ����� �� ����������/������
not_empty = function(value)
    if is_table(value) then
        return next(value) ~= nil
    end

    return value ~= nil
end

-- ���������, ��� ���� �������� �� ����� ������� (==)
not_eq = function(value1, value2)
    return value1 ~= value2
end

-- ���������, ��� ����� �� ���������� � ������/�������
not_method_exists = function(object, method)
    if not_object(object) then
        error("\r\n" .. "Error: �������� (������) - � ������ ���������. ��������: [" .. getType(object) .. "] - " .. tostring(object), 2)
    end

    if is_nil(method) then
        error("\r\n" .. "Error: ��������� (����� �������� ����� nil) - �� ������ ���������. ��������: [" .. getType(method) .. "] - " .. tostring(method), 2)
    end

    return type(object[method]) ~= "function"
end

-- ���������, ��� �������� �� ���������� � ������/�������
not_property_exists = function(object, property)
    if not_object(object) then
        error("\r\n" .. "Error: �������� (������) - � ������ ���������. ��������: [" .. getType(object) .. "] - " .. tostring(object), 2)
    end

    if is_nil(property) then
        error("\r\n" .. "Error: ��������� (����� �������� ����� nil) - �� ������ ���������. ��������: [" .. getType(property) .. "] - " .. tostring(property), 2)
    end

    return object[property] == nil
end

Assert = {
    --- �������� �� ������������

    -- ���������, ��� �������� ����� nil
    is_nil = function(self, value)
        if not_nil(value) then
            error("\r\n" .. "Assert: ��������� (nil). ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- ���������, ��� �������� �������� ������
    is_number = function(self, value)
        if not_number(value) then
            error("\r\n" .. "Assert: ��������� (�����). ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- ��������� ��� �������� �������� �������
    is_string = function(self, value)
        if not_string(value) then
            error("\r\n" .. "Assert: ��������� (������). ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- ��������� ��� �������� �������� ��������
    is_function = function(self, value)
        if not_function(value) then
            error("\r\n" .. "Assert: ��������� (�������). ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- ���������, ��� �������� �������� ��������
    is_table = function(self, value)
        if not_table(value) then
            error("\r\n" .. "Assert: ��������� (�������). ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- ���������, ��� �������� �������� ��������
    is_array = function(self, value)
        if not_array(value) then
            error("\r\n" .. "Assert: �������� (������). ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- ���������, ��� �������� �������� ��������
    is_object = function(self, value)
        if not_object(value) then
            error("\r\n" .. "Assert: �������� (������). ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- ���������, ��� �������� �������� ���������� �����
    is_boolean = function(self, value)
        if not_boolean(value) then
            error("\r\n" .. "Assert: ��������� ���������� �������� (boolean). ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- ���������, ��� �������� ����� true
    is_true = function(self, value)
        if not_boolean(value) then
            error("\r\n" .. "Error: ��������� ���������� �������� (boolean). ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end

        if not_true(value) then
            error("\r\n" .. "Assert: ��������� ���������� �������� (boolean = true). ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- ���������, ��� �������� ����� false
    is_false = function(self, value)
        if not_boolean(value) then
            error("\r\n" .. "Error: ��������� ���������� �������� (boolean). ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end

        if not_false(value) then
            error("\r\n" .. "Assert: ��������� ���������� �������� (boolean = false). ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- ���������, ��� � ������� ���������� ����
    key_exists = function(self, array, key)
        if not_array(array) then
            error("\r\n" .. "Error: �������� (������) - � ������ ���������. ��������: [" .. getType(array) .. "] - " .. tostring(array), 2)
        end

        if is_nil(key) then
            error("\r\n" .. "Error: ��������� (�������� ����� nil) - �� ������ ���������. ��������: [" .. getType(key) .. "] - " .. tostring(key), 2)
        end

        if not key_exists(array, key) then
            error("\r\n" .. "Assert: ��������� (� �������): [" .. getType(array) .. "] - " .. tostring(array) .. " (������� �����): [" .. getType(key) .. "] - " .. tostring(key), 2)
        end
    end,

    -- ���������, ��� � ������� ������������ ��������
    in_array = function(self, array, value)
        if not_array(array) then
            error("\r\n" .. "Error: �������� (������) - � ������ ���������. ��������: [" .. getType(array) .. "] - " .. tostring(array), 2)
        end

        if is_nil(value) then
            error("\r\n" .. "Error: ��������� (�������� ����� nil) - �� ������ ���������. ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end

        if not in_array(array, value) then
            error("\r\n" .. "Assert: ��������� (� �������): [" .. getType(array) .. "] - " .. tostring(array) .. " (������� ��������): [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- ��������� ������� ���� ������ �� ������� "keysArray" � ������� "array"
    -- ���� ��� ����� ���� - ����� "true", ����� "false"
    keys_in_array = function(self, array, keysArray)
        if not is_table(array) then
            error("\r\n" .. "Error: �������� (������). ��������: [" .. getType(array) .. "] - " .. tostring(array), 2)
        end

        if not is_table(keysArray) then
            error("\r\n" .. "Error: �������� (������). ��������: [" .. getType(keysArray) .. "] - " .. tostring(keysArray), 2)
        end

        if not keys_in_array(array, keysArray) then
            error("\r\n" .. "Assert: ��������� (� �������): [" .. getType(array) .. "] - " .. tostring(array) .. " (������� ���� ������): [" .. getType(keysArray) .. "] - " .. tostring(keysArray), 2)
        end
    end,

    -- ��������� ���������� �� ���������� (�� ����� "nil")
    isset = function(self, value)
        if not_isset(value) then
            error("\r\n" .. "Assert: ��������� ������������� ��������. ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- ���������, ����� �� ����������/������
    empty = function(self, value)
        if not_empty(value) then
            error("\r\n" .. "Assert: ��������� ������ ��������. ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- ���������, ��� ���� �������� ����� ������� (==)
    eq = function(self, value1, value2)
        if not_eq(value1, value2) then
            error("\r\n" .. "Assert: ��������� ��������� � ���������. �������� [value 1]:  [" .. getType(value1) .. "] - " .. tostring(value1) .. ", [value 2]: " .. getType(value2) .. "] - " .. tostring(value2), 2)
        end
    end,

    -- ���������, ��� ����� ���������� � ������/�������
    method_exists = function(self, object, method)
        if not method_exists(object, method) then
            error("\r\n" .. "Assert: ��������� � (�������): [" .. getType(object) .. "], (������� ������): [" .. getType(method) .. "] - " .. tostring(method), 2)
        end
    end,

    -- ���������, ��� �������� ���������� � ������/�������
    property_exists = function(self, object, property)
        if not property_exists(object, property) then
            error("\r\n" .. "Assert: ��������� � (�������): [" .. getType(object) .. "], (������� ��������): [" .. getType(property) .. "] - " .. tostring(property), 2)
        end
    end,

    --- �������� �� �� ������������

    -- ���������, ��� �������� ����� nil
    not_nil = function(self, value)
        if is_nil(value) then
            error("\r\n" .. "Assert: ��������� (�� nil). ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- ���������, ��� �������� �������� ������
    not_number = function(self, value)
        if is_number(value) then
            error("\r\n" .. "Assert: ��������� (�� �����). ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- ��������� ��� �������� �������� �������
    not_string = function(self, value)
        if is_string(value) then
            error("\r\n" .. "Assert: ��������� (�� ������). ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- ��������� ��� �������� �������� ��������
    not_function = function(self, value)
        if is_function(value) then
            error("\r\n" .. "Assert: ��������� (�� �������). ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- ���������, ��� �������� �������� ��������
    not_table = function(self, value)
        if is_table(value) then
            error("\r\n" .. "Assert: ��������� (�� �������). ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- ���������, ��� �������� �������� ��������
    not_array = function(self, value)
        if is_array(value) then
            error("\r\n" .. "Assert: �������� (�� ������). ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- ���������, ��� �������� �������� ��������
    not_object = function(self, value)
        if is_object(value) then
            error("\r\n" .. "Assert: �������� (�� ������). ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- ���������, ��� �������� �������� ���������� �����
    not_boolean = function(self, value)
        if is_boolean(value) then
            error("\r\n" .. "Assert: ��������� �� ���������� �������� (boolean). ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- ���������, ��� �������� ����� true
    not_true = function(self, value)
        if not_boolean(value) then
            error("\r\n" .. "Error: ��������� ���������� �������� (boolean). ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end

        if is_true(value) then
            error("\r\n" .. "Assert: ��������� ���������� �������� (boolean = false). ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- ���������, ��� �������� ����� false
    not_false = function(self, value)
        if not_boolean(value) then
            error("\r\n" .. "Error: ��������� ���������� �������� (boolean). ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end

        if is_false(value) then
            error("\r\n" .. "Assert: ��������� ���������� �������� (boolean = true). ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- ���������, ��� � ������� ���������� ����
    not_key_exists = function(self, array, key)
        if not_array(array) then
            error("\r\n" .. "Error: �������� (������) - � ������ ���������. ��������: [" .. getType(array) .. "] - " .. tostring(array), 2)
        end

        if is_nil(key) then
            error("\r\n" .. "Error: ��������� (�������� ����� nil) - �� ������ ���������. ��������: [" .. getType(key) .. "] - " .. tostring(key), 2)
        end

        if key_exists(array, key) then
            error("\r\n" .. "Assert: ��������� (���������� � �������): [" .. getType(array) .. "] - " .. tostring(array) .. " (�����): [" .. getType(key) .. "] - " .. tostring(key), 2)
        end
    end,

    -- ���������, ��� � ������� ������������ ��������
    not_in_array = function(self, array, value)
        if not_array(array) then
            error("\r\n" .. "Error: �������� (������) - � ������ ���������. ��������: [" .. getType(array) .. "] - " .. tostring(array), 2)
        end

        if is_nil(value) then
            error("\r\n" .. "Error: ��������� (�������� ����� nil) - �� ������ ���������. ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end

        if in_array(array, value) then
            error("\r\n" .. "Assert: ��������� (���������� � �������): [" .. getType(array) .. "] - " .. tostring(array) .. " (��������): [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- ��������� ���������� ���� ������ �� ������� "keysArray" � ������� "array"
    -- ���� ��� ����� ���� - ����� "true", ����� "false"
    not_keys_in_array = function(self, array, keysArray)
        if not is_table(array) then
            error("\r\n" .. "Error: �������� (������). ��������: [" .. getType(array) .. "] - " .. tostring(array), 2)
        end

        if not is_table(keysArray) then
            error("\r\n" .. "Error: �������� (������). ��������: [" .. getType(keysArray) .. "] - " .. tostring(keysArray), 2)
        end

        if keys_in_array(array, keysArray) then
            error("\r\n" .. "Assert: ��������� (���������� � �������): [" .. getType(array) .. "] - " .. tostring(array) .. " (���� ������): [" .. getType(keysArray) .. "] - " .. tostring(keysArray), 2)
        end
    end,

    -- ��������� ���������� �� ���������� (�� ����� "nil")
    not_isset = function(self, value)
        if isset(value) then
            error("\r\n" .. "Assert: ��������� ���������� ��������. ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- ���������, ����� �� ����������/������
    not_empty = function(self, value)
        if empty(value) then
            error("\r\n" .. "Assert: ��������� �� ������ ��������. ��������: [" .. getType(value) .. "] - " .. tostring(value), 2)
        end
    end,

    -- ���������, ��� ���� �������� ����� ������� (==)
    not_eq = function(self, value1, value2)
        if eq(value1, value2) then
            error("\r\n" .. "Assert: ��������� �� ��������� � ���������. �������� [value 1]:  [" .. getType(value1) .. "] - " .. tostring(value1) .. ", [value 2]: " .. getType(value2) .. "] - " .. tostring(value2), 2)
        end
    end,

    -- ���������, ��� ����� �� ���������� � ������/�������
    not_method_exists = function(self, object, method)
        if method_exists(object, method) then
            error("\r\n" .. "Assert: ��������� � (�������): [" .. getType(object) .. "] - " .. tostring(object) .. ", (���������� ������): " .. getType(method) .. "] - " .. tostring(method), 2)
        end
    end,

    -- ���������, ��� �������� ���������� � ������/�������
    not_property_exists = function(self, object, property)
        if property_exists(object, property) then
            error("\r\n" .. "Assert: ��������� � (�������): [" .. getType(object) .. "] - " .. tostring(object) .. ", (���������� ��������): " .. getType(property) .. "] - " .. tostring(property), 2)
        end
    end
}
