---

-- ������� ����� ����� �������
function d0(num)
    if is_nil(num) then
        dd(debug_traceback())
    end

    num = tonumber(num);

    -- ��������� �� �������� ������ �����
    if num == math.floor(num) then
        num = math.floor(num);
    end ;

    return num;      -- ���������� ��� �����
end;

-- ���������� �� ������ ������������
dMin = function(num)
    num = tonumber(num);

    return math.floor(num)
end

-- ���������� �� ������ �������������
dMax = function(num)
    num = tonumber(num);

    return math.ceil(num)
end

-- ������� �� ������ ����� ����� �������
-- count ����� ������ ����� ������� ������� ����� ��������
dCrop = function(num, count)
    num = tonumber(num);
    count = tonumber(count);

    if count < 0 then
        count = 0
    end

    -- ������� ����� ����� ������� (string.format("%.2f", result) - ������� 2 ����� ����� �������)
    return tonumber(string.format("%." .. count .. "f", num))
end
