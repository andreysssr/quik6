--- Factory CreateRepository фабрика для создания репозиториев и добавления их в контейнер

local Factory = {
    --
    name = "Factory_CreateRepository",

    --
    container = {},

    --
    new = function(self, container)
        self.container = container

        return self
    end,

    createRepository = function(self, nameRepository)
        -- получаем экземпляр нового репозитория
        local repository = self.container:get("Repository_Interface"):newChild(nameRepository)

        -- добавление репозитория в контейнер
        self.container:setService(nameRepository, repository)
    end,
}

return Factory
