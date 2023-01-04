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

    -- ������������ ������ �� ���� � entity ��� ������� 1
    recoveryParams = function(self, idStock, params)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(idStock)

        entity:recoveryParams(params)
    end,

    -- ���������� ������ �� ������� ����
    calculateParams = function(self, idStock, operation, range)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(idStock)

        entity:calculateParams(operation, range)

        -- �������� ������� �� Entity � ������� �� � ��������� �������
        self.dispatcher:dispatchEvents(entity:releaseEvents())
    end,

    -- ���������� ������ �� ���������� ����
    calculateParamsToPrice = function(self, idStock, operation, price)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(idStock)

        entity:calculateParamsToPrice(operation, price)

        -- �������� ������� �� Entity � ������� �� � ��������� �������
        self.dispatcher:dispatchEvents(entity:releaseEvents())
    end,

    -- ������� ��������� ��� id
    getParams = function(self, idStock, idParams)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(idStock)

        return entity:getParams(idParams)
    end,

    -- ������� ��������� ��� id
    getParamsZapros = function(self, idStock, idParams)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(idStock)

        return entity:getParamsZapros(idParams)
    end,

    -- ������� ��������� ��� id
    getParamsStop = function(self, idStock, idParams)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(idStock)

        return entity:getParamsStop(idParams)
    end,

    -- ������� ��������� ��� id
    getParamsStopMove = function(self, idStock, idParams)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(idStock)

        return entity:getParamsStopMove(idParams)
    end,

    -- ������� ��������� take ��� id
    getParamsTake = function(self, idStock, idParams)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(idStock)

        return entity:getParamsTake(idParams)
    end,
}

return EntityService
