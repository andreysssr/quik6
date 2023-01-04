--- EventHandler ViewBasePriceToChart

local EventHandler = {
    --
    name = "EventHandler_ViewBasePriceToChart",

    --
    storage = {},

    --
    status = false,

    --
    arrayStock = {},

    --
    basePriceToChart = {},

    --
    timerName = {},

    --
    timerPause = {},

    --
    new = function(self, container)
        self.storage = container:get("Storage")

        self.arrayStock = self.storage:getHomeworkId()
        self.basePriceToChart = container:get("MicroService_BasePriceToChart")

        self.timer = container:get("Timer")
        self.timerName = container:get("config").timerViewBasePriceToChart.timerName
        self.timerPause = container:get("config").timerViewBasePriceToChart.timerPause

        self.timer:set(self.timerName, self.timerPause)
        return self
    end,

    --
    showAll = function(self)
        -- �������� ������
        self.basePriceToChart:updateLocation()
    end,

    --
    resetAll = function(self)
        self.basePriceToChart:removeAll()
    end,

    --
    handle = function(self)
        if self.status then
            self.status = false

            self:resetAll()
        else
            self.status = true

            self:showAll()
        end
    end,

    -- ����������� (����� ����� � �����)
    updateLocation = function(self)
        -- ������
        if self.timer:allows(self.timerName) and self.status then
            -- ���������� 1 ��� � �������������� �����
            self.timer:set(self.timerName, self.timerPause)

            -- �������� ������
            self.basePriceToChart:updateLocation()
        end
    end,

    -- ���������� ��������� basePrice ��� ��������� ������� �� ��������� ������� ����
    eventUpdateLocation = function(self, event)
        if self.status then
            -- �������� id �� �������
            local id = event:getParam("id")

            -- ������ ��������� ����� basePrice
            self.basePriceToChart:updateLocationToId(id)
        end
    end,
}

return EventHandler
