--- UseCase ClosePositionMarket

local UseCase = {
    --
    name = "UseCase_ClosePositionMarket",

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
    serviceCorrectPrice = {},

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
        self.serviceCorrectPrice = container:get("DomainService_CorrectPrice")
        self.validator = container:get("AppService_Validator")

        self.dispatcher = container:get("TransactDispatcher")

        local trait = container:get("UseCase_Trait")

        extended(self, trait)

        return self
    end,

    -- разрешено ли действие с бумагой
    -- для этого действия бумага должна быть активной или ограниченой
    allowedAction = function(self, idStock)
        local status = self.entityServiceStock:getStatus(idStock)

        if status == "active" or status == "limitedActive" then
            return true
        end

        return false
    end,

    -- закрыть позицию по рынку
    closePosition = function(self, idStock)
        self.validator:checkId(idStock)

        -- если бумага не активна для данных действий
        if not self:allowedAction(idStock) then
            return
        end

        -- порядковый номер для транзакции
        local idTransact = self.nextId:getId()

        -- получаем колличество лотов инструмента
        local position = self.entityServiceStock:getPositionParams(idStock)

        -- получаем абсолютное значение позиий (без минуса)
        local qty = self:getAbsoluteQty(position.qty)

        if qty == 0 then
            return
        end

        -- operation противоположен позиции
        local operation = self:getReverseOperation(position.operation)

        -- получаем класс инструмента
        local class = self.storage:getClassToId(idStock)

        -- получаем минимальную и максимально - возможные цены
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
                --price = MinMaxPrice.maxPrice,
                -- максимальную цену уменьшаем на шаг цены
                price = self.serviceCorrectPrice:getPriceSell(idStock, class, MinMaxPrice.maxPrice)
            }

            -- отправляем транзакцию в диспетчер
            self.dispatcher:OrderMarketBuy(order)

            -- добавляем данные
            self.entityServiceTransact:create(idTransact, {
                idStock = idStock,
                idParams = idTransact,

                role = "take",
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

                -- минимальную цену увеличиваем на шаг цены
                price = self.serviceCorrectPrice:getPriceBuy(idStock, class, MinMaxPrice.minPrice)
            }

            -- отправляем транзакцию в диспетчер
            self.dispatcher:OrderMarketSell(order)

            -- добавляем данные
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
