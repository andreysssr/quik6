---

local PanelAlert = {
    --
    name = "Panels_PanelAlert",

    -- структура панели для построения колонок панели
    structure = {},

    -- цвета которые могут использоваться
    panelColors = {},

    -- настройки панели - размеры, расположение
    settings = {},

    -- номер панели в системе Quik
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

    -- возвращает массив данных из файла
    structure = function(self, dataPath)
        local name = Autoload:getPathFile(dataPath)
        return dofile(name)
    end,

    -- добавляет пустые строки в таблицу
    addLineInTable = function(self)
        for i = 1, #self.dom do
            self.view:addLine(self.panelId)
        end
    end,

    -- создание структуры таблицы (колонки)
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

    -- показать панель
    show = function(self)
        -- получаем id для создания таблицы
        self.panelId = self.view:idTableCreate()

        -- создаём заголовки панели и вставляем их его в таблицу
        self:createStructure()

        -- выводим таблицу в программе и добавляем Title
        self.view:showTable(self.panelId, self.settings.title)

        -- устанавливаем положение и размеры
        self.view:setPosition(
            self.panelId,
            self.settings.location.left,
            self.settings.location.top,
            self.settings.size.width,
            self.settings.size.height
        )
    end,

    -- возвращает id панели
    getId = function(self)
        return self.panelId
    end,

    -- возвращает название панели
    getName = function(self)
        return self.settings.name
    end,

    -- вернуть дефолтный цвет по номеру строки
    getDefaultColorToRow = function(self, row)
        if row % 2 ~= 0 then
            -- не чётная строка: 1, 3, 5
            --return "gray_2"
            return self.theme.line1
        else
            -- чётная строка: 2, 4, 6
            --return "gray_1"
            return self.theme.line2
        end
    end,

    -- добавить сообщение в панель оповещений
    addAlert = function(self, alert)
        local textTime = os.date("%H:%M:%S")
        local textName = alert.name
        local textIdStock = alert.idStock
        local textMessage = alert.message

        local color = alert.color

        -- добавить в панель строку
        self.view:addLine(self.panelId)

        -- получаем номер этой строки
        local rowNum = self.view:getLastRow(self.panelId)

        -- получаем дефолтный цвет для строки
        local defaultColor = self:getDefaultColorToRow(rowNum)

        -- добавить дефолтный цвет (зебра)
        self.view:setColor(self.panelId, rowNum, "all", self.colorScheme:get(defaultColor))

        -- добавить сообщение
        self.view:setValue(self.panelId, rowNum, 1, textTime)
        self.view:setValue(self.panelId, rowNum, 2, textName)
        self.view:setValue(self.panelId, rowNum, 3, textIdStock)
        self.view:setValue(self.panelId, rowNum, 4, textMessage)

        -- установить цвет сообщения - если он требуется
        if color ~= "default" then
            self.view:setColor(self.panelId, rowNum, "all", self.colorScheme:get(self.panelColors[color]))
        end
    end,

}

return PanelAlert
