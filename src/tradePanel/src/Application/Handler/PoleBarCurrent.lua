--- Handler PoleBarCurrent

local Handler = {
    --
    name = "Handler_PoleBarCurrent",

    --
    entityServiceDs = {},

    --
    new = function(self, container)
        self.entityServiceDs = container:get("EntityService_Ds5M")

        return self
    end,

    --
    getParams = function(self, idStock)
        local barCurrent = self.entityServiceDs:getAtrBarCurrent(idStock)

        local result = {}

        if is_number(barCurrent) then
            result.barCurrent_data = barCurrent
        end

        if barCurrent > 5 then
            result.barCurrent_condition = "color5"
        else
            result.barCurrent_condition = "default"
        end

        return result
    end,
}

return Handler
