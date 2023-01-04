--- Handler PoleMaxLots

local Handler = {
    --
    name = "Handler_PoleMaxLots",

    --
    container = {},

    --
    entityServiceStock = {},

    --
    new = function(self, container)
        self.container = container
        self.entityServiceStock = container:get("EntityService_Stock")

        return self
    end,

    --
    getParams = function(self, idStock)
        local maxLots = self.entityServiceStock:getMaxLots(idStock)

        return {
            maxLots_data = maxLots
        }
    end,
}

return Handler
