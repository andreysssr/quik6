--- Handler MirrorLineToChart

local Handler = {
    --
    name = "Handler_MirrorLineToChart",

    --
    storage = {},

    --
    entityServiceDsD = {},

    --
    entityServiceDsH1 = {},

    --
    new = function(self, container)
        self.storage = container:get("Storage")
        self.entityServiceDsD = container:get("EntityService_DsD")
        self.entityServiceDsH1 = container:get("EntityService_DsH1")

        return self
    end,

    --
    getMirrorLineHi = function(self, idStock)
        local dayHi = self.entityServiceDsD:getHiLowClosePreviousBar(idStock).hi
        local dayClose = self.entityServiceDsD:getHiLowClosePreviousBar(idStock).close
        local result = dayClose - (dayHi - dayClose)

        return result
    end,

    --
    getMirrorLineLow = function(self, idStock)
        local dayLow = self.entityServiceDsD:getHiLowClosePreviousBar(idStock).low
        local dayClose = self.entityServiceDsD:getHiLowClosePreviousBar(idStock).close

        local result = dayClose + (dayClose - dayLow)

        return result
    end,
}

return Handler
