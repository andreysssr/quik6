--- Middleware CreateEventCallback -- создаёт события из сообщений обратного вызова

local Middleware = {
    --
    name = "Middleware_CallbackToEvent",

    --
    sender = {},

    --
    new = function(self, container)
        self.sender = container:get("AppService_EventSender")

        return self
    end,

    --
    process = function(self, request, handler)
        self:parseRequest(request)

        handler:handle(request)
    end,

    --
    parseRequest = function(self, request)
        -- order
        if request.name == "order" or request.name == "stopOrder" then
            local data = {
                sec_code = request.data.sec_code,
                status = request.data.status,
                typeSending = request.data.typeSending,
                typeTrade = request.data.typeTrade,
                operation = request.data.operation,
                price = request.data.price,

                trans_id = request.data.trans_id, -- номер транзакции
                order_num = request.data.order_num, -- номер заявки
            }

            self.sender:send("Callback_OrderAndStopOrder", data)

            return
        end

        -- trade
        if request.name == "trade" then
            local data = {
                status = request.data.status,

                sec_code = request.data.sec_code,
                operation = request.data.operation,
                qty = request.data.qty,

                trans_id = request.data.trans_id, -- номер транзакции
                order_num = request.data.order_num, -- номер заявки
            }

            self.sender:send("Callback_Trade", data)
        end
    end,
}

return Middleware
