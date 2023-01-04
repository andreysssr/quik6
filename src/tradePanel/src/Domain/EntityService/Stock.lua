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

    -- �������� ������� �������� �������
    hasPosition = function(self, id)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(id)

        --
        return entity:hasPosition()
    end,

    -- ������� ������ ���������� ������
    getStatus = function(self, id)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(id)

        if is_nil(entity) then
            error("\n" .. "Error: ����������� EntityStock ��� ������ (" .. tostring(id) .. ")", 2)
        end

        return entity:getStatus()
    end,

    -- ������� ��������� ���������� �����
    getLots = function(self, id)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(id)

        return entity:getLots()
    end,

    -- ������� ������������ ���������� �����
    getMaxLots = function(self, id)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(id)

        return entity:getMaxLots()
    end,

    -- ������� ��������� ��������
    getPositionParams = function(self, id)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(id)

        return entity:getPositionParams()
    end,

    -- ������� ���������� ��������
    getPositionQty = function(self, id)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(id)

        return entity:getPositionQty()
    end,

    -- ������� ��������� �������
    getZaprosParams = function(self, id)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(id)

        return entity:getZaprosParams()
    end,

    -- ������� ������ (���� �� ����)
    getZapros = function(self, id)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(id)

        return entity:getZapros()
    end,

    -- stop
    getStop = function(self, id)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(id)

        return entity:getStop()
    end,

    -- ������� ��������� �����
    getStopParams = function(self, id)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(id)

        return entity:getStopParams()
    end,

    -- ������� ��������� ����� ��� �������� � ���������
    getStopMoveParams = function(self, id)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(id)

        return entity:getStopMoveParams()
    end,

    -- ���������� ����������� idParams ���������� ������������ �����
    -- ��� ���������� �������������� ����� ��� ��������� ��������
    getRecoveryIdParams = function(self, idStock)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(idStock)

        return entity:getRecoveryIdParams()
    end,

    -- take
    -- ������� ��������� �����
    getTakeParams = function(self, id)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(id)

        return entity:getTakeParams()
    end,

    -- ����� ������� �����, �������� � ����������
    changeTake = function(self, id, selectSize)
        local entity = self.repository:get(id)

        -- �������� ��������
        entity:changeTake(selectSize)

        -- �������� ������� �� Entity � ������� �� � ��������� �������
        self.dispatcher:dispatchEvents(entity:releaseEvents())
    end,

    -- ������� �� ����
    isActiveTake = function(self, id)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(id)

        return entity:isActiveTake()
    end,

    -- ������� ��������� �������� �����
    getTakeSize = function(self, idStock)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(idStock)

        return entity:getTakeSize()
    end,

    -- �������� ��������� �� ��������� ������ �� basePrice
    updateParams = function(self, id, operation, range)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(id)

        -- �������� ��������
        entity:updateParams(operation, range)

        -- �������� ������� �� Entity � ������� �� � ��������� �������
        self.dispatcher:dispatchEvents(entity:releaseEvents())
    end,

    -- �������� ��������� �� ���������
    updateParamsTo = function(self, id, operation, range, price)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(id)

        -- �������� ��������
        entity:updateParamsTo(operation, range, price)

        -- �������� ������� �� Entity � ������� �� � ��������� �������
        self.dispatcher:dispatchEvents(entity:releaseEvents())
    end,

    -- ���������� ������������ ���������� �����
    calculateMaxLots = function(self, id)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(id)

        -- �������� ��������
        entity:calculateMaxLots()

        -- �������� ������� �� Entity � ������� �� � ��������� �������
        self.dispatcher:dispatchEvents(entity:releaseEvents())
    end,

    -- �������� �������
    changePosition = function(self, id, trade)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(id)

        -- �������� ��������
        entity:changePosition(trade)

        -- �������� ������� �� Entity � ������� �� � ��������� �������
        self.dispatcher:dispatchEvents(entity:releaseEvents())
    end,

    -- �������� ���������
    changeCondition = function(self, id, params)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(id)

        -- �������� ��������
        entity:changeCondition(params)

        -- �������� ������� �� Entity � ������� �� � ��������� �������
        self.dispatcher:dispatchEvents(entity:releaseEvents())
    end,

    -- �� ���������� �������� ���������� ����
    getRole = function(self, id, params)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(id)

        return entity:getRole(params)
    end,
}

return EntityService
