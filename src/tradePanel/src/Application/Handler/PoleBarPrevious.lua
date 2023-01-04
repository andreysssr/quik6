--- Handler PoleBarPrevious

local Handler = {
    --
    name = "Handler_PoleBarPrevious",

    --
    entityServiceDs = {},

    --
    new = function(self, container)
        self.entityServiceDs = container:get("EntityService_Ds5M")

        return self
    end,

    --
    getParams = function(self, idStock)
        local barPrevious = self.entityServiceDs:getAtrBarPrev(idStock)

        local result = {}

        if is_number(barPrevious) then
            result.barPrevious_data = barPrevious
        end

        return result
    end,
}

return Handler
