---

local Repository = {
    --
    name = "Repository_Interface",

    -- контроллер
    new = function(self)
        return self
    end,

    -- создаёт новый репозиторий который наследуется от текущего
    newChild = function(self, nameRepository)
        local repository = {
            name = nameRepository,
            data = {}
        }

        -- созданный объект наследуется от текущего
        setmetatable(repository, self)
        self.__index = self

        return repository
    end,

    save = function(self, entity, id)
        local _id = id or entity:getId()

        self.data[_id] = entity
    end,

    -- получение инструмента из репозитория по коду инструмента
    get = function(self, id)
        return self.data[id]
    end,

    -- получение всех инструментов
    getAll = function(self)
        return self.data
    end,

    -- проверка существование "id"
    has = function(self, id)
        -- возвращает результат существования в репозитории сущности с запрошенным "id"
        if isset(self.data[id]) then
            return true
        else
            return false
        end
    end,

    -- удалить из репозитория объект с переданным "id"
    remove = function(self, id)
        self.data[id] = nil
    end,
}

return Repository
