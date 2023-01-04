--- EventHandler Key

local EventHandler = {
    --
    name = "EventHandler_Key_RemoveZapros",

    --
    container = {},

    --
    microservice = {},

    --
    useCase = {},

    --
    new = function(self, container)
        self.container = container
        self.microservice = container:get("MicroService_ActiveStockPanelTrade")
        self.useCase = container:get("UseCase_RemoveZapros")

        return self
    end,

    -- �������� �������� ����������
    getCurrentId = function(self)
        return self.microservice:getCurrentIdStock()
    end,

    -- ������ �� 0%
    removeZapros = function(self, event)
        local id = self:getCurrentId()

        if id == "" then
            return
        end

        self.useCase:removeZapros(id)
    end,
}

return EventHandler
