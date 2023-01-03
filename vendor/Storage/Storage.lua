---

local Storage = {
    --
    name = "Storage",

    container = {},

    -- ������ � ������, �������� �����
    dataClassAccount = {},

    -- ������ �� �������
    dataHomework = {},

    -- �������� ��� id ������� �� ������� (��������� ������ �� 1 - �� �����)
    dataFullHomework = {},

    -- ������ ������
    dataAllowedShort = {},

    -- id �������� �� id ������
    dataIdCharts = {},

    --
    dbLevels = {},

    --
    new = function(self, container)
        self.container = container
        self:init()

        return self
    end,

    -- ���������� ������ ������ �� �����
    getData = function(self, dataPath)
        if is_nil(dataPath) then
            error("\n" .. "Error: � Storage:getData(dataPath) ������� �������� dataPath = nil", 2)
        end

        local name = Autoload:getPathFile(dataPath)
        local result = File:readCsv(name)

        return result
    end,

    init = function(self)
        -- ������ ������ �� classAccount
        self:parseClassAccount()

        -- ������ ������ �� �������
        self:parseHomework()

        -- ������ ������ �� ����������� ������������ ��� �����
        self:parseAllowedToShort()

        -- ������ ������ id �������� ��� �����
        self:parseIdCharts()

        -- �������� � ��������� ���� ������ �������
        self:addDbLevels()
    end,

    -- ������ ������ id �������� ��� �����
    parseIdCharts = function(self)
        local idChart = self.container:get("config").dataPath.idChart
        local data = self:getData(idChart)

        for i = 2, #data do
            if data[i][1] ~= "" then
                self.dataIdCharts[data[i][1]] = data[i][3]
            end
        end
    end,

    -- ������ ������ classAccount
    parseClassAccount = function(self)
        -- ��������� account ������ ��� �����������
        local val = {
            stock = self.container:get("Config_stock"),
            futures = self.container:get("Config_futures"),
            currency = self.container:get("Config_currency"),
        }

        -- ������ ������� � ��������� �� �������
        local classAccountPath = self.container:get("config").dataPath.stockClassAccount
        local data = self:getData(classAccountPath)

        for i = 2, #data do
            if data[i][1] ~= "" then
                -- ���� � self.data ��� ������� � �������� ������ - ����� ������
                if not_isset(self.dataClassAccount[data[i][1]]) then
                    self.dataClassAccount[data[i][1]] = {}
                end

                -- �������� - (��������)
                self.dataClassAccount[data[i][1]]["name"] = data[i][2]

                -- class ������
                self.dataClassAccount[data[i][1]]["class"] = data[i][3]

                -- account - ���� ���� ��� ������ (��� �����, ���������, ������)
                self.dataClassAccount[data[i][1]]["account"] = val[data[i][4]].account

                -- ��� ������� - ��� ������ (��� �����, ���������, ������)
                self.dataClassAccount[data[i][1]]["client_code"] = val[data[i][4]].client_code
            end
        end
    end,

    -- ������ ������ �� �������
    parseHomework = function(self)
        local homeworkPath = self.container:get("config").dataPath.homework
        local data = self:getData(homeworkPath)

        for i = 2, #data do
            if data[i][1] ~= "" then
                -- ���� � self.data ��� ������� � �������� ������ - ����� ������
                if not_isset(self.dataHomework[data[i][1]]) then
                    self.dataHomework[data[i][1]] = {}
                end

                -- �������� ������
                self.dataHomework[data[i][1]]["name"] = data[i][2]

                -- ��������
                if data[i][3] == "" then
                    error("\r\n" .. "Error: � ����� (homework.csv) ��� ����������� (" .. data[i][1] .. ") ���������� (��������)")
                else
                    self.dataHomework[data[i][1]]["interval"] = tonumber(data[i][3])
                end

                -- ���� ���� �� �����
                if data[i][4] ~= "" then
                    -- ������� �������
                    local strongLevel = explode("|", data[i][4])
                    for k = 1, #strongLevel do
                        strongLevel[k] = tonumber(strongLevel[k])
                    end

                    self.dataHomework[data[i][1]]["strongLevel"] = strongLevel
                end

                self.dataHomework[data[i][1]]["trend"] = data[i][5]
                self.dataHomework[data[i][1]]["comment"] = data[i][6]

                -- ��������� ������ ������ - dataFullHomework
                self.dataFullHomework[#self.dataFullHomework + 1] = data[i][1]
            end
        end
    end,

    -- ������ ������ �� ����������� ������������ ��� �����
    parseAllowedToShort = function(self)
        local allowedToShortPath = self.container:get("config").dataPath.stockAllowedToShort
        local data = self:getData(allowedToShortPath)

        -- ��������� ���� ������
        for i = 2, #data do
            self.dataAllowedShort[data[i][1]] = true
        end
    end,

    -- ��������� � ��������� ���� ������ ��� ������� �������
    addDbLevels = function(self)
        --���������� ���� ������ � �����������
        local levelsNameFile = self.container:get("config").dbPath.dbLevels

        local dbPath = Autoload:getPathFile(levelsNameFile)

        self.dbLevels = dofile(dbPath):new()
    end,

    -- ������� ������� ������
    getStrongLevel = function(self, idStock)
        if isset(self.dataHomework[idStock]["strongLevel"]) then
            return self.dataHomework[idStock]["strongLevel"]
        end

        return 0
    end,

    -- ��������� ���� �� ������� ������
    hasStrongLevel = function(self, idStock)
        if isset(self.dataHomework[idStock]["strongLevel"]) then
            return true
        end

        return false
    end,

    -- ������� ����� ������ �� id
    getClassToId = function(self, id)
        if not_isset(self.dataClassAccount[id]) then
            error("\r\n" .. "Error: �� (Storage) � ( getClassToId() ) �������� �� ������������ ����� (" .. tostring(id) .. ")", 2)
        end

        return self.dataClassAccount[id]["class"]
    end,

    -- ������� ���� ������ �� id
    getAccountToId = function(self, id)
        if not_isset(self.dataClassAccount[id]) then
            error("\r\n" .. "Error: �� (Storage) � ( getAccountToId() ) �������� �� ������������ ����� (" .. id .. ")", 2)
        end

        return self.dataClassAccount[id]["account"]
    end,

    -- ������� ��� �������
    getClientCodeToId = function(self, id)
        if not_isset(self.dataClassAccount[id]) then
            error("\r\n" .. "Error: �� (Storage) � ( getClientCodeToId() ) �������� �� ������������ ����� (" .. id .. ")", 2)
        end

        return self.dataClassAccount[id]["client_code"]
    end,

    -- ������� �������� ������ �� id
    getIntervalToId = function(self, id)
        if not_isset(self.dataHomework[id]) then
            error("\r\n" .. "Error: �� (Storage) � ( getIntervalToId() ) �������� �� ������������ ����� (" .. id .. ")", 2)
        end

        local class = self:getClassToId(id)
        local interval = self.dbLevels:getInterval(id, class)

        return interval
    end,

    -- ������� �������� ������ �� � id (������)
    getNameToId = function(self, id)
        if not_isset(self.dataHomework[id]) then
            error("\r\n" .. "Error: �� (Storage) � ( getNameToId() ) �������� �� ������������ ����� (" .. id .. ")", 2)
        end

        return self.dataHomework[id]["name"]
    end,

    -- ���������� ��������� �������� ������������� id, class
    levelsExist = function(self, id, class)
        return self.dbLevels:exist(id, class)
    end,

    -- ������� ������
    getLevels = function(self, id, class, lastPrice, countInterval)
        return self.dbLevels:getParamsLevel(id, class, lastPrice, countInterval)
    end,

    -- ������� �����������
    getCommentToId = function(self, id)
        if not_isset(self.dataHomework[id]) then
            error("\r\n" .. "Error: �� (Storage) � ( getCommentToId() ) �������� �� ������������ ����� (" .. id .. ")", 2)
        end

        return self.dataHomework[id]["comment"]
    end,

    -- ������� �����������
    getTrendToId = function(self, id)
        if not_isset(self.dataHomework[id]) then
            error("\r\n" .. "Error: �� (Storage) � ( getTrendToId() ) �������� �� ������������ ����� (" .. id .. ")", 2)
        end

        return self.dataHomework[id]["trend"]
    end,

    -- ������� ���������� ������ � ����� �� id
    getAllowedShortToId = function(self, id)
        if not_isset(self.dataClassAccount[id]) then
            error("\r\n" .. "Error: �� (Storage) � ( getAllowedShortToId() ) �������� �� ������������ ����� (" .. tostring(id) .. ")", 2)
        end

        if isset(self.dataAllowedShort[id]) then
            return true
        end

        return false
    end,

    -- ������� ��� ������ ������� � ��� ������� - � ������� � �������
    getHomeworkId = function(self)
        return copy(self.dataFullHomework)
    end,

    -- ������� id ������� �� id ������
    getIdChart = function(self, id)
        if not_isset(self.dataIdCharts[id]) then
            error("\r\n" .. "Error: �� (Storage) � ( getIdChart() ) �������� �� ������������ ����� (" .. tostring(id) .. ")", 2)
        end

        return self.dataIdCharts[id]
    end,
}

return Storage
