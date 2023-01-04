--- EventHandler Key

local EventHandler = {
    --
    name = "EventHandler_Key_SelectActiveStock",

    --
    microservice = {},

    -- ����� ������ = idStock
    rowLinkId = {},

    -- idStock = ����� �����
    idLinkRow = {},

    --
    new = function(self, container)
        self.microservice = container:get("MicroService_ActiveStockPanelTrade")
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

    -- 1, 2, 3, 4, 5, 6, 7, 8, 9,
    numberSelect = function(self, event)
        local row = tonumber(event.attachKey)

        local idStock = self.rowLinkId[row]

        self.microservice:changeActive(idStock)
    end,

    -- 0
    numberOff = function(self)
        self.microservice:resetCurrent()
    end,

    -- Shift
    revers = function(self)
        self.microservice:reversCurrent()
    end,

    -- ������� ����� (up), ������� ���� (down)
    upDown = function(self, event)
        -- up
        if event.attachKey == "NumPad 8" then
            self:upNext()
        end

        -- down
        if event.attachKey == "NumPad 2" then
            self:downNext()
        end
    end,

    -- ��������� ����� �� ���������
    upNext = function(self)
        -- �������� ������� �������� ���������� � �������� ������
        local idStock = self.microservice:getCurrentIdStock()

        -- ���� ������� ���������� �������� - ������������� ���������
        if idStock == "" then
            return
        end

        -- �������� ����� ������ ��������� ����������� � �������� ������
        local row = self.idLinkRow[idStock]

        -- ��������� �� 1
        local row_1 = row - 1

        -- ��������� �� 2
        local row_2 = row - 2

        -- id ��������� ������
        local nextIdStock = ""

        -- ���� ���� ����� �� 1 ���� - ������ �������� ���
        if isset(self.rowLinkId[row_1]) then
            nextIdStock = self.rowLinkId[row_1]
            self.microservice:changeActive(nextIdStock)

            return
        end

        -- ���� ���� ����� �� 2 ���� - ������ �������� ��� (���� ����� �������������� �������)
        if isset(self.rowLinkId[row_2]) then
            nextIdStock = self.rowLinkId[row_2]
            self.microservice:changeActive(nextIdStock)

            return
        end

        -- ���� ����� ������� ��� - ��������� ���������� (��������� ����� ���� 1)
        self.microservice:resetCurrent()
    end,

    -- ��������� ���� �� ���������
    downNext = function(self)
        -- �������� ������� �������� ���������� � �������� ������
        local idStock = self.microservice:getCurrentIdStock()

        -- ���� ������� ���������� �������� - ������������� ���������
        if idStock == "" then
            return
        end

        -- �������� ����� ������ ��������� ����������� � �������� ������
        local row = self.idLinkRow[idStock]

        -- ��������� �� 1
        local row_1 = row + 1

        -- ��������� �� 2
        local row_2 = row + 2

        -- id ��������� ������
        local nextIdStock = ""

        -- ���� ���� ����� �� 1 ���� - ������ �������� ���
        if isset(self.rowLinkId[row_1]) then
            nextIdStock = self.rowLinkId[row_1]
            self.microservice:changeActive(nextIdStock)

            return
        end

        -- ���� ���� ������� 2 ���� - ������ �������� ��� (���� ����� �������������� �������)
        if isset(self.rowLinkId[row_2]) then
            nextIdStock = self.rowLinkId[row_2]
            self.microservice:changeActive(nextIdStock)

            return
        end

        -- ���� ����� ������� ��� - ��������� ���������� (���������� ���� ������ ������� �����������)
        self.microservice:resetCurrent()
    end
}

return EventHandler
