--- EventHandler PanelTrade

local EventHandler = {
    --
    name = "EventHandler_PanelTrade_UpdatePoleTake",

    --
    container = {},

    --
    panelTrade = {},

    --
    handlerPoleBarCurrent = {},

    --
    new = function(self, container)
        self.container = container
        self.panelTrade = container:get("Panels_PanelTrade")

        return self
    end,

    -- меняем цвет поля в торговой панели
    handle = function(self, event)
        --dd(event)

        local idStock = event:getParam("idStock")

        local dto = {}

        local take = self.container:get("Handler_PoleTake"):getParams(idStock)
        array_merge(dto, take)

        self.panelTrade:update(idStock, dto)

    end,
}

return EventHandler
