--- EventHandler Key

local EventHandler = {
    --
    name = "EventHandler_Key_ClosePositionLimit",

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
        self.useCase = container:get("UseCase_ClosePositionLimit")

        return self
    end,

    -- �������� �������� ����������
    getCurrentId = function(self)
        return self.microservice:getCurrentIdStock()
    end,

    -- ������� ������� �� ������ ����
    closePosition = function(self, event)
        local id = self:getCurrentId()

        if id == "" then
            return
        end

        self.useCase:closePosition(id)
    end,
}

return EventHandler
