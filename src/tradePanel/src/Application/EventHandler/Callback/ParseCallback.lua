--- EventHandler ChangedStage

local EventHandler = {
    --
    name = "EventHandler_ChangedOrders",

    --
    serviceTransact = {},

    --
    new = function(self, container)
        self.serviceTransact = container:get("EntityService_Transact")

        return self
    end,

    -- для order и stopOrder
    parseOrderAndStopOrder = function(self, event)
        local data = event:getParams()

        -- если есть транзакция с (order_num) - тогда меняем у ней статус
        if self.serviceTransact:has(data.order_num) then
            self.serviceTransact:changeStatus(data.order_num, data.status)

            return
        end

        -- ищем транзакцию по (trans_id)
        if self.serviceTransact:has(data.trans_id) then
            -- получаем сохранённые параметры
            local params = self.serviceTransact:getParams(data.trans_id)

            local transact = {
                order_num = data.order_num,
                idStock = data.sec_code,
                idParams = data.trans_id,
                role = params.role,
                typeSending = data.typeSending,
            }

            -- создаём новую транзакцию с параметрами (order_num)
            self.serviceTransact:create(data.order_num, transact)

            -- применяем изменения
            self.serviceTransact:changeStatus(data.order_num, data.status)
        end
    end,

    -- разбор стоп-ордера со связанной заявкой
    parseStopOrderLinked = function(self, event)
        local data = event:getParams()
        -- если есть транзакция с (order_num) - тогда меняем у ней статус
        if self.serviceTransact:has(data.order_num) then
            self.serviceTransact:changeStatus(data.order_num, data.status)

            return
        end

        -- ищем транзакцию по (trans_id)
        if self.serviceTransact:has(data.trans_id) then
            -- получаем сохранённые параметры
            local params = self.serviceTransact:getParams(data.trans_id)
            local transactStopOrder = {
                order_num = data.order_num,
                idStock = data.sec_code,
                idParams = data.trans_id,

                role = params.role,
                typeSending = data.typeSending,
            }

            -- создаём новую транзакцию с параметрами (order_num)
            self.serviceTransact:create(data.order_num, transactStopOrder)

            -- применяем изменения
            self.serviceTransact:changeStatus(data.order_num, data.status)
        end
    end,

}

return EventHandler
