--- UseCase DeleteOrdersAndStopOrders

local UseCase = {
    --
    name = "UseCase_DeleteOrdersAndStopOrders",

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
        self.nextId = container:get("AppService_NextId")
        self.validator = container:get("AppService_Validator")
        self.dispatcher = container:get("TransactDispatcher")

        extended(self, trait)

        return self
    end,

    --
    find = function(self, typeOrders, id, class)
        local result = {}

        local table = ""

        if typeOrders == "orders" then
            table = "orders"
        end

        if typeOrders == "stop_orders" then
            table = "stop_orders"
        end

        function myFind(F, sec_code)
            if sec_code == id and (bit.band(F, 0x1) ~= 0) then
                return true
            end

            return false
        end

        local orders = SearchItems(table, 0, getNumberOf(table) - 1, myFind, "flags, sec_code")

        if (orders ~= nil) and (#orders > 0) then
            for i = 1, #orders do
                result[#result + 1] = {
                    trans_id = self.nextId:getId(),
                    idStock = id,
                    class = class,
                    order_num = getItem(table, orders[i]).order_num
                }
            end
        end

        return result
    end,

    -- удаляет все заявки и стоп-заявки по инструменту
    delete = function(self, id)
        self.validator:checkId(id)

        -- получаем класс инструмента
        local class = self.storage:getClassToId(id)

        local orders = self:find("orders", id, class)
        if not_empty(orders) then
            for i = 1, #orders do
                self.dispatcher:OrderDelete(orders[i])
            end
        end

        local stopOrders = self:find("stop_orders", id, class)
        if not_empty(stopOrders) then
            for i = 1, #stopOrders do
                self.dispatcher:StopOrderDelete(stopOrders[i])
            end
        end
    end,
}

return UseCase
