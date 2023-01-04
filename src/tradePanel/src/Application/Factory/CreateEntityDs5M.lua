--- Factory CreateEntityBasePrice

local Factory = {
    --
    name = "Factory_CreateEntityDs5M",

    --
    container = {},

    --
    storage = {},

    --
    quik = {},

    --
    repositoryBasePrice = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")
        self.repositoryDs = container:get("Repository_Ds5M")

        return self
    end,

    -- �������� Entity_BasePrice � ���������� ��� � �����������
    createEntity = function(self, idStock)
        local class = self.storage:getClassToId(idStock)

        local interval = self.storage:getIntervalToId(idStock)

        -- ������� ������� �� ����� ������� ������� ���������, ������ � ����
        local ds, error_desc = CreateDataSource(class, idStock, INTERVAL_M5)

        -- �������� �������� ������
        local classEntityDs = self.container:get("Entity_Ds")

        local entity = {
            --
            events = {},
            numLastBar = 0,

            name = "Entity_Ds",
            id = idStock,
            class = class,
            interval = interval,

            ds = ds,
        }

        extended(entity, classEntityDs)

        self.repositoryDs:save(entity)
    end,
}

return Factory
