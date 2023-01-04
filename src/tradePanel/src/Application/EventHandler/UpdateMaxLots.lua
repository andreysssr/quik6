--- EventHandler UpdateMaxLots - ��������

local EventHandler = {
    --
    name = "EventHandler_UpdateMaxLots",

    --
    storage = {},

    --
    entityServiceStock = {},

    --
    new = function(self, container)
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

return EventHandler
