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

    -- ������� entity
    create = function(self, idTransact, params)
        local entity = self.entityClass:newChild(params)

        self.repository:save(entity, idTransact)
    end,

    -- �������� ������������� ���������� � �������
    -- ������� ����� ���� (idTransact) ��� (order_num)
    has = function(self, id)
        return self.repository:has(id)
    end,

    -- ������� ����������
    getParams = function(self, id)
        return self.repository:get(id)
    end,

    -- �������� ��������� ����������
    changeStatus = function(self, order_num, params)

        if self.repository:has(order_num) then
            local entity = self.repository:get(order_num)

            entity:changeStatus(params)

            -- �������� ������� �� Entity � ������� �� � ��������� �������
            self.dispatcher:dispatchEvents(entity:releaseEvents())

            return
        end

        error("\r\n" .. "Error: EntityTransact � ����� order_num - (" .. order_num .. ") �� ����������", 2)
    end,
}

return EntityService
