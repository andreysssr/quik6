--- EntityService Ds5M - описание

local EntityService = {
    --
    name = "EntityService_Ds5M",

    --
    repository = {},

    --
    dispatcher = {},

    --
    new = function(self, container)
        self.repository = container:get("Repository_Ds5M")
        self.dispatcher = container:get("EventDispatcher")

        return self
    end,

    -- удаляет источник данных, отписывается от получения данных
    removeDs = function(self, idStock)
        local entity = self.repository:get(idStock)

        entity:removeDs()
    end,

    -- проверяет - обновился ли бар
    -- если бар обновился - создаётся событие
    checkNewBar = function(self, idStock)
        local entity = self.repository:get(idStock)

        entity:checkNewBar()

        -- получаем события из Entity и передаём их в диспетчер событий
        self.dispatcher:dispatchEvents(entity:releaseEvents())
    end,

    -- вернуть Atr последнего бара
    -- (текущий Hi) - (текущий Low)
    getAtrBarCurrent = function(self, idStock)
        local entity = self.repository:get(idStock)

        return entity:getAtrBarCurrent()
    end,

    -- вернуть Atr предыдущего бара
    -- (предыдущий Hi) - (предыдущий low)
    getAtrBarPrev = function(self, idStock)
        local entity = self.repository:get(idStock)

        return entity:getAtrBarPrev()
    end,

    -- вернуть hi low последних 3 баров
    getHiLow = function(self, idStock)
        local entity = self.repository:get(idStock)

        return entity:getHiLow()
    end,

    -- вернуть объём последних 3 баров
    getVolume = function(self, idStock)
        local entity = self.repository:get(idStock)

        return entity:getVolume()
    end,
}

return EntityService
