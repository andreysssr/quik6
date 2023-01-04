--- Handler PoleGap

local Handler = {
    --
    name = "Handler_PoleGap",

    --
    entityServiceDs = {},

    --
    new = function(self, container)
        self.entityServiceDs = container:get("EntityService_DsD")

        return self
    end,

    --
    getParams = function(self, idStock)
        local gap = self.entityServiceDs:getGap(idStock)

        local result = {}

        if is_number(gap) then
            result.gap_data = gap
        end

        return result
    end,
}

return Handler
