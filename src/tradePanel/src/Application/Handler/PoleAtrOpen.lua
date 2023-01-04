--- Handler PoleAtrOpen

local Handler = {
    --
    name = "Handler_PoleAtrOpen",

    --
    entityServiceDs = {},

    --
    new = function(self, container)
        self.entityServiceDs = container:get("EntityService_DsD")

        return self
    end,

    --
    getParams = function(self, idStock)
        local atrOpen = self.entityServiceDs:getAtrOpen(idStock)

        local result = {}

        if is_number(atrOpen) then
            result.atrOpen_data = atrOpen
        end

        return result
    end,
}

return Handler
