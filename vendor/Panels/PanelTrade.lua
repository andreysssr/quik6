---

local PanelTrade = {
    --
    name = "Panels_PanelTrade",

    -- отправка событий
    eventSender = {},

    -- структура панели для построения колонок панели
    structure = {},

    -- структура данных для заполнения строк панели
    stockArray = {},

    -- настройки панели - размеры, расположение
    settings = {},

    -- номер панели в системе Quik
    panelId = 0,

    -- массив номеров линий разделителей
    dividerRow = {},

    -- количество строк в панели
    numberRows = 0,

    --
    storage = {},

    --
    view = {},

    --
    colorScheme = {},

    --
    theme = {},

    -- структура dom
    dom = {},

    -- карта кликов
    mapClick = {},

    -- карта (_condition) для смены состояний (цвета)
    mapCondition = {},

    -- карта (_data) для смены значений
    mapData = {},

    -- массив строк панели с id бумаг
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

    -- возвращает массив данных из файла
    structure = function(self, dataPath)
        local name = Autoload:getPathFile(dataPath)
        return dofile(name)
    end,

    -- запуск подготовки данных
    init = function(self)
        -- создать массив dom - для заполнения новой панели при её созд
        self:createDom()

        -- добавить номера монитора в созданную структуру dom
        self:addMonitorNumberInDom()
    end,

    -- добавить номер монитора в структуру dom
    addMonitorNumberInDom = function(self)
        local displayNum = 2

        local start = self.settings.numberGraphs + 1
        local step = self.settings.numberGraphs + 1

        for i = start, #self.dom, step do
            self.dom[i][1].text = displayNum

            --- увеличиваем номер дисплея
            displayNum = displayNum + 1
        end
    end,

    -- вернуть строку разделителя
    getDividerRow = function(self)
        local dividerRow = {}

        -- заполняем все поля в строчку для строки разделителя
        for i = 1, #self.structure do
            dividerRow[i] = {
                text = "",
                color = self.theme.dividerRow,
            }
        end

        return dividerRow
    end,

    -- вернуть строку инструмента
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
                    color = defaultColor, -- дефолтный цвет для строки под номером
                }
            end
        end

        -- записываем название бумаги
        stockRow[1].text = self.storage:getNameToId(id)

        return stockRow
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

    -- создание внутренней структуры панели - dom
    createDom = function(self)
        -- перебираем весь массив инструментов
        for i = 1, #self.stockArray do
            -- старт поиска разделительной горизонтальной линии
            -- начало с 13, с шагом в 12 строк
            for k = self.settings.numberGraphs + 1, #self.stockArray, self.settings.numberGraphs do
                if i == k then
                    -- записываем строку разделитель в дом структуру
                    self.dom[#self.dom + 1] = self:getDividerRow()
                end
            end

            -- дефолтный цвет строки инструмента (зависит от номера в панели - чередуется зеброй)
            local defaultColor = self:getDefaultColorToRow(i)

            -- номер строки в dom - в которую будут записаны данные
            local row = #self.dom + 1

            -- получаем строку для инструмента (передаём номер инструмента из stockArray)
            self.dom[#self.dom + 1] = self:getStockRow(self.stockArray[i], defaultColor)

            -- создаём массив (номер строки) = (idStock) - для сервиса кликов
            self:createRowLinkId(row, self.stockArray[i])

            -- создаём карту кликов
            -- передаём (id инструмента) и (номер строки инструмента в дом структуре)
            self:createMapClick(self.stockArray[i], row)

            -- создание карты состояний - для смены цвета
            -- передаём (id инструмента) и (номер строки инструмента в дом структуре)
            self:createMapCondition(self.stockArray[i], row, defaultColor)

            -- создание карты данных - для смены текста в ячейке
            self:createMapData(self.stockArray[i], row)

        end
    end,

    -- сохраняет в массиве id бумаг по д номерами - которые идут в торовой панели
    createRowLinkId = function(self, row, idStock)
        self.rowLinkId[row] = idStock
    end,

    -- вернуть массив (используется для стрелочного перехода по инструментам)
    getRowLinkId = function(self)
        return self.rowLinkId
    end,

    -- создаёт карту кликов
    createMapClick = function(self, id, row)
        -- структура карты кликов
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
            -- если клики по полю должны обрабатываться
            if self.structure[col].body.type == "clickOn" then
                key = tostring(row) .. "_" .. tostring(col)

                self.mapClick[key] = {
                    id = id,
                    name = self.structure[col].body.name,
                    -- нужна только для отладки
                    nameStock = self.storage:getNameToId(id)
                }

                -- если при клике по полю нужна подсветка
                if self.structure[col].body.lamp then
                    self.mapClick[key].lamp = true
                end
            end
        end
    end,

    -- создаёт карту состояний
    createMapCondition = function(self, id, row, defaultColor)
        -- структура карты состояний
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

    -- создаёт карту значений
    createMapData = function(self, id, row)
        self.mapData[id] = {}

        for col = 1, #self.structure do
            self.mapData[id][self.structure[col].body.name .. "_data"] = {
                row = row,
                col = col,
            }
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

    -- добавляет пустые строки в таблицу
    addLineInTable = function(self)
        for i = 1, #self.dom do
            self.view:addLine(self.panelId)
        end
    end,

    -- вставляем в таблицу структуру dom
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
        -- если полученный параметр это состояние (_condition) - меняем цвет
        if self.mapCondition[id][key] then
            local row = self.mapCondition[id][key].row
            local col = self.mapCondition[id][key].col

            if not_key_exists(self.mapCondition[id][key].colors, value) then
                error("\r\n" .. "Error: В структуре (data_lua_structurePanelTrade.lua) для параметра [" .. key .. "] " ..
                    "отсутствует [colors] - (" .. value .. ")", 3)
            end

            local color = self.mapCondition[id][key].colors[value]
            self.view:setColor(self.panelId, row, col, self.colorScheme:get(color))

            return
        end

        -- если полученный параметр это значение (_data) - меняем значение
        if self.mapData[id][key] then
            local row = self.mapData[id][key].row
            local col = self.mapData[id][key].col

            self.view:setValue(self.panelId, row, col, value)

            return
        end

        error("\r\n" .. "Error: Для ( panel:update() ) указаны не правильные параметры: \r\n" ..
            "id - (" .. type(id) .. ") - (" .. tostring(id) .. "), \r\n" ..
            "key - (" .. type(key) .. ") - (" .. tostring(key) .. "), \r\n" ..
            "value - (" .. type(value) .. ") - (" .. tostring(value) .. "), ", 3)
    end,

    -- обновить данные в панели
    update = function(self, id, params)
        for k, v in pairs(params) do
            self:parseUpdate(id, k, v)
        end
    end,

    --
    updateIndicator = function(self, mode)
        if mode ~= "on" and mode ~= "off" then
            error("\n" .. "Error: Ошибка в ( updateIndicator()  ) должны передаваться (on) или (off), \n" ..
                "передано - (" .. type(mode) .. ") - (" .. tostring(mode) .. ")", 2)
        end

        if mode == "on" then
            self.view:setColor(self.panelId, self.settings.indicator.row, self.settings.indicator.col, self.colorScheme:get(self.settings.indicator.on))
        else
            self.view:setColor(self.panelId, self.settings.indicator.row, self.settings.indicator.col, self.colorScheme:get(self.settings.indicator.off))
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

        -- добавляем в таблицу строки
        self:addLineInTable()

        -- вставляем в таблицу структуру данных и цвет
        self:insertDataInTable()
    end,

    -- возвращает id панели
    getId = function(self)
        return self.panelId
    end,

    -- возвращает название панели
    getName = function(self)
        return self.settings.name
    end,

    -- обработчик кликов по ячейкам
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
