--- Action CreateEntityStock

local Action = {
    --
    name = "Action_CalculateMaxLotsEntityStock",

    --
    container = {},

    --
    storage = {},

    --
    entityServiceStock = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")
        self.entityServiceStock = container:get("EntityService_Stock")

        return self
    end,

    --
    handle = function(self)
        -- �������� ������ ������� �� �������
        local arrayTickers = self.storage:getHomeworkId()

        -- � ����� �������� �������� Entity BasePrice
        for i = 1, #arrayTickers do
            self.entityServiceStock:calculateMaxLots(arrayTickers[i])
        end
    end,

}

return Action
