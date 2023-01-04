--- EventHandler Key

local EventHandler = {
    --
    name = "EventHandler_Key_ZaprosLimit",

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
        self.useCase = container:get("UseCase_AddZaprosLimit")

        return self
    end,

    -- �������� �������� ����������
    getCurrentId = function(self)
        return self.microservice:getCurrentIdStock()
    end,

    -- ������ �� 0%
    buy0 = function(self, event)
        local idStock = self:getCurrentId()

        if idStock == "" then
            return
        end

        self.useCase:addZapros(idStock, "buy", 0)
    end,

    -- ������ �� 5% ����
    buy5 = function(self, event)
        local idStock = self:getCurrentId()

        if idStock == "" then
            return
        end

        self.useCase:addZapros(idStock, "buy", 5)
    end,

    -- ������ �� 10% ����
    buy10 = function(self, event)
        local idStock = self:getCurrentId()

        if idStock == "" then
            return
        end

        self.useCase:addZapros(idStock, "buy", 10)
    end,

    -- ������ �� 5% ����
    buy105 = function(self, event)
        local idStock = self:getCurrentId()

        if idStock == "" then
            return
        end

        self.useCase:addZapros(idStock, "buy", 105)
    end,

    -- ������ �� 10% ����
    buy110 = function(self, event)
        local idStock = self:getCurrentId()

        if idStock == "" then
            return
        end

        self.useCase:addZapros(idStock, "buy", 110)
    end,

    -- ������� �� 0%
    sell0 = function(self, event)
        local idStock = self:getCurrentId()

        if idStock == "" then
            return
        end

        self.useCase:addZapros(idStock, "sell", 0)
    end,

    -- ������� �� 5% ����
    sell5 = function(self, event)
        local idStock = self:getCurrentId()

        if idStock == "" then
            return
        end

        self.useCase:addZapros(idStock, "sell", 5)
    end,

    -- ������� �� 10% ����
    sell10 = function(self, event)
        local idStock = self:getCurrentId()

        if idStock == "" then
            return
        end

        self.useCase:addZapros(idStock, "sell", 10)
    end,

    -- ������� �� 5% ����
    sell105 = function(self, event)
        local idStock = self:getCurrentId()

        if idStock == "" then
            return
        end

        self.useCase:addZapros(idStock, "sell", 105)
    end,

    -- ������� �� 10% ����
    sell110 = function(self, event)
        local idStock = self:getCurrentId()

        if idStock == "" then
            return
        end

        self.useCase:addZapros(idStock, "sell", 110)
    end,
}

return EventHandler
