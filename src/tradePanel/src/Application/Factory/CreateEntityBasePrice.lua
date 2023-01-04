--- Factory CreateEntityBasePrice

local Factory = {
    --
    name = "Factory_CreateEntityBasePrice",

    --
    container = {},

    --
    storage = {},

    --
    quik = {},

    --
    repositoryBasePrice = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")
        self.quik = container:get("Quik")
        self.repositoryBasePrice = container:get("Repository_BasePrice")

        return self
    end,

    -- создание Entity_BasePrice и сохранение его в репозиторий
    createEntity = function(self, idTicker)
        local id = idTicker
        local class = self.storage:getClassToId(id)

        -- последняя цена инстурмента
        local lastPrice = self.quik:getLastPrice(id, class)

        -- проверка последней цены для инструмента
        if not_number(lastPrice) then
            error("\r\n" .. "Error: Последняя цена должна быть числом. Получено: (" .. type(lastPrice) .. ")")
        end

        -- количество интервалов для расчёта
        local countInterval = self.container:get("config").basePrice.countInterval

        -- параметры расчёта интервала
        local params = self.storage:getLevels(id, class, lastPrice, countInterval)

        if not_nil(params) then
            params.id = id
            params.class = class

            -- получаем класс Entity BasePrice
            local classEntityBase = self.container:get("Entity_BasePrice")

            -- получаем entity
            local entity = classEntityBase:newChild(params)

            -- запускаем инициализацию - расчёт данных
            entity:init()

            -- освобождаем блок событий
            local event = entity:releaseEvents()

            self.repositoryBasePrice:save(entity)

            return
        end

        -- выбрасываем ошибку - параметра для id не найдено
        error("\r\n" .. "Error: параметра для тикера с id - (" .. tostring(id) .. ") не найдено")
    end,
}

return Factory
