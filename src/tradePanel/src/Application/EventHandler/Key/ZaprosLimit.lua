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

    -- получить активный инструмент
    getCurrentId = function(self)
        return self.microservice:getCurrentIdStock()
    end,

    -- купить на 0%
    buy0 = function(self, event)
        local idStock = self:getCurrentId()

        if idStock == "" then
            return
        end

        self.useCase:addZapros(idStock, "buy", 0)
    end,

    -- купить на 5% выше
    buy5 = function(self, event)
        local idStock = self:getCurrentId()

        if idStock == "" then
            return
        end

        self.useCase:addZapros(idStock, "buy", 5)
    end,

    -- купить на 10% выше
    buy10 = function(self, event)
        local idStock = self:getCurrentId()

        if idStock == "" then
            return
        end

        self.useCase:addZapros(idStock, "buy", 10)
    end,

    -- купить на 5% ниже
    buy105 = function(self, event)
        local idStock = self:getCurrentId()

        if idStock == "" then
            return
        end

        self.useCase:addZapros(idStock, "buy", 105)
    end,

    -- купить на 10% ниже
    buy110 = function(self, event)
        local idStock = self:getCurrentId()

        if idStock == "" then
            return
        end

        self.useCase:addZapros(idStock, "buy", 110)
    end,

    -- продать на 0%
    sell0 = function(self, event)
        local idStock = self:getCurrentId()

        if idStock == "" then
            return
        end

        self.useCase:addZapros(idStock, "sell", 0)
    end,

    -- продать на 5% ниже
    sell5 = function(self, event)
        local idStock = self:getCurrentId()

        if idStock == "" then
            return
        end

        self.useCase:addZapros(idStock, "sell", 5)
    end,

    -- продать на 10% ниже
    sell10 = function(self, event)
        local idStock = self:getCurrentId()

        if idStock == "" then
            return
        end

        self.useCase:addZapros(idStock, "sell", 10)
    end,

    -- продать на 5% выше
    sell105 = function(self, event)
        local idStock = self:getCurrentId()

        if idStock == "" then
            return
        end

        self.useCase:addZapros(idStock, "sell", 105)
    end,

    -- продать на 10% выше
    sell110 = function(self, event)
        local idStock = self:getCurrentId()

        if idStock == "" then
            return
        end

        self.useCase:addZapros(idStock, "sell", 110)
    end,
}

return EventHandler
