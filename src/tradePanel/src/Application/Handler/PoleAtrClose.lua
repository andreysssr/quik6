--- Handler PoleAtrClose

local Handler = {
    --
    name = "Handler_PoleAtrClose",

    --
    entityServiceDs = {},

    --
    new = function(self, container)
        self.entityServiceDs = container:get("EntityService_DsD")

        return self
    end,

    --
    getParams = function(self, idStock)
        local atrClose = self.entityServiceDs:getAtrClose(idStock)

        local result = {}

        if is_number(atrClose) then
            result.atrClose_data = atrClose
        end

        return result
    end,
}

return Handler
