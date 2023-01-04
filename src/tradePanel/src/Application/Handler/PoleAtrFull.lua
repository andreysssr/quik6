--- Handler PoleAtrFull

local Handler = {
    --
    name = "Handler_PoleAtrFull",

    --
    entityServiceDs = {},

    --
    new = function(self, container)
        self.entityServiceDs = container:get("EntityService_DsD")

        return self
    end,

    --
    getParams = function(self, idStock)
        local atrFull = self.entityServiceDs:getAtrFull(idStock)

        local result = {}

        if is_number(atrFull) then
            result.atrFull_data = atrFull
        end

        if atrFull >= 70 then
            result.atrFull_condition = "color70"
        end

        if atrFull >= 100 then
            result.atrFull_condition = "color100"
        end

        if atrFull >= 150 then
            result.atrFull_condition = "color150"
        end

        if atrFull >= 200 then
            result.atrFull_condition = "color200"
        end

        return result
    end,
}

return Handler
