--- Отправляет транзакцию на сервер брокера

local TransactDispatcher = {
    --
    nome = "TransactDispatcher",

    --
    timer = {},

    -- название таймера
    nameTimer = "",

    -- время таймера в секундах
    pauseTime = 0,

    -- количество транзакций подряд
    countTransactions = 0,

    --
    queue = {},

    --
    eventSender = {},

    -- список номеров ордеров и стоп-ордеров которые отправили на удаление
    -- чтобы избежать повторной отправки на удаление
    data_KILL = {},

    --
    new = function(self, container)
        self.timer = container:get("Timer")

        self.nameTimer = container:get("config").transaction.nameTimer
        self.pauseTime = container:get("config").transaction.pauseTime
        self.countTransactions = container:get("config").transaction.countTransactions

        self.queue = container:get("Queue")
        self.eventSender = container:get("AppService_EventSender")

        -- таймер обновляется если очередь была не пустой и мы делали транзакцию
        self.timer:set(self.nameTimer, self.pauseTime)

        return self
    end,

    -- запускаем отсылку транзакций
    dispatch = function(self)
        -- проверяем таймер - можно ли обрабатывать очередь
        if not self.timer:allows(self.nameTimer) then
            return
        end

        -- максимальное количество транзакций подряд
        for i = 0, self.countTransactions do
            -- если очередь пустая
            if self.queue:isEmpty() then
                break -- выходим из цикла

                return
            end

            -- берём транзакцию из очереди для отправки
            local transact = self.queue:dequeue()

            -- результат отправки транзакции
            local result = sendTransaction(transact)

            if result ~= "" then
                dd("=====================================================")
                dd("sendTransaction - " .. tostring(result))
                dd(result)
                dd(transact)
                dd("=====================================================")

                -- создаём событие ошибки транзакции
                self.eventSender:send("Alert", {
                    alert = "Ошибка транзакции: " .. result
                })

                break
            end

            -- таймер обновляется если очередь была не пустой и мы делали транзакцию
            self.timer:set(self.nameTimer, self.pauseTime)
        end
    end,

    -- для рыночной заявки меняет цену на 0
    checkMarketPrice = function(self, dto)
        if dto["TYPE"] == "M" then
            dto["PRICE"] = "0"
        end

        return dto
    end,

    -- переводит все значения массива в строку
    converterToString = function(self, array)
        for key, value in pairs(array) do
            if not_string(value) then
                array[key] = tostring(value)
            end
        end

        return array
    end,

    -- добавляет транзакцию в диспетчер транзакций
    add = function(self, dto)
        -- если это удаление стоп-ордера - проверяем не удаляли ли его раньше
        if dto["ACTION"] == "KILL_ORDER" or dto["ACTION"] == "KILL_STOP_ORDER" then
            -- если такого номер стоп-ордера нет - тогда выполняем транзакцию
            local num = dto["ORDER_KEY"] or dto["STOP_ORDER_KEY"]

            -- если номера удаления уже были
            if self.data_KILL[num] then
                return
            end

            -- сохраняем номер стоп-ордера
            self.data_KILL[num] = 1
        end

        -- переводим все числовые значения в строковые
        local transact = self:converterToString(dto)
        transact = self:checkMarketPrice(transact)

        -- добавляем транзакцию в очередь
        self.queue:enqueue(transact)
    end,

    -- val - передаём параметр
    -- name - название параметра строкой
    checkNotNil = function(self, val, name)
        if is_nil(val) then
            error("Error: Ошибка: параметр (" .. name .. ") не передан.", 3)
        end
    end,

    -- лимитная заявка на покупку
    OrderLimitBuy = function(self, params)
        local dto = {
            ACTION = "NEW_ORDER",
            TYPE = "L",
            OPERATION = "B",

            TRANS_ID = params.trans_id,

            ACCOUNT = params.account,
            CLIENT_CODE = params.client_code,

            SECCODE = params.idStock,
            CLASSCODE = params.class,

            QUANTITY = params.qty,
            PRICE = params.price,
        }

        self:checkNotNil(dto.TRANS_ID, "trans_id")
        self:checkNotNil(dto.ACCOUNT, "account")
        self:checkNotNil(dto.CLIENT_CODE, "client_code")
        self:checkNotNil(dto.SECCODE, "idStock")
        self:checkNotNil(dto.CLASSCODE, "class")
        self:checkNotNil(dto.QUANTITY, "qty")
        self:checkNotNil(dto.PRICE, "price")

        self:add(dto)
    end,

    -- лимитная заявка на продажу
    OrderLimitSell = function(self, params)
        local dto = {
            ACTION = "NEW_ORDER",
            TYPE = "L",
            OPERATION = "S",

            TRANS_ID = params.trans_id,

            ACCOUNT = params.account,
            CLIENT_CODE = params.client_code,

            SECCODE = params.idStock,
            CLASSCODE = params.class,

            QUANTITY = params.qty,
            PRICE = params.price,
        }

        self:checkNotNil(dto.TRANS_ID, "trans_id")
        self:checkNotNil(dto.ACCOUNT, "account")
        self:checkNotNil(dto.CLIENT_CODE, "client_code")
        self:checkNotNil(dto.SECCODE, "idStock")
        self:checkNotNil(dto.CLASSCODE, "class")
        self:checkNotNil(dto.QUANTITY, "qty")
        self:checkNotNil(dto.PRICE, "price")

        self:add(dto)
    end,

    -- рыночная заявка на покупку
    OrderMarketBuy = function(self, params)
        local dto = {
            ACTION = "NEW_ORDER",
            TYPE = "M",
            OPERATION = "B",

            TRANS_ID = params.trans_id,

            ACCOUNT = params.account,
            CLIENT_CODE = params.client_code,

            SECCODE = params.idStock,
            CLASSCODE = params.class,

            QUANTITY = params.qty,
            PRICE = params.price,
        }

        self:checkNotNil(dto.TRANS_ID, "trans_id")
        self:checkNotNil(dto.ACCOUNT, "account")
        self:checkNotNil(dto.CLIENT_CODE, "client_code")
        self:checkNotNil(dto.SECCODE, "idStock")
        self:checkNotNil(dto.CLASSCODE, "class")
        self:checkNotNil(dto.QUANTITY, "qty")
        self:checkNotNil(dto.PRICE, "price")

        self:add(dto)
    end,

    -- рыночная заявка на продажу
    OrderMarketSell = function(self, params)
        local dto = {
            ACTION = "NEW_ORDER",
            TYPE = "M",
            OPERATION = "S",

            TRANS_ID = params.trans_id,

            ACCOUNT = params.account,
            CLIENT_CODE = params.client_code,

            SECCODE = params.idStock,
            CLASSCODE = params.class,

            QUANTITY = params.qty,
            PRICE = params.price,
        }

        self:checkNotNil(dto.TRANS_ID, "trans_id")
        self:checkNotNil(dto.ACCOUNT, "account")
        self:checkNotNil(dto.CLIENT_CODE, "client_code")
        self:checkNotNil(dto.SECCODE, "idStock")
        self:checkNotNil(dto.CLASSCODE, "class")
        self:checkNotNil(dto.QUANTITY, "qty")
        self:checkNotNil(dto.PRICE, "price")

        self:add(dto)
    end,

    -- удаление заявки по номеру
    OrderDelete = function(self, params)
        local dto = {
            ACTION = "KILL_ORDER",
            TRANS_ID = params.trans_id,
            SECCODE = params.idStock,
            CLASSCODE = params.class,
            ORDER_KEY = params.order_num,
        }

        self:checkNotNil(dto.TRANS_ID, "trans_id")
        self:checkNotNil(dto.SECCODE, "idStock")
        self:checkNotNil(dto.CLASSCODE, "class")
        self:checkNotNil(dto.ORDER_KEY, "order_num")

        self:add(dto)
    end,

    -- лимитный стоп-ордер на покупку
    StopOrderLimitBuy = function(self, params)
        local dto = {
            ACTION = "NEW_STOP_ORDER",
            OPERATION = "B",
            CONDITION = "5", -- Направленность стоп-цены. Возможные значения: «4» - меньше или равно, «5» – больше или равно

            TRANS_ID = params.trans_id,

            ACCOUNT = params.account,
            CLIENT_CODE = params.client_code,

            SECCODE = params.idStock,
            CLASSCODE = params.class,

            QUANTITY = params.qty,

            PRICE = params.price,
            STOPPRICE = params.stopPrice,

            EXPIRY_DATE = "GTC",
        }

        self:checkNotNil(dto.TRANS_ID, "trans_id")
        self:checkNotNil(dto.ACCOUNT, "account")
        self:checkNotNil(dto.CLIENT_CODE, "client_code")
        self:checkNotNil(dto.SECCODE, "idStock")
        self:checkNotNil(dto.CLASSCODE, "class")
        self:checkNotNil(dto.QUANTITY, "qty")
        self:checkNotNil(dto.PRICE, "price")
        self:checkNotNil(dto.STOPPRICE, "stopPrice")

        -- цена покупки < стоп цены
        --if dto.PRICE >= dto.STOPPRICE then
        if dto.PRICE > dto.STOPPRICE then
            error("\r\n" .. "Error: (Цена покупки) должна быть меньше (стоп цены)", 2)
        end

        self:add(dto)
    end,

    -- лимитный стоп-ордер на продажу
    StopOrderLimitSell = function(self, params)
        local dto = {
            ACTION = "NEW_STOP_ORDER",
            OPERATION = "S",
            CONDITION = "4", -- Направленность стоп-цены. Возможные значения: «4» - меньше или равно, «5» – больше или равно

            TRANS_ID = params.trans_id,

            ACCOUNT = params.account,
            CLIENT_CODE = params.client_code,

            SECCODE = params.idStock,
            CLASSCODE = params.class,

            QUANTITY = params.qty,

            PRICE = params.price,
            STOPPRICE = params.stopPrice,

            EXPIRY_DATE = "GTC",
        }

        self:checkNotNil(dto.TRANS_ID, "trans_id")
        self:checkNotNil(dto.ACCOUNT, "account")
        self:checkNotNil(dto.CLIENT_CODE, "client_code")
        self:checkNotNil(dto.SECCODE, "idStock")
        self:checkNotNil(dto.CLASSCODE, "class")
        self:checkNotNil(dto.QUANTITY, "qty")
        self:checkNotNil(dto.PRICE, "price")
        self:checkNotNil(dto.STOPPRICE, "stopPrice")

        -- цена продажи > стоп цены
        --if dto.PRICE <= dto.STOPPRICE then
        if dto.PRICE < dto.STOPPRICE then
            error("\r\n" .. "Error: (Цена продажи) должна быть больше (стоп цены)", 2)
        end

        self:add(dto)
    end,

    -- рыночный стоп-ордер на покупку
    StopOrderMarketBuy = function(self, params)
        local dto = {
            ACTION = "NEW_STOP_ORDER",
            OPERATION = "B",
            CONDITION = "5", -- Направленность стоп-цены. Возможные значения: «4» - меньше или равно, «5» – больше или равно

            TRANS_ID = params.trans_id,

            ACCOUNT = params.account,
            CLIENT_CODE = params.client_code,

            SECCODE = params.idStock,
            CLASSCODE = params.class,

            QUANTITY = params.qty,

            PRICE = params.price,
            STOPPRICE = params.stopPrice,

            EXPIRY_DATE = "GTC",
        }

        self:checkNotNil(dto.TRANS_ID, "trans_id")
        self:checkNotNil(dto.ACCOUNT, "account")
        self:checkNotNil(dto.CLIENT_CODE, "client_code")
        self:checkNotNil(dto.SECCODE, "idStock")
        self:checkNotNil(dto.CLASSCODE, "class")
        self:checkNotNil(dto.QUANTITY, "qty")
        self:checkNotNil(dto.PRICE, "price")
        self:checkNotNil(dto.STOPPRICE, "stopPrice")

        -- цена покупки > стоп цены
        if dto.PRICE <= dto.STOPPRICE then
            error("\r\n" .. "Error: (Цена покупки) должна быть больше (стоп цены)", 2)
        end

        self:add(dto)
    end,

    -- рыночный стоп-ордер на продажу
    StopOrderMarketSell = function(self, params)
        local dto = {
            ACTION = "NEW_STOP_ORDER",
            OPERATION = "S",
            CONDITION = "4", -- Направленность стоп-цены. Возможные значения: «4» - меньше или равно, «5» – больше или равно

            TRANS_ID = params.trans_id,

            ACCOUNT = params.account,
            CLIENT_CODE = params.client_code,

            SECCODE = params.idStock,
            CLASSCODE = params.class,

            QUANTITY = params.qty,

            PRICE = params.price,
            STOPPRICE = params.stopPrice,

            EXPIRY_DATE = "GTC",
        }

        self:checkNotNil(dto.TRANS_ID, "trans_id")
        self:checkNotNil(dto.ACCOUNT, "account")
        self:checkNotNil(dto.CLIENT_CODE, "client_code")
        self:checkNotNil(dto.SECCODE, "idStock")
        self:checkNotNil(dto.CLASSCODE, "class")
        self:checkNotNil(dto.QUANTITY, "qty")
        self:checkNotNil(dto.PRICE, "price")
        self:checkNotNil(dto.STOPPRICE, "stopPrice")

        -- цена продажи < стоп цены
        if dto.PRICE >= dto.STOPPRICE then
            error("\r\n" .. "Error: (Цена продажи) должна быть меньше (стоп цены)", 2)
        end

        self:add(dto)
    end,

    -- рыночный стоп-ордер на покупку со связанной заявкой
    StopOrderMarketBuyLink = function(self, params)
        local dto = {
            ACTION = "NEW_STOP_ORDER",
            STOP_ORDER_KIND = "WITH_LINKED_LIMIT_ORDER",
            KILL_IF_LINKED_ORDER_PARTLY_FILLED = "NO",
            OPERATION = "B",
            CONDITION = "5", -- Направленность стоп-цены. Возможные значения: «4» - меньше или равно, «5» – больше или равно

            TRANS_ID = params.trans_id,

            ACCOUNT = params.account,
            CLIENT_CODE = params.client_code,

            SECCODE = params.idStock,
            CLASSCODE = params.class,

            QUANTITY = params.qty,
            PRICE = params.price,
            STOPPRICE = params.stopPrice,

            LINKED_ORDER_PRICE = params.linkedPrice,
        }

        self:checkNotNil(dto.TRANS_ID, "trans_id")
        self:checkNotNil(dto.ACCOUNT, "account")
        self:checkNotNil(dto.CLIENT_CODE, "client_code")
        self:checkNotNil(dto.SECCODE, "idStock")
        self:checkNotNil(dto.CLASSCODE, "class")
        self:checkNotNil(dto.QUANTITY, "qty")
        self:checkNotNil(dto.PRICE, "price")
        self:checkNotNil(dto.STOPPRICE, "stopPrice")
        self:checkNotNil(dto.LINKED_ORDER_PRICE, "linkedPrice")

        -- цена покупки > стоп цены
        if dto.PRICE <= dto.STOPPRICE then
            error("\r\n" .. "Error: (Цена покупки) должна быть больше (стоп цены)", 2)
        end

        -- цена покупки связанной заявки < стоп цены
        if dto.LINKED_ORDER_PRICE >= dto.STOPPRICE then
            error("\r\n" .. "Error: (Цена покупки связанной заявки) должна быть меньше (стоп цены)", 2)
        end

        self:add(dto)
    end,

    -- рыночный стоп-ордер на продажу со связанной заявкой
    StopOrderMarketSellLink = function(self, params)
        local dto = {
            ACTION = "NEW_STOP_ORDER",
            STOP_ORDER_KIND = "WITH_LINKED_LIMIT_ORDER",
            KILL_IF_LINKED_ORDER_PARTLY_FILLED = "NO",
            OPERATION = "S",
            CONDITION = "4", -- Направленность стоп-цены. Возможные значения: «4» - меньше или равно, «5» – больше или равно

            TRANS_ID = params.trans_id,

            ACCOUNT = params.account,
            CLIENT_CODE = params.client_code,

            SECCODE = params.idStock,
            CLASSCODE = params.class,

            QUANTITY = params.qty,
            PRICE = params.price,
            STOPPRICE = params.stopPrice,

            LINKED_ORDER_PRICE = params.linkedPrice,
        }

        self:checkNotNil(dto.TRANS_ID, "trans_id")
        self:checkNotNil(dto.ACCOUNT, "account")
        self:checkNotNil(dto.CLIENT_CODE, "client_code")
        self:checkNotNil(dto.SECCODE, "idStock")
        self:checkNotNil(dto.CLASSCODE, "class")
        self:checkNotNil(dto.QUANTITY, "qty")
        self:checkNotNil(dto.PRICE, "price")
        self:checkNotNil(dto.STOPPRICE, "stopPrice")
        self:checkNotNil(dto.LINKED_ORDER_PRICE, "linkedPrice")

        -- цена продажи < стоп цены
        if dto.PRICE >= dto.STOPPRICE then
            error("\r\n" .. "Error: (Цена продажи) должна быть меньше (стоп цены)", 2)
        end

        -- цена продажи связанной заявки > стоп цены
        if dto.LINKED_ORDER_PRICE <= dto.STOPPRICE then
            error("\r\n" .. "Error: (Цена продажи связанной заявки) должна быть больше (стоп цены)", 2)
        end

        self:add(dto)
    end,

    -- удаление стоп-заявки
    StopOrderDelete = function(self, params)
        local dto = {
            ACTION = "KILL_STOP_ORDER",
            TRANS_ID = params.trans_id,
            CLASSCODE = params.class,
            STOP_ORDER_KEY = params.order_num,
        }

        self:checkNotNil(dto.TRANS_ID, "trans_id")
        self:checkNotNil(dto.CLASSCODE, "class")
        self:checkNotNil(dto.STOP_ORDER_KEY, "order_num")

        self:add(dto)
    end,

}

return TransactDispatcher
