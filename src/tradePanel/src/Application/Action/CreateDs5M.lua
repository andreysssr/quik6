--- Action

local Action = {
    --
    name = "Action_CreateDs5M",

    --
    container = {},

    --
    storage = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")

        return self
    end,

    --
    handle = function(self)
        -- ???????? ?????? ??????? ?? ???????
        local arrayTickers = self.storage:getHomeworkId()

        -- ? ????? ???????? ???????? Entity BasePrice
        for i = 1, #arrayTickers do
            -- ??????? ??????????? ??? BasePrice
            self.container:get("Factory_CreateEntityDs5M"):createEntity(arrayTickers[i])
        end
    end,

}

return Action
