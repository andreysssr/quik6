--- EntityService BasePrice

local EntityService = {
    --
    name = "EntityService_BasePrice",

    --
    repository = {},

    --
    dispatcher = {},

    --
    idTickers = {},

    --
    new = function(self, container)
        self.repository = container:get("Repository_BasePrice")
        self.dispatcher = container:get("EventDispatcher")
        self.idTickers = container:get("Storage"):getHomeworkId()

        return self
    end,

    -- �������� �������
    checkLevel = function(self, id)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(id)

        -- �������� ��������
        entity:checkLevel()

        -- �������� ������� �� Entity � ������� �� � ��������� �������
        self.dispatcher:dispatchEvents(entity:releaseEvents())
    end,

    -- �������� �������� �������
    checkLevels = function(self)
        for i = 1, #self.idTickers do
            self:checkLevel(self.idTickers[i])
        end
    end,

    -- ������� ����������� ���������
    getData = function(self, id)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(id)

        return entity:getData()
    end,

    -- ������� ������� ����
    getPrice = function(self, id)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(id)

        return entity:getPrice()
    end,

    -- ���������� ������ ������� ������ basePrice
    getBasePrice = function(self, id)
        -- �������� �� ����������� ������ Entity
        local entity = self.repository:get(id)

        return entity:getBasePrice()
    end,

}

return EntityService
