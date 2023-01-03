--- Queue - класс для работы с очередями

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

    -- поместить значение в очередь
    enqueue = function(self, value)
        local index_num = self.last + 1;

        self.data[index_num] = value;

        self.last = index_num;
    end,

    -- получить самое старое значение и удалить его из очереди
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

    -- получить размер очереди
    size = function(self)
        return self.last - self.first + 1;
    end,

    -- проверить пустая очередь или нет
    isEmpty = function(self)
        if (self.last - self.first + 1 == 0) then
            return true;
        else
            return false;
        end
    end,
}

return Queue;
