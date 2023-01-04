--- EntityService Ds5M - ��������

local EntityService = {
    --
    name = "EntityService_Ds5M",

    --
    repository = {},

    --
    dispatcher = {},

    --
    new = function(self, container)
        self.repository = container:get("Repository_Ds5M")
        self.dispatcher = container:get("EventDispatcher")

        return self
    end,

    -- ������� �������� ������, ������������ �� ��������� ������
    removeDs = function(self, idStock)
        local entity = self.repository:get(idStock)

        entity:removeDs()
    end,

    -- ��������� - ��������� �� ���
    -- ���� ��� ��������� - �������� �������
    checkNewBar = function(self, idStock)
        local entity = self.repository:get(idStock)

        entity:checkNewBar()

        -- �������� ������� �� Entity � ������� �� � ��������� �������
        self.dispatcher:dispatchEvents(entity:releaseEvents())
    end,

    -- ������� Atr ���������� ����
    -- (������� Hi) - (������� Low)
    getAtrBarCurrent = function(self, idStock)
        local entity = self.repository:get(idStock)

        return entity:getAtrBarCurrent()
    end,

    -- ������� Atr ����������� ����
    -- (���������� Hi) - (���������� low)
    getAtrBarPrev = function(self, idStock)
        local entity = self.repository:get(idStock)

        return entity:getAtrBarPrev()
    end,

    -- ������� hi low ��������� 3 �����
    getHiLow = function(self, idStock)
        local entity = self.repository:get(idStock)

        return entity:getHiLow()
    end,

    -- ������� ����� ��������� 3 �����
    getVolume = function(self, idStock)
        local entity = self.repository:get(idStock)

        return entity:getVolume()
    end,
}

return EntityService
