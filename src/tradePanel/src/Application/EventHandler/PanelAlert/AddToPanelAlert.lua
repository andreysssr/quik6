--- EventHandler AddToPanelAlert - ��������

local EventHandler = {
    --
    name = "EventHandler_AddToPanelAlert",

    --
    container = {},

    --
    storage = {},

    --
    panelAlert = {},

    -- ����� ������ = idStock
    rowLinkId = {},

    -- idStock = ����� ������
    idLinkRow = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")
        self.panelAlert = container:get("Panels_PanelAlert")
        self.rowLinkId = container:get("Panels_PanelTrade"):getRowLinkId()

        self:prepareIdLinkRow()

        return self
    end,

    -- �������������� ������ � ������� idStock � � �������� ����� ������ � �������� ������
    prepareIdLinkRow = function(self)
        for row, idStock in pairs(self.rowLinkId) do
            self.idLinkRow[idStock] = row
        end
    end,

    --
    getNumRow = function(self, idStock)
        if isset(self.idLinkRow[idStock]) then
            return self.idLinkRow[idStock] .. " ) "
        end

        return ""
    end,

    -- �������� ������� � ������ Alert - ������� �������
    openedPosition = function(self, event)
        local idStock = event:getParam("idStock")
        local name = self.storage:getNameToId(idStock)
        local operation = event:getParam("operation")

        -- ���� ������ �� ���� ���� ���������� �� ���� �� ������ �������� � ������ ���
        if operation == "" then
            return
        end

        local dto = {
            idStock = idStock,
            name = self:getNumRow(idStock) .. name,
            message = "������� �������",
            color = "default"
        }

        if operation == "sell" then
            dto.color = "sell"
        else
            dto.color = "buy"
        end

        self.panelAlert:addAlert(dto)
    end,

    -- �������� ������� � ������ Alert - ������� �������
    closedPosition = function(self, event)
        local idStock = event:getParam("idStock")
        local name = self.storage:getNameToId(idStock)

        local dto = {
            idStock = idStock,
            name = self:getNumRow(idStock) .. name,
            message = "������� �������",
            color = "default"
        }

        self.panelAlert:addAlert(dto)
    end,
}

return EventHandler
