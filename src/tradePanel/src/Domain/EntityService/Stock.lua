--- EntityService Stock

local EntityService = {
    --
    name = "EntityService_Stock",

    --
    repository = {},

    --
    dispatcher = {},

    --
    new = function(self, container)
        self.repository = container:get("Repository_Stock")
        self.dispatcher = container:get("EventDispatcher")

        return self
    end,

    -- проверка наличия открытых позиции
    hasPosition = function(self, id)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(id)

        --
        return entity:hasPosition()
    end,

    -- вернуть статус активности бумаги
    getStatus = function(self, id)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(id)

        if is_nil(entity) then
            error("\n" .. "Error: Отсутствует EntityStock для тикера (" .. tostring(id) .. ")", 2)
        end

        return entity:getStatus()
    end,

    -- вернуть доступное количество лотов
    getLots = function(self, id)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(id)

        return entity:getLots()
    end,

    -- вернуть максимальное количество лотов
    getMaxLots = function(self, id)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(id)

        return entity:getMaxLots()
    end,

    -- вернуть параметры поизиции
    getPositionParams = function(self, id)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(id)

        return entity:getPositionParams()
    end,

    -- вернуть количество поизиции
    getPositionQty = function(self, id)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(id)

        return entity:getPositionQty()
    end,

    -- вернуть параметры запроса
    getZaprosParams = function(self, id)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(id)

        return entity:getZaprosParams()
    end,

    -- вернуть запрос (если он есть)
    getZapros = function(self, id)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(id)

        return entity:getZapros()
    end,

    -- stop
    getStop = function(self, id)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(id)

        return entity:getStop()
    end,

    -- вернуть параметры стопа
    getStopParams = function(self, id)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(id)

        return entity:getStopParams()
    end,

    -- вернуть параметры стопа для переноса в безубыток
    getStopMoveParams = function(self, id)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(id)

        return entity:getStopMoveParams()
    end,

    -- возвращает добавленный idParams последнего добавленного стопа
    -- для резервного восстановления стопа при случайном удалении
    getRecoveryIdParams = function(self, idStock)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(idStock)

        return entity:getRecoveryIdParams()
    end,

    -- take
    -- вернуть параметры тейка
    getTakeParams = function(self, id)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(id)

        return entity:getTakeParams()
    end,

    -- смена размера тейка, влючение и отключение
    changeTake = function(self, id, selectSize)
        local entity = self.repository:get(id)

        -- вызываем проверку
        entity:changeTake(selectSize)

        -- получаем события из Entity и передаём их в диспетчер событий
        self.dispatcher:dispatchEvents(entity:releaseEvents())
    end,

    -- активен ли тейк
    isActiveTake = function(self, id)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(id)

        return entity:isActiveTake()
    end,

    -- вернуть выбранный параметр тейка
    getTakeSize = function(self, idStock)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(idStock)

        return entity:getTakeSize()
    end,

    -- обновить параметры по значениям исходя из basePrice
    updateParams = function(self, id, operation, range)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(id)

        -- вызываем проверку
        entity:updateParams(operation, range)

        -- получаем события из Entity и передаём их в диспетчер событий
        self.dispatcher:dispatchEvents(entity:releaseEvents())
    end,

    -- обновить параметры по значениям
    updateParamsTo = function(self, id, operation, range, price)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(id)

        -- вызываем проверку
        entity:updateParamsTo(operation, range, price)

        -- получаем события из Entity и передаём их в диспетчер событий
        self.dispatcher:dispatchEvents(entity:releaseEvents())
    end,

    -- рассчитать максимальное количество лотов
    calculateMaxLots = function(self, id)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(id)

        -- вызываем проверку
        entity:calculateMaxLots()

        -- получаем события из Entity и передаём их в диспетчер событий
        self.dispatcher:dispatchEvents(entity:releaseEvents())
    end,

    -- изменить позиции
    changePosition = function(self, id, trade)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(id)

        -- вызываем проверку
        entity:changePosition(trade)

        -- получаем события из Entity и передаём их в диспетчер событий
        self.dispatcher:dispatchEvents(entity:releaseEvents())
    end,

    -- изменить состояние
    changeCondition = function(self, id, params)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(id)

        -- вызываем проверку
        entity:changeCondition(params)

        -- получаем события из Entity и передаём их в диспетчер событий
        self.dispatcher:dispatchEvents(entity:releaseEvents())
    end,

    -- по параметрам пытаемся определить роль
    getRole = function(self, id, params)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(id)

        return entity:getRole(params)
    end,
}

return EntityService
