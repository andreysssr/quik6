--- Action UpdateBasePrice ��������� basePrice ��� ���� ������������

local Action = {
    --
    name = "Action_UpdateBasePrice",

    --
    timer = {},

    --
    nameTimer = "",

    --
    pauseTime = 0,

    --
    entityService = {},

    --
    countRun = 1,

    --
    new = function(self, container)
        self.timer = container:get("Timer")
        self.nameTimer = container:get("config").basePrice.nameTimer
        self.pauseTime = container:get("config").basePrice.pauseTime
        self.entityService = container:get("EntityService_BasePrice")

        -- ��������� ������
        self.timer:set(self.nameTimer, self.pauseTime)

        return self
    end,

    --
    handle = function(self, event)
        -- ���� Action ���������� ������ ��� - ����� �� ��� �������� �������
        if self.countRun == 1 then
            -- ���������� ������ ��� ���� ������������
            self.entityService:checkLevels()

            -- ������ �������� �������
            self.countRun = 2
        end

        -- ���������� ���������� � �������� ���������� � ������� (basePrice.pauseTime)
        if self.timer:allows(self.nameTimer) then

            -- ���������� ������ ��� ���� ������������
            self.entityService:checkLevels()

            -- ����� ������������� ������
            self.timer:set(self.nameTimer, self.pauseTime)
        end
    end,

}

return Action
