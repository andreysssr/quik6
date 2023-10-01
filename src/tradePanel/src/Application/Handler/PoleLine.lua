--- Handler PoleLine

local Handler = {
    --
    name = "Handler_PoleLine",

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

        -- отступ цены от цены уровня интервала
        local offset = math.abs(lastPrice - price)

        -- отступ цены от цены уровня интервала в %
        local range = 0

        -- если это центральная линия
        if basePrice.type == "line" then

            if offset == 0 then
                result.line_data = 0

                return result
            end

            -- находим отступ в %
            range = offset / (basePrice.interval / 100)

            -- округляем до целого большего числа
            range = math.ceil(range)

            -- меняем содержимое поля
            result.line_data = range

            if range < 10 then
                result.line_condition = "color10"
            end

            if range < 5 then
                result.line_condition = "color5"
            end

            return result
        end

        return result
    end,
}

return Handler
