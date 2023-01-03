---

local PanelAlert = {
    --
    name = "Panels_PanelAlert",

    -- ��������� ������ ��� ���������� ������� ������
    structure = {},

    -- ����� ������� ����� ��������������
    panelColors = {},

    -- ��������� ������ - �������, ������������
    settings = {},

    -- ����� ������ � ������� Quik
    panelId = 0,

    --
    storage = {},

    --
    view = {},

    --
    colorScheme = {},

    --
    theme = {},

    --
    new = function(self, container)
        self.eventSender = container:get("AppService_EventSender")
        self.storage = container:get("Storage")
        self.view = container:get("View")
        self.colorScheme = container:get("ColorScheme")

        self.stockArray = self.storage:getHomeworkId()
        self.settings = container:get("config").panels.alert
        self.theme = container:get("config").themeAlert

        self.structure = self:structure(container:get("config").panelsPath.alert)
        self.panelColors = self.structure[4].colors

        return self
    end,

    -- ���������� ������ ������ �� �����
    structure = function(self, dataPath)
        local name = Autoload:getPathFile(dataPath)
        return dofile(name)
    end,

    -- ��������� ������ ������ � �������
    addLineInTable = function(self)
        for i = 1, #self.dom do
            self.view:addLine(self.panelId)
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
    end,

    -- ���������� id ������
    getId = function(self)
        return self.panelId
    end,

    -- ���������� �������� ������
    getName = function(self)
        return self.settings.name
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

    -- �������� ��������� � ������ ����������
    addAlert = function(self, alert)
        local textTime = os.date("%H:%M:%S")
        local textName = alert.name
        local textIdStock = alert.idStock
        local textMessage = alert.message

        local color = alert.color

        -- �������� � ������ ������
        self.view:addLine(self.panelId)

        -- �������� ����� ���� ������
        local rowNum = self.view:getLastRow(self.panelId)

        -- �������� ��������� ���� ��� ������
        local defaultColor = self:getDefaultColorToRow(rowNum)

        -- �������� ��������� ���� (�����)
        self.view:setColor(self.panelId, rowNum, "all", self.colorScheme:get(defaultColor))

        -- �������� ���������
        self.view:setValue(self.panelId, rowNum, 1, textTime)
        self.view:setValue(self.panelId, rowNum, 2, textName)
        self.view:setValue(self.panelId, rowNum, 3, textIdStock)
        self.view:setValue(self.panelId, rowNum, 4, textMessage)

        -- ���������� ���� ��������� - ���� �� ���������
        if color ~= "default" then
            self.view:setColor(self.panelId, rowNum, "all", self.colorScheme:get(self.panelColors[color]))
        end
    end,

}

return PanelAlert
