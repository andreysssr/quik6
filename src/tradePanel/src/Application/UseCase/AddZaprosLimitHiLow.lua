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


    -- разрешено ли действие с бумагой
    -- для этого действия бумага должна быть полностью активной, без ограничений
    allowedAction = function(self, idStock)
        local status = self.entityServiceStock:getStatus(idStock)

        if status == "active" then
            return true
        end

        return false
    end,

    --
    addZapros = function(self, idStock, operation)
        self.validator:checkId(idStock)
        self.validator:check_buy_sell(operation)

        -- если бумага не активна для данных действий
        if not self:allowedAction(idStock) then
            return
        end

        -- порядковый номер для транзакции
        local idTransact = self.nextId:getId()

        -- получаем класс инструмента
        local class = self.storage:getClassToId(idStock)

        -- получаем последнюю цену
        local lastPrice = self.servicePrices:getLastPrice(idStock, class)

        -- цена hi и low предыдущего дня
        local prices = self.servicePrices:getPricesHiLow(idStock)

        -- подсчитываем параметры для текущего запроса
        if operation == "buy" then
            self.entityServiceTradeParams:calculateParamsToPrice(idStock, operation, prices.buyPrice)
        else
            self.entityServiceTradeParams:calculateParamsToPrice(idStock, operation, prices.sellPrice)
        end

        -- получаем параметры цены для запроса
        local zapros = self.entityServiceTradeParams:getParamsZapros(idStock)

        -- получаем количество лотов для сделки
        local lots = self.entityServiceStock:getLots(idStock)

        -- подготавливаем данные для транзакции
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

                -- отправляем транзакцию в диспетчер
                self.dispatcher:OrderLimitBuy(order)

                -- добавляем данные
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

                -- отправляем транзакцию в диспетчер
                self.dispatcher:StopOrderLimitBuy(stopOrder)

                -- добавляем данные
                self.entityServiceTransact:create(idTransact, {
                    idStock = idStock,
                    idParams = idTransact,

                    role = "zapros",
                    typeSending = "stopOrder",
                })
            end
        end

        -- подготавливаем данные для транзакции
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

                -- отправляем транзакцию в диспетчер
                self.dispatcher:OrderLimitSell(order)

                -- добавляем данные
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

                -- отправляем транзакцию в диспетчер
                self.dispatcher:StopOrderLimitSell(stopOrder)

                -- добавляем данные
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
