--- Handler Take

local Handler = {
    --
    name = "Handler_Take",

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
        local statusTake = self.entityServiceStock:isActiveTake(idStock)
        local sizeTake = self.entityServiceStock:getTakeSize(idStock)

        local nameOn = "take" .. tostring(sizeTake) .. "_condition"

        local result = {}

        if statusTake then
            result = {
                -- записываем все в дефолтный цвет строки
                take2_condition = "default",
                take3_condition = "default",
                take4_condition = "default",
                take5_condition = "default",
                take6_condition = "default",
                take7_condition = "default",
                take8_condition = "default",

                -- выбранный размер переписываем в включённый
                [nameOn] = "on"
            }
        else
            result = {
                -- записываем все в дефолтный цвет строки
                take2_condition = "off",
                take3_condition = "off",
                take4_condition = "off",
                take5_condition = "off",
                take6_condition = "off",
                take7_condition = "off",
                take8_condition = "off",
            }
        end

        return result
    end,
}

return Handler
