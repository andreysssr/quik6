local db_levels = {
    --
    data = {},

    new = function(self)
        local dataPath = basePath .. "data\\lua\\levels.lua"

        self.data = dofile(dataPath)

        return self
    end,

    -- �������� �� ������ ���� nil
    checkParamNotNil = function(self, value, name)
        if type(value) == "nil" then
            error("Error: ������: �������� (" .. name .. ") �� �������.", 3)
        end
    end,

    -- �������� �� ������ ���� nil
    checkParamNumber = function(self, value, name)
        if type(value) ~= "number" then
            error("Error: ������: �������� (" .. name .. ") ������ ���� ������. " ..
                "��������: (" .. type(value) .. ") - " .. tostring(value), 3)
        end
    end,

    -- �������� �� ������ ���� nil
    checkParamString = function(self, value, name)
        if type(value) ~= "string" then
            error("Error: ������: �������� (" .. name .. ") ������ ���� �������. " ..
                "��������: (" .. type(value) .. ") - " .. tostring(value), 3)
        end
    end,

    -- �������� �� ������ ���� nil
    checkParamBoolean = function(self, value, name)
        if type(value) ~= "boolean" then
            error("Error: ������: �������� (" .. name .. ") ������ ���� boolean ���������. " ..
                "��������: (" .. type(value) .. ") - " .. tostring(value), 3)
        end
    end,

    -- �������� ������������� ����������� � ���� ������
    exist = function(self, id, class)
        if class ~= "TQBR" and class ~= "SPBFUT" and class ~= "CETS" and class ~= "QJSIM" and class ~= "SPBOPT" and class ~= "INDX" then
            error("\n" .. "Error: ������: �������� (class) ������ ����: (TQBR) ��� (SPBFUT) ��� (CETS). " ..
                "��������: (" .. type(class) .. ") - " .. tostring(class), 3)
        end

        -- ��� ���� ������ ������ ��� �����
        if class == "QJSIM" then
            class = "TQBR"
        end

        -- ��� ���� ������ ������ ��� ���������
        if class == "SPBOPT" then
            class = "SPBFUT"
        end

        if self.data[class][id] then
            return true
        end

        return false
    end,

    -- ����������� ���� ��� ���������� �������
    -- ���������� ��������� ����, �������� ����, ��������
    getCalculateStartStopPrice = function(self, lastPrice, interval, countInterval, offset)
        -- ���� � ������� ������� ���������
        local startPrice = 0 + offset

        -- ���� �� ������� ����������� ���������
        local stopPrice = lastPrice + (interval * countInterval)

        -- ��������� ������� ���� ���������
        local result = {}

        -- ��������� ������ ��� ���������� ��� � ����� ���������
        local arrayPrice = {}

        -- ���������� ��� ���� �� 0 �� ������������
        for i = startPrice, stopPrice, interval do
            arrayPrice[#arrayPrice + 1] = i
        end

        -- ������������ ����� ������� �������
        local lastNumber = #arrayPrice

        -- ������������ ���� ��� ������ - ��������� ����������� ���� � ������
        -- �������� ��������� ����������� ������
        result.maxPrice = arrayPrice[lastNumber]

        -- ���� ���������� ���������� ������ ��� ������ ������� � ����������� ��� - ����� ��������� ����� ����� ���� ������
        -- �������� ����������� ���� ����� ����������
        -- arrayPrice - ������ �� ������� ���������� �� 0 �� �������������, �������� ��� ��������� ����� = 20
        -- ������ �� 20 - countInterval (���������� ���������� �������� 3) * 2(3 ���������� �����, � 3 ���������� ����, ���������� ��������� ����)
        -- ����� ����� 20 - 6 + 1 = 15, ��� ������ ������ ��������� � ������� ����,
        -- ����� ������ 15 ����� ����������� ����� ����� ����������,
        -- � ������������ ���� - ��� ��������� ������ ����� ����������
        local minPrice = arrayPrice[lastNumber - (countInterval * 2) + 1]

        -- ������ ����� �������� ������� � ������ ������ � �����
        -- ��������� ������� � ������� ��� - ����� nil
        if minPrice == nil then
            result.minPrice = startPrice
        else
            result.minPrice = minPrice
        end

        -- ��������� � ���������� ��������� ��������
        result.interval = interval

        return result
    end,

    -- ���������� ��������� ���������, ������ ����, ��������� ���� - ��� �������
    -- class, id - ����� � ��� �����������
    -- lastPrice ��������� ���� ����������� (����� ������� ������� ��� ����������)
    -- countInterval - ���������� ���������� ������� ����� ��������
    -- mode - ����� ������:
    -- dev - ����� ������������, ������������, ������������ ���� ��� ��������� ����
    -- prod - ����� ������, ������������ ���������� ����
    --[[
        return ���������� nil - ���� ������ ����������� ���
        ��� ���������� ���������
        {
            maxPrice = 200,
            minPrice = 180,
        }
    ]]
    getParamsLevel = function(self, id, class, lastPrice, countInterval)
        self:checkParamString(id, "id")
        self:checkParamString(class, "class")
        self:checkParamNumber(lastPrice, "lastPrice")
        self:checkParamNumber(countInterval, "countInterval")

        if not self:exist(id, class) then
            return false
        end

        -- ��� ���� ������ ������ ��� �����
        if class == "QJSIM" then
            class = "TQBR"
        end

        -- ��� ���� ������ ������ ��� ���������
        if class == "SPBOPT" then
            class = "SPBFUT"
        end

        -- �������� ����������� ���������� � ����
        local interval = self.data[class][id].interval

        -- �������� ���� ����
        local offset = 0

        -- ���� � ����������� ���� �������� � ���� - ����� ���������� ���, ����� ��� ����� 0
        if self.data[class][id].offset then
            offset = self.data[class][id].offset
        end

        -- �������� ��������� ��� ���������� �������
        local result = self:getCalculateStartStopPrice(lastPrice, interval, countInterval, offset)

        -- ���� ���� ��������� ��� ������� ������� - ��������� �� ���������
        if self.data[class][id].strongLevels then
            result.strongLevels = self.data[class][id].strongLevels
        end

        return result
    end,

    -- ������� �������� ������
    getInterval = function(self, id, class)
        self:checkParamString(id, "id")
        self:checkParamString(class, "class")

        if not self:exist(id, class) then
            return false
        end

        -- �������� ����������� ���������� � ����
        return self.data[class][id].interval
    end,
}

return db_levels
