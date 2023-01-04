--- AppService CalculateLotsToMoneyRisk

local AppService = {
    --
    name = "AppService_CalculateLotsToMoneyRisk",

    --
    container = {},

    -- ������ ����� � ������,
    -- ������� �� ������ ��������:
    -- test - 1 �����, �� �� ������ �����
    -- norm - ���������� ����� ������� �� �����
    -- ��� ��������� ������ ������� ��������� �� �����
    -- ���� ������ 0 - ����� 1 ���
    trade = 0,

    --
    storage = {},

    --
    quik = {},

    --
    new = function(self, container)
        self.container = container

        self.trade = container:get("Config_trade")
        self.storage = container:get("Storage")
        self.quik = container:get("Quik")

        return self
    end,

    -- ���������� ���������� ����� ��� �����
    getLotsStock = function(self, id, class)
        -- ������� ������� ���������� ����� ��� �����
        -- ������ ����� / (������ ����� * ���������� ����� � 1 ����)
        -- (������ �����) = �������� * 7%

        -- �������� �����������
        local interval = self.storage:getIntervalToId(id)

        -- ���� � ��������� - 7%
        local stopSizePercent = self.container:get("config").stop.size.default

        -- ������� ���� �� ���������
        local sizeStop = interval / 100 * stopSizePercent

        -- ���������� ����� � 1 �����
        local lotSize = self.quik:getLotSize(id, class)

        -- ���� �� ������
        local moneyRisk = self.trade.moneyRisk

        -- ���������� ����� �� 1 ����
        local lots = moneyRisk / (sizeStop * lotSize)

        -- ��������� � ������� �������
        lots = math.floor(lots)

        -- ���� ��� �������� �������� � ������������ � ����
        -- ����� ��������� ����� 1 �����
        if self.trade.mode == "test" and lots > 0 then
            return 1
        end

        return d0(lots)
    end,

    -- ���������� ���������� ����� ��� ���������
    getLotsFutures = function(self, id, class)
        -- ������������ ���������� ���� �� ������ � ������,
        -- ���� �� ������
        local moneyRisk = self.trade.moneyRisk
        -- ----------------------------------------------------
        -- ������������ ����-���� � �������
        -- ����-���� � ������� = (���� ����� � ���� �����)
        -- �������� �����������
        local interval = self.storage:getIntervalToId(id)

        -- ���� � ��������� - 7%
        local stopSizePercent = self.container:get("config").stop.size.default

        -- ������� ���� �� ���������
        local sizeStop = interval / 100 * stopSizePercent
        -- ----------------------------------------------------
        -- ������������ ���� � ������ - ��� 1 ���� ��������
        -- ����-���� � ������ = (����-���� � ������� / ��� ����) * ��������� ������
        -- local sizeRub = (sizeStop / ��� ����) * ��������� ���� ����

        -- ��� ����
        local stepSize = self.quik:getStepSize(id, class)

        -- ���� 1 ����
        local stepPrice = self.quik:getStepPrice(id, class)

        -- 1 ���� � ������
        -- (������ ����� � �������) ����� �� (������ ����) = ���������� ����� � �����
        -- (���������� ����� � �����) �������� �� (���� ����) = ���� ����� 1 ���� � ������
        local sizeStopRubles = (sizeStop / stepSize) * stepPrice
        -- ----------------------------------------------------
        -- ���������� ���������� = ���������� ���� �� ������ � ������ / ����-���� � ������ 1 ���� ��������
        local lots = moneyRisk / sizeStopRubles

        -- ��������� � ������� �������
        lots = math.floor(lots)

        -- ���� ��� �������� �������� � ������������ � ����
        -- ����� ��������� ����� 1 �����
        if self.trade.mode == "test" and lots > 0 then
            return 1
        end

        return d0(lots)
    end,


    -- ���������� ���������� ����� ��� ������
    getLotsCurrency = function(self, id, class)
        -- ������������ ���������� ���� �� ������ � ������,
        -- ���� �� ������
        local moneyRisk = self.trade.moneyRisk
        -- ----------------------------------------------------
        -- ������������ ����-���� � �������
        -- ����-���� � ������� = (���� ����� � ���� �����)
        -- �������� �����������
        local interval = self.storage:getIntervalToId(id)

        -- ���� � ��������� - 7%
        local stopSizePercent = self.container:get("config").stop.size.default

        -- ������� ���� �� ���������
        local sizeStop = interval / 100 * stopSizePercent

        -- ----------------------------------------------------
        -- ���������� ���� � ������� * �� ���������� ����� � 1 ���� (1000) - ���������� ���������� ��� ������
        -- ��������� ������ ����� ��� 1 ����
        local sizeStopLot = sizeStop * 1000

        -- ----------------------------------------------------
        -- (���� �� ������) ����� �� (������ ����� 1 ����)
        local lots = moneyRisk / sizeStopLot

        -- ��������� � ������� �������
        lots = math.floor(lots)

        -- ���� ��� �������� �������� � ������������ � ����
        -- ����� ��������� ����� 1 �����
        if self.trade.mode == "test" and lots > 0 then
            return 1
        end

        return d0(lots)
    end,


    getLots = function(self, id, class)
        if class == "TQBR" or class == "QJSIM" then
            return self:getLotsStock(id, class)
        end

        if class == "SPBFUT" then
            return self:getLotsFutures(id, class)
        end

        if class == "CETS" then
            return self:getLotsCurrency(id, class)
        end
    end,
}

return AppService
