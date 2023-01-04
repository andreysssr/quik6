--- MicroService LevelsToChart - ��������� ����� � ������ �� ������

local MicroService = {
    --
    name = "MicroService_LevelsToChart",

    --
    storage = {},

    -- EntityService BasePrice
    entityService = {},

    -- ��������� ���� labels ��� id ��������
    labels = {},

    -- ��� ����� ����
    data = "",

    -- ��� ������ �������
    time = "",

    -- ������ ������������ ������� ���������� ��� ���������� �������
    arrayIdStock = {},

    -- ������ ����� � ������ �����������
    image = {},

    -- ��� �������
    tag = {},

    --
    new = function(self, container)
        self.storage = container:get("Storage")
        self.entityService = container:get("EntityService_BasePrice")

        self.data = os.date("%Y%m%d")
        self.time = os.date("%H%M") .. "00"

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

    -- ����� ������������ ��� ������ �������� ���������
    addLevelToId = function(self, idStock)
        -- ��������� ������ idStock
        self.arrayIdStock[#self.arrayIdStock + 1] = idStock

        self:addLevel(idStock)
    end,

    -- ��������� ������ � ����� �� ��������� ������ �� id ������
    addLevel = function(self, idStock)
        local tag = ""

        -- �������� id �������
        if self.tag[idStock] then
            tag = self.tag[idStock]
        else
            self.tag[idStock] = self.storage:getIdChart(idStock)
            tag = self.tag[idStock]
        end

        -- �������� ������
        local data = self.entityService:getData(idStock)

        -- ��������� ����� �� ������
        self:addLines(tag, data)
    end,

    -- �������� ����� �� ������
    addLines = function(self, tag, data)
        local labels = {}

        -- ���������� ������ �� ����� � ������, ��� ��� � ������ �������� ������� (strong)
        for i = #data, 1, -1 do
            if data[i].type == "level" then
                labels[#labels + 1] = {
                    IMAGE_PATH = self.image["line"],
                    YVALUE = data[i].price,
                    DATE = self.data, --DATE = "20220809",
                    TIME = self.time, --TIME = "173500",
                    TRANSPARENT_BACKGROUND = 0,
                }
            else
                -- ��� ������� (strong) � (line) � (center)- ������ ����� ������ �� ������� ����
                -- ��� �������������� ����� 5% � 10%
                labels[#labels + 1] = {
                    IMAGE_PATH = self.image[data[i].type],
                    YVALUE = data[i].price,
                    DATE = self.data,
                    TIME = self.time,
                    TRANSPARENT_BACKGROUND = 0,
                }
            end
        end

        -- ���������� ������ ��������� label ��� ���������� �� �� ������
        for i = 1, #labels do
            if not_isset(self.labels[tag]) then
                self.labels[tag] = {}
            end

            -- ��������� �� ������ ��� ��������� ������ � �����
            self.labels[tag][#self.labels[tag] + 1] = AddLabel(tag, labels[i])
        end

        -- ������� ������ ������� - �� �������� ������
        if empty(self.labels[tag]) then
            self.labels[tag] = nil
        end
    end,

    -- �������� ����� ��� ��������� ������� �� ������� ���� �����
    removeLine = function(self, tag, labels)
        for i = 1, #labels do
            DelLabel(tag, labels[i])
        end
    end,

    -- ������� ����� �� id ������
    removeLineToId = function(self, idStock)
        local tag = self.storage:getIdChart(idStock)

        -- ���� ���������� � �� ������
        if isset(self.labels[tag]) and not_empty(self.labels[tag]) then
            self:removeLine(tag, self.labels[tag])
        end

        -- �������� ����� � ������� - ������� �������
        self.labels[tag] = {}
    end,

    -- ������� ������������ ����� �� ���� ��������
    removeAll = function(self)
        -- ������ id ����� - ������� �������� ��� ������ ������� ���������� �������
        for i = 1, #self.arrayIdStock do
            --  �������� ���������� ������� �� id ������
            self:removeLineToId(self.arrayIdStock[i])
        end
    end,

    -- ���������
    updateLocationToId = function(self, idStock)
        -- ������� ������ � ����� �� idStock
        self:removeLineToId(idStock)

        -- ��������� ������ � ����� �� ��������� ������ �� id ������
        self:addLevel(idStock)
    end,

    -- ��������� ������ � �����
    updateLocation = function(self)
        -- ��������� ���� � �����
        self.data = os.date("%Y%m%d")
        self.time = os.date("%H%M") .. "00"

        -- ������ id ����� - ������� �������� ��� ������ ������� ���������� �������
        for i = 1, #self.arrayIdStock do
            --  �������� ���������� ������� �� id ������
            self:updateLocationToId(self.arrayIdStock[i])
        end
    end,
}

return MicroService
