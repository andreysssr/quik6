--- EntityService BasePrice

local EntityService = {
    --
    name = "EntityService_BasePrice",

    --
    repository = {},

    --
    dispatcher = {},

    --
    idTickers = {},

    --
    new = function(self, container)
        self.repository = container:get("Repository_BasePrice")
        self.dispatcher = container:get("EventDispatcher")
        self.idTickers = container:get("Storage"):getHomeworkId()

        return self
    end,

    -- проверка уровней
    checkLevel = function(self, id)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(id)

        -- вызываем проверку
        entity:checkLevel()

        -- получаем события из Entity и передаём их в диспетчер событий
        self.dispatcher:dispatchEvents(entity:releaseEvents())
    end,

    -- вызываем проверку уровней
    checkLevels = function(self)
        for i = 1, #self.idTickers do
            self:checkLevel(self.idTickers[i])
        end
    end,

    -- вернуть построенную структуру
    getData = function(self, id)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(id)

        return entity:getData()
    end,

    -- вернуть базовую цену
    getPrice = function(self, id)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(id)

        return entity:getPrice()
    end,

    -- возвращает массив текущих данных basePrice
    getBasePrice = function(self, id)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(id)

        return entity:getBasePrice()
    end,

}

return EntityService
