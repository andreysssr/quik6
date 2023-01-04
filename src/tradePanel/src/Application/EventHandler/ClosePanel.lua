--- EventHandler ClosePanel - закрывает панели

local EventHandler = {
    --
    name = "EventHandler_ClosePanel",

    --
    panelTrade = {},

    --
    panelAlert = {},

    --
    view = {},

    --
    new = function(self, container)
        self.panelTrade = container:get("Panels_PanelTrade")
        self.panelAlert = container:get("Panels_PanelAlert")
        self.view = container:get("View")

        return self
    end,

    --
    handle = function(self)
        local idPanelTrade = self.panelTrade:getId()
        local idPanelAlert = self.panelAlert:getId()

        self.view:delete(idPanelTrade)
        self.view:delete(idPanelAlert)
    end,
}

return EventHandler
