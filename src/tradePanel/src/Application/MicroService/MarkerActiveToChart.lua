--- MicroService MarkerActiveToChart

local MicroService = {
    --
    name = "MicroService_MarkerActiveToChart",

    --
    container = {},

    --
    storage = {},

    --
    servicePrices = {},

    -- idStock = idTag
    -- ���� �������� ��� ����� - ������� �� ������� ��� ����������� ������
    tag = {},

    -- idStock = idLabel
    -- ���� ������ ��������� - ����� �������� id ������� ��� ������ idStock
    labels = {},

    --
    dataTime = {},

    -- ������ ����� � ������ �����������
    image = {},

    -- idStock = interval
    interval = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")
        self.servicePrices = container:get("AppService_ServicePrices")

        -- ����������� �������� �������� � ���� � ������
        self:prepareImage(container:get("config").chartPath)

        return self
    end,

    -- ��������� �������� �������� � ���� � ������
    prepareImage = function(self, chartPath)
        for nameLine, pathImg in pairs(chartPath) do
            self.image[nameLine] = Autoload:getPathFile(pathImg)
        end
    end,

    -- �������� �� ������ ������ - Active
    addMarker = function(self, id, tag, label)
        self.labels[id] = AddLabel(tag, label)
    end,

    -- ������� ���� ��� �������
    getData = function(self, idStock)
        -- ���� ���� ���� - ����������
        if isset(self.dataTime[idStock]) then
            return self.dataTime[idStock].data
        end

        -- ���� ���� ��� - ���������� �
        self.dataTime[idStock] = {
            data = os.date("%Y%m%d"),
            time = os.date("%H%M") .. "00"
        }

        return self.dataTime[idStock].data
    end,

    -- ������� ����� ��� �������
    getTime = function(self, idStock)
        return self.dataTime[idStock].time
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
        local interval = 0

        -- �������� �������� ������
        if self.interval[idStock] then
            interval = self.interval[idStock]
        else
            -- ���� ��������� ��� - ��������� ��� ����� �������� �� ��������
            self.interval[idStock] = self.storage:getIntervalToId(idStock)

            interval = self.interval[idStock]
        end

        -- ��������� �������� ���� ��� ���������� �������
        local linePrise = 0

        -- ���������� � ���� 7% �� ���������
        linePrise = lastPrice + ((interval / 100) * 7)

        return d0(linePrise)
    end,

    -- ������� ������ �� id ������
    removeMarkerActive = function(self, idStock)
        local tag = ""

        -- �������� id �������
        if self.tag[idStock] then
            tag = self.tag[idStock]
        else
            self.tag[idStock] = self.storage:getIdChart(idStock)
            tag = self.tag[idStock]
        end

        -- ���� ���� id ������� ��� id ������ - ����� �������
        if isset(self.labels[idStock]) then
            DelLabel(tag, self.labels[idStock])

            self.labels[idStock] = nil
        end

        -- �������� dataTime ��� ������
        self.dataTime[idStock] = nil
    end,

    -- �������� �� ������ �� idStock ������ Active
    addMarkerActive = function(self, idStock)
        local tag = ""

        -- �������� id �������
        if self.tag[idStock] then
            tag = self.tag[idStock]
        else
            self.tag[idStock] = self.storage:getIdChart(idStock)
            tag = self.tag[idStock]
        end

        local label = {
            -- ���� ������� �� ��������� �� �������� ������ ������ ""
            TEXT = "Active        ",

            YVALUE = self:getLineVertical(idStock),
            DATE = self:getData(idStock), --DATE = "20220809",
            TIME = self:getTime(idStock), --TIME = "173500",

            -- ���� ������ ���������
            -- ������� ���������� ����� � ������� RGB. ����� � ��������� [0;255]
            R = 0,
            -- ������� ���������� ����� � ������� RGB. ����� � ��������� [0;255]
            G = 255,
            -- ����� ���������� ����� � ������� RGB. ����� � ��������� [0;255]
            B = 255,

            -- ������������ ����� � ���������. �������� ������ ���� � ���������� [0; 100]
            TRANSPARENCY = 0,

            -- ������������ ���� ��������. ��������� ��������: �0� � ������������ ���������, �1� � ������������ ��������
            TRANSPARENT_BACKGROUND = 1,

            -- �������� ������ (�������� �Arial�)
            FONT_FACE_NAME = "Arial",

            -- ������ ������
            FONT_HEIGHT = 14,
        }

        -- ��������� ������ �� ������
        self:addMarker(idStock, tag, label)
    end
}

return MicroService
