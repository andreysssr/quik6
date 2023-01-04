--- DomainService

local DomainService = {
    --
    name = "DomainService_GetBasePrice",

    --
    entityService = {},

    --
    new = function(self, container)
        self.entityService = container:get("EntityService_BasePrice")

        return self
    end,

    -- возвращает текущие данные basePrice для инструмента
    getBasePrice = function(self, id)
        return self.entityService:getBasePrice(id)
    end,
}

return DomainService
