--- Cache

local Cache = {
    --
    name = "Cache",

    --
    container = {},

    -- базовый путь дл€ кеша
    dirPath = "",

    --  расширение файлов дл€ кеша
    ext = "",

    --
    new = function(self, container)
        self.container = container
        self:init()
        self:checkDirPath()

        return self
    end,

    -- получение пути дл€ общего кеша
    init = function(self, dirName)
        -- название кеша дл€ сегодн€шнего дн€
        --local dir = os.date("%d.%m.%Y")
        local dir = "params"

        if not_nil(dirName) then
            dir = dirName
        end

        local config = self.container:get("config").dirPath.cacheParams

        if is_nil(config) then
            error("\r\n\r\n" .. "Error: ƒл€ Cache в (config) нет настроек (dirPath.cacheParams)")
        end

        local dirCacheGeneral = Autoload:getPathDir(config.dir)

        self.dirPath = dirCacheGeneral .. "\\" .. dir
        self.ext = config.ext
    end,

    -- если директории дл€ сегодн€шнего кеша нет - тогда создаЄм еЄ
    checkDirPath = function(self)
        if not Dir:exists(self.dirPath) then
            Dir:create(self.dirPath)
        end
    end,

    getKey = function(self, key)
        return self.dirPath .. "\\" .. key .. "." .. self.ext
    end,

    -- подключить файл кеша
    getFile = function(self, key)
        local fileName = self:getKey(key)

        if File:exists(fileName) then
            return File:get(fileName)
        end

        return nil
    end,

    -- вернуть значение по ключу
    -- если есть ключ - возвращает данные, иначе вернЄт nil
    get = function(self, key)
        local fileName = self:getKey(key)

        if File:exists(fileName) then
            return File:readContent(fileName)
        end

        return nil
    end,

    -- вернуть значени€ по ключу
    -- если есть ключ - возвращает данные, иначе вернЄт nil
    getAll = function(self, keyArray)
        local result = {}

        for i, v in ipairs() do
            result[v] = self:get(keyArray[i])
        end
    end,

    -- установить значение дл€ ключа
    set = function(self, key, value)
        local fileName = self:getKey(key)

        if not File:exists(fileName) then
            File:create(fileName)
        end

        File:writeUpdate(fileName, value)
    end,

    -- удалить ключ
    delete = function(self, key)
        local fileName = self:getKey(key)

        if File:exists(fileName) then
            File:remove(fileName)
        end
    end,

    -- удалить все ключи
    deleteAll = function(self, keyArray)
        for i = 1, #keyArray do
            self:delete(keyArray[i])
        end
    end,

    -- очистить кэш
    clear = function(self)
        local listAllKey = Dir:getListFiles(self.dirPath)

        for i = 1, #listAllKey do
            File:remove(listAllKey[i])
        end
    end,

    -- проверить существование ключа
    has = function(self, key)
        local fileName = self:getKey(key)

        if File:exists(fileName) then
            return true
        end

        return false
    end,
}

return Cache
