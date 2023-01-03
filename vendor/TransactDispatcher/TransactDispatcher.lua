--- ���������� ���������� �� ������ �������

local TransactDispatcher = {
    --
    nome = "TransactDispatcher",

    --
    timer = {},

    -- �������� �������
    nameTimer = "",

    -- ����� ������� � ��������
    pauseTime = 0,

    -- ���������� ���������� ������
    countTransactions = 0,

    --
    queue = {},

    --
    eventSender = {},

    -- ������ ������� ������� � ����-������� ������� ��������� �� ��������
    -- ����� �������� ��������� �������� �� ��������
    data_KILL = {},

    --
    new = function(self, container)
        self.timer = container:get("Timer")

        self.nameTimer = container:get("config").transaction.nameTimer
        self.pauseTime = container:get("config").transaction.pauseTime
        self.countTransactions = container:get("config").transaction.countTransactions

        self.queue = container:get("Queue")
        self.eventSender = container:get("AppService_EventSender")

        -- ������ ����������� ���� ������� ���� �� ������ � �� ������ ����������
        self.timer:set(self.nameTimer, self.pauseTime)

        return self
    end,

    -- ��������� ������� ����������
    dispatch = function(self)
        -- ��������� ������ - ����� �� ������������ �������
        if not self.timer:allows(self.nameTimer) then
            return
        end

        -- ������������ ���������� ���������� ������
        for i = 0, self.countTransactions do
            -- ���� ������� ������
            if self.queue:isEmpty() then
                break -- ������� �� �����

                return
            end

            -- ���� ���������� �� ������� ��� ��������
            local transact = self.queue:dequeue()

            -- ��������� �������� ����������
            local result = sendTransaction(transact)

            if result ~= "" then
                dd("=====================================================")
                dd("sendTransaction - " .. tostring(result))
                dd(result)
                dd(transact)
                dd("=====================================================")

                -- ������ ������� ������ ����������
                self.eventSender:send("Alert", {
                    alert = "������ ����������: " .. result
                })

                break
            end

            -- ������ ����������� ���� ������� ���� �� ������ � �� ������ ����������
            self.timer:set(self.nameTimer, self.pauseTime)
        end
    end,

    -- ��� �������� ������ ������ ���� �� 0
    checkMarketPrice = function(self, dto)
        if dto["TYPE"] == "M" then
            dto["PRICE"] = "0"
        end

        return dto
    end,

    -- ��������� ��� �������� ������� � ������
    converterToString = function(self, array)
        for key, value in pairs(array) do
            if not_string(value) then
                array[key] = tostring(value)
            end
        end

        return array
    end,

    -- ��������� ���������� � ��������� ����������
    add = function(self, dto)
        -- ���� ��� �������� ����-������ - ��������� �� ������� �� ��� ������
        if dto["ACTION"] == "KILL_ORDER" or dto["ACTION"] == "KILL_STOP_ORDER" then
            -- ���� ������ ����� ����-������ ��� - ����� ��������� ����������
            local num = dto["ORDER_KEY"] or dto["STOP_ORDER_KEY"]

            -- ���� ������ �������� ��� ����
            if self.data_KILL[num] then
                return
            end

            -- ��������� ����� ����-������
            self.data_KILL[num] = 1
        end

        -- ��������� ��� �������� �������� � ���������
        local transact = self:converterToString(dto)
        transact = self:checkMarketPrice(transact)

        -- ��������� ���������� � �������
        self.queue:enqueue(transact)
    end,

    -- val - ������� ��������
    -- name - �������� ��������� �������
    checkNotNil = function(self, val, name)
        if is_nil(val) then
            error("Error: ������: �������� (" .. name .. ") �� �������.", 3)
        end
    end,

    -- �������� ������ �� �������
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

    -- �������� ������ �� �������
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

    -- �������� ������ �� �������
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

    -- �������� ������ �� �������
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

    -- �������� ������ �� ������
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

    -- �������� ����-����� �� �������
    StopOrderLimitBuy = function(self, params)
        local dto = {
            ACTION = "NEW_STOP_ORDER",
            OPERATION = "B",
            CONDITION = "5", -- �������������� ����-����. ��������� ��������: �4� - ������ ��� �����, �5� � ������ ��� �����

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

        -- ���� ������� < ���� ����
        --if dto.PRICE >= dto.STOPPRICE then
        if dto.PRICE > dto.STOPPRICE then
            error("\r\n" .. "Error: (���� �������) ������ ���� ������ (���� ����)", 2)
        end

        self:add(dto)
    end,

    -- �������� ����-����� �� �������
    StopOrderLimitSell = function(self, params)
        local dto = {
            ACTION = "NEW_STOP_ORDER",
            OPERATION = "S",
            CONDITION = "4", -- �������������� ����-����. ��������� ��������: �4� - ������ ��� �����, �5� � ������ ��� �����

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

        -- ���� ������� > ���� ����
        --if dto.PRICE <= dto.STOPPRICE then
        if dto.PRICE < dto.STOPPRICE then
            error("\r\n" .. "Error: (���� �������) ������ ���� ������ (���� ����)", 2)
        end

        self:add(dto)
    end,

    -- �������� ����-����� �� �������
    StopOrderMarketBuy = function(self, params)
        local dto = {
            ACTION = "NEW_STOP_ORDER",
            OPERATION = "B",
            CONDITION = "5", -- �������������� ����-����. ��������� ��������: �4� - ������ ��� �����, �5� � ������ ��� �����

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

        -- ���� ������� > ���� ����
        if dto.PRICE <= dto.STOPPRICE then
            error("\r\n" .. "Error: (���� �������) ������ ���� ������ (���� ����)", 2)
        end

        self:add(dto)
    end,

    -- �������� ����-����� �� �������
    StopOrderMarketSell = function(self, params)
        local dto = {
            ACTION = "NEW_STOP_ORDER",
            OPERATION = "S",
            CONDITION = "4", -- �������������� ����-����. ��������� ��������: �4� - ������ ��� �����, �5� � ������ ��� �����

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

        -- ���� ������� < ���� ����
        if dto.PRICE >= dto.STOPPRICE then
            error("\r\n" .. "Error: (���� �������) ������ ���� ������ (���� ����)", 2)
        end

        self:add(dto)
    end,

    -- �������� ����-����� �� ������� �� ��������� �������
    StopOrderMarketBuyLink = function(self, params)
        local dto = {
            ACTION = "NEW_STOP_ORDER",
            STOP_ORDER_KIND = "WITH_LINKED_LIMIT_ORDER",
            KILL_IF_LINKED_ORDER_PARTLY_FILLED = "NO",
            OPERATION = "B",
            CONDITION = "5", -- �������������� ����-����. ��������� ��������: �4� - ������ ��� �����, �5� � ������ ��� �����

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

        -- ���� ������� > ���� ����
        if dto.PRICE <= dto.STOPPRICE then
            error("\r\n" .. "Error: (���� �������) ������ ���� ������ (���� ����)", 2)
        end

        -- ���� ������� ��������� ������ < ���� ����
        if dto.LINKED_ORDER_PRICE >= dto.STOPPRICE then
            error("\r\n" .. "Error: (���� ������� ��������� ������) ������ ���� ������ (���� ����)", 2)
        end

        self:add(dto)
    end,

    -- �������� ����-����� �� ������� �� ��������� �������
    StopOrderMarketSellLink = function(self, params)
        local dto = {
            ACTION = "NEW_STOP_ORDER",
            STOP_ORDER_KIND = "WITH_LINKED_LIMIT_ORDER",
            KILL_IF_LINKED_ORDER_PARTLY_FILLED = "NO",
            OPERATION = "S",
            CONDITION = "4", -- �������������� ����-����. ��������� ��������: �4� - ������ ��� �����, �5� � ������ ��� �����

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

        -- ���� ������� < ���� ����
        if dto.PRICE >= dto.STOPPRICE then
            error("\r\n" .. "Error: (���� �������) ������ ���� ������ (���� ����)", 2)
        end

        -- ���� ������� ��������� ������ > ���� ����
        if dto.LINKED_ORDER_PRICE <= dto.STOPPRICE then
            error("\r\n" .. "Error: (���� ������� ��������� ������) ������ ���� ������ (���� ����)", 2)
        end

        self:add(dto)
    end,

    -- �������� ����-������
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
