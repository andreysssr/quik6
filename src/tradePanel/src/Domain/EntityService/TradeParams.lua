--- EntityService TradeParams

local EntityService = {
    --
    name = "EntityService_TradeParams",

    --
    repository = {},

    --
    dispatcher = {},

    --
    new = function(self, container)
        self.repository = container:get("Repository_TradeParams")
        self.dispatcher = container:get("EventDispatcher")

        return self
    end,

    -- восстановить данные из кеша в entity под номером 1
    recoveryParams = function(self, idStock, params)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(idStock)

        entity:recoveryParams(params)
    end,

    -- рассчитать данные по базовой цене
    calculateParams = function(self, idStock, operation, range)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(idStock)

        entity:calculateParams(operation, range)

        -- получаем события из Entity и передаём их в диспетчер событий
        self.dispatcher:dispatchEvents(entity:releaseEvents())
    end,

    -- рассчитать данные по переданной цене
    calculateParamsToPrice = function(self, idStock, operation, price)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(idStock)

        entity:calculateParamsToPrice(operation, price)

        -- получаем события из Entity и передаём их в диспетчер событий
        self.dispatcher:dispatchEvents(entity:releaseEvents())
    end,

    -- вернуть параметры для id
    getParams = function(self, idStock, idParams)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(idStock)

        return entity:getParams(idParams)
    end,

    -- вернуть параметры под id
    getParamsZapros = function(self, idStock, idParams)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(idStock)

        return entity:getParamsZapros(idParams)
    end,

    -- вернуть параметры под id
    getParamsStop = function(self, idStock, idParams)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(idStock)

        return entity:getParamsStop(idParams)
    end,

    -- вернуть параметры под id
    getParamsStopMove = function(self, idStock, idParams)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(idStock)

        return entity:getParamsStopMove(idParams)
    end,

    -- вернуть параметры take для id
    getParamsTake = function(self, idStock, idParams)
        -- получаем из репозитория нужный Entity
        local entity = self.repository:get(idStock)

        return entity:getParamsTake(idParams)
    end,
}

return EntityService
