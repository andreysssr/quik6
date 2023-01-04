--- Factory CreateEntityTradeParams

local Factory = {
    --
    name = "Factory_CreateEntityTradeParams",

    --
    container = {},

    --
    storage = {},

    --
    quik = {},

    --
    repositoryTradeParams = {},

    --
    entityServiceStock = {},

    --
    entityServiceParams = {},

    --
    cache = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")
        self.quik = container:get("Quik")
        self.repositoryTradeParams = container:get("Repository_TradeParams")
        self.entityServiceStock = container:get("EntityService_Stock")
        self.entityServiceParams = container:get("EntityService_TradeParams")
        self.cache = container:get("Cache") -- написать, папка хранилища постоянная

        return self
    end,

    -- создание Entity_TradeParams и сохранение его в репозиторий
    createEntity = function(self, idStock)
        local id = idStock
        local class = self.storage:getClassToId(id)

        local params = {}
        params.idStock = id
        params.class = class

        -- получаем класс Entity TradeParams
        local classEntityTradeParams = self.container:get("Entity_TradeParams")

        -- получаем entity
        local entity = classEntityTradeParams:newChild(params)

        -- сохраняем созданный entity TradeParams
        self.repositoryTradeParams:save(entity)

        -- восстановить данные если есть открытые позиции по бумаге
        if self.entityServiceStock:hasPosition(idStock) then
            if self.cache:has(idStock .. "_params") then
                local cacheParams = self.cache:getFile(idStock .. "_params")
                self.entityServiceParams:recoveryParams(idStock, cacheParams)
            end
        end
    end,

}

return Factory
