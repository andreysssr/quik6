--- EventHandler PanelTrade

local EventHandler = {
    --
    name = "EventHandler_PanelTrade_UpdatePoleStock",

    --
    panelTrade = {},

    --
    entityServiceStock = {},

    --
    new = function(self, container)
        self.panelTrade = container:get("Panels_PanelTrade")
        self.entityServiceStock = container:get("EntityService_Stock")

        return self
    end,

    -- меняем цвет поля в торговой панели
    handle = function(self, event)
        local idStock = event:getParam("id")
        local condition = event:getParam("stock")

        local status = self.entityServiceStock:getStatus(idStock)

        -- при включении - фон закрашиваем активным цветом
        if condition == "on" then
            self.panelTrade:update(idStock, {
                stock_condition = "active"
            })
        end

        -- при выключении проверяем в какой цвет закрасить фон
        if condition == "off" then
            -- если статус бумаги - в дефолтный цвет строки
            if status == "active" then
                self.panelTrade:update(idStock, {
                    stock_condition = "default"
                })
            end

            -- если статус бумаги ограниченный - в цвет ограниченной бумаги
            if status == "limitedActive" then
                self.panelTrade:update(idStock, {
                    stock_condition = "limited"
                })
            end
        end
    end,

    --
    changedStatus = function(self, event)
        local idStock = event:getParam("id")
        local status = event:getParam("status")


        -- если статус бумаги - в дефолтный цвет строки
        if status == "notActive" then
            self.panelTrade:update(idStock, {
                stock_condition = "disable"
            })
        end

        -- если статус бумаги - в дефолтный цвет строки
        if status == "active" then
            self.panelTrade:update(idStock, {
                stock_condition = "default"
            })
        end

        -- если статус бумаги ограниченный - в цвет ограниченной бумаги
        if status == "limitedActive" then
            self.panelTrade:update(idStock, {
                stock_condition = "limited"
            })
        end
    end
}

return EventHandler
