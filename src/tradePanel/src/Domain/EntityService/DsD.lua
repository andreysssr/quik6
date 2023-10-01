--- EntityService DsD - описание

local EntityService = {
    --
    name = "EntityService_DsD",

    --
    repository = {},

    --
    dispatcher = {},

    --
    new = function(self, container)
        self.repository = container:get("Repository_DsD")
        self.dispatcher = container:get("EventDispatcher")

        return self
    end,

    -- удаляет источник данных, отписывается от получения данных
    removeDs = function(self, idStock)
        local entity = self.repository:get(idStock)

        entity:removeDs()
    end,

    -- вернуть hi, low, close предыдущего дня
    getHiLowClosePreviousBar = function(self, idStock)
        local entity = self.repository:get(idStock)

        return entity:getHiLowClosePreviousBar()
    end,

    -- вернуть Гэп
    -- (вчерашнее закрытие) - (сегодняшнее открытие)
    -- абсолютная величина
    getGap = function(self, idStock)
        local entity = self.repository:get(idStock)

        return entity:getGap()
    end,

    -- ATR от вчерашнего закрытия
    -- (вчерашнее закрытие) - (текущая цена)
    getAtrClose = function(self, idStock)
        local entity = self.repository:get(idStock)

        return entity:getAtrClose()
    end,

    -- (цена открытия) - (текущая цена)
    getAtrOpen = function(self, idStock)
        local entity = self.repository:get(idStock)

        return entity:getAtrOpen()
    end,

    -- (цена открытия) - (текущая цена)
    getAtrOpen = function(self, idStock)
        local entity = self.repository:get(idStock)

        return entity:getAtrOpen()
    end,

    -- вернуть полный Atr текущего дневного бара
    -- (текущий Hi) - (текущий Low)
    getAtrFull = function(self, idStock)
        local entity = self.repository:get(idStock)

        return entity:getAtrFull()
    end,
}

return EntityService
