--- UseCase OpenPositionLimit

local UseCase = {
    --
    name = "UseCase_OpenPositionLimit",

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

        -- получаем лучшие цены продажи и покупки
        local goodPrice = self.servicePrices:getGoodPrices(idStock, class)

        -- подготавливаем данные для транзакции
        if operation == "buy" then
            -- расчитываем данные для запроса, стопа, переносас стопа, тейка
            self.entityServiceTradeParams:calculateParamsToPrice(idStock, operation, goodPrice.buyPrice)

            local order = {
                trans_id = idTransact,

                account = self.storage:getAccountToId(idStock),
                client_code = self.storage:getClientCodeToId(idStock),

                idStock = idStock,
                class = class,

                qty = qty,
                price = goodPrice.buyPrice,
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
        end

        -- подготавливаем данные для транзакции
        if operation == "sell" then
            -- расчитываем данные для запроса, стопа, переносас стопа, тейка
            self.entityServiceTradeParams:calculateParamsToPrice(idStock, operation, goodPrice.sellPrice)

            local order = {
                trans_id = idTransact,

                account = self.storage:getAccountToId(idStock),
                client_code = self.storage:getClientCodeToId(idStock),

                idStock = idStock,
                class = class,

                qty = qty,
                price = goodPrice.sellPrice,
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
        end
    end,
}

return UseCase
