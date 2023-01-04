--- AppService CleanChart - �������� ������ �� ���� �����

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

    -- ������� ������ �� ���� ����� � �����
    clean = function(self, idStock)
        -- �������� id �������
        local tag = self.storage:getIdChart(idStock)

        -- ������� ������ �� ���� ����� � �����
        DelAllLabels(tag)
    end,

}

return AppService
