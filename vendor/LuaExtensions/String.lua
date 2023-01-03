--- ��� ������� ��������� ����� ����� � ������ � �������������� ���������

-- ������� �������� ����� �� ������ (� ������)
-- ���� r �� ������� - �� ��������� ����� ��������� ������
-- s - ������ �� ������� ����� ������� �������
-- r - ������� ��� ��������,
function string.ltrim(s, r)
    s = s:gsub("^" .. (r or "%s+"), "")
    return s
end

-- ������� �������� ������ �� ������ (� �����)
-- ���� r �� ������� - �� ��������� ����� ��������� ������
-- s - ������ �� ������� ����� ������� �������
-- r - ������� ��� ��������,
function string.rtrim(s, r)
    s = s:gsub((r or "%s+") .. "$", "")
    return s
end

-- ������� �������� ����� � ������ �� ������ (� ������ � � �����)
-- ���� r �� ������� - �� ��������� ����� ��������� ������
-- s - ������ �� ������� ����� ������� �������
-- r - ������� ��� ��������,
function string.trim(s, r)
    return s:ltrim(r):rtrim(r)
end

-- ������� �������� ����� � ������ �� ������ (� ������ � � �����)
--(������ "string.trim(s,r)")
function trim(s, r)
    return string.trim(s, r)
end

-- ������� �������� ����� (� ������)
--(������ "string.trim(s,r)")
function rtrim(s, r)
    return string.rtrim(s, r)
end

-- ������� �������� ������ �� ������ (� �����)
--(������ "string.trim(s,r)")
function ltrim(s, r)
    return string.ltrim(s, r)
end

-- ������ � ������ ��������� - ���������� ����� ������
-- search - ��� ������
-- pattern - ��� ��������
-- str - ������ ��� ������
function str_replace(search, pattern, str)
    return string.gsub(str, search, pattern)
end

-- ��������� � ����������� �� ����������
--[[
	1 - �����, 	2 - �����, 	5 - ������
	1 - �����, 	2 - ������, 5 - �������
	1 - ������, 2 - ������, 5 - �����
	1 - ���, 	2 - ����, 	5 - �����
	1 - ����, 	2 - ���, 	5 - ����

getWord(1, "�����", "������", "�������")
]]

-- ���������� ��������� � ����������� �� �����
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
