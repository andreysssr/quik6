--- Action AddLevelsToChart

local Action = {
    --
    name = "Action_AddLevelsToChart",

    --
    container = {},

    --
    storage = {},

    -- ������ �������� ������� �� ���� ����� � ����� ���������� �����
    serviceClean = {},

    -- microservice
    levelsToChart = {},

    -- microservice
    basePriceToChart = {},

    --
    timer = {},

    --
    timerName = "",

    --
    timerPause = 0,

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")
        self.serviceClean = container:get("AppService_CleanChart")
        self.levelsToChart = container:get("MicroService_LevelsToChart")
        self.basePriceToChart = container:get("MicroService_BasePriceToChart")
        self.timer = container:get("Timer")
        self.timerName = container:get("config").chartTimer.timerName
        self.timerPause = container:get("config").chartTimer.timerPause

        return self
    end,

    -- ���������� ������� �� �������
    handle = function(self)
        local arrayStock = self.storage:getHomeworkId()

        for i = 1, #arrayStock do
            -- ��� ������ ������� - ������� ������
            self.serviceClean:clean(arrayStock[i])

            -- ��������� �� ������ ������ � �����
            self.levelsToChart:addLevelToId(arrayStock[i])

            -- ��������� �� ������ ����� basePrice � ����� 5% � 10% �� ����� �� ������� �����
            self.basePriceToChart:addBasePriceToId(arrayStock[i])
        end

        -- ���������� 1 ��� � 4 ������
        self.timer:set(self.timerName, self.timerPause)

    end,

    -- ����������� (����� ����� � �����)
    updateLocation = function(self)
        -- ������
        if self.timer:allows(self.timerName) then
            -- �������� ������
            self.levelsToChart:updateLocation()

            -- �������� ����� basePrice � ����������� ����� �� �������
            self.basePriceToChart:updateLocation()

            -- ���������� 1 ��� � 4 ������
            self.timer:set(self.timerName, self.timerPause)
        end
    end,
}

return Action
