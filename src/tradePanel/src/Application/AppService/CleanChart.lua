--- AppService CleanChart - отчищает график от всех меток

local AppService = {
    --
    name = "AppService_CleanChart",

    --
    storage = {},

    --
    new = function(self, container)
        self.storage = container:get("Storage")

        return self
    end,

    -- очищаем график от всех лниий и меток
    clean = function(self, idStock)
        -- получаем id графика
        local tag = self.storage:getIdChart(idStock)

        -- очищаем график от всех линий и меток
        DelAllLabels(tag)
    end,

}

return AppService
