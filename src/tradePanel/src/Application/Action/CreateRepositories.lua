--- Action Create Repositories

local Action = {
    --
    name = "Action_CreateRepositories",

    --
    container = {},

    --
    new = function(self, container)
        self.container = container

        return self
    end,

    handle = function(self)
        -- создать репозиторий для BasePrice
        self.container:get("Factory_CreateRepository"):createRepository("Repository_BasePrice")

        -- создать репозиторий для EntityStock
        self.container:get("Factory_CreateRepository"):createRepository("Repository_Stock")

        -- создать репозиторий для EntityTransact
        self.container:get("Factory_CreateRepository"):createRepository("Repository_Transact")

        -- создать репозиторий для EntityTradeParams
        self.container:get("Factory_CreateRepository"):createRepository("Repository_TradeParams")

        -- создать репозиторий для иссточников данных пятиминуток
        self.container:get("Factory_CreateRepository"):createRepository("Repository_Ds5M")

        -- создать репозиторий для иссточников данных дневок
        self.container:get("Factory_CreateRepository"):createRepository("Repository_DsD")

        -- создать репозиторий для иссточников данных часовиков
        self.container:get("Factory_CreateRepository"):createRepository("Repository_DsH1")
    end,

}

return Action
