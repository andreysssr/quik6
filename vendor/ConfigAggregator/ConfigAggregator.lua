--- Агрегатор конфигураций

local ConfigAggregator = {
    --
    name = "ConfigAggregator",

    -- список всех загруженных файлов
    files = {},

    -- общая склеенная конфигурация
    config = {},

    -- добавляет файлы по одному в список
    addFiles = function(self, ...)
        local arg = { ... }

        for i, value in ipairs(arg) do
            self.files[#self.files + 1] = value
        end
    end,

    --
    new = function(self, arrayFiles)
        -- распаковывает каждый массив и возвращает по 1 элементу (unpack)
        for i = 1, #arrayFiles do
            self:addFiles(unpack(arrayFiles[i]))
        end

        -- получает содержимое конфигов и мержит их между собой
        self.config = self:loadConfigFromProviders(self.files)

        return self
    end,

    -- возвращает конфиг
    getMergedConfig = function(self)
        return self.config
    end,

    --
    loadConfigFromProviders = function(self, providers)
        local config = {}

        for i = 1, #providers do
            config = array_merge(config, dofile(providers[i]))
        end

        return config
    end,
}

return ConfigAggregator
