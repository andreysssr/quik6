--- функция для отладки - просмотр данных

--- функции для отладки
-- посылает данные в программу - "DebugView"

-- dd(value) - распечатать содержимое переменной
-- ! ddt(tab) - распечатать содержимое таблицы

function table_val_to_str (v)
    if "string" == type(v) then
        v = string.gsub(v, "\n", "\\n")

        if string.match(string.gsub(v, "[^'\"]", ""), '^"+$') then
            return "'" .. v .. "'"
        end

        return '"' .. string.gsub(v, '"', '\\"') .. '"'
    end

    if "function" == type(v) then
        return "f()"
    end

    return "table" == type(v) and table_tostring(v) or tostring(v)
end

function table_key_to_str (k)
    if "string" == type(k) and string.match(k, "^[_%a][_%a%d]*$") then
        return k
    end

    return "[" .. table_val_to_str(k) .. "]"
end

-- Преобразование таблицы или массива в текстовое представление в соответствии с синтаксисом языка lua
function table_tostring(tbl)
    local result, done = {}, {}

    for k, v in ipairs(tbl) do
        table.insert(result, table_val_to_str(v))
        done[k] = true
    end

    for k, v in pairs(tbl) do
        if not done[k] then
            table.insert(result, table_key_to_str(k) .. " = " .. table_val_to_str(v))
        end
    end

    return "{" .. table.concat(result, ", ") .. "}"
end

-- распечатка таблицы в зависимости от выбранного варианта
function ddPrint(value, nested)
    local print = nested or 0

    for key, val in pairs(value) do
        local str = ""

        if print == 0 then
            if is_table(val) then
                str = tostring(key) .. " = " .. table_tostring(val)
            end
        else
            if is_table(val) then
                PrintDbgStr("[dd] ");
                PrintDbgStr("[dd] [НАЧАЛО ВН.ТАБЛ.] =======================================");
                PrintDbgStr("[dd] Индекс таблицы: [ " .. tostring(key) .. " ]");
                str = ddPrint(val)
                PrintDbgStr("[dd] [КОНЕЦ ВН.ТАБЛ.] =======================================");
                PrintDbgStr("[dd]");
            end
        end

        if is_string(val) then
            str = tostring(key) .. ' = "' .. val .. '"'
        end
        if is_number(val) then
            str = tostring(key) .. " = " .. tostring(val)
        end
        if is_function(val) then
            str = tostring(key) .. " = f()"
        end
        if is_boolean(val) then
            str = key .. " = " .. tostring(val)
        end

        if not is_nil(str) then
            PrintDbgStr("[dd] строка таблицы: " .. tostring(str));
        end
    end
end

function view(value)
    for key, val in pairs(value) do
        local str = ""

        if is_table(val) then
            str = tostring(key) .. " = {}"
        end
        if is_string(val) then
            str = tostring(key) .. ' = "' .. val .. '"'
        end
        if is_number(val) then
            str = tostring(key) .. " = " .. tostring(val)
        end
        if is_function(val) then
            str = tostring(key) .. " = f()"
        end
        if is_boolean(val) then
            str = key .. " = " .. tostring(val)
        end

        if not is_nil(str) then
            PrintDbgStr("[dd] строка таблицы: " .. tostring(str));
        end
    end
end

--- функция проверки отладчика
-- @param mixed value - переменную для вывода в программе
-- nested - уровень вложенности
function dd(value, key)

    if is_table(value) and key == "v" then
        PrintDbgStr("[dd] [НАЧАЛО ТАБЛИЦЫ] =======================================");
        view(value)
        PrintDbgStr("[dd] [КОНЕЦ ТАБЛИЦЫ]  ========================================");

        return
    end

    if is_table(value) then
        PrintDbgStr("[dd] [НАЧАЛО ТАБЛИЦЫ] =======================================");
        ddPrint(value, key)
        PrintDbgStr("[dd] [КОНЕЦ ТАБЛИЦЫ]  ========================================");
    end

    if is_string(value) then
        PrintDbgStr("[dd] передана строка: " .. '"' .. value .. '"');
    end

    if is_function(value) then
        PrintDbgStr("[dd] передана функция");
    end

    if is_number(value) then
        PrintDbgStr("[dd] передано число: " .. value);
    end

    if is_boolean(value) then
        local res = tostring(value);
        PrintDbgStr("[dd] передано булево значение: " .. res);
    end

    if is_nil(value) then
        PrintDbgStr("[dd] передано пустое значение: [ nil ]");
    end
end

function ddCl(value)
    PrintDbgStr("[dd] [НАЧАЛО КЛАССА] =======================================");

    for key, val in pairs(value) do
        local str = ""

        if is_table(val) then
            str = tostring(key) .. " = {}"
        end

        if is_string(val) then
            str = tostring(key) .. ' = "' .. val .. '"'
        end
        if is_number(val) then
            str = tostring(key) .. " = " .. tostring(val)
        end
        if is_function(val) then
            str = tostring(key) .. " = f()"
        end
        if is_boolean(val) then
            str = key .. " = " .. tostring(val)
        end

        if not is_nil(str) then
            PrintDbgStr("[dd] строка таблицы: " .. tostring(str));
        end
    end

    PrintDbgStr("[dd] [КОНЕЦ КЛАССА]  ========================================");
    PrintDbgStr("[dd]");

    if is_nil(value.name) then
        PrintDbgStr("[dd] [! ВНИМАНИЕ] В КЛАССЕ НЕТ ПАРАМЕТРА - \"name\"");
        PrintDbgStr("[dd]");
    end
end

function traceback()
    local level = 1
    local str = ""

    PrintDbgStr("------------------------------------------------------")
    PrintDbgStr("Errors:")

    while true do
        local info = debug.getinfo(level, "Sl")
        if not info then
            break
        end
        -- is a C function?
        if info.what == "C" then
            --dd(level .. "C function")
        else
            -- a Lua function
            --dd(string.format("[file: %s], line - %d", info.short_src, info.currentline))
            str = string.format("file: %s, line - %d", info.source, info.currentline)
            str = str.gsub(str, basePath, "")
            PrintDbgStr(str)
        end
        level = level + 1
    end

    PrintDbgStr("------------------------------------------------------")
end

debug_traceback = debug.traceback
function debug.traceback(msg, level)
    if err_traceback then
        local tcb = debug_traceback(msg or "", (level or 0) + 3)
        local full_msg = tcb:sub(1, tcb:find("stack traceback") - 1)
        local _, i = tcb:find(PATH .. "[^\n]*'do_ucoroutine_error'")
        if i then
            tcb = tcb:sub(i + 2)
            tcb = tcb:sub(tcb:find("\n") + 1)
            tcb = "stack traceback:\n" .. err_traceback .. "\n" .. tcb
            return full_msg .. tcb
        else
            err_msg, err_traceback = nil, nil
        end
    end
    return debug_traceback(msg or "", level)
end

stop = function()
    error("Остановка приложения - метод stop()")
end
