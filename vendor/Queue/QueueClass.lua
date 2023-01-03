--- QueueClass - ����� ��� ������ � ���������
-- �� ����� ������ �����������

local QueueClass = {
    --
    name = "Queue_QueueClass",

    -- ��������� ������ ���������� � �������
    --data = {},

    -- ������� �������� ���������
    --first = 0,

    -- ������� ����������� ���������
    --last = 0,

    -- ������� ����� ������� FIFO
    new = function(self)
        return self
    end,

    -- �������� ������ � �������
    enqueue = function(self, value)
        local last = self.last + 1
        self.data[last] = value
        self.last = last
    end,

    -- �������� ����� ������ �������� � ������� ��� �� �������
    dequeue = function(self)
        local first = self.first;

        if first <= self.last then
            local value = self.data[first]
            self.data[first] = nil
            self.first = first + 1;

            return value
        else
            return nil
        end
    end,

    -- �������� ������ �������
    size = function(self)
        return self.last - self.first + 1;
    end,

    -- ��������� ������ ������� ��� ���
    isEmpty = function(self)
        if (self.last - self.first + 1 == 0) then
            return true;
        else
            return false;
        end
    end,
}

return QueueClass;
