---
--[[
-- ����������� �����
-- �������� ������������� �����
-- �������� ������ ���� ��� ���
-- �������� �����
-- ������ � ����
-- ������ ����� � ������
-- ������ ����� � ������
-- ������ ����� ���������
-- ������ ����� csv

-- �������� ������������� ����������
-- �������� ����������
-- �������� ������ ������ � ����������
]]
--[[
r 	(�� ���������), ��������� ���� ������ ��� ������
w 	��������� ���� ��� ������. �������������� ���������� ��� ������ ����� ����
a 	�������� ����. �������� �� ����� ��� ������ ��� ����� ����. �������� ��������� ������������.
r+	��������� ���� � ������ ������ � ������. ���� ������ ������������.
w+  ��������� ���� ��� ������. ������� ������������ ���������� ��� ������ ����� ����.
a+  ��������� ���� � ������ ������. �������� �� ����� ��� �������� ����� ����. �������� �����������
������ �� ����� ������.
]]
--[[
local file = io.open("test.txt", "r")
local content = file:read("a")
file:close()
return content

*all		� ��������� �� ����������
*line		l ��������� ���� ������ �� �����
L ��������� ���� ������ �� �����, �� ��������� ������ ����� ������
*number		n ��������� ������ ��� ������� �� �����. ��� �������� �� ����� ���������� ������������������
(integer)	[number] ��������� [number] ������� �� �����. ���� ����� �� ���������� �������.
]]

File = {
    -- ����������� �����
    get = function(self, filePath)
        return dofile(filePath)
    end,

    -- �������� ������������� �����
    exists = function(self, filePath)
        local file = io.open(filePath)
        -- ������ �� ����
        if file ~= nil then
            io.close(file)
            return true
        end
        return false
    end,

    -- �������� ������ ���� ��� ���
    empty = function(self, filePath)
        -- �������, ��� ��������� ��� ������/���������� ����
        local file = io.open(filePath, "a+")

        -- ������ � ����� �����, �������� ����� �������
        local position = file:seek("end", 0);

        local statusEmpty = true

        -- ���� ���� ��� ������
        if position == 0 then
            statusEmpty = false
        end
        io.close(file)

        return statusEmpty
    end,

    -- �������� �����
    create = function(self, filePath)
        -- ������� ���� � ������ "������"
        local file = io.open(filePath, "w")
        -- ��������� ����
        io.close(file)
    end,

    -- ������ � ���� � ������ (����������)
    writeAdd = function(self, filePath, data)
        -- �������, ��� ��������� ��� ������/���������� ����
        local file = io.open(filePath, "a+")
        -- ���������� � ���� ������
        file:write(data)
        -- ��������� ��������� � �����
        file:flush()
        -- ��������� ����
        io.close(file)
    end,

    -- ������ � ���� � ������ (����������)
    writeUpdate = function(self, filePath, data)
        -- �������, ��� ��������� ��� ������/���������� ����
        local file = io.open(filePath, "w+")
        -- ���������� � ���� ������
        file:write(data)
        -- ��������� ��������� � �����
        file:flush()
        -- ��������� ����
        io.close(file)
    end,

    -- ������ ����� � ������
    readContent = function(self, filePath)
        -- �������, ��� ��������� ��� ������/���������� ����
        local file = io.open(filePath, "a+")
        local content = file:read("*a")
        -- ��������� ����
        io.close(file)

        return content
    end,

    -- ������ ����� � ������
    readToArray = function(self, filePath)
        local array = {}

        -- �������, ��� ��������� ��� ������/���������� ����
        local file = io.open(filePath, "a+")

        -- ���������� ������ �����, ������� �� ���������� � ����������
        for line in file:lines() do
            array[#array + 1] = line
        end

        -- ��������� ����
        io.close(file)

        return array
    end,

    -- ������ ����� csv
    readCsv = function(self, filePath)
        local array = {}

        -- �������, ��� ��������� ��� ������/���������� ����
        local file = io.open(filePath, "a+")

        -- ���������� ������ �����, ������� �� ���������� � ����������
        for line in file:lines() do
            array[#array + 1] = explode(";", line)
        end

        -- ��������� ����
        io.close(file)

        return array
    end,

    -- �������� �����
    -- ������� ���� ��� ���������� � �������� ������.
    -- ���������� ������ ���� �����. ���� ������� �� ����� �������� ��������,
    -- ��� ���������� nil, ���� ������, ���������� �������� ������.
    remove = function(self, filePath)
        os.remove(filePath)
    end
}
