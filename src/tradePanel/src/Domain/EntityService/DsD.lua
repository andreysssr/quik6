--- EntityService DsD - ��������

local EntityService = {
    --
    name = "EntityService_DsD",

    --
    repository = {},

    --
    dispatcher = {},

    --
    new = function(self, container)
        self.repository = container:get("Repository_DsD")
        self.dispatcher = container:get("EventDispatcher")

        return self
    end,

    -- ������� �������� ������, ������������ �� ��������� ������
    removeDs = function(self, idStock)
        local entity = self.repository:get(idStock)

        entity:removeDs()
    end,

    -- ������� hi, low, close ����������� ���
    getHiLowClosePreviousBar = function(self, idStock)
        local entity = self.repository:get(idStock)

        return entity:getHiLowClosePreviousBar()
    end,

    -- ������� ���
    -- (��������� ��������) - (����������� ��������)
    -- ���������� ��������
    getGap = function(self, idStock)
        local entity = self.repository:get(idStock)

        return entity:getGap()
    end,

    -- ATR �� ���������� ��������
    -- (��������� ��������) - (������� ����)
    getAtrClose = function(self, idStock)
        local entity = self.repository:get(idStock)

        return entity:getAtrClose()
    end,

    -- (���� ��������) - (������� ����)
    getAtrOpen = function(self, idStock)
        local entity = self.repository:get(idStock)

        return entity:getAtrOpen()
    end,

    -- (���� ��������) - (������� ����)
    getAtrOpen = function(self, idStock)
        local entity = self.repository:get(idStock)

        return entity:getAtrOpen()
    end,

    -- ������� ������ Atr �������� �������� ����
    -- (������� Hi) - (������� Low)
    getAtrFull = function(self, idStock)
        local entity = self.repository:get(idStock)

        return entity:getAtrFull()
    end,
}

return EntityService
