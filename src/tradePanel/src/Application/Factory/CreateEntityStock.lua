--- Factory CreateEntityStock ������� ��� �������� EntityStock

local Factory = {
    --
    name = "Factory_CreateEntityStock",

    --
    container = {},

    --
    servicePosition = {},

    --
    storage = {},

    --
    calculateLots = {},

    -- search
    search = {},

    --
    entityRepository = {},

    -- ���������� ���� ��� ��� ��� ����������� �����
    takeStatus = false,

    -- ������ ����� �� ���������
    selectSize = 3,

    --
    new = function(self, container)
        self.container = container

        self.servicePosition = self.container:get("AppService_GetPosition")
        self.positionSetting = self.container:get("Config_positionSetting")

        self.storage = container:get("Storage")
        self.calculateLots = container:get("AppService_CalculateLotsToMoneyRisk")
        self.search = container:get("Quik_Search")
        self.entityRepository = container:get("Repository_Stock")
        self.takeStatus = container:get("config").takeStatus
        self.selectSize = container:get("config").selectSize

        return self
    end,

    -- �������� Entity_BasePrice � ���������� ��� � �����������
    createEntity = function(self, idStock)
        if is_nil(idStock) then
            error("\r\n" .. "Error: ����������� Entity �� ����� ������. ��������: (" .. type(idStock) .. ") - " .. tostring(idStock), 2)
        end

        --local id = idStock
        local class = self.storage:getClassToId(idStock)

        -- �������� �� ���� ��� �����������
        local statusAllowedShort = self.storage:getAllowedShortToId(idStock)

        -- ������� ����� ����� ������ ������ �� 7% ����� �� ������� ���������
        local lots = self.calculateLots:getLots(idStock, class)

        -- ����� EntityStock
        local classEntity = self.container:get("Entity_Stock")

        -- ������������ ���������� ����� ��������� � ������ ��� �����������
        --local maxLots = self.container:get("DomainService_CalculateMaxLots"):getMaxLots(idStock, class)
        --- ����� ������ �������� ������������� ���������� �����, ����� �� �������� ����� �� ������
        --- ������ ���� ������

        -- �������� ������� ������
        local position = 0

        -- �������� � �������
        if class == 'SPBFUT' or class == 'SPBOPT' then
            position = self.servicePosition:getPositionFutures(idStock, class, self.positionSetting.futures)
        end

        -- �����
        if class == 'TQBR' or class == 'QJSIM' then
            position = self.servicePosition:getPositionStock(idStock, class, self.positionSetting.stock)
        end

        -- ������
        if class == 'CETS' then
            position = self.servicePosition:getPositionCurrency(idStock, class, self.positionSetting.currency)
        end

        -- ����������� �������
        local operation = ""

        if position < 0 then
            operation = "sell"
        end

        if position > 0 then
            operation = "buy"
        end

        local entity = {
            id = idStock,
            class = class,

            events = {},

            trade = {
                -- ������� �� ����������
                -- �� ��������� ���������� �������
                -- active, limitedActive, notActive
                status = "active",

                -- ��������� �� �����
                statusAllowedShort = statusAllowedShort,

                -- ���������� ����� ��� ��������
                lots = lots or 0,

                -- ������������ ���������� �����
                --maxLots = maxLots,
                maxLots = -1, -- ����� �������� ����� ��� ������ ��������� � ��������� ��������� ��������� �������
            },

            -- ���� ������� sell - ����� ����� �������������
            position = {
                qty = position,
                operation = operation, -- "", "buy", "sell,
            },

            zapros = {
                list = {}
            },

            stop = {
                -- �������� idParams ���������� ��������� �����
                -- ���� �������� ������� - ����� ��������� ��������
                -- ����������: ��� �������� �������
                recoveryIdParams = 0,

                list = {},
            },

            take = {
                -- ������� ���� ��� ��������
                status = self.takeStatus,
                -- ��������: 2, 3, 4, 5, 6
                selectSize = self.selectSize,

                list = {}
            },

            -- ��������� ���� ��� ��������
            basePrice = {},
        }

        -- ���� ���� ������� ������������� ����� idParams ��� ��������������
        if position ~= 0 then
            entity.stop.recoveryIdParams = 1
        end

        extended(entity, classEntity)

        self.entityRepository:save(entity)
    end,

}

return Factory
