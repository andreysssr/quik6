--- Factory CreateRepository ������� ��� �������� ������������ � ���������� �� � ���������

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
        -- �������� ��������� ������ �����������
        local repository = self.container:get("Repository_Interface"):newChild(nameRepository)

        -- ���������� ����������� � ���������
        self.container:setService(nameRepository, repository)
    end,
}

return Factory
