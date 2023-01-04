--- Handler PoleCenter

local Handler = {
    --
    name = "Handler_PoleCenter",

    --
    container = {},

    --
    storage = {},

    --
    entityServiceBasePrice = {},

    --
    servicePrices = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")
        self.entityServiceBasePrice = container:get("EntityService_BasePrice")
        self.servicePrices = container:get("AppService_ServicePrices")

        return self
    end,

    --
    getParams = function(self, idStock)
        local result = {}

        local class = self.storage:getClassToId(idStock)

        local basePrice = self.entityServiceBasePrice:getBasePrice(idStock)
        local lastPrice = self.servicePrices:getLastPrice(idStock, class)

        local price = basePrice.price

        if not_number(price) or not_number(lastPrice) then
            return {}
        end

        -- отсуп цены от цены уровня интервала
        local offset = math.abs(lastPrice - price)

        -- отсуп цены от цены уровня интервала в %
        local range = 0

        -- если это центральная линия
        if basePrice.type == "center" then

            if offset == 0 then
                result.center_data = 0
                --result.center_condition = "center0"

                return result
            end

            -- находим отсуп в %
            range = offset / (basePrice.interval / 100)

            -- округляем до целого большего числа
            range = math.ceil(range)

            -- меняем содержимое поля
            result.center_data = range

            if range < 10 then
                result.center_condition = "color10"
            end

            if range < 5 then
                result.center_condition = "color5"
            end

            return result
        end

        return result
    end,
}

return Handler
