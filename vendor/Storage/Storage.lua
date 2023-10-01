---

local Storage = {
    --
    name = "Storage",

    container = {},

    -- данные о классе, аккаунте бумаг
    dataClassAccount = {},

    -- данные из домашки
    dataHomework = {},

    -- содержит все id домашки по порядку (численный массив от 1 - до конца)
    dataFullHomework = {},

    -- данные шортах
    dataAllowedShort = {},

    -- id графиков по id бумаги
    dataIdCharts = {},

    --
    dbLevels = {},

    --
    new = function(self, container)
        self.container = container
        self:init()

        return self
    end,

    -- возвращает массив данных из файла
    getData = function(self, dataPath)
        if is_nil(dataPath) then
            error("\n" .. "Error: В Storage:getData(dataPath) передан параметр dataPath = nil", 2)
        end

        local name = Autoload:getPathFile(dataPath)
        local result = File:readCsv(name)

        return result
    end,

    init = function(self)
        -- разбор данных из classAccount
        self:parseClassAccount()

        -- разбор данных из домашки
        self:parseHomework()

        -- разбор данных из разрешённых инструментов для шорта
        self:parseAllowedToShort()

        -- разбор данных id графиков для бумаг
        self:parseIdCharts()

        -- добавить в хранилище базу данных уровней
        self:addDbLevels()
    end,

    -- разбор данных id графиков для бумаг
    parseIdCharts = function(self)
        local idChart = self.container:get("config").dataPath.idChart
        local data = self:getData(idChart)

        for i = 2, #data do
            if data[i][1] ~= "" then
                self.dataIdCharts[data[i][1]] = data[i][3]
            end
        end
    end,

    -- разбор данных classAccount
    parseClassAccount = function(self)
        -- настройки account счетов для подключения
        local val = {
            stock = self.container:get("Config_stock"),
            futures = self.container:get("Config_futures"),
            currency = self.container:get("Config_currency"),
        }

        -- список классов и аккаунтов по бумагам
        local classAccountPath = self.container:get("config").dataPath.stockClassAccount
        local data = self:getData(classAccountPath)

        for i = 2, #data do
            if data[i][1] ~= "" then
                -- если в self.data нет массива с индексом тикера - тогда создаём
                if not_isset(self.dataClassAccount[data[i][1]]) then
                    self.dataClassAccount[data[i][1]] = {}
                end

                -- название - (Сбербанк)
                self.dataClassAccount[data[i][1]]["name"] = data[i][2]

                -- class бумаги
                self.dataClassAccount[data[i][1]]["class"] = data[i][3]

                -- account - счёт депо для бумаги (для акций, фьючерсов, валюты)
                self.dataClassAccount[data[i][1]]["account"] = val[data[i][4]].account

                -- код клиента - для бумаги (для акций, фьючерсов, валюты)
                self.dataClassAccount[data[i][1]]["client_code"] = val[data[i][4]].client_code
            end
        end
    end,

    -- разбор данных из домашки
    parseHomework = function(self)
        local homeworkPath = self.container:get("config").dataPath.homework
        local data = self:getData(homeworkPath)

        for i = 2, #data do
            if data[i][1] ~= "" then
                -- если в self.data нет массива с индексом тикера - тогда создаём
                if not_isset(self.dataHomework[data[i][1]]) then
                    self.dataHomework[data[i][1]] = {}
                end

                -- название бумаги
                self.dataHomework[data[i][1]]["name"] = data[i][2]

                -- интервал
                if data[i][3] == "" then
                    error("\r\n" .. "Error: В файле (homework.csv) для инструмента (" .. data[i][1] .. ") отсутсвует (интервал)")
                else
                    self.dataHomework[data[i][1]]["interval"] = tonumber(data[i][3])
                end

                -- если поле не пусто
                if data[i][4] ~= "" then
                    -- сильный уровень
                    local strongLevel = explode("|", data[i][4])
                    for k = 1, #strongLevel do
                        strongLevel[k] = tonumber(strongLevel[k])
                    end

                    self.dataHomework[data[i][1]]["strongLevel"] = strongLevel
                end

                self.dataHomework[data[i][1]]["trend"] = data[i][5]
                self.dataHomework[data[i][1]]["comment"] = data[i][6]

                -- формируем другой массив - dataFullHomework
                self.dataFullHomework[#self.dataFullHomework + 1] = data[i][1]
            end
        end
    end,

    -- разбор данных из разрешённых инструментов для шорта
    parseAllowedToShort = function(self)
        local allowedToShortPath = self.container:get("config").dataPath.stockAllowedToShort
        local data = self:getData(allowedToShortPath)

        -- добавляем весь массив
        for i = 2, #data do
            self.dataAllowedShort[data[i][1]] = true
        end
    end,

    -- добавляет в хранилище базу данных для расчёта уровней
    addDbLevels = function(self)
        --подключаем базу данных с параметрами
        local levelsNameFile = self.container:get("config").dbPath.dbLevels

        local dbPath = Autoload:getPathFile(levelsNameFile)

        self.dbLevels = dofile(dbPath):new()
    end,

    -- вернуть сильные уровни
    getStrongLevel = function(self, idStock)
        if isset(self.dataHomework[idStock]["strongLevel"]) then
            return self.dataHomework[idStock]["strongLevel"]
        end

        return 0
    end,

    -- проверить есть ли сильные уровни
    hasStrongLevel = function(self, idStock)
        if isset(self.dataHomework[idStock]["strongLevel"]) then
            return true
        end

        return false
    end,

    -- вернуть класс бумаги по id
    getClassToId = function(self, id)
        if not_isset(self.dataClassAccount[id]) then
            error("\r\n" .. "Error: Из (Storage) в ( getClassToId() ) запрошен не существующий тикер (" .. tostring(id) .. ")", 2)
        end

        return self.dataClassAccount[id]["class"]
    end,

    -- вернуть счёт бумаги по id
    getAccountToId = function(self, id)
        if not_isset(self.dataClassAccount[id]) then
            error("\r\n" .. "Error: Из (Storage) в ( getAccountToId() ) запрошен не существующий тикер (" .. id .. ")", 2)
        end

        return self.dataClassAccount[id]["account"]
    end,

    -- вернуть код клиента
    getClientCodeToId = function(self, id)
        if not_isset(self.dataClassAccount[id]) then
            error("\r\n" .. "Error: Из (Storage) в ( getClientCodeToId() ) запрошен не существующий тикер (" .. id .. ")", 2)
        end

        return self.dataClassAccount[id]["client_code"]
    end,

    -- вернуть интервал бумаги по id
    getIntervalToId = function(self, id)
        if not_isset(self.dataHomework[id]) then
            error("\r\n" .. "Error: Из (Storage) в ( getIntervalToId() ) запрошен не существующий тикер (" .. id .. ")", 2)
        end

        local class = self:getClassToId(id)
        local interval = self.dbLevels:getInterval(id, class)

        return interval
    end,

    -- вернуть название бумаги по её id (тикеру)
    getNameToId = function(self, id)
        if not_isset(self.dataHomework[id]) then
            error("\r\n" .. "Error: Из (Storage) в ( getNameToId() ) запрошен не существующий тикер (" .. id .. ")", 2)
        end

        return self.dataHomework[id]["name"]
    end,

    -- возвращает результат проверки существования id, class
    levelsExist = function(self, id, class)
        return self.dbLevels:exist(id, class)
    end,

    -- вернуть уровни
    getLevels = function(self, id, class, lastPrice, countInterval)
        return self.dbLevels:getParamsLevel(id, class, lastPrice, countInterval)
    end,

    -- вернуть комментарий
    getCommentToId = function(self, id)
        if not_isset(self.dataHomework[id]) then
            error("\r\n" .. "Error: Из (Storage) в ( getCommentToId() ) запрошен не существующий тикер (" .. id .. ")", 2)
        end

        return self.dataHomework[id]["comment"]
    end,

    -- вернуть комментарий
    getTrendToId = function(self, id)
        if not_isset(self.dataHomework[id]) then
            error("\r\n" .. "Error: Из (Storage) в ( getTrendToId() ) запрошен не существующий тикер (" .. id .. ")", 2)
        end

        return self.dataHomework[id]["trend"]
    end,

    -- вернуть разрешение бумаги к шорту по id
    getAllowedShortToId = function(self, id)
        if not_isset(self.dataClassAccount[id]) then
            error("\r\n" .. "Error: Из (Storage) в ( getAllowedShortToId() ) запрошен не существующий тикер (" .. tostring(id) .. ")", 2)
        end

        if isset(self.dataAllowedShort[id]) then
            return true
        end

        return false
    end,

    -- вернуть все тикеры домашки в том порядке - в котором в домашке
    getHomeworkId = function(self)
        return copy(self.dataFullHomework)
    end,

    -- вернуть id графика по id бумаги
    getIdChart = function(self, id)
        if not_isset(self.dataIdCharts[id]) then
            error("\r\n" .. "Error: Из (Storage) в ( getIdChart() ) запрошен не существующий тикер (" .. tostring(id) .. ")", 2)
        end

        return self.dataIdCharts[id]
    end,
}

return Storage
