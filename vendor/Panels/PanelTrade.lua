---

local PanelTrade = {
    --
    name = "Panels_PanelTrade",

    -- �������� �������
    eventSender = {},

    -- ��������� ������ ��� ���������� ������� ������
    structure = {},

    -- ��������� ������ ��� ���������� ����� ������
    stockArray = {},

    -- ��������� ������ - �������, ������������
    settings = {},

    -- ����� ������ � ������� Quik
    panelId = 0,

    -- ������ ������� ����� ������������
    dividerRow = {},

    -- ���������� ����� � ������
    numberRows = 0,

    --
    storage = {},

    --
    view = {},

    --
    colorScheme = {},

    --
    theme = {},

    -- ��������� dom
    dom = {},

    -- ����� ������
    mapClick = {},

    -- ����� (_condition) ��� ����� ��������� (�����)
    mapCondition = {},

    -- ����� (_data) ��� ����� ��������
    mapData = {},

    -- ������ ����� ������ � id �����
    rowLinkId = {},

    --
    new = function(self, container)
        self.eventSender = container:get("AppService_EventSender")
        self.storage = container:get("Storage")
        self.view = container:get("View")
        self.colorScheme = container:get("ColorScheme")

        self.stockArray = self.storage:getHomeworkId()
        self.settings = container:get("config").panels.trade
        self.theme = container:get("config").theme

        self.structure = self:structure(container:get("config").panelsPath.trade)

        self:init()

        return self
    end,

    -- ���������� ������ ������ �� �����
    structure = function(self, dataPath)
        local name = Autoload:getPathFile(dataPath)
        return dofile(name)
    end,

    -- ������ ���������� ������
    init = function(self)
        -- ������� ������ dom - ��� ���������� ����� ������ ��� � ����
        self:createDom()

        -- �������� ������ �������� � ��������� ��������� dom
        self:addMonitorNumberInDom()
    end,

    -- �������� ����� �������� � ��������� dom
    addMonitorNumberInDom = function(self)
        local displayNum = 2

        local start = self.settings.numberGraphs + 1
        local step = self.settings.numberGraphs + 1

        for i = start, #self.dom, step do
            self.dom[i][1].text = displayNum

            --- ����������� ����� �������
            displayNum = displayNum + 1
        end
    end,

    -- ������� ������ �����������
    getDividerRow = function(self)
        local dividerRow = {}

        -- ��������� ��� ���� � ������� ��� ������ �����������
        for i = 1, #self.structure do
            dividerRow[i] = {
                text = "",
                color = self.theme.dividerRow,
            }
        end

        return dividerRow
    end,

    -- ������� ������ �����������
    getStockRow = function(self, id, defaultColor)
        local stockRow = {}

        for col = 1, #self.structure do
            if self.structure[col].body.name == "divider" then
                stockRow[col] = {
                    text = "",
                    color = self.theme.dividerCol,
                }
            elseif self.structure[col].body.name == "dividerV" then
                stockRow[col] = {
                    text = "",
                    color = self.theme.dividerColV,
                }
            else
                stockRow[col] = {
                    text = "",
                    color = defaultColor, -- ��������� ���� ��� ������ ��� �������
                }
            end
        end

        -- ���������� �������� ������
        stockRow[1].text = self.storage:getNameToId(id)

        return stockRow
    end,

    -- ������� ��������� ���� �� ������ ������
    getDefaultColorToRow = function(self, row)
        if row % 2 ~= 0 then
            -- �� ������ ������: 1, 3, 5
            --return "gray_2"
            return self.theme.line1
        else
            -- ������ ������: 2, 4, 6
            --return "gray_1"
            return self.theme.line2
        end
    end,

    -- �������� ���������� ��������� ������ - dom
    createDom = function(self)
        -- ���������� ���� ������ ������������
        for i = 1, #self.stockArray do
            -- ����� ������ �������������� �������������� �����
            -- ������ � 13, � ����� � 12 �����
            for k = self.settings.numberGraphs + 1, #self.stockArray, self.settings.numberGraphs do
                if i == k then
                    -- ���������� ������ ����������� � ��� ���������
                    self.dom[#self.dom + 1] = self:getDividerRow()
                end
            end

            -- ��������� ���� ������ ����������� (������� �� ������ � ������ - ���������� ������)
            local defaultColor = self:getDefaultColorToRow(i)

            -- ����� ������ � dom - � ������� ����� �������� ������
            local row = #self.dom + 1

            -- �������� ������ ��� ����������� (������� ����� ����������� �� stockArray)
            self.dom[#self.dom + 1] = self:getStockRow(self.stockArray[i], defaultColor)

            -- ������ ������ (����� ������) = (idStock) - ��� ������� ������
            self:createRowLinkId(row, self.stockArray[i])

            -- ������ ����� ������
            -- ������� (id �����������) � (����� ������ ����������� � ��� ���������)
            self:createMapClick(self.stockArray[i], row)

            -- �������� ����� ��������� - ��� ����� �����
            -- ������� (id �����������) � (����� ������ ����������� � ��� ���������)
            self:createMapCondition(self.stockArray[i], row, defaultColor)

            -- �������� ����� ������ - ��� ����� ������ � ������
            self:createMapData(self.stockArray[i], row)

        end
    end,

    -- ��������� � ������� id ����� �� � �������� - ������� ���� � ������� ������
    createRowLinkId = function(self, row, idStock)
        self.rowLinkId[row] = idStock
    end,

    -- ������� ������ (������������ ��� ����������� �������� �� ������������)
    getRowLinkId = function(self)
        return self.rowLinkId
    end,

    -- ������ ����� ������
    createMapClick = function(self, id, row)
        -- ��������� ����� ������
        --[[
            mapClick = {
                4_5 = {
                    id = "SBER",
                    name = "stock",
                    lamp = true,
                }
            },
        ]]

        local key = ""

        for col = 1, #self.structure do
            -- ���� ����� �� ���� ������ ��������������
            if self.structure[col].body.type == "clickOn" then
                key = tostring(row) .. "_" .. tostring(col)

                self.mapClick[key] = {
                    id = id,
                    name = self.structure[col].body.name,
                    -- ����� ������ ��� �������
                    nameStock = self.storage:getNameToId(id)
                }

                -- ���� ��� ����� �� ���� ����� ���������
                if self.structure[col].body.lamp then
                    self.mapClick[key].lamp = true
                end
            end
        end
    end,

    -- ������ ����� ���������
    createMapCondition = function(self, id, row, defaultColor)
        -- ��������� ����� ���������
        --[[
            mapCondition = {
                SBER = {
                    stock_condition = {
                        row,
                        col,
                        colors = {
                            default,
                            active,
                            disable
                        }
                    }
                }

            },
        ]]

        self.mapCondition[id] = {}

        for col = 1, #self.structure do
            self.mapCondition[id][self.structure[col].body.name .. "_condition"] = {
                row = row,
                col = col,
                colors = copy(self.structure[col].body.colors)
            }

            self.mapCondition[id][self.structure[col].body.name .. "_condition"].colors.default = defaultColor
        end
    end,

    -- ������ ����� ��������
    createMapData = function(self, id, row)
        self.mapData[id] = {}

        for col = 1, #self.structure do
            self.mapData[id][self.structure[col].body.name .. "_data"] = {
                row = row,
                col = col,
            }
        end
    end,

    -- �������� ��������� ������� (�������)
    createStructure = function(self)
        for i = 1, #self.structure do
            AddColumn(self.panelId,
                i,
                self.structure[i].header.title,
                true,
                QTABLE_STRING_TYPE,
                self.structure[i].header.width
            );
        end
    end,

    -- ��������� ������ ������ � �������
    addLineInTable = function(self)
        for i = 1, #self.dom do
            self.view:addLine(self.panelId)
        end
    end,

    -- ��������� � ������� ��������� dom
    insertDataInTable = function(self)
        for row = 1, #self.dom do
            for col = 1, #self.dom[row] do
                self.view:setColor(self.panelId, row, col, self.colorScheme:get(self.dom[row][col].color))
                self.view:setValue(self.panelId, row, col, self.dom[row][col].text)
            end
        end
    end,

    --
    parseUpdate = function(self, id, key, value)
        -- ���� ���������� �������� ��� ��������� (_condition) - ������ ����
        if self.mapCondition[id][key] then
            local row = self.mapCondition[id][key].row
            local col = self.mapCondition[id][key].col

            if not_key_exists(self.mapCondition[id][key].colors, value) then
                error("\r\n" .. "Error: � ��������� (data_lua_structurePanelTrade.lua) ��� ��������� [" .. key .. "] " ..
                    "����������� [colors] - (" .. value .. ")", 3)
            end

            local color = self.mapCondition[id][key].colors[value]
            self.view:setColor(self.panelId, row, col, self.colorScheme:get(color))

            return
        end

        -- ���� ���������� �������� ��� �������� (_data) - ������ ��������
        if self.mapData[id][key] then
            local row = self.mapData[id][key].row
            local col = self.mapData[id][key].col

            self.view:setValue(self.panelId, row, col, value)

            return
        end

        error("\r\n" .. "Error: ��� ( panel:update() ) ������� �� ���������� ���������: \r\n" ..
            "id - (" .. type(id) .. ") - (" .. tostring(id) .. "), \r\n" ..
            "key - (" .. type(key) .. ") - (" .. tostring(key) .. "), \r\n" ..
            "value - (" .. type(value) .. ") - (" .. tostring(value) .. "), ", 3)
    end,

    -- �������� ������ � ������
    update = function(self, id, params)
        for k, v in pairs(params) do
            self:parseUpdate(id, k, v)
        end
    end,

    --
    updateIndicator = function(self, mode)
        if mode ~= "on" and mode ~= "off" then
            error("\n" .. "Error: ������ � ( updateIndicator()  ) ������ ������������ (on) ��� (off), \n" ..
                "�������� - (" .. type(mode) .. ") - (" .. tostring(mode) .. ")", 2)
        end

        if mode == "on" then
            self.view:setColor(self.panelId, self.settings.indicator.row, self.settings.indicator.col, self.colorScheme:get(self.settings.indicator.on))
        else
            self.view:setColor(self.panelId, self.settings.indicator.row, self.settings.indicator.col, self.colorScheme:get(self.settings.indicator.off))
        end

    end,

    -- �������� ������
    show = function(self)
        -- �������� id ��� �������� �������
        self.panelId = self.view:idTableCreate()

        -- ������ ��������� ������ � ��������� �� ��� � �������
        self:createStructure()

        -- ������� ������� � ��������� � ��������� Title
        self.view:showTable(self.panelId, self.settings.title)

        -- ������������� ��������� � �������
        self.view:setPosition(
            self.panelId,
            self.settings.location.left,
            self.settings.location.top,
            self.settings.size.width,
            self.settings.size.height
        )

        -- ��������� � ������� ������
        self:addLineInTable()

        -- ��������� � ������� ��������� ������ � ����
        self:insertDataInTable()
    end,

    -- ���������� id ������
    getId = function(self)
        return self.panelId
    end,

    -- ���������� �������� ������
    getName = function(self)
        return self.settings.name
    end,

    -- ���������� ������ �� �������
    clickHandler = function(self, row, col)
        local key = tostring(row) .. "_" .. tostring(col)

        if isset(self.mapClick[key]) then

            if isset(self.mapClick[key].lamp) then
                Highlight(self.panelId, row, col, self.theme.colorHighlight, self.theme.colorHighlight, 300)
            end

            self.eventSender:send("PanelTrade_Clicked_" .. self.mapClick[key].name, {
                id = self.mapClick[key].id,
                name = self.mapClick[key].name,
                panel = self.settings.name,
            })
        end
    end,
}

return PanelTrade
