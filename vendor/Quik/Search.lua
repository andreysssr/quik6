---

local Search = {
    --
    name = "Quik_Search",

    new = function(self)
        return self
    end,

    -- образец метода поиска активной заявки
    -- https://forum.quik.ru/forum10/topic3348/
    search = function(self)
        function myFind(F)
            return (bit.band(F, 0x1) ~= 0)    -- вернёт true если значение не равно 0
        end

        local ord = "orders"
        local orders = SearchItems(ord, 0, getNumberOf(ord) - 1, myFind, "flags")

        local transaction = {}

        if (orders ~= nil) and (#orders > 0) then
            for i = 1, #orders do
                transaction = {
                    TRANS_ID = tostring(1000 * os.clock),
                    ACTION = "KILL_ORDERS",
                    CLASSCODE = c_code,
                    SECCODE = getItem(ord, orders[i].sec_code),
                    ORDER_KEY = tostring(getItem(ord, orders[i].order_num))
                }

                local res = sendTransaction(transaction)
            end
        end

    end,

}

return Search
