--- EventHandler

local EventHandler = {
    --
    name = "EventHandler_ClickedPanelTrade_PoleTake",

    --
    microservice = {},

    --
    container = {},

    --
    new = function(self, container)
        self.entityServiceStock = container:get("EntityService_Stock")

        return self
    end,

    select2 = function(self, event)
        local idStock = event:getParam("id")

        self.entityServiceStock:changeTake(idStock, 2)
    end,

    select3 = function(self, event)
        local idStock = event:getParam("id")

        self.entityServiceStock:changeTake(idStock, 3)
    end,

    select4 = function(self, event)
        local idStock = event:getParam("id")

        self.entityServiceStock:changeTake(idStock, 4)
    end,

    select5 = function(self, event)
        local idStock = event:getParam("id")

        self.entityServiceStock:changeTake(idStock, 5)
    end,

    select6 = function(self, event)
        local idStock = event:getParam("id")

        self.entityServiceStock:changeTake(idStock, 6)
    end,

    select7 = function(self, event)
        local idStock = event:getParam("id")

        self.entityServiceStock:changeTake(idStock, 7)
    end,

    select8 = function(self, event)
        local idStock = event:getParam("id")

        self.entityServiceStock:changeTake(idStock, 8)
    end,
}

return EventHandler
