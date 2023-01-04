--- UseCase AddStopLinked

local UseCase = {
    --
    name = "UseCase_AddStopLinked",

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

        -- порядковый номер для транзакции
        local idTransact = self.nextId:getId()
        --local idTransact = idParams

        -- получаем параметры стопа
        local stop = self.entityServiceTradeParams:getParamsStop(idStock)

        -- устанавливаем направление для выставления стопа
        local operation = stop.operation

        -- получаем установленный размер тейка
        local takeSize = self.entityServiceStock:getTakeSize(idStock)

        -- получаем параметры тейка
        local take = self.entityServiceTradeParams:getParamsTake(idStock)

        -- получаем цену тейка
        local takePrice = take.price[takeSize]

        -- получаем абсолютное число лотов открытой позиции инструмента
        local lots = math.abs(self.entityServiceStock:getPositionQty(idStock))

        -- получаем класс инструмента
        local class = self.storage:getClassToId(idStock)

        -- подготавливаем данные для транзакции
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
                linkedPrice = takePrice,
            }

            -- отправляем транзакцию в диспетчер
            self.dispatcher:StopOrderMarketBuyLink(stopOrder)

            -- добавляем данные
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
                linkedPrice = takePrice,
            }

            -- отправляем транзакцию в диспетчер
            self.dispatcher:StopOrderMarketSellLink(stopOrder)

            -- добавляем данные
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
