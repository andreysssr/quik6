--- Handler PoleStock

local Handler = {
    --
    name = "Handler_PoleStock",

    --
    container = {},

    --
    storage = {},

    --
    entityServiceStock = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")
        self.entityServiceStock = container:get("EntityService_Stock")

        return self
    end,

    --
    getParams = function(self, idStock)
        local status = self.entityServiceStock:getStatus(idStock)
        --
        if status == "active" then
            return {
                stock_condition = "default"
            }
        end

        --
        if status == "limitedActive" then
            return {
                stock_condition = "limited"
            }
        end

        --
        if status == "notActive" then
            return {
                stock_condition = "disable"
            }
        end
    end,
}

return Handler
