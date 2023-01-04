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
    entityServiceDsD = {},

    -- массив путей к файлам изображений
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

        -- подготовить названия картинок и пути к файлам
        self:prepareImage(container:get("config").chartPath)

        -- подготовить список бумаг домашки
        self:updateArrayIdStock()

        -- подготовить tag графиков
        self:prepareTag()

        return self
    end,

    -- формирует названия картинок и пути к файлам
    prepareImage = function(self, chartPath)
        for nameLine, pathImg in pairs(chartPath) do
            self.image[nameLine] = Autoload:getPathFile(pathImg)
        end
    end,

    -- подготовить список акций домашки
    updateArrayIdStock = function(self)
        self.trendIdStock = self.microserviceConditionPanelTrade:getMarkerDayBarListTrue()
    end,

    -- id графиков для бумаг
    prepareTag = function(self)
        for i = 1, #self.listIdStock do
            self.tag[self.listIdStock[i]] = self.storage:getIdChart(self.listIdStock[i])
        end
    end,

    -- вернуть цену на которой будет выставлен маркер
    getLineVertical = function(self, idStock)
        local lineVertical = self.entityServiceDsD:getHiLowClosePreviousBar(idStock).close

        return lineVertical
    end,

    --
    addLabel = function(self, idStock, tag, label)
        self.labels[idStock] = AddLabel(tag, label)
    end,

    -- добавить маркер на график =
    addMarker = function(self, idStock)
        local tag = self.tag[idStock]
        local arrayStrongLine = self.storage:getStrongLevel(idStock)

        if arrayStrongLine == 0 then
            return
        end

        for i = 1, #arrayStrongLine do
            -- оранжевый по умолчанию для боковика
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

        -- добавляем доавляем его в список для общего обновления
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
