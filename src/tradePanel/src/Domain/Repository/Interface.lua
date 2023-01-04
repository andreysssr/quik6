---

local Repository = {
    --
    name = "Repository_Interface",

    -- ����������
    new = function(self)
        return self
    end,

    -- ������ ����� ����������� ������� ����������� �� ��������
    newChild = function(self, nameRepository)
        local repository = {
            name = nameRepository,
            data = {}
        }

        -- ��������� ������ ����������� �� ��������
        setmetatable(repository, self)
        self.__index = self

        return repository
    end,

    save = function(self, entity, id)
        local _id = id or entity:getId()

        self.data[_id] = entity
    end,

    -- ��������� ����������� �� ����������� �� ���� �����������
    get = function(self, id)
        return self.data[id]
    end,

    -- ��������� ���� ������������
    getAll = function(self)
        return self.data
    end,

    -- �������� ������������� "id"
    has = function(self, id)
        -- ���������� ��������� ������������� � ����������� �������� � ����������� "id"
        if isset(self.data[id]) then
            return true
        else
            return false
        end
    end,

    -- ������� �� ����������� ������ � ���������� "id"
    remove = function(self, id)
        self.data[id] = nil
    end,
}

return Repository
