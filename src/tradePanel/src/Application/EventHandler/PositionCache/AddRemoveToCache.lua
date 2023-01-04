--- EventHandler AddRemoveToCache - описание

local EventHandler = {
    --
    name = "EventHandler_PositionCache_AddRemoveToCache",

    --
    container = {},

    --
    storage = {},

    --
    cache = {},

    --
    entityServiceParams = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")
        self.cache = container:get("Cache")
        self.entityServiceParams = container:get("EntityService_TradeParams")

        return self
    end,

    -- добавить кеш
    addCache = function(self, event)
        local idStock = event:getParam("idStock")
        --local idParams = event:getParam("idParams")

        local params = self.entityServiceParams:getParams(idStock)

        -- конвертируем таблицу в строку
        local strParams = serializeTable(params)

        local key = idStock .. "_params"

        self.cache:set(key, strParams)
    end,

    -- удалить кеш
    removeCache = function(self, event)
        local idStock = event:getParam("idStock")
        local key = idStock .. "_params"

        self.cache:delete(key)
    end,

}

return EventHandler
