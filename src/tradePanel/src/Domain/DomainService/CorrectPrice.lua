--- DomainService CorrectPrice - ��������� ���� �� ���� �����������

local DomainService = {
    --
    name = "DomainService_CorrectPrice",

    --
    quik = {},

    --
    new = function(self, container)
        self.quik = container:get("Quik")

        return self
    end,

    -- ������� ���� ����������������� ��� �������
    getPriceBuy = function(self, id, class, price)
        local step = self.quik:getStepSize(id, class)

        return d0(price + (price % step))
    end,

    -- ������� ���� ����������������� ��� �������
    getPriceSell = function(self, id, class, price)
        local step = self.quik:getStepSize(id, class)

        return d0(price - (price % step))
    end,
}

return DomainService
