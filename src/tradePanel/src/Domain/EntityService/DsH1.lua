--- EntityService DsH1 - описание

local EntityService = {
    --
    name = "EntityService_DsH1",

    --
    repository = {},

    --
    dispatcher = {},

    --
    new = function(self, container)
        self.repository = container:get("Repository_DsH1")
        self.dispatcher = container:get("EventDispatcher")

        return self
    end,

    -- удаляет источник данных, отписывается от получения данных
    removeDs = function(self, idStock)
        local entity = self.repository:get(idStock)

        entity:removeDs()
    end,

    -- вернуть hi, low, одного часа - 10 часов
    getHiLowBarHour10 = function(self, idStock)
        local entity = self.repository:get(idStock)

        return entity:getHiLowBarHour10()
    end,

    -- вернуть hi, low, двух часов - 9 и 10
    getHiLowBarHour9 = function(self, idStock)
        local entity = self.repository:get(idStock)

        return entity:getHiLowBarHour9()
    end,
}

return EntityService
