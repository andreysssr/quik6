--- Handler PoleLastPrice

local Handler = {
    --
    name = "Handler_PoleLastPrice",

    --
    container = {},

    --
    storage = {},

    --
    servicePrices = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")
        self.servicePrices = container:get("AppService_ServicePrices")

        return self
    end,

    --
    getParams = function(self, idStock)
        local result = {}

        local class = self.storage:getClassToId(idStock)
        local lastPrice = self.servicePrices:getLastPrice(idStock, class)

        if not_number(lastPrice) then
            return {}
        end

        result.lastPrice_data = lastPrice

        return result
    end,
}

return Handler
