--- MicroService MarkerTrendToChart

local MicroService = {
    --
    name = "MicroService_MarkerTrendToChart",

    --
    container = {},

    --
    storage = {},

    --
    servicePrices = {},

    --
    microserviceConditionPanelTrade = {},

    -- ��� ����� ����
    data = "",

    -- ��� ������ �������
    time = "",

    -- ������ ������� �������
    listIdStock = {},

    -- ������ ������������ �� ������� ����� ����������� ������� (����������� � markerVolume)
    -- ����� ��������� 1 ���������� ��� �� ������
    trendIdStock = {},

    -- ���� ���� ����� �������
    tag = {},

    -- idStock = ����/����/������� ������ ���� ����� �������
    textTrend = {},

    -- ��������� ���� labels ��� id �������� �� ������� ��������� �������
    -- idStock = num label
    labels = {},

    -- idStock = interval
    interval = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")
        self.servicePrices = container:get("AppService_ServicePrices")
        self.microserviceConditionPanelTrade = container:get("MicroService_ConditionPanelTrade")

        self.data = os.date("%Y%m%d")
        self.time = os.date("%H%M") .. "00"

        self.listIdStock = self.storage:getHomeworkId()

        -- ����������� ������ ����� �������
        self:updateArrayIdStock()

        -- ����������� ����� ��� ��������
        self:prepareTextTrend()

        -- ����������� tag ��������
        self:prepareTag()

        --
        self:prepareInterval()

        return self
    end,

    -- ����������� ������ ����� �������
    updateArrayIdStock = function(self)
        self.trendIdStock = self.microserviceConditionPanelTrade:getMarkerTrendListTrue()
    end,

    -- ����������� ����������� ������������
    prepareTextTrend = function(self)
        for i = 1, #self.listIdStock do
            self.textTrend[self.listIdStock[i]] = self.storage:getTrendToId(self.listIdStock[i])
        end
    end,

    -- id �������� ��� �����
    prepareTag = function(self)
        for i = 1, #self.listIdStock do
            self.tag[self.listIdStock[i]] = self.storage:getIdChart(self.listIdStock[i])
        end
    end,

    -- id �������� ��� �����
    prepareInterval = function(self)
        for i = 1, #self.listIdStock do
            self.interval[self.listIdStock[i]] = self.storage:getIntervalToId(self.listIdStock[i])
        end
    end,

    -- ������� ��������� ���� �����������
    getLastPrice = function(self, idStock)
        local class = self.storage:getClassToId(idStock)
        return self.servicePrices:getLastPrice(idStock, class)
    end,

    -- ������� ���� �� ������� ����� ��������� ������
    getLineVertical = function(self, idStock)
        local lastPrice = self:getLastPrice(idStock)

        -- �������� ����� ��� ������� ������� ����� �� ��������� ����
        local interval = self.interval[idStock]

        -- ��������� �������� ���� ��� ���������� �������
        local linePrise = 0

        -- ���������� � ���� 2% �� ���������
        linePrise = lastPrice + ((interval / 100) * 2)

        return d0(linePrise)
    end,

    --
    addLabel = function(self, idStock, tag, label)
        self.labels[idStock] = AddLabel(tag, label)
    end,

    -- �������� ������ �� ������ =
    addMarker = function(self, idStock)
        local tag = self.tag[idStock]
        local text = self.textTrend[idStock]

        -- ��������� �� ��������� ��� ��������
        local label = {
            -- ���� ������� �� ��������� �� �������� ������ ������ ""
            TEXT = text .. "     ",

            YVALUE = self:getLineVertical(idStock),
            DATE = self.data, --DATE = "20220809",
            TIME = self.time, --TIME = "173500",

            -- ���� ������ ���������
            -- ������� ���������� ����� � ������� RGB. ����� � ��������� [0;255]
            R = 255,
            -- ������� ���������� ����� � ������� RGB. ����� � ��������� [0;255]
            G = 128,
            -- ����� ���������� ����� � ������� RGB. ����� � ��������� [0;255]
            B = 0,

            -- ������������ ����� � ���������. �������� ������ ���� � ���������� [0; 100]
            TRANSPARENCY = 0,

            -- ������������ ���� ��������. ��������� ��������: �0� � ������������ ���������, �1� � ������������ ��������
            TRANSPARENT_BACKGROUND = 1,

            -- �������� ������ (�������� �Arial�)
            FONT_FACE_NAME = "Arial",

            -- ������ ������
            FONT_HEIGHT = 14,
        }

        --
        if text == "����" or text == "�������" or text == "�������" then
            label.R = 0
            label.G = 255
            label.B = 0
        end

        --
        if text == "����" or text == "������" or text == "������" then
            label.R = 255
            label.G = 0
            label.B = 0
        end

        if text == "��������" or text == "�" or text == "��" then
            label.R = 255
            label.G = 0
            label.B = 255
        end

        self:addLabel(idStock, tag, label)
    end,

    -- ������� ������ � �������
    removeMarker = function(self, idStock)
        -- ���� ���� ����� ������ - �������� ��� ������� ��� ����������� � �������
        if self.labels[idStock] then
            DelLabel(self.tag[idStock], self.labels[idStock])
        end

        -- ������� ������ �� ������
        self.labels[idStock] = nil

        -- ������� ������ �� ������ ������������ ������� ����� ���������
        self.trendIdStock[idStock] = nil
    end,

    -- ������� ������ � �������
    removeMarkerLocal = function(self, idStock)
        -- ���� ���� ����� ������ - �������� ��� ������� ��� ����������� � �������
        if self.labels[idStock] then
            DelLabel(self.tag[idStock], self.labels[idStock])
        end

        -- ������� ������ �� ������
        self.labels[idStock] = nil
    end,

    -- ������� ������������ ������� �� ���� ��������
    removeAll = function(self)
        for idStock, v in pairs(self.trendIdStock) do
            --  �������� ���������� ������� �� id ������
            self:removeMarker(idStock)
        end
    end,

    -- ��������� ������ �� ������ ��� 1 �����������
    addMarkerToChart = function(self, idStock)
        -- ��������� ���� � �����
        self.data = os.date("%Y%m%d")
        self.time = os.date("%H%M") .. "00"

        -- ��������� ��������� ��� � ������ ��� ������ ����������
        self.trendIdStock[idStock] = 1

        -- ��������� ������ �� ������
        self:addMarker(idStock)
    end,

    -- ��������� ������������ �������
    updateLocation = function(self)
        -- ��������� ���� � �����
        self.data = os.date("%Y%m%d")
        self.time = os.date("%H%M") .. "00"

        -- ���� idStock ���� � ������ - ����� ������� ��� � �������
        for idStock, v in pairs(self.trendIdStock) do
            --  �������� ���������� ������� �� id ������
            self:removeMarkerLocal(idStock)

            -- ��������� ������ �� ������
            self:addMarker(idStock)
        end
    end,
}

return MicroService
