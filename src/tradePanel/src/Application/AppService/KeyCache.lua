--- возращает ключ кеша - чтобы не придумывать ключи - они записаны в конфике

local KeyCache = {

    --
    name = "AppService_KeyCache",

    --
    config = {},

    new = function(self, container)
        self.config = container:get("config").namesCache

        return self
    end,

    getKey = function(self, id, namesCache)
        if not_string(id) then
            error("Error: id для кеша должен быть строкой. Получено: (" .. getType(namesCache) .. ") -  (" .. tostring(namesCache) .. ")", 2)
        end

        if not_string(namesCache) then
            error("Error: Ключ для кеша должен быть строкой. Получено: (" .. getType(namesCache) .. ") -  (" .. tostring(namesCache) .. ")", 2)
        end

        if not_key_exists(self.config, namesCache) then
            error("Error: В (config) в именах для кешей (namesCache) отсутствует ключ: (" .. namesCache .. ")", 2)
        end

        return id .. "_" .. self.config[namesCache]
    end,
}

return KeyCache
