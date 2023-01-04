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
        self.cache = container:get("Cache") -- ��������, ����� ��������� ����������

        return self
    end,

    -- �������� Entity_TradeParams � ���������� ��� � �����������
    createEntity = function(self, idStock)
        local id = idStock
        local class = self.storage:getClassToId(id)

        local params = {}
        params.idStock = id
        params.class = class

        -- �������� ����� Entity TradeParams
        local classEntityTradeParams = self.container:get("Entity_TradeParams")

        -- �������� entity
        local entity = classEntityTradeParams:newChild(params)

        -- ��������� ��������� entity TradeParams
        self.repositoryTradeParams:save(entity)

        -- ������������ ������ ���� ���� �������� ������� �� ������
        if self.entityServiceStock:hasPosition(idStock) then
            if self.cache:has(idStock .. "_params") then
                local cacheParams = self.cache:getFile(idStock .. "_params")
                self.entityServiceParams:recoveryParams(idStock, cacheParams)
            end
        end
    end,

}

return Factory
