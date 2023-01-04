--- EventHandler Key

local EventHandler = {
    --
    name = "EventHandler_Key_ZaprosMarket",

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
        self.useCase = container:get("UseCase_AddZaprosMarket")

        return self
    end,

    -- �������� �������� ����������
    getCurrentId = function(self)
        return self.microservice:getCurrentIdStock()
    end,

    -- ������ �� 0%
    buy0 = function(self, event)
        local id = self:getCurrentId()

        if id == "" then
            return
        end

        self.useCase:addZapros(id, "buy", 0)
    end,

    -- ������ �� 5%
    buy5 = function(self, event)
        local id = self:getCurrentId()

        if id == "" then
            return
        end

        self.useCase:addZapros(id, "buy", 5)
    end,

    -- ������ �� 10%
    buy10 = function(self, event)
        local id = self:getCurrentId()

        if id == "" then
            return
        end

        self.useCase:addZapros(id, "buy", 10)
    end,

    -- ������� �� 0%
    sell0 = function(self, event)
        local id = self:getCurrentId()

        if id == "" then
            return
        end

        self.useCase:addZapros(id, "sell", 0)
    end,

    -- ������� �� 5%
    sell5 = function(self, event)
        local id = self:getCurrentId()

        if id == "" then
            return
        end

        self.useCase:addZapros(id, "sell", 5)
    end,

    -- ������� �� 10%
    sell10 = function(self, event)
        local id = self:getCurrentId()

        if id == "" then
            return
        end

        self.useCase:addZapros(id, "sell", 10)
    end,
}

return EventHandler
