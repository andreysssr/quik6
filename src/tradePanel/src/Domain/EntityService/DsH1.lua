--- EntityService DsH1 - ��������

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

    -- ������� �������� ������, ������������ �� ��������� ������
    removeDs = function(self, idStock)
        local entity = self.repository:get(idStock)

        entity:removeDs()
    end,

    -- ������� hi, low, ������ ���� - 10 �����
    getHiLowBarHour10 = function(self, idStock)
        local entity = self.repository:get(idStock)

        return entity:getHiLowBarHour10()
    end,

    -- ������� hi, low, ���� ����� - 9 � 10
    getHiLowBarHour9 = function(self, idStock)
        local entity = self.repository:get(idStock)

        return entity:getHiLowBarHour9()
    end,
}

return EntityService
