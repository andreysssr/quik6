--- MicroService LevelsToChart - добавляет линии и уровни на график

local MicroService = {
    --
    name = "MicroService_LevelsToChart",

    --
    storage = {},

    -- EntityService BasePrice
    entityService = {},

    -- хранилище всех labels для id графиков
    labels = {},

    -- год месяц день
    data = "",

    -- час минуты секунды
    time = "",

    -- массив инструментов которые передавали для построения графика
    arrayIdStock = {},

    -- массив путей к файлам изображений
    image = {},

    -- тег графика
    tag = {},

    --
    new = function(self, container)
        self.storage = container:get("Storage")
        self.entityService = container:get("EntityService_BasePrice")

        self.data = os.date("%Y%m%d")
        self.time = os.date("%H%M") .. "00"

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

    -- метод используется для вызова внешними объектами
    addLevelToId = function(self, idStock)
        -- сохраняем массив idStock
        self.arrayIdStock[#self.arrayIdStock + 1] = idStock

        self:addLevel(idStock)
    end,

    -- добавляет уровни и линии на указанный график по id бумаги
    addLevel = function(self, idStock)
        local tag = ""

        -- получаем id графика
        if self.tag[idStock] then
            tag = self.tag[idStock]
        else
            self.tag[idStock] = self.storage:getIdChart(idStock)
            tag = self.tag[idStock]
        end

        -- получаем уровни
        local data = self.entityService:getData(idStock)

        -- добавляем линии на график
        self:addLines(tag, data)
    end,

    -- добавить линии на график
    addLines = function(self, tag, data)
        local labels = {}

        -- перебираем массив от конца к началу, так как в начале находися уровень (strong)
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
                -- для уровней (strong) и (line) и (center)- рисуем линию только по базовой цене
                -- без дополнительных линий 5% и 10%
                labels[#labels + 1] = {
                    IMAGE_PATH = self.image[data[i].type],
                    YVALUE = data[i].price,
                    DATE = self.data,
                    TIME = self.time,
                    TRANSPARENT_BACKGROUND = 0,
                }
            end
        end

        -- перебираем массив созданных label для добавления их на график
        for i = 1, #labels do
            if not_isset(self.labels[tag]) then
                self.labels[tag] = {}
            end

            -- добавляем на график все созданные уровни и линии
            self.labels[tag][#self.labels[tag] + 1] = AddLabel(tag, labels[i])
        end

        -- убираем пустые массивы - не записаны данные
        if empty(self.labels[tag]) then
            self.labels[tag] = nil
        end
    end,

    -- удаление линий для заданного графика по номерам этих линий
    removeLine = function(self, tag, labels)
        for i = 1, #labels do
            DelLabel(tag, labels[i])
        end
    end,

    -- очистка меток по id бумаги
    removeLineToId = function(self, idStock)
        local tag = self.storage:getIdChart(idStock)

        -- если существует и не пустой
        if isset(self.labels[tag]) and not_empty(self.labels[tag]) then
            self:removeLine(tag, self.labels[tag])
        end

        -- обнуляем метки в массиве - которые удалили
        self.labels[tag] = {}
    end,

    -- удалить выставленные метки на всех графиках
    removeAll = function(self)
        -- список id бумаг - которые вызывали при первом запуске добавления уровней
        for i = 1, #self.arrayIdStock do
            --  вызывает обновление уровней по id бумаги
            self:removeLineToId(self.arrayIdStock[i])
        end
    end,

    -- обновляет
    updateLocationToId = function(self, idStock)
        -- удаляем уровни и линии по idStock
        self:removeLineToId(idStock)

        -- добавляет уровни и линии на указанный график по id бумаги
        self:addLevel(idStock)
    end,

    -- обновляет уровни и линии
    updateLocation = function(self)
        -- обновляем дату и время
        self.data = os.date("%Y%m%d")
        self.time = os.date("%H%M") .. "00"

        -- список id бумаг - которые вызывали при первом запуске добавления уровней
        for i = 1, #self.arrayIdStock do
            --  вызывает обновление уровней по id бумаги
            self:updateLocationToId(self.arrayIdStock[i])
        end
    end,
}

return MicroService
