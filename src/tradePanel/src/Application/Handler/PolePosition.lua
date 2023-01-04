--- Handler PolePosition

local Handler = {
    --
    name = "Handler_PolePosition",

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
        local position = self.entityServiceStock:getPositionParams(idStock)

        local result = {}

        if position.qty == 0 then
            return result
        end

        if position.qty ~= 0 then
            result.position_data = position.qty

            if position.operation == "buy" then
                result.position_condition = "long"
            else
                result.position_condition = "short"
            end
        end

        return result
    end,
}

return Handler
