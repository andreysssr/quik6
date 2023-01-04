--- Handler PoleOrdersAll

local Handler = {
    --
    name = "Handler_PoleOrdersAll",

    --
    container = {},

    --
    storage = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")

        return self
    end,

    -- // typeOrders = "orders", "stop_orders"
    find = function(self, typeOrders, idStock)
        local table = ""

        if typeOrders == "orders" then
            table = "orders"
        end

        if typeOrders == "stop_orders" then
            table = "stop_orders"
        end

        function myFind(F, sec_code)
            if sec_code == idStock and (bit.band(F, 0x1) ~= 0) then
                return true
            end

            return false
        end

        local orders = SearchItems(table, 0, getNumberOf(table) - 1, myFind, "flags, sec_code")

        if (orders ~= nil) and (#orders > 0) then
            return true
        end

        return false
    end,

    --
    isOrders = function(self, idStock)
        if self:find("orders", idStock) then
            return true
        end

        if self:find("stop_orders", idStock) then
            return true
        end

        return false
    end,

    --
    getParams = function(self, idStock)
        if self:isOrders(idStock) then
            return {
                ordersAll_condition = "active"
            }
        else
            return {
                ordersAll_condition = "default"
            }
        end
    end,
}

return Handler
