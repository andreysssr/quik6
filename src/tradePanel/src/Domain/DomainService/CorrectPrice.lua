--- DomainService CorrectPrice - округляет цену до шага инструмента

local DomainService = {
    --
    name = "DomainService_CorrectPrice",

    --
    quik = {},

    --
    new = function(self, container)
        self.quik = container:get("Quik")

        return self
    end,

    -- вернуть цену скорректированную для покупки
    getPriceBuy = function(self, id, class, price)
        local step = self.quik:getStepSize(id, class)

        return d0(price + (price % step))
    end,

    -- вернуть цену скорректированную для продажи
    getPriceSell = function(self, id, class, price)
        local step = self.quik:getStepSize(id, class)

        return d0(price - (price % step))
    end,
}

return DomainService
