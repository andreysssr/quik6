--- Handler PoleBarLimit

local Handler = {
    --
    name = "Handler_PoleBarLimit",

    --
    entityServiceDs = {},

    --
    entityServiceBasePrice = {},

    --
    new = function(self, container)
        self.entityServiceDs = container:get("EntityService_Ds5M")
        self.entityServiceBasePrice = container:get("EntityService_BasePrice")

        return self
    end,

    --
    getParams = function(self, idStock)
        local result = {
            barLimit_data = "",
            barLimit_condition = "default"
        }

        -- значения hi и low последних 3 баров
        local params = self.entityServiceDs:getHiLow(idStock)

        if params == "notBar" then
            return result
        end

        -- цена базового активного уровня
        local price = self.entityServiceBasePrice:getBasePrice(idStock).price

        -- если цена коснулась уровня (дошла до текущего активного уровня/линии)
        if price == params.bar1.hi or price == params.bar1.low then
            result.barLimit_data = "B - L"
            result.barLimit_condition = "touchColor"
        end

        -- если обнаружены лимитные бары (три подряд) или (два последние и 4-й от них)
        if price == params.bar1.hi and price == params.bar2.hi and (price == params.bar3.hi or price == params.bar4.hi) then
            result.barLimit_data = "L"
            result.barLimit_condition = "limitColor"
        elseif price == params.bar1.low and price == params.bar2.low and (price == params.bar3.low or price == params.bar4.low) then
            result.barLimit_data = "L"
            result.barLimit_condition = "limitColor"
        end

        return result
    end,
}

return Handler
