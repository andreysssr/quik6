--- EventHandler PanelTrade

local EventHandler = {
    --
    name = "EventHandler_PanelTrade_UpdatePolePosition",

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
        local operation = params.operation
        local qty = params.qty

        local dto = {}

        if qty == 0 then
            dto.position_data = ""
            dto.position_condition = "default"
        else
            dto.position_data = qty

            if operation == "buy" then
                dto.position_condition = "long"
            else
                dto.position_condition = "short"
            end
        end

        self.panelTrade:update(idStock, dto)
    end,
}

return EventHandler
