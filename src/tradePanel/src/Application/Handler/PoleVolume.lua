--- Handler PoleVolume

local Handler = {
    --
    name = "Handler_PoleVolume",

    --
    entityServiceDs = {},

    --
    new = function(self, container)
        self.entityServiceDs = container:get("EntityService_Ds5M")

        return self
    end,

    --
    getParams = function(self, idStock)
        local result = {
            volume1_condition = "default",
            volume2_condition = "default",
        }

        -- значения hi и low последних 3 баров
        local volume = self.entityServiceDs:getVolume(idStock)

        if volume == "notBar" then
            return result
        end

        if volume.bar1 > (volume.bar2 * 10) then
            result.volume1_condition = "active"
        end

        if volume.bar2 > (volume.bar3 * 10) then
            result.volume2_condition = "active"
        end

        return result
    end,
}

return Handler
