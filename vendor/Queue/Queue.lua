--- Queue - ����� ��� ������ � ���������

local Queue = {
    --
    name = "Queue",

    first = 0,

    last = -1,

    data = {},

    --
    new = function(self)
        return self
    end,

    -- ��������� �������� � �������
    enqueue = function(self, value)
        local index_num = self.last + 1;

        self.data[index_num] = value;

        self.last = index_num;
    end,

    -- �������� ����� ������ �������� � ������� ��� �� �������
    dequeue = function(self)
        local index_num = self.first;

        if (index_num <= self.last) then
            local value = self.data[index_num];
            self.data[index_num] = nil;

            self.first = index_num + 1;

            return value;
        else
            return nil;
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

return Queue;
