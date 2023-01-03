--- Функция проверяет установлен бит, или нет (возвращает true, или false)
-- https://quikluacsharp.ru/qlua-osnovy/funktsiya-dlya-raboty-s-bitovymi-flagami-v-qlua-lua/
--[[
пример:

function OnOrder(order)
--бит 0 (0x1)     Заявка активна, иначе – не активна
--бит 1 (0x2)     Заявка снята. Если флаг не установлен и значение бита «0» равно «0», то заявка исполнена
--бит 2 (0x4)     Заявка на продажу, иначе – на покупку. Данный флаг для сделок и сделок для исполнения определяет направление сделки (BUY/SELL)
--бит 3 (0x8)     Заявка лимитированная, иначе – рыночная
--бит 4 (0x10)    Разрешить / запретить сделки по разным ценам
--бит 5 (0x20)    Исполнить заявку немедленно или снять (FILL OR KILL)
--бит 6 (0x40)    Заявка маркет-мейкера. Для адресных заявок – заявка отправлена контрагенту
--бит 7 (0x80)    Для адресных заявок – заявка получена от контрагента
--бит 8 (0x100)   Снять остаток
--бит 9 (0x200)   Айсберг-заявка

-- Проверка бита 2
if checkBit(order.flags, 2) then
message("Заявка на продажу");
else
message("Заявка на покупку");
end;
end;

]]

_checkBit = function(flags, _bit)
    -- Проверяет, что переданные аргументы являются числами
    if type(flags) ~= "number" then
        error("Ошибка!!! Checkbit: 1-й аргумент не число!", 2)
    end
    if type(_bit) ~= "number" then
        error("Ошибка!!! Checkbit: 2-й аргумент не число!", 2)
    end

    if _bit == 0 then
        _bit = 0x1
    elseif _bit == 1 then
        _bit = 0x2
    elseif _bit == 2 then
        _bit = 0x4
    elseif _bit == 3 then
        _bit = 0x8
    elseif _bit == 4 then
        _bit = 0x10
    elseif _bit == 5 then
        _bit = 0x20
    elseif _bit == 6 then
        _bit = 0x40
    elseif _bit == 7 then
        _bit = 0x80
    elseif _bit == 8 then
        _bit = 0x100
    elseif _bit == 9 then
        _bit = 0x200
    elseif _bit == 10 then
        _bit = 0x400
    elseif _bit == 11 then
        _bit = 0x800
    elseif _bit == 12 then
        _bit = 0x1000
    elseif _bit == 13 then
        _bit = 0x2000
    elseif _bit == 14 then
        _bit = 0x4000
    elseif _bit == 15 then
        _bit = 0x8000
    elseif _bit == 16 then
        _bit = 0x10000
    elseif _bit == 17 then
        _bit = 0x20000
    elseif _bit == 18 then
        _bit = 0x40000
    elseif _bit == 19 then
        _bit = 0x80000
    elseif _bit == 20 then
        _bit = 0x100000
    end

    if bit.band(flags, _bit) == _bit then
        return true
    else
        return false
    end
end

checkBit = function(flags, _bit)
    -- Проверяет, что переданные аргументы являются числами
    if type(flags) ~= "number" then
        error("Ошибка!!! Checkbit: 1-й аргумент не число!", 2)
    end
    if type(_bit) ~= "number" then
        error("Ошибка!!! Checkbit: 2-й аргумент не число!", 2)
    end

    local bitArray = {
        [0] = 0x1,
        [1] = 0x2,
        [2] = 0x4,
        [3] = 0x8,
        [4] = 0x10,
        [5] = 0x20,
        [6] = 0x40,
        [7] = 0x80,
        [8] = 0x100,
        [9] = 0x200,
        [10] = 0x400,
        [11] = 0x800,
        [12] = 0x1000,
        [13] = 0x2000,
        [14] = 0x4000,
        [15] = 0x8000,
        [16] = 0x10000,
        [17] = 0x20000,
        [18] = 0x40000,
        [19] = 0x80000,
        [20] = 0x100000,
    }

    if bit.band(flags, bitArray[_bit]) == bitArray[_bit] then
        return true
    else
        return false
    end
end
