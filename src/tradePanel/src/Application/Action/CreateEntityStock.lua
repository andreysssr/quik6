--- Action CreateEntityStock

local Action = {
    --
    name = "Action_CreateEntityStock",

    --
    container = {},

    --
    storage = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")

        return self
    end,

    --
    handle = function(self)
        -- получаем массив тикеров по домашке
        local arrayTickers = self.storage:getHomeworkId()

        -- в цикле вызываем создание Entity BasePrice
        for i = 1, #arrayTickers do
            self.container:get("Factory_CreateEntityStock"):createEntity(arrayTickers[i])
        end
    end,

}

return Action
