--- AppService NextId

local AppService = {

    --
    name = "AppService_NextId",

    --
    new = function(self)
        return self
    end,

    -- ������� ��������� 0 � ����������� ��������,
    -- ���� ���������� ���������� �������� = 1, "1" -> "01"
    -- ��������� 0 � ������� �� 1 - 9
    -- ��� ����� � ������
    addZero = function(self, number_str)
        local numberStr = tostring(number_str)

        if #numberStr == 1 then
            return "0" .. numberStr
        else
            return numberStr
        end
    end,

    -- ��������� 00 � ������������� ����� ����� ���� 3-� �������
    -- ������ ������������: 324, 798, 621,
    -- ����� ����: 10, 79, 5, 8,
    addZeroMcs = function(self, number_str)
        -- ����� ������ ���� 3-� �������
        local numberStr = tostring(number_str)

        -- ���� ����� ������� �� 2 ��������
        if #numberStr == 2 then
            return "0" .. numberStr
        end

        -- ���� ����� ������� �� 1 �������
        if #numberStr == 1 then
            return "00" .. numberStr
        end

        return numberStr
    end,

    -- ���������� ����� id ����������
    getId = function(self)
        sleep(1)

        local id = tostring(os.sysdate().hour) .. self:addZero(os.sysdate().min) .. self:addZero(os.sysdate().sec) .. self:addZeroMcs(os.sysdate().ms)

        return tonumber(id)
    end,

}

return AppService
