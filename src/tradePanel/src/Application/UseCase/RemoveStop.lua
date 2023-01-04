--- UseCase RemoveStop

local UseCase = {
    --
    name = "UseCase_RemoveStop",

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

    --
    removeStop = function(self, idStock, idNum)
        self.validator:checkId(idStock)

        -- получаем класс инструмента
        local class = self.storage:getClassToId(idStock)

        local order_num = 0

        --
        if idNum then
            order_num = idNum
        else
            order_num = self.entityServiceStock:getStop(idStock).order_num
        end

        -- если стопа нет - останавливаем выполнение
        if not_number(order_num) then
            return
        end

        -- подготавливаем данные для транзакции
        local stopOrder = {
            trans_id = self.nextId:getId(),
            class = class,
            order_num = order_num,
        }

        -- отправляем транзакцию в диспетчер
        self.dispatcher:StopOrderDelete(stopOrder.trans_id, stopOrder)
    end,
}

return UseCase
