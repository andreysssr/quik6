--- Factory CreateEntityBasePrice

local Factory = {
    --
    name = "Factory_CreateEntityDsH1",

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
        self.repositoryDs = container:get("Repository_DsH1")

        return self
    end,

    -- создание Entity_BasePrice и сохранение его в репозиторий
    createEntity = function(self, idStock)
        local class = self.storage:getClassToId(idStock)

        local interval = self.storage:getIntervalToId(idStock)

        -- Создаем таблицу со всеми свечами нужного интервала, класса и кода
        local ds, error_desc = CreateDataSource(class, idStock, INTERVAL_H1)

        -- получаем источник данных
        local classEntityDs = self.container:get("Entity_Ds")

        local entity = {
            --
            events = {},
            numLastBar = 0,

            name = "Entity_Ds",
            id = idStock,
            class = class,
            interval = interval,

            ds = ds,
        }

        extended(entity, classEntityDs)

        self.repositoryDs:save(entity)
    end,

}

return Factory
