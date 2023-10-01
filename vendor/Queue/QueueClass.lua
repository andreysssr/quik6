--- QueueClass - класс для работы с очередями
-- от этого класса наследуются

local QueueClass = {
    --
    name = "Queue_QueueClass",

    -- хранилище данных помещённых в очередь
    --data = {},

    -- счётчик отданных элементов
    --first = 0,

    -- счётчик добавленных элементов
    --last = 0,

    -- создать новую очередь FIFO
    new = function(self)
        return self
    end,

    -- добавить данные в очередь
    enqueue = function(self, value)
        local last = self.last + 1
        self.data[last] = value
        self.last = last
    end,

    -- получить самое старое значение и удалить его из очереди
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

return QueueClass;
