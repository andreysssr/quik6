--- EventHandler ChangedBasePrice ���������� ����� basePrice �� ������� �� ������� ��������� ������ ����
-- �������� ��������� ������� ���� �� �������

local EventHandler = {
    --
    name = "EventHandler_ChangeLocationBasePriceLineOnChart",

    --
    basePriceToChart = {},

    --
    new = function(self, container)
        self.basePriceToChart = container:get("MicroService_BasePriceToChart")

        return self
    end,

    -- ���������� ��������� basePrice ��� ��������� ������� �� ��������� ������� ����
    handle = function(self, event)
        -- �������� id �� �������
        local id = event:getParam("id")

        -- ������ ��������� ����� basePrice
        self.basePriceToChart:updateLocationToId(id)
    end,

}

return EventHandler
