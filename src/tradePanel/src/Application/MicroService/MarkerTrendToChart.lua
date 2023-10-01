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

    -- год месяц день
    data = "",

    -- час минуты секунды
    time = "",

    -- список тикеров домашки
    listIdStock = {},

    -- массив инструментов по которым будет обновляться локация (вколючённые в markerVolume)
    -- может содержать 1 инструмент или ни одного
    trendIdStock = {},

    -- теги всех бумаг домашки
    tag = {},

    -- idStock = лонг/шорт/боковик тренды всех бумаг домашки
    textTrend = {},

    -- хранилище всех labels для id графиков на которые добавлены маркеры
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

        -- подготовить список бумаг домашки
        self:updateArrayIdStock()

        -- подготовить текст для графиков
        self:prepareTextTrend()

        -- подготовить tag графиков
        self:prepareTag()

        --
        self:prepareInterval()

        return self
    end,

    -- подготовить список акций домашки
    updateArrayIdStock = function(self)
        self.trendIdStock = self.microserviceConditionPanelTrade:getMarkerTrendListTrue()
    end,

    -- подготовить комментарий инструментов
    prepareTextTrend = function(self)
        for i = 1, #self.listIdStock do
            self.textTrend[self.listIdStock[i]] = self.storage:getTrendToId(self.listIdStock[i])
        end
    end,

    -- id графиков для бумаг
    prepareTag = function(self)
        for i = 1, #self.listIdStock do
            self.tag[self.listIdStock[i]] = self.storage:getIdChart(self.listIdStock[i])
        end
    end,

    -- id графиков для бумаг
    prepareInterval = function(self)
        for i = 1, #self.listIdStock do
            self.interval[self.listIdStock[i]] = self.storage:getIntervalToId(self.listIdStock[i])
        end
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
        local interval = self.interval[idStock]

        -- расчётное значение цены для размещения маркера
        local linePrise = 0

        -- прибавляем к цене 2% от интервала
        linePrise = lastPrice + ((interval / 100) * 2)

        return d0(linePrise)
    end,

    --
    addLabel = function(self, idStock, tag, label)
        self.labels[idStock] = AddLabel(tag, label)
    end,

    -- добавить маркер на график =
    addMarker = function(self, idStock)
        local tag = self.tag[idStock]
        local text = self.textTrend[idStock]

        -- оранжевый по умолчанию для боковика
        local label = {
            -- Если подпись не требуется то оставить строку пустой ""
            TEXT = text .. "     ",

            YVALUE = self:getLineVertical(idStock),
            DATE = self.data, --DATE = "20220809",
            TIME = self.time, --TIME = "173500",

            -- цвет уровня интервала
            -- Красная компонента цвета в формате RGB. Число в интервале [0;255]
            R = 255,
            -- Зеленая компонента цвета в формате RGB. Число в интервале [0;255]
            G = 128,
            -- Синяя компонента цвета в формате RGB. Число в интервале [0;255]
            B = 0,

            -- Прозрачность метки в процентах. Значение должно быть в промежутке [0; 100]
            TRANSPARENCY = 0,

            -- Прозрачность фона картинки. Возможные значения: «0» – прозрачность отключена, «1» – прозрачность включена
            TRANSPARENT_BACKGROUND = 1,

            -- Название шрифта (например «Arial»)
            FONT_FACE_NAME = "Arial",

            -- Размер шрифта
            FONT_HEIGHT = 14,
        }

        --
        if text == "лонг" or text == "сильнее" or text == "сильный" then
            label.R = 0
            label.G = 255
            label.B = 0
        end

        --
        if text == "шорт" or text == "слабее" or text == "слабый" then
            label.R = 255
            label.G = 0
            label.B = 0
        end

        if text == "внимание" or text == "в" or text == "вн" then
            label.R = 255
            label.G = 0
            label.B = 255
        end

        self:addLabel(idStock, tag, label)
    end,

    -- удалить маркер с графика
    removeMarker = function(self, idStock)
        -- если есть номер лабела - получаем тег графика для инструмента и удаляем
        if self.labels[idStock] then
            DelLabel(self.tag[idStock], self.labels[idStock])
        end

        -- удаляем данные из лабела
        self.labels[idStock] = nil

        -- удаляем данные из списка инструментов которые нужно обновлять
        self.trendIdStock[idStock] = nil
    end,

    -- удалить маркер с графика
    removeMarkerLocal = function(self, idStock)
        -- если есть номер лабела - получаем тег графика для инструмента и удаляем
        if self.labels[idStock] then
            DelLabel(self.tag[idStock], self.labels[idStock])
        end

        -- удаляем данные из лабела
        self.labels[idStock] = nil
    end,

    -- удалить выставленные маркеры на всех графиках
    removeAll = function(self)
        for idStock, v in pairs(self.trendIdStock) do
            --  вызывает обновление уровней по id бумаги
            self:removeMarker(idStock)
        end
    end,

    -- добавляет маркер на график для 1 инструмента
    addMarkerToChart = function(self, idStock)
        -- обновляем дату и время
        self.data = os.date("%Y%m%d")
        self.time = os.date("%H%M") .. "00"

        -- добавляем добавляем его в список для общего обновления
        self.trendIdStock[idStock] = 1

        -- добавляем маркер на график
        self:addMarker(idStock)
    end,

    -- обновляет расположение маркера
    updateLocation = function(self)
        -- обновляем дату и время
        self.data = os.date("%Y%m%d")
        self.time = os.date("%H%M") .. "00"

        -- если idStock есть в списке - тогда удаляем его с графика
        for idStock, v in pairs(self.trendIdStock) do
            --  вызывает обновление уровней по id бумаги
            self:removeMarkerLocal(idStock)

            -- добавляем маркер на график
            self:addMarker(idStock)
        end
    end,
}

return MicroService
