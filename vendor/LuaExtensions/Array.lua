---

array_merge = function(a, b)
    if not_array(a) then
        error("Error: ��������� �������� (������) - � ������ ���������. ��������: [" .. getType(a) .. "] - " .. tostring(a), 2)
    end

    if is_nil(b) then
        error("Error: ��������� �������� (�������� �� ������ nil) - �� ������ ���������. ��������: [" .. getType(b) .. "] - " .. tostring(b), 2)
    end

    -- �������� ��� a - ��� ������
    -- �������� ��� b - ��� ������
    for key, value in pairs(b) do
        if isset(a[key]) then
            if type(key) == "number" then
                a[#a + 1] = value
            elseif type(value) == "table" and type(a[key]) == "table" then
                a[key] = array_merge(a[key], value)
            else
                a[key] = value
            end
        else
            a[key] = value
        end
    end

    return a
end

-- ���������� ������ ��� "��������"
-- ��������� ����� ���� ������, ������, �����, ������
-- "," , ":", "word"
-- ���������� ������������ ������
function string:split(delimiter)
    local result = { }
    local from = 1
    local delim_from, delim_to = string.find(self, delimiter, from)

    while delim_from do
        table.insert(result, string.sub(self, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = string.find(self, delimiter, from)
    end

    table.insert(result, string.sub(self, from))

    return result
end

-- ���� ����� ��� � ������� "string:split(delimiter)" (������� ������)
-- ���������� ������������ ������
function explode(delimiter, str)
    if not_string(str) then
        error("Error: ��������� (������). ��������: [" .. getType(str) .. "] - " .. tostring(str), 2)
    end

    return str:split(delimiter)
end

-- ������������� �������� ������ � ����� �� 1 ��������
function unpack(t, i)
    i = i or 1
    if t[i] then
        return t[i], unpack(t, i + 1)
    end
end

-- ����������� �������
function copy(t)
    if type(t) ~= "table" then
        return t
    end

    local t2 = {};
    for k, v in pairs(t) do
        if type(v) == "table" then
            t2[k] = copy(v);
        else
            t2[k] = v;
        end
    end
    return t2;
end

function serialize (tabl, indent)
    local nl = string.char(10) -- newline
    local pr = ""

    indent = indent and (indent .. "  ") or ""
    local str = ''
    str = str .. indent .. "{" .. nl
    for key, value in pairs(tabl) do

        if (type(key) == "string") and ('["' .. key .. '"]=') then
            pr = '["' .. key .. '"]='
        end

        if (type(key) == "number") and ('[' .. key .. ']=') then
            pr = '[' .. key .. ']='
        end

        if type(value) == "table" then
            str = str .. pr .. serialize(value, indent)
        elseif type(value) == "string" then
            str = str .. indent .. pr .. '"' .. tostring(value) .. '",' .. nl
        else
            str = str .. indent .. pr .. tostring(value) .. ',' .. nl
        end
    end
    str = str .. indent .. "}" .. nl

    return str
end
