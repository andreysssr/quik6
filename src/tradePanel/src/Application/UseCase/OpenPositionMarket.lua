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

    -- разрешено ли действие с бумагой
    -- для этого действия бумага должна быть полностью активной, без ограничений
    allowedAction = function(self, idStock)
        local status = self.entityServiceStock:getStatus(idStock)

        if status == "active" then
            return true
        end

        return false
    end,

    -- открыть позицию по лучшей цене
    openPosition = function(self, idStock, operation)
        self.validator:checkId(idStock)
        self.validator:check_buy_sell(operation)

        -- если бумага не активна для данных действий
        if not self:allowedAction(idStock) then
            return
        end

        -- порядковый номер для транзакции
        local idTransact = self.nextId:getId()

        -- получаем колличество лотов инструмента
        local qty = self.entityServiceStock:getLots(idStock)

        -- получаем класс инструмента
        local class = self.storage:getClassToId(idStock)

        -- получаем последнюю цену
        local lastPrice = self.servicePrices:getLastPrice(idStock, class)

        -- расчитываем данные для запроса, стопа, переносас стопа, тейка
        self.entityServiceTradeParams:calculateParamsToPrice(idStock, operation, lastPrice)

        -- получаем максимальную и минимальую цены продажи и покупки по рынку
        local MinMaxPrice = self.servicePrices:getMinMaxPrices(idStock, class)

        -- подготавливаем данные для транзакции
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

            -- отправляем транзакцию в диспетчер
            self.dispatcher:OrderMarketBuy(order)

            -- добавляем данные
            self.entityServiceTransact:create(idTransact, {
                idStock = idStock,
                idParams = idTransact,

                role = "zapros",
                typeSending = "order",
            })
        end

        -- подготавливаем данные для транзакции
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

            -- отправляем транзакцию в диспетчер
            self.dispatcher:OrderMarketSell(order)

            -- добавляем данные
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
