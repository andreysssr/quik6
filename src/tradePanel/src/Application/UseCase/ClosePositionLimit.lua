--- UseCase ClosePositionLimit

local UseCase = {
    --
    name = "UseCase_ClosePositionLimit",

    --
    storage = {},

    --
    entityServiceStock = {},

    --
    entityServiceTransact = {},

    --
    nextId = {},

    --
    servicePrices = {},

    --
    validator = {},

    --
    dispatcher = {},

    --
    new = function(self, container)
        self.storage = container:get("Storage")

        self.entityServiceStock = container:get("EntityService_Stock")
        self.entityServiceTransact = container:get("EntityService_Transact")

        self.nextId = container:get("AppService_NextId")
        self.servicePrices = container:get("AppService_ServicePrices")
        self.validator = container:get("AppService_Validator")

        self.dispatcher = container:get("TransactDispatcher")

        local trait = container:get("UseCase_Trait")

        extended(self, trait)

        return self
    end,

    -- ��������� �� �������� � �������
    -- ��� ����� �������� ������ ������ ���� �������� ��� �����������
    allowedAction = function(self, idStock)
        local status = self.entityServiceStock:getStatus(idStock)

        if status == "active" or status == "limitedActive" then
            return true
        end

        return false
    end,

    -- ������� ������� �� ������ ����
    closePosition = function(self, idStock)
        self.validator:checkId(idStock)

        -- ���� ������ �� ������� ��� ������ ��������
        if not self:allowedAction(idStock) then
            return
        end

        -- ���������� ����� ��� ����������
        local idTransact = self.nextId:getId()

        -- �������� ����������� ����� �����������
        local position = self.entityServiceStock:getPositionParams(idStock)

        -- �������� ���������� �������� ������ (��� ������)
        local qty = self:getAbsoluteQty(position.qty)

        if qty == 0 then
            return
        end

        -- ����������� �������� ������ ���� �������������� �������
        local operation = self:getReverseOperation(position.operation)

        -- �������� ����� �����������
        local class = self.storage:getClassToId(idStock)

        -- �������� ������ ���� ������� � �������
        local goodPrice = self.servicePrices:getGoodPrices(idStock, class)

        -- �������������� ������ ��� ����������
        if operation == "buy" then

            local order = {
                trans_id = idTransact,

                account = self.storage:getAccountToId(idStock),
                client_code = self.storage:getClientCodeToId(idStock),

                idStock = idStock,
                class = class,

                qty = qty,
                price = goodPrice.buyPrice,
            }

            -- ���������� ���������� � ���������
            self.dispatcher:OrderLimitBuy(order)

            -- ��������� ������
            self.entityServiceTransact:create(idTransact, {
                idStock = idStock,
                idParams = idTransact,

                role = "take",
                typeSending = "order",
            })
        end

        -- �������������� ������ ��� ����������
        if operation == "sell" then

            local order = {
                trans_id = idTransact,

                account = self.storage:getAccountToId(idStock),
                client_code = self.storage:getClientCodeToId(idStock),

                idStock = idStock,
                class = class,

                qty = qty,
                price = goodPrice.sellPrice,
            }

            -- ���������� ���������� � ���������
            self.dispatcher:OrderLimitSell(order)

            -- ��������� ������
            self.entityServiceTransact:create(idTransact, {
                idStock = idStock,
                idParams = idTransact,

                role = "take",
                typeSending = "order",
            })
        end
    end,
}

return UseCase
