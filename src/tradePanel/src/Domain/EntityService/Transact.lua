--- EntityService Transact

local EntityService = {
    --
    name = "EntityService_Transact",

    --
    repository = {},

    --
    entityClass = {},

    --
    dispatcher = {},

    --
    new = function(self, container)
        self.repository = container:get("Repository_Transact")
        self.entityClass = container:get("Entity_Transact")
        self.dispatcher = container:get("EventDispatcher")

        return self
    end,

    -- создать entity
    create = function(self, idTransact, params)
        local entity = self.entityClass:newChild(params)

        self.repository:save(entity, idTransact)
    end,

    -- проверка существования транзакции с номером
    -- номером может быть (idTransact) или (order_num)
    has = function(self, id)
        return self.repository:has(id)
    end,

    -- вернуть транзакцию
    getParams = function(self, id)
        return self.repository:get(id)
    end,

    -- изменить состояние транзакции
    changeStatus = function(self, order_num, params)

        if self.repository:has(order_num) then
            local entity = self.repository:get(order_num)

            entity:changeStatus(params)

            -- получаем события из Entity и передаём их в диспетчер событий
            self.dispatcher:dispatchEvents(entity:releaseEvents())

            return
        end

        error("\r\n" .. "Error: EntityTransact с таким order_num - (" .. order_num .. ") не существует", 2)
    end,
}

return EntityService
