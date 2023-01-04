--- Handler PoleLots

local Handler = {
    --
    name = "Handler_PoleLots",

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
        local lots = self.entityServiceStock:getLots(idStock)

        return {
            lots_data = lots
        }
    end,
}

return Handler
