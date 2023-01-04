--- AppService Validating

local AppService = {
    --
    name = "AppService_Validating",

    --
    new = function(self)
        return self
    end,

    -- �������� �� ������ ���� nil
    checkParamNotNil = function(self, val, name)
        if is_nil(val) then
            error("Error: ������: �������� (" .. name .. ") �� �������.", 3)
        end
    end,

    -- �������� �� ������ ���� nil
    checkParamNumber = function(self, value, name)
        if not_number(value) then
            error("Error: ������: �������� (" .. name .. ") ������ ���� ������. " ..
                "��������: (" .. type(value) .. ") - " .. tostring(value), 3)
        end
    end,

    -- �������� �� ������ ���� nil
    checkParamString = function(self, value, name)
        if not_string(value) then
            error("Error: ������: �������� (" .. name .. ") ������ ���� �������. " ..
                "��������: (" .. type(value) .. ") - " .. tostring(value), 3)
        end
    end,

    -- �������� �� ������ ���� nil
    checkParamBoolean = function(self, value, name)
        if not_boolean(value) then
            error("Error: ������: �������� (" .. name .. ") ������ ���� boolean ���������. " ..
                "��������: (" .. type(value) .. ") - " .. tostring(value), 3)
        end
    end,

    -- �������� ������ ����: "limit" ��� "market" - ����� ������
    checkId = function(self, value)
        if not_string(value) then
            error("\r\n\r\n" .. "Error: id ������ ���� �������. " ..
                "��������: (" .. type(value) .. ") - " .. tostring(value), 3)
        end
    end,

    -- �������� ������ ����: "limit" ��� "market" - ����� ������
    checkClass = function(self, value)
        if not_string(value) then
            error("\r\n\r\n" .. "Error: class ������ ���� �������. " ..
                "��������: (" .. type(value) .. ") - " .. tostring(value), 3)
        end
    end,

    -- �������� ������ ����: "limit" ��� "market" - ����� ������
    checkPrice = function(self, value)
        if not_number(value) then
            error("\r\n\r\n" .. "Error: ���� ������ ���� ������ " ..
                "��������: (" .. type(value) .. ") - " .. tostring(value), 3)
        end
    end,

    -- �������� ������ ����: "limit" ��� "market" - ����� ������
    check_limit_market = function(self, value)
        if value ~= "limit" and value ~= "market" then
            error("\r\n\r\n" .. "Error: �������� (typeOrder) ������ ���� (limit) ��� (market). " ..
                "��������: (" .. type(value) .. ") - " .. tostring(value), 3)
        end
    end,

    -- �������� ������ ����: "buy" ��� "sell" - ����� ������
    check_buy_sell = function(self, value)
        if value ~= "buy" and value ~= "sell" then
            error("\r\n\r\n" .. "Error: �������� (operation) ������ ���� (buy) ��� (sell)." ..
                "��������: (" .. type(value) .. ") - " .. tostring(value), 3)
        end
    end,

    -- �������� ������ ����: 0, ��� 5, ��� 10 - ����� ������
    checkRange = function(self, value)
        if value ~= 0 and value ~= 5 and value ~= 10 and value ~= 105 and value ~= 110 then
            error("\r\n\r\n" .. "Error: �������� (range) ������ ���� (0) ��� (5) ��� (10)." ..
                "��������: (" .. type(value) .. ") - " .. tostring(value), 3)
        end
    end,

    -- �������� ������ ����: 20, ��� 30, ��� 40, ��� 50, ��� 60, ��� 70 - ����� ������
    checkTake = function(self, value)
        if value ~= 2 and value ~= 3 and value ~= 4 and value ~= 5 and value ~= 6 and value ~= 7 and value ~= 8 and value ~= 9 and value ~= 10 then
            error("\r\n\r\n" .. "Error: �������� (�����) ������ ���� (2) ��� (3) ��� (4) ��� (5) ��� (6)." ..
                "��������: (" .. type(value) .. ") - " .. tostring(value), 3)
        end
    end,
}

return AppService
