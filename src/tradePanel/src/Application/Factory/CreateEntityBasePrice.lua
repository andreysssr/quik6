--- Factory CreateEntityBasePrice

local Factory = {
    --
    name = "Factory_CreateEntityBasePrice",

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
        self.quik = container:get("Quik")
        self.repositoryBasePrice = container:get("Repository_BasePrice")

        return self
    end,

    -- �������� Entity_BasePrice � ���������� ��� � �����������
    createEntity = function(self, idTicker)
        local id = idTicker
        local class = self.storage:getClassToId(id)

        -- ��������� ���� �����������
        local lastPrice = self.quik:getLastPrice(id, class)

        -- �������� ��������� ���� ��� �����������
        if not_number(lastPrice) then
            error("\r\n" .. "Error: ��������� ���� ������ ���� ������. ��������: (" .. type(lastPrice) .. ")")
        end

        -- ���������� ���������� ��� �������
        local countInterval = self.container:get("config").basePrice.countInterval

        -- ��������� ������� ���������
        local params = self.storage:getLevels(id, class, lastPrice, countInterval)

        if not_nil(params) then
            params.id = id
            params.class = class

            -- �������� ����� Entity BasePrice
            local classEntityBase = self.container:get("Entity_BasePrice")

            -- �������� entity
            local entity = classEntityBase:newChild(params)

            -- ��������� ������������� - ������ ������
            entity:init()

            -- ����������� ���� �������
            local event = entity:releaseEvents()

            self.repositoryBasePrice:save(entity)

            return
        end

        -- ����������� ������ - ��������� ��� id �� �������
        error("\r\n" .. "Error: ��������� ��� ������ � id - (" .. tostring(id) .. ") �� �������")
    end,
}

return Factory
