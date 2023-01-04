--- EventHandler Key

local EventHandler = {
    --
    name = "EventHandler_Key_OpenPositionMarket",

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
        self.useCase = container:get("UseCase_OpenPositionMarket")

        return self
    end,

    -- �������� �������� ����������
    getCurrentId = function(self)
        return self.microservice:getCurrentIdStock()
    end,

    -- ������� ������� �� ������ ����
    openPositionSell = function(self, event)
        local id = self:getCurrentId()

        if id == "" then
            return
        end

        self.useCase:openPosition(id, "sell")
    end,

    -- ������� ������� �� ������ ����
    openPositionBuy = function(self, event)
        local id = self:getCurrentId()

        if id == "" then
            return
        end

        self.useCase:openPosition(id, "buy")
    end,
}

return EventHandler
