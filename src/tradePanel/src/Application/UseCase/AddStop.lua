--- UseCase AddStop

local UseCase = {
    --
    name = "UseCase_AddStop",

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

    --
    addStop = function(self, idStock)
        self.validator:checkId(idStock)

        -- ���������� ����� ��� ����������
        local idTransact = self.nextId:getId()
        --local idTransact = idParams

        -- �������� ��������� �����
        local stop = self.entityServiceTradeParams:getParamsStop(idStock)

        -- �������� ����� - ����� ��� �� ������
        if empty(stop) then
            error("\r\n" .. "Error: �������� ������ ��������� ��� (stop), idStock - " .. idStock .. "), idParams - (" .. idParams .. ")")
        end

        -- ������������� ����������� ������
        local operation = stop.operation

        -- �������� ���������� ����� ����� �������� ������� �����������
        local lots = math.abs(self.entityServiceStock:getPositionQty(idStock))

        -- �������� ����� �����������
        local class = self.storage:getClassToId(idStock)

        -- �������������� ������ ��� ����������
        if operation == "buy" then

            local stopOrder = {
                trans_id = idTransact,

                account = self.storage:getAccountToId(idStock),
                client_code = self.storage:getClientCodeToId(idStock),

                idStock = idStock,
                class = class,

                qty = lots,

                price = stop.price,
                stopPrice = stop.stopPrice,
            }

            -- ���������� ���������� � ���������
            self.dispatcher:StopOrderMarketBuy(stopOrder)

            -- ��������� ������
            self.entityServiceTransact:create(idTransact, {
                idStock = idStock,
                idParams = idTransact,

                role = "stop",
                typeSending = "stopOrder",
            })
        end

        --
        if operation == "sell" then

            local stopOrder = {
                trans_id = idTransact,

                account = self.storage:getAccountToId(idStock),
                client_code = self.storage:getClientCodeToId(idStock),

                idStock = idStock,
                class = class,

                qty = lots,

                price = stop.price,
                stopPrice = stop.stopPrice,
            }

            -- ���������� ���������� � ���������
            self.dispatcher:StopOrderMarketSell(stopOrder)

            -- ��������� ������
            self.entityServiceTransact:create(idTransact, {
                idStock = idStock,
                idParams = idTransact,

                role = "stop",
                typeSending = "stopOrder",
            })
        end
    end,
}

return UseCase
