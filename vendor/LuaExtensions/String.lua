--- Три функции обрезания строк слева и справа с использованием паттернов

-- обрезка символов слева от строки (в начале)
-- если r не передан - по умолчанию будет очищаться пробел
-- s - строка из которой нужно удалить символы
-- r - символы для удаления,
function string.ltrim(s, r)
    s = s:gsub("^" .. (r or "%s+"), "")
    return s
end

-- обрезка символов справа от строки (в конце)
-- если r не передан - по умолчанию будет очищаться пробел
-- s - строка из которой нужно удалить символы
-- r - символы для удаления,
function string.rtrim(s, r)
    s = s:gsub((r or "%s+") .. "$", "")
    return s
end

-- обрезка символов слева и справа от строки (в начале и в конце)
-- если r не передан - по умолчанию будет очищаться пробел
-- s - строка из которой нужно удалить символы
-- r - символы для удаления,
function string.trim(s, r)
    return s:ltrim(r):rtrim(r)
end

-- обрезка символов слева и справа от строки (в начале и в конце)
--(обёртка "string.trim(s,r)")
function trim(s, r)
    return string.trim(s, r)
end

-- обрезка символов слева (в начале)
--(обёртка "string.trim(s,r)")
function rtrim(s, r)
    return string.rtrim(s, r)
end

-- обрезка символов справа от строки (в конце)
--(обёртка "string.trim(s,r)")
function ltrim(s, r)
    return string.ltrim(s, r)
end

-- замена в строке подстроки - возвращает новую строку
-- search - что меняем
-- pattern - чем заменяем
-- str - строка где меняем
function str_replace(search, pattern, str)
    return string.gsub(str, search, pattern)
end

-- склонение в зависимости от количества
--[[
	1 - рубль, 	2 - рубля, 	5 - рублей
	1 - пункт, 	2 - пункта, 5 - пунктов
	1 - минута, 2 - минуты, 5 - минут
	1 - час, 	2 - часа, 	5 - часов
	1 - день, 	2 - дня, 	5 - дней

getWord(1, "пункт", "пункта", "пунктов")
]]

-- возвращает склонение в зависимости от числа
getWord = function(value, word1, word2, word3)
    local val = math.abs(value)

    local remains_100 = val % 100
    local remains_10 = val % 10

    if (remains_100 >= 11) and (remains_100 <= 19) then
        return word3
    else

        if (remains_10 == 1) then
            return word1
        end

        if (remains_10 == 2) or (remains_10 == 3) or (remains_10 == 4) then
            return word2
        end

        return word3
    end
end
