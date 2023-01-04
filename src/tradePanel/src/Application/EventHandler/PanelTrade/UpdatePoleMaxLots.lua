--- EventHandler PanelTrade

local EventHandler = {
    --
    name = "EventHandler_PanelTrade_UpdatePoleMaxLots",

    --
    container = {},

    --
    storage = {},

    --
    panelTrade = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")
        self.panelTrade = container:get("Panels_PanelTrade")

        return self
    end,

    --
    handle = function(self, event)
        local params = event:getParams()

        local idStock = params.idStock
        local maxLots = params.maxLots

        local dto = {}

        dto.maxLots_data = maxLots

        self.panelTrade:update(idStock, dto)
    end,

}

return EventHandler
