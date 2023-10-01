--- UseCase RemoveZapros

local UseCase = {
    --
    name = "UseCase_RemoveZapros",

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

    -- удалить запрос
    removeZapros = function(self, idStock, idNum)
        self.validator:checkId(idStock)

        -- получаем класс инструмента
        local class = self.storage:getClassToId(idStock)

        local order_num = 0

        -- получаем параметры запроса
        local zapros = self.entityServiceStock:getZapros(idStock)

        if idNum then
            order_num = idNum
        else
            order_num = zapros.order_num
        end

        -- если стопа нет - останавливаем выполнение
        if not_number(order_num) then
            return
        end

        -- порядковый номер для транзакции
        local idTransact = self.nextId:getId()

        -- подготавливаем данные для транзакции
        -- если запрос был выставлен ордером
        if zapros.typeSending == "order" then
            local order = {
                trans_id = idTransact,
                idStock = idStock,
                class = class,
                order_num = order_num,
            }

            -- отправляем транзакцию в диспетчер
            self.dispatcher:OrderDelete(order)
        else
            -- если запрос был выставлен стоп-ордером
            local stopOrder = {
                trans_id = idTransact,
                class = class,
                order_num = order_num,
            }

            -- отправляем транзакцию в диспетчер
            self.dispatcher:StopOrderDelete(stopOrder)
        end
    end,
}

return UseCase
