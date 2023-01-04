--- UseCase AddZaprosLimit

local UseCase = {
    --
    name = "UseCase_AddZaprosLimit",

    --
    storage = {},

    --
    entityServiceStock = {},

    --
    entityServiceTradeParams = {},

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
        self.entityServiceTradeParams = container:get("EntityService_TradeParams")
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
    -- ��� ����� �������� ������ ������ ���� ��������� ��������, ��� �����������
    allowedAction = function(self, idStock)
        local status = self.entityServiceStock:getStatus(idStock)

        if status == "active" then
            return true
        end

        return false
    end,

    --
    addZapros = function(self, idStock, operation, range)
        self.validator:checkId(idStock)
        self.validator:check_buy_sell(operation)
        self.validator:checkRange(range)

        -- ���� ������ �� ������� ��� ������ ��������
        if not self:allowedAction(idStock) then
            return
        end

        -- ���������� ����� ��� ����������
        local idTransact = self.nextId:getId()

        -- �������� ����� �����������
        local class = self.storage:getClassToId(idStock)

        -- �������� ��������� ����
        local lastPrice = self.servicePrices:getLastPrice(idStock, class)

        -- ������������ ��������� ��� �������� �������
        self.entityServiceTradeParams:calculateParams(idStock, operation, range)

        -- �������� ��������� ���� ��� �������
        local zapros = self.entityServiceTradeParams:getParamsZapros(idStock)

        -- �������� ���������� ����� ��� ������
        local lots = self.entityServiceStock:getLots(idStock)

        -- �������������� ������ ��� ����������
        if operation == "buy" then

            if lastPrice >= zapros.price then
                local order = {
                    trans_id = idTransact,

                    account = self.storage:getAccountToId(idStock),
                    client_code = self.storage:getClientCodeToId(idStock),

                    idStock = idStock,
                    class = class,

                    qty = lots,
                    price = zapros.price,
                }

                -- ���������� ���������� � ���������
                self.dispatcher:OrderLimitBuy(order)

                -- ��������� ������
                self.entityServiceTransact:create(idTransact, {
                    idStock = idStock,
                    idParams = idTransact,

                    role = "zapros",
                    typeSending = "order",
                })
            else
                local stopOrder = {
                    trans_id = idTransact,

                    account = self.storage:getAccountToId(idStock),
                    client_code = self.storage:getClientCodeToId(idStock),

                    idStock = idStock,
                    class = class,

                    qty = lots,

                    price = zapros.price,
                    stopPrice = zapros.stopPrice,
                }

                -- ���������� ���������� � ���������
                self.dispatcher:StopOrderLimitBuy(stopOrder)

                -- ��������� ������
                self.entityServiceTransact:create(idTransact, {
                    idStock = idStock,
                    idParams = idTransact,

                    role = "zapros",
                    typeSending = "stopOrder",
                })
            end
        end

        -- �������������� ������ ��� ����������
        if operation == "sell" then

            if lastPrice <= zapros.price then
                local order = {
                    trans_id = idTransact,

                    account = self.storage:getAccountToId(idStock),
                    client_code = self.storage:getClientCodeToId(idStock),

                    idStock = idStock,
                    class = class,

                    qty = lots,
                    price = zapros.price,
                }

                -- ���������� ���������� � ���������
                self.dispatcher:OrderLimitSell(order)

                -- ��������� ������
                self.entityServiceTransact:create(idTransact, {
                    idStock = idStock,
                    idParams = idTransact,

                    role = "zapros",
                    typeSending = "order",
                })
            else
                local stopOrder = {
                    trans_id = idTransact,

                    account = self.storage:getAccountToId(idStock),
                    client_code = self.storage:getClientCodeToId(idStock),

                    idStock = idStock,
                    class = class,

                    qty = lots,

                    price = zapros.price,
                    stopPrice = zapros.stopPrice,
                }

                -- ���������� ���������� � ���������
                self.dispatcher:StopOrderLimitSell(stopOrder)

                -- ��������� ������
                self.entityServiceTransact:create(idTransact, {
                    idStock = idStock,
                    idParams = idTransact,

                    role = "zapros",
                    typeSending = "stopOrder",
                })
            end
        end
    end,
}

return UseCase
