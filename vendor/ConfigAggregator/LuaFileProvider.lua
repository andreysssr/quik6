-- сбор всех файлов конфигураций в указанной директории

local LuaFileProvider = {

    --
    name = "ConfigAggregator_LuaFileProvider",

    --
    new = function(self)
        return self
    end,

    -- возвращает файлы
    get = function(self, dirPath)
        return Dir:getListFiles(dirPath)
    end,
}

return LuaFileProvider
