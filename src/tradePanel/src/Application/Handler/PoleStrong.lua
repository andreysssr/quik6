--- Handler PoleStrong

local Handler = {
    --
    name = "Handler_PoleStrong",

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

        -- ������ ���� �� ���� ������ ���������
        local offset = math.abs(lastPrice - price)

        -- ������ ���� �� ���� ������ ��������� � %
        local range = 0

        if basePrice.type == "strong" then

            if offset == 0 then
                result.strong_data = 0

                return result
            end

            -- ������� ������ � %
            range = offset / (basePrice.interval / 100)

            -- ��������� �� ������ �������� �����
            range = math.ceil(range)

            result.strong_data = range

            if range < 10 then
                result.strong_condition = "color10"
            end

            if range < 5 then
                result.strong_condition = "color5"
            end

            return result
        end

        return result
    end,
}

return Handler
