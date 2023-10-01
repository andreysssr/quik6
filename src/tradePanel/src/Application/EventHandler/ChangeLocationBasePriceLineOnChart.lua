--- EventHandler ChangedBasePrice обновление линии basePrice на графике по событию изменение базвой цены
-- изменить положение базовой цены на графике

local EventHandler = {
    --
    name = "EventHandler_ChangeLocationBasePriceLineOnChart",

    --
    basePriceToChart = {},

    --
    new = function(self, container)
        self.basePriceToChart = container:get("MicroService_BasePriceToChart")

        return self
    end,

    -- обновление положения basePrice при получении события об изменении базовой цены
    handle = function(self, event)
        -- получаем id из события
        local id = event:getParam("id")

        -- меняем положение линии basePrice
        self.basePriceToChart:updateLocationToId(id)
    end,

}

return EventHandler
