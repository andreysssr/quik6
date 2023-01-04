--- EventHandler UpdateMaxLots - описание

local EventHandler = {
    --
    name = "EventHandler_UpdateMaxLots",

    --
    storage = {},

    --
    entityServiceStock = {},

    --
    new = function(self, container)
        self.storage = container:get("Storage")
        self.entityServiceStock = container:get("EntityService_Stock")

        return self
    end,

    --
    handle = function(self)
        -- получаем массив тикеров по домашке
        local arrayTickers = self.storage:getHomeworkId()

        -- в цикле вызываем создание Entity BasePrice
        for i = 1, #arrayTickers do
            self.entityServiceStock:calculateMaxLots(arrayTickers[i])
        end
    end,

}

return EventHandler
