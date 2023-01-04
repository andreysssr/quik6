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

    -- ������ ���� ���� � �������� ������
    handle = function(self, event)
        local idStock = event:getParam("id")
        local condition = event:getParam("stock")

        local status = self.entityServiceStock:getStatus(idStock)

        -- ��� ��������� - ��� ����������� �������� ������
        if condition == "on" then
            self.panelTrade:update(idStock, {
                stock_condition = "active"
            })
        end

        -- ��� ���������� ��������� � ����� ���� ��������� ���
        if condition == "off" then
            -- ���� ������ ������ - � ��������� ���� ������
            if status == "active" then
                self.panelTrade:update(idStock, {
                    stock_condition = "default"
                })
            end

            -- ���� ������ ������ ������������ - � ���� ������������ ������
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


        -- ���� ������ ������ - � ��������� ���� ������
        if status == "notActive" then
            self.panelTrade:update(idStock, {
                stock_condition = "disable"
            })
        end

        -- ���� ������ ������ - � ��������� ���� ������
        if status == "active" then
            self.panelTrade:update(idStock, {
                stock_condition = "default"
            })
        end

        -- ���� ������ ������ ������������ - � ���� ������������ ������
        if status == "limitedActive" then
            self.panelTrade:update(idStock, {
                stock_condition = "limited"
            })
        end
    end
}

return EventHandler
