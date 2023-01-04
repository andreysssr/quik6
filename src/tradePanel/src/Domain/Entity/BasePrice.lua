---

local Entity_BasePrice = {
    --
    name = "Entity_BasePrice",

    --[[
        --
        id = "",

        --
        class = "",

        --
        events = {},

        --
        lastPrice = {},

        --
        params = {},

        -- ����� �������� ��� �������� ������ - � ��������� �������
        data = {},

        -- ��������� �������� ������
        basePrice = {
            --price = 0,
            ---- strong, line, level
            --type = "strong",
            --lines = {120, 125, 135, 140,}
        },

        ---
        -- ������� ������
        strong = {},

        -- ����� (30, 50, 70)
        levels = {},

        -- ������ ����������
        lines = {},

        -- ������ ��������
        centers = {}

        -- ��������������� ������ ��� ��������
        -- ����������� ������ ����������
        levelsTmp = {},

        -- ��������������� ������ ��� ��������
        -- ����������� ������ (30%, 70%)
        linesTMP = {},

        -- ��������������� ������ ��� ��������
        -- ����������� ������ (50%)
        centersTMP = {},

        ]]

    --
    lastPrice = {},

    --
    new = function(self, container)
        self.lastPrice = container:get("DomainService_LastPrice")

        local trait = container:get("Entity_TraitEvent")
        extended(self, trait)

        return self
    end,

    --
    newChild = function(self, params)
        local obj = {
            id = params.id,
            class = params.class,
            events = {},

            params = params,
            data = {}, -- ������ ��� ����������� ��������� ������
            dataView = {}, -- ������ ��� ����������� ����� �� �������
            basePrice = {},

            strong = {},
            levels = {},
            lines = {},
            centers = {},

            levelsTmp = {},
            linesTMP = {},
            centersTMP = {},

            intervalStep = 0,
        }

        extended(obj, self)

        return obj
    end,

    --
    init = function(self)
        self:createDataLevel()         -- ������ ��������� ��� ������������ �������
        self:createDataLine()          -- ������ ��������� ��� ����� (30%, 50%, 70%,)

        self:joinData()                -- ���������� ��� ��������� � ����� (� ������� ��������)
    end,

    -- ������� id
    getId = function(self)
        return self.id
    end,

    -- ������� ������ lines - ������� �� 4 ����� (-10%, -5%, 5%, 10%) �� ���������� ����
    -- price - ������� ����, ����������� �������, ������������ �������, ��� � 5% �� ���������
    getLines = function(self, price, min, max, step)
        local lines = {}

        for i = min, max, step do
            if i ~= price then
                lines[#lines + 1] = i
            end
        end

        return lines
    end,

    -- ������������ ��������� ��� ������������ �������
    createDataLevel = function(self)
        -- ���������� ������� ��������� (� �������� ���� ������ ���������)
        for price = self.params.minPrice, self.params.maxPrice, self.params.interval do
            self.levelsTmp[#self.levelsTmp + 1] = price
        end

        -- ��� ��������� ��� ����� ��������� ������
        local intervalStep = self.params.interval / 2

        local viewLinesBasePrice = self.params.interval / 8

        for i = 1, #self.levelsTmp do
            self.levels[#self.levels + 1] = {
                price = self.levelsTmp[i],

                -- 1 ��� ���������
                minBorder = self.levelsTmp[i] - intervalStep, -- ����������� ������� ��� ������: -1 ��� ���������
                maxBorder = self.levelsTmp[i] + intervalStep, -- ������������ ������� ��� ������: 1 ��� ���������

                type = "level",
                interval = self.params.interval,
                lines = self:getLines(
                    self.levelsTmp[i], -- ���� ������� �����
                    self.levelsTmp[i] - viewLinesBasePrice, -- ����������� �������: 1/6 ����� ���������
                    self.levelsTmp[i] + viewLinesBasePrice, -- ������������ �������: 1/6 ����� ���������
                    viewLinesBasePrice    -- �������� ���� ���������
                )
            }
        end
    end,

    createDataLine = function(self)
        -- ��� ���������
        local intervalStep = self.params.interval / 6

        local viewLinesBasePrice = self.params.interval / 3 / 8

        -- ��������� ��������� �����
        for i = 1, #self.levelsTmp do
            self.linesTMP[#self.linesTMP + 1] = self.levelsTmp[i] - (intervalStep * 2) -- ����� 2 ���� ���������
            self.linesTMP[#self.linesTMP + 1] = self.levelsTmp[i] + (intervalStep * 2) -- ����� 2 ���� ���������
        end

        for i = 1, #self.linesTMP do
            self.lines[#self.lines + 1] = {
                price = self.linesTMP[i],

                -- 1 ��� ���������
                minBorder = self.linesTMP[i] - intervalStep, -- ����������� ������� ��� ������: -1 ��� ���������
                maxBorder = self.linesTMP[i] + intervalStep, -- ������������ ������� ��� ������: 1 ��� ���������

                type = "line",
                interval = self.params.interval,
                lines = self:getLines(
                    self.linesTMP[i], -- ���� ������� �����
                    self.linesTMP[i] - viewLinesBasePrice, -- ����������� �������: 1/6 ����� ���������
                    self.linesTMP[i] + viewLinesBasePrice, -- ������������ �������: 1/6 ����� ���������
                    viewLinesBasePrice    -- �������� ���� ���������
                )
            }
        end
    end,

    -- ���������� ��������� � 1
    joinData = function(self)
        -- ��������� ��������� levels � ������ ��� �������� ����
        for i = 1, #self.levels do
            self.data[#self.data + 1] = self.levels[i]
        end
    end,

    -- ������� ���������� �������� � �������
    updateBasePrice = function(self, price, params, range)
        -- ���� �������� �� ���� (�������� � �������� ������ ������ ��� - ����� �������������)
        if empty(self.basePrice) then
            -- ���������� ������
            self.basePrice = copy(params)
            self.basePrice.range = range

            local dto = copy(params)
            dto.id = self.id
            dto.class = self.class
            dto.range = range

            dto.blockEvents = 1

            self:registerEvent("BasePrice_ChangedBasePrice", dto)

            return
        end

        -- ���� ���������� ���� �� ����� �������� ������� ����
        if self.basePrice.price ~= price then
            -- ���������� ������
            self.basePrice = copy(params)
            self.basePrice.range = range

            local dto = copy(params)
            dto.id = self.id
            dto.class = self.class
            dto.range = range

            dto.blockEvents = 2

            self:registerEvent("BasePrice_ChangedBasePrice", dto)
        end
    end,

    -- ����� �������� � ������� ��������� ���� ������������ ������/������
    -- 5%, 10%, 15%, 20%
    getRange = function(self, currentPrice, basePrice)
        local range_5 = self.params.interval / 100 * 5
        local range_10 = self.params.interval / 100 * 10

        -- ���� (������� ����) ������ ��� ����� (������� ��������� ������� ����)
        --									�
        -- (������� ����) ������ ��� ����� (�������� ��������� ������� ����)
        -- ����� �������������� ��� - "strong", "line", "level"
        if currentPrice >= (basePrice - range_5) and currentPrice <= (basePrice + range_5) then
            return 5
        end

        -- ����� �������������� ��� - "strong", "line", "level"
        if currentPrice >= (basePrice - range_10) and currentPrice <= (basePrice + range_10) then
            return 10
        end

        return 0
    end,

    -- ��������� � ��������� ����� ����� ������� ����
    checkLevel = function(self)
        -- �������� ��������� ����
        local price = self.lastPrice:getPrice(self.id, self.class)

        -- �������� ��������� ���� �� �����/������ - ��������
        -- ���� � ���������:
        --		5%
        --		10%
        local range = 0

        -- �������� �� ���� ��������� ������ � ���������
        for i = 1, #self.data do
            -- (���� > ����������� �������) � (���� < ������������ �������)
            if price > self.data[i].minBorder and price < self.data[i].maxBorder then
                range = self:getRange(price, self.data[i].price)
                self:updateBasePrice(self.data[i].price, self.data[i], range)

                break
            end
        end
    end,

    -- ������� ����������� ���������
    getData = function(self)
        return self.data
    end,

    -- ������� ������� ����
    getPrice = function(self)
        if not_empty(self.basePrice) then
            return self.basePrice.price
        end

        return nil
    end,

    -- ���������� ������ ������� ������ basePrice
    getBasePrice = function(self)
        return self.basePrice
    end,
}

return Entity_BasePrice
