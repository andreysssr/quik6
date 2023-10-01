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
    -- теги графиков для бумаг - которые на которых уже выставлялся маркер
    tag = {},

    -- idStock = idLabel
    -- если маркер выставлен - здесь хранится id маркера под ключём idStock
    labels = {},

    --
    dataTime = {},

    -- массив путей к файлам изображений
    image = {},

    -- idStock = interval
    interval = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")
        self.servicePrices = container:get("AppService_ServicePrices")

        -- подготовить названия картинок и пути к файлам
        self:prepareImage(container:get("config").chartPath)

        return self
    end,

    -- формирует названия картинок и пути к файлам
    prepareImage = function(self, chartPath)
        for nameLine, pathImg in pairs(chartPath) do
            self.image[nameLine] = Autoload:getPathFile(pathImg)
        end
    end,

    -- добавить на график маркер - Active
    addMarker = function(self, id, tag, label)
        self.labels[id] = AddLabel(tag, label)
    end,

    -- вернуть дату для графика
    getData = function(self, idStock)
        -- если дата есть - возвращаем
        if isset(self.dataTime[idStock]) then
            return self.dataTime[idStock].data
        end

        -- если даты нет - записываем её
        self.dataTime[idStock] = {
            data = os.date("%Y%m%d"),
            time = os.date("%H%M") .. "00"
        }

        return self.dataTime[idStock].data
    end,

    -- вернуть время для графика
    getTime = function(self, idStock)
        return self.dataTime[idStock].time
    end,

    -- вернуть последнюю цену инструмента
    getLastPrice = function(self, idStock)
        local class = self.storage:getClassToId(idStock)
        return self.servicePrices:getLastPrice(idStock, class)
    end,

    -- вернуть цену на которой будет выставлен маркер
    getLineVertical = function(self, idStock)
        local lastPrice = self:getLastPrice(idStock)

        -- интервал нужен для расчёта отступа вверх от последней цены
        local interval = 0

        -- получаем интервал бумаги
        if self.interval[idStock] then
            interval = self.interval[idStock]
        else
            -- если интервала нет - сохраняем его чтобы повторно не получать
            self.interval[idStock] = self.storage:getIntervalToId(idStock)

            interval = self.interval[idStock]
        end

        -- расчётное значение цены для размещения маркера
        local linePrise = 0

        -- прибавляем к цене 7% от интервала
        linePrise = lastPrice + ((interval / 100) * 7)

        return d0(linePrise)
    end,

    -- удалить маркер по id бумаги
    removeMarkerActive = function(self, idStock)
        local tag = ""

        -- получаем id графика
        if self.tag[idStock] then
            tag = self.tag[idStock]
        else
            self.tag[idStock] = self.storage:getIdChart(idStock)
            tag = self.tag[idStock]
        end

        -- если есть id маркера для id бумаги - тогда удаляем
        if isset(self.labels[idStock]) then
            DelLabel(tag, self.labels[idStock])

            self.labels[idStock] = nil
        end

        -- обнуляем dataTime для бумаги
        self.dataTime[idStock] = nil
    end,

    -- добавить на график по idStock маркер Active
    addMarkerActive = function(self, idStock)
        local tag = ""

        -- получаем id графика
        if self.tag[idStock] then
            tag = self.tag[idStock]
        else
            self.tag[idStock] = self.storage:getIdChart(idStock)
            tag = self.tag[idStock]
        end

        local label = {
            -- Если подпись не требуется то оставить строку пустой ""
            TEXT = "Active        ",

            YVALUE = self:getLineVertical(idStock),
            DATE = self:getData(idStock), --DATE = "20220809",
            TIME = self:getTime(idStock), --TIME = "173500",

            -- цвет уровня интервала
            -- Красная компонента цвета в формате RGB. Число в интервале [0;255]
            R = 0,
            -- Зеленая компонента цвета в формате RGB. Число в интервале [0;255]
            G = 255,
            -- Синяя компонента цвета в формате RGB. Число в интервале [0;255]
            B = 255,

            -- Прозрачность метки в процентах. Значение должно быть в промежутке [0; 100]
            TRANSPARENCY = 0,

            -- Прозрачность фона картинки. Возможные значения: «0» – прозрачность отключена, «1» – прозрачность включена
            TRANSPARENT_BACKGROUND = 1,

            -- Название шрифта (например «Arial»)
            FONT_FACE_NAME = "Arial",

            -- Размер шрифта
            FONT_HEIGHT = 14,
        }

        -- добавляем маркер на график
        self:addMarker(idStock, tag, label)
    end
}

return MicroService
