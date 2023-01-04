--- MicroService MarkerStrongLineToChart

local MicroService = {
    --
    name = "MicroService_MarkerStrongLineToChart",

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
    entityServiceDsD = {},

    -- ������ ����� � ������ �����������
    image = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")
        self.servicePrices = container:get("AppService_ServicePrices")
        self.entityServiceDsD = container:get("EntityService_DsD")
        self.microserviceConditionPanelTrade = container:get("MicroService_ConditionPanelTrade")

        self.data = os.date("%Y%m%d")
        self.time = os.date("%H%M") .. "00"

        self.listIdStock = self.storage:getHomeworkId()

        -- ����������� �������� �������� � ���� � ������
        self:prepareImage(container:get("config").chartPath)

        -- ����������� ������ ����� �������
        self:updateArrayIdStock()

        -- ����������� tag ��������
        self:prepareTag()

        return self
    end,

    -- ��������� �������� �������� � ���� � ������
    prepareImage = function(self, chartPath)
        for nameLine, pathImg in pairs(chartPath) do
            self.image[nameLine] = Autoload:getPathFile(pathImg)
        end
    end,

    -- ����������� ������ ����� �������
    updateArrayIdStock = function(self)
        self.trendIdStock = self.microserviceConditionPanelTrade:getMarkerDayBarListTrue()
    end,

    -- id �������� ��� �����
    prepareTag = function(self)
        for i = 1, #self.listIdStock do
            self.tag[self.listIdStock[i]] = self.storage:getIdChart(self.listIdStock[i])
        end
    end,

    -- ������� ���� �� ������� ����� ��������� ������
    getLineVertical = function(self, idStock)
        local lineVertical = self.entityServiceDsD:getHiLowClosePreviousBar(idStock).close

        return lineVertical
    end,

    --
    addLabel = function(self, idStock, tag, label)
        self.labels[idStock] = AddLabel(tag, label)
    end,

    -- �������� ������ �� ������ =
    addMarker = function(self, idStock)
        local tag = self.tag[idStock]
        local arrayStrongLine = self.storage:getStrongLevel(idStock)

        if arrayStrongLine == 0 then
            return
        end

        for i = 1, #arrayStrongLine do
            -- ��������� �� ��������� ��� ��������
            local label = {
                IMAGE_PATH = self.image["strong"],
                ALIGNMENT = "RIGHT",
                YVALUE = arrayStrongLine[i],
                DATE = self.data, --DATE = "20220809",
                TIME = self.time, --TIME = "173500",
                TRANSPARENT_BACKGROUND = 0,
            }

            self:addLabel(idStock, tag, label)
        end

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

        -- ��������� �������� ��� � ������ ��� ������ ����������
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
