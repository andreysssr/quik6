--- MicroService ActiveStockPanelTrade - ��������� �������� ������������ � �������� ������

local MicroService = {
    --
    name = "MicroService_ActiveStockPanelTrade",

    --
    container = {},

    --
    entityService = {},

    --
    eventSender = {},

    -- ������ � ������� ������� �������� idStock - ��� �������� ����������� idStock
    arrayIdStock = {},

    -- ������ ������� � ���������� idStock
    dataActive = {
        current = "",
        prev = "",
    },

    --
    new = function(self, container)
        self.container = container
        self.entityService = container:get("EntityService_Stock")
        self.eventSender = container:get("AppService_EventSender")

        self:prepareArrayIdStock()

        return self
    end,

    -- �������������� ������ - ��� ������� �������� idStock
    prepareArrayIdStock = function(self)
        local arrayStock = self.container:get("Storage"):getHomeworkId()

        for i = 1, #arrayStock do
            self.arrayIdStock[arrayStock[i]] = 1
        end
    end,

    -- �������� �������� ����������� ��� �����������
    checkCurrentStock = function(self)
        if self.dataActive.current ~= "" then
            local idStock = self.dataActive.current

            if not self.entityService:isActive(idStock) then
                self.dataActive.prev = self.dataActive.current

                -- ������� id �������
                self.dataActive.current = ""
            end
        end
    end,

    -- ������������ �������� � ��������� ���������
    resetCurrent = function(self)
        local actions = {}

        --	���� ��� ������� ����� id
        if self.dataActive.current ~= "" then
            -- ��������� ������� ���������� � ����������
            self.dataActive.prev = self.dataActive.current

            -- ��������� id ��� ����������
            actions.off = self.dataActive.prev

            -- ������� ������� id
            self.dataActive.current = ""

            -- ��������� ���������
            self:commit(actions)
        end
    end,

    -- ������������ �� ���������� ������
    reversCurrent = function(self)
        local actions = {}

        -- ���� (������� �� ������) � (���������� �� ������)
        --	���� ��� ������� ����� id
        if self.dataActive.current ~= "" and self.dataActive.prev ~= "" then

            -- ���� ���������� ������ �� ��������� � ��������
            -- ����� ��������� ������� ������
            if not self:allowedAction(self.dataActive.prev) then
                self:resetCurrent()

                return
            end

            local newActiveStock = self.dataActive.prev

            -- ��������� ������� ���������� � ����������
            self.dataActive.prev = self.dataActive.current

            -- ��������� id ��� ����������
            actions.off = self.dataActive.prev

            -- �������� ������� id
            self.dataActive.current = newActiveStock

            -- ��������� id ��� ���������
            actions.on = self.dataActive.current

            -- ��������� ���������
            self:commit(actions)

            return
        end

        -- ���� (������� �� ������), � (���������� ������)
        if self.dataActive.current ~= "" and self.dataActive.prev == "" then
            self.dataActive.prev = self.dataActive.current

            -- ��������� id ��� ����������
            actions.off = self.dataActive.prev

            -- ������� �������
            self.dataActive.current = ""

            -- ��������� ���������
            self:commit(actions)

            return
        end

        -- ���� (������� ������), � (���������� �� ������)
        if self.dataActive.current == "" and self.dataActive.prev ~= "" then

            -- ���� ���������� ������ �� ��������� � ��������
            -- ����� ��������� ������� ������
            if not self:allowedAction(self.dataActive.prev) then
                -- ������� ����������
                self.dataActive.prev = ""

                return
            end

            self.dataActive.current = self.dataActive.prev

            -- ��������� id ��� ����������
            actions.on = self.dataActive.current

            -- ������� ����������
            self.dataActive.prev = ""

            -- ��������� ���������
            self:commit(actions)

            return
        end
    end,

    -- ��������� �� ��������� ������
    allowedAction = function(self, idStock)
        local status = self.entityService:getStatus(idStock)

        if status == "active" or status == "limitedActive" then
            return true
        end

        return false
    end,

    -- �������� �������� ����������
    changeActive = function(self, idStock)
        if isset(self.arrayIdStock[idStock]) then
            -- �������� �� (��������� � ��������) id
            if self:allowedAction(idStock) then
                -- 1 ������ �� ������� - �������
                --		������� ������,
                if self.dataActive.current == "" then
                    local actions = {}

                    self.dataActive.prev = self.dataActive.current

                    self.dataActive.current = idStock

                    -- ��������� id ��� ���������
                    actions.on = self.dataActive.current

                    -- ��������� ���������
                    self:commit(actions)

                    return
                end

                -- 2 ������ ������� - ������� �� ������
                --		������� �� ������,
                if self.dataActive.current ~= "" and self.dataActive.current ~= idStock then
                    local actions = {}

                    self.dataActive.prev = self.dataActive.current

                    -- ��������� ��� ��� ��� ����������
                    actions.off = self.dataActive.prev

                    -- � ������� ���������� ��� �� �������� ��������
                    self.dataActive.current = idStock

                    -- ��������� id ��� ���������
                    actions.on = self.dataActive.current

                    -- ��������� ���������
                    self:commit(actions)

                    return
                end
            end

            -- �������� �� (�� ��������� � ��������) id
            if not self:allowedAction(idStock) then
                local actions = {}

                --	���� ��� ������� ����� id
                if self.dataActive.current ~= "" then
                    -- ��������� ������� ���������� � ����������
                    self.dataActive.prev = self.dataActive.current

                    -- ��������� id ��� ����������
                    actions.off = self.dataActive.prev

                    --
                    self.dataActive.current = ""

                    -- ��������� ���������
                    self:commit(actions)
                end
            end
        end
    end,

    -- ���������� ������� �������� ������ ���� ���� ������ �����: ""
    getCurrentIdStock = function(self)
        return self.dataActive.current
    end,

    -- ������ �������
    commitAction = function(self, action, id)
        self.eventSender:send("MicroService_ChangedActiveStock", {
            id = id,
            stock = action
        })
    end,

    -- ��������� ���������
    commit = function(self, actions)
        for action, id in pairs(actions) do
            self:commitAction(action, id)
        end
    end,
}

return MicroService
