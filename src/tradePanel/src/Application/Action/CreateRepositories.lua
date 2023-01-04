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
        -- ������� ����������� ��� BasePrice
        self.container:get("Factory_CreateRepository"):createRepository("Repository_BasePrice")

        -- ������� ����������� ��� EntityStock
        self.container:get("Factory_CreateRepository"):createRepository("Repository_Stock")

        -- ������� ����������� ��� EntityTransact
        self.container:get("Factory_CreateRepository"):createRepository("Repository_Transact")

        -- ������� ����������� ��� EntityTradeParams
        self.container:get("Factory_CreateRepository"):createRepository("Repository_TradeParams")

        -- ������� ����������� ��� ����������� ������ �����������
        self.container:get("Factory_CreateRepository"):createRepository("Repository_Ds5M")

        -- ������� ����������� ��� ����������� ������ ������
        self.container:get("Factory_CreateRepository"):createRepository("Repository_DsD")

        -- ������� ����������� ��� ����������� ������ ���������
        self.container:get("Factory_CreateRepository"):createRepository("Repository_DsH1")
    end,

}

return Action
