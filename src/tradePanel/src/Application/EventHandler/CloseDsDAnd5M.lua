--- EventHandler CloseDsDAnd5M - ��������� ��������� ������ ��� 5M � D

local EventHandler = {
    --
    name = "EventHandler_CloseDsDAnd5M",

    --
    storage = {},

    --
    new = function(self, container)
        self.storage = container:get("Storage")
        self.entityService5M = container:get("EntityService_Ds5M")
        self.entityServiceD = container:get("EntityService_DsD")

        return self
    end,

    --
    handle = function(self)
        -- �������� ������ ������� �� �������
        local arrayTickers = self.storage:getHomeworkId()

        -- � ����� �������� �������� Entity BasePrice
        for i = 1, #arrayTickers do
            self.entityService5M:removeDs(arrayTickers[i])
            self.entityServiceD:removeDs(arrayTickers[i])
        end
    end,

}

return EventHandler
