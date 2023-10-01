--- UseCase AddStopMove

local UseCase = {
    --
    name = "UseCase_AddStopMove",

    --
    storage = {},

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
    addStop = function(self, idStock, idParams)
        self.validator:checkId(idStock)

        -- порядковый номер для транзакции
        local idTransact = self.nextId:getId()

        -- получаем параметры стопа
        local stop = self.entityServiceTradeParams:getParamsStopMove(idStock, idParams)

        -- прверка стопа - чтобы был не пустой
        if empty(stop) then
            error("\r\n" .. "Error: Получены пустые параметры для (stop), idStock - " .. idStock .. "), idParams - (" .. idParams .. ")")
        end

        -- устанавливаем направление заявки
        local operation = stop.operation

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

                qty = stop.lots,

                price = stop.price,
                stopPrice = stop.stopPrice,
            }

            -- отправляем транзакцию в диспетчер
            self.dispatcher:StopOrderMarketBuy(stopOrder)

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

                qty = stop.lots,

                price = stop.price,
                stopPrice = stop.stopPrice,
            }

            -- отправляем транзакцию в диспетчер
            self.dispatcher:StopOrderMarketSell(stopOrder)

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
