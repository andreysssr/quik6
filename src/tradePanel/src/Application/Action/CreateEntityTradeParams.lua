--- Action CreateEntityTradeParams

local Action = {
    --
    name = "Action_CreateEntityTradeParams",

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
        -- �������� ������ ������� �� �������
        local arrayTickers = self.storage:getHomeworkId()

        -- � ����� �������� �������� Entity BasePrice
        for i = 1, #arrayTickers do
            self.container:get("Factory_CreateEntityTradeParams"):createEntity(arrayTickers[i])
        end
    end,

}

return Action