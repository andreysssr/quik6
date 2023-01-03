--- Timer

local Timer = {
    --
    name = "Timer",

    -- ��������� ��������
    dataTimer = {},

    currentTime = 0,

    -- �����������
    new = function(self)
        return self
    end,

    -- ������������� ��� � ����� ������� � ��������
    set = function(self, name, intervalSeconds)
        if not_number(intervalSeconds) then
            error("��������� �������� ������ ���� ������ - � ��������")
        end

        -- ��������� ����� ������ �������
        -- os.time() - ���������� ����� � ��������, ��������� � �������� 1 ������ 1970 ����,
        self.dataTimer[name] = os.time() + intervalSeconds
    end,

    -- ��������� �������� (���� ������������� ����� �������)
    allows = function(self, name)
        if not isset(self.dataTimer[name]) then
            error("������ ������� �� ���������� - " .. name)
        end

        -- ����� ������� ������ ��� ������� - ����� ��������
        -- ������������� ����� ������
        if self.dataTimer[name] <= os.time() then
            return true
        else
            return false
        end
    end
}

return Timer
