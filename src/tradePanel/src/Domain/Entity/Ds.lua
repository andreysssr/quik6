--- Entity Ds

local Entity = {
    --
    name = "Entity_Ds",

    --
    storage = {},

    --
    servicePrices = {},

    --
    new = function(self, container)
        self.storage = container:get("Storage")
        self.servicePrices = container:get("AppService_ServicePrices")

        local trait = container:get("Entity_TraitEvent")

        extended(self, trait)

        return self
    end,

    -- ������� id
    getId = function(self)
        return self.id
    end,

    -- ������� �������� ������, ������������ �� ��������� ������
    removeDs = function(self)
        self.ds:Close()
    end,

    -- ������� ����������� �������� � % �� ���������
    getRangeInterval = function(self, offsetPrice)
        local result = offsetPrice / (self.interval / 100)
        return dCrop(result, 1)
    end,

    -- ������� ����������� �������� � % �� ���������
    getRangeDay = function(self, offsetPrice)
        local result = offsetPrice / ((self.interval / 2) / 100)
        return dCrop(result, 1)
    end,

    -- ��������� - ��������� �� ���
    -- ���� ��� ��������� - �������� �������
    checkNewBar = function(self)
        if self.numLastBar ~= self.ds:Size() then
            self.numLastBar = self.ds:Size()

            -- ������������ ������� - ��������� ����� �������� ����
            self:registerEvent("DS_UpdatedNumBar", {
                idStock = self.id
            })
        end
    end,

    -- ������� Atr ���������� ����
    -- (������� Hi) - (������� Low)
    getAtrBarCurrent = function(self)
        local numBar = self.ds:Size()

        if is_nil(numBar) then
            return "notBar"
        end

        local atr = self.ds:H(numBar) - self.ds:L(numBar)

        return self:getRangeInterval(atr)
    end,

    -- ������� Atr ����������� ����
    -- (���������� Hi) - (���������� low)
    getAtrBarPrev = function(self)
        local numBar = self.ds:Size() - 1

        if is_nil(numBar) then
            return "notBar"
        end

        local atr = self.ds:H(numBar) - self.ds:L(numBar)

        return self:getRangeInterval(atr)
    end,

    -- ������� ���
    -- (��������� ��������) - (����������� ��������)
    -- ���������� ��������
    getGap = function(self)
        local currentBar = self.ds:Size()
        local prevBar = self.ds:Size() - 1

        if is_nil(prevBar) then
            return "notBar"
        end

        local gap = self.ds:C(prevBar) - self.ds:O(currentBar)

        gap = math.abs(gap)

        return self:getRangeDay(gap)
    end,

    -- ATR �� ���������� ��������
    -- (��������� ��������) - (������� ����)
    getAtrClose = function(self)
        local prevBar = self.ds:Size() - 1

        if is_nil(prevBar) then
            return "notBar"
        end

        local idStock = self.id
        local class = self.storage:getClassToId(idStock)

        -- ������� ������� ����
        local lastPrice = self.servicePrices:getLastPrice(idStock, class)

        local closePrevBar = self.ds:C(prevBar)

        -- ������� ������� ����� ��������� ��������� � ������� �����
        local atrClose = math.abs(closePrevBar - lastPrice)

        return self:getRangeDay(atrClose)
    end,

    --
    -- (���� ��������) - (������� ����)
    getAtrOpen = function(self)
        local idStock = self.id
        local class = self.storage:getClassToId(idStock)

        local lastPrice = self.servicePrices:getLastPrice(idStock, class)

        local currentBar = self.ds:Size()

        local openPrice = self.ds:O(currentBar)

        -- ������� ������� ����� ��������� � ������� �����
        local atrOpen = math.abs(openPrice - lastPrice)

        return self:getRangeDay(atrOpen)
    end,

    -- ������� ������ Atr �������� �������� ����
    -- (������� Hi) - (������� Low)
    getAtrFull = function(self)
        local numBar = self.ds:Size()

        if is_nil(numBar) then
            return "notBar"
        end

        local atr = self.ds:H(numBar) - self.ds:L(numBar)

        return self:getRangeDay(atr)
    end,

    -- ������� hi low ��������� 3 �����
    getHiLow = function(self)
        local numBar = self.ds:Size()

        if is_nil(numBar) then
            return "notBar"
        end

        local result = {
            bar1 = {
                hi = self.ds:H(numBar),
                low = self.ds:L(numBar),
            },
            bar2 = {
                hi = self.ds:H(numBar - 1),
                low = self.ds:L(numBar - 1),
            },
            bar3 = {
                hi = self.ds:H(numBar - 2),
                low = self.ds:L(numBar - 2),
            },
            bar4 = {
                hi = self.ds:H(numBar - 3),
                low = self.ds:L(numBar - 3),
            },
        }

        return result
    end,

    -- ������� ����� ��������� 3 �����
    getVolume = function(self)
        local numBar = self.ds:Size()

        if is_nil(numBar) then
            return "notBar"
        end

        local result = {
            bar1 = self.ds:V(numBar),
            bar2 = self.ds:V(numBar - 1),
            bar3 = self.ds:V(numBar - 2),
        }

        return result
    end,

    -- ������� hi, low, close ����������� ���
    getHiLowClosePreviousBar = function(self)
        local numBar = self.ds:Size() - 1

        local dto = {
            hi = self.ds:H(numBar),
            low = self.ds:L(numBar),
            close = self.ds:C(numBar),
        }

        return dto
    end,

    -- ��� �������� (10 ����� - ��� �����)
    getHiLowBarHour10 = function(self)
        local result = {
            hi = 0,
            low = 0,
        }

        for i = self.ds:Size(), 20, -1 do
            if self.ds:T(i).hour == 10 then
                result.hi = self.ds:H(i)
                result.low = self.ds:L(i)

                break
            end
        end

        return result
    end,

    -- ��� �������� (9 ����� - ��� ���������)
    getHiLowBarHour9 = function(self)
        local result = {
            hi = 0,
            low = 0,
        }

        for i = self.ds:Size(), 20, -1 do
            if self.ds:T(i).hour == 9 then
                result.hi = self.ds:H(i)
                result.low = self.ds:L(i)

                break
            end
        end

        return result
    end,
}

return Entity
