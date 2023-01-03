--- Cache

local Cache = {
    --
    name = "Cache",

    --
    container = {},

    -- ������� ���� ��� ����
    dirPath = "",

    --  ���������� ������ ��� ����
    ext = "",

    --
    new = function(self, container)
        self.container = container
        self:init()
        self:checkDirPath()

        return self
    end,

    -- ��������� ���� ��� ������ ����
    init = function(self, dirName)
        -- �������� ���� ��� ������������ ���
        --local dir = os.date("%d.%m.%Y")
        local dir = "params"

        if not_nil(dirName) then
            dir = dirName
        end

        local config = self.container:get("config").dirPath.cacheParams

        if is_nil(config) then
            error("\r\n\r\n" .. "Error: ��� Cache � (config) ��� �������� (dirPath.cacheParams)")
        end

        local dirCacheGeneral = Autoload:getPathDir(config.dir)

        self.dirPath = dirCacheGeneral .. "\\" .. dir
        self.ext = config.ext
    end,

    -- ���� ���������� ��� ������������ ���� ��� - ����� ������ �
    checkDirPath = function(self)
        if not Dir:exists(self.dirPath) then
            Dir:create(self.dirPath)
        end
    end,

    getKey = function(self, key)
        return self.dirPath .. "\\" .. key .. "." .. self.ext
    end,

    -- ���������� ���� ����
    getFile = function(self, key)
        local fileName = self:getKey(key)

        if File:exists(fileName) then
            return File:get(fileName)
        end

        return nil
    end,

    -- ������� �������� �� �����
    -- ���� ���� ���� - ���������� ������, ����� ����� nil
    get = function(self, key)
        local fileName = self:getKey(key)

        if File:exists(fileName) then
            return File:readContent(fileName)
        end

        return nil
    end,

    -- ������� �������� �� �����
    -- ���� ���� ���� - ���������� ������, ����� ����� nil
    getAll = function(self, keyArray)
        local result = {}

        for i, v in ipairs() do
            result[v] = self:get(keyArray[i])
        end
    end,

    -- ���������� �������� ��� �����
    set = function(self, key, value)
        local fileName = self:getKey(key)

        if not File:exists(fileName) then
            File:create(fileName)
        end

        File:writeUpdate(fileName, value)
    end,

    -- ������� ����
    delete = function(self, key)
        local fileName = self:getKey(key)

        if File:exists(fileName) then
            File:remove(fileName)
        end
    end,

    -- ������� ��� �����
    deleteAll = function(self, keyArray)
        for i = 1, #keyArray do
            self:delete(keyArray[i])
        end
    end,

    -- �������� ���
    clear = function(self)
        local listAllKey = Dir:getListFiles(self.dirPath)

        for i = 1, #listAllKey do
            File:remove(listAllKey[i])
        end
    end,

    -- ��������� ������������� �����
    has = function(self, key)
        local fileName = self:getKey(key)

        if File:exists(fileName) then
            return true
        end

        return false
    end,
}

return Cache
