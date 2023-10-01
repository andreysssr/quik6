---

-- обрезка нулей после запятой
function d0(num)
    if is_nil(num) then
        dd(debug_traceback())
    end

    num = tonumber(num);

    -- округляет до меньшего целого числа
    if num == math.floor(num) then
        num = math.floor(num);
    end ;

    return num;      -- возвращаем без нулей
end;

-- округление до целого минимального
dMin = function(num)
    num = tonumber(num);

    return math.floor(num)
end

-- округление до целого максимального
dMax = function(num)
    num = tonumber(num);

    return math.ceil(num)
end

-- обрезка до нужных чисел после запятой
-- count число знаков после запятой которое нужно оставить
dCrop = function(num, count)
    num = tonumber(num);
    count = tonumber(count);

    if count < 0 then
        count = 0
    end

    -- обрезка чисел после запятой (string.format("%.2f", result) - оставит 2 знака после запятой)
    return tonumber(string.format("%." .. count .. "f", num))
end
