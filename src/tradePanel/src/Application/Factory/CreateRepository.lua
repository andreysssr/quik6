--- Factory CreateRepository фабрика дл€ создани€ репозиториев и добавлени€ их в контейнер

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
        -- получаем экземпл€р нового репозитори€
        local repository = self.container:get("Repository_Interface"):newChild(nameRepository)

        -- добавление репозитори€ в контейнер
        self.container:setService(nameRepository, repository)
    end,
}

return Factory
