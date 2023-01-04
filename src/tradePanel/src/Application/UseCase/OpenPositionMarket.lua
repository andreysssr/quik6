--- UseCase OpenPositionMarket

local UseCase = {
    --
    name = "UseCase_OpenPositionMarket",

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

    -- ������� ������� �� ������ ����
    openPosition = function(self, idStock, operation)
        self.validator:checkId(idStock)
        self.validator:check_buy_sell(operation)

        -- ���� ������ �� ������� ��� ������ ��������
        if not self:allowedAction(idStock) then
            return
        end

        -- ���������� ����� ��� ����������
        local idTransact = self.nextId:getId()

        -- �������� ����������� ����� �����������
        local qty = self.entityServiceStock:getLots(idStock)

        -- �������� ����� �����������
        local class = self.storage:getClassToId(idStock)

        -- �������� ��������� ����
        local lastPrice = self.servicePrices:getLastPrice(idStock, class)

        -- ����������� ������ ��� �������, �����, ��������� �����, �����
        self.entityServiceTradeParams:calculateParamsToPrice(idStock, operation, lastPrice)

        -- �������� ������������ � ���������� ���� ������� � ������� �� �����
        local MinMaxPrice = self.servicePrices:getMinMaxPrices(idStock, class)

        -- �������������� ������ ��� ����������
        if operation == "buy" then

            local order = {
                trans_id = idTransact,

                account = self.storage:getAccountToId(idStock),
                client_code = self.storage:getClientCodeToId(idStock),

                idStock = idStock,
                class = class,

                qty = qty,
                price = MinMaxPrice.maxPrice,
            }

            -- ���������� ���������� � ���������
            self.dispatcher:OrderMarketBuy(order)

            -- ��������� ������
            self.entityServiceTransact:create(idTransact, {
                idStock = idStock,
                idParams = idTransact,

                role = "zapros",
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
                price = MinMaxPrice.minPrice,
            }

            -- ���������� ���������� � ���������
            self.dispatcher:OrderMarketSell(order)

            -- ��������� ������
            self.entityServiceTransact:create(idTransact, {
                idStock = idStock,
                idParams = idTransact,

                role = "zapros",
                typeSending = "order",
            })
        end
    end,
}

return UseCase
