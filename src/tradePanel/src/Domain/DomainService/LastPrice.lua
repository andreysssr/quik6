--- DomainService LastPrice

local DomainService = {
    --
    name = "DomainService_LastPrice",

    --
    quik = {},

    --
    new = function(self, container)
        self.quik = container:get("Quik")

        return self
    end,

    -- возвращает последнюю цену инструмента
    getPrice = function(self, id, class)
        return self.quik:getLastPrice(id, class)
    end
}

return DomainService
