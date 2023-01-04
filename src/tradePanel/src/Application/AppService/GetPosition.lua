--- DomainService GetPosition - ��������

local DomainService = {
    --
    name = "AppService_GetPosition",

    --
    container = {},

    --
    storage = {},

    --
    positionSetting = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")
        self.positionSetting = self.container:get("Config_positionSetting")

        return self
    end,

    -- ������� ������ �����������
    getPosition = function(self, idStock)
        local class = self.storage:getClassToId(idStock)

        -- �������� � �������
        if class == 'SPBFUT' or class == 'SPBOPT' then
            return self:getPositionFutures(idStock, class, self.positionSetting.futures)
        end

        -- �����
        if class == 'TQBR' or class == 'QJSIM' then
            return self:getPositionStock(idStock, class, self.positionSetting.stock)
        end

        -- ������
        if class == 'CETS' then
            return self:getPositionCurrency(idStock, class, self.positionSetting.currency)
        end

    end,

    -- ��� ����������� ������� � ������� "������� ������� �� �������� ���������" (1 - � �����, 2 - � ������ ���������� � ����)
    -- ��������, ��� ������� 1 ���� USDRUB ���� ������� � ���� "������" ����������� 1, ������ 1000
    -- 1 ��� ����� ��������� ����� ������������ � ������� "������� �� ������������" � ���� "������� �������" ��� 1, ��� 10
    -- ������� ������� ���������
    getPositionFutures = function(self, idStock, class, params)
        local account = params.account
        local positionType = params.positionType

        local num = getNumberOf('futures_client_holding')
        if num > 0 then
            -- ������� ������ ����
            local lot = tonumber(getParamEx(class, idStock, 'LOTSIZE').param_value)
            if num > 1 then
                for i = 0, num - 1 do
                    local futures_client_holding = getItem('futures_client_holding', i)
                    if futures_client_holding.sec_code == idStock and futures_client_holding.trdaccid == account then
                        if positionType == "lots" then
                            return math.floor(futures_client_holding.totalnet / lot)
                        else
                            return math.floor(futures_client_holding.totalnet)
                        end
                    end
                end
            else
                local futures_client_holding = getItem('futures_client_holding', 0)
                if futures_client_holding.sec_code == idStock and futures_client_holding.trdaccid == account then
                    if positionType == "lots" then
                        return math.floor(futures_client_holding.totalnet)
                    else
                        return math.floor(futures_client_holding.totalnet / lot)
                    end
                end
            end
        end

        -- ���� ������� �� ����������� � ������� �� �������, ���������� 0
        return 0
    end,

    -- ������� ������� �����
    getPositionStock = function(self, idStock, class, params)
        local account = params.account   -- ��� �����
        local limit_kind = params.limit_kind   -- ��� ������ (�����), ��� ���� ����� ������ ���� 0, ��� ��������� 2
        local positionType = params.positionType  -- ��� ����������� ������� � ������� "������� ������� �� �������� ���������" (1 - � �����, 2 - � ������ ���������� � ����)

        local num = getNumberOf('depo_limits')
        if num > 0 then
            local lot = tonumber(getParamEx(class, idStock, 'LOTSIZE').param_value)
            if num > 1 then
                for i = 0, num - 1 do
                    local depo_limit = getItem('depo_limits', i)
                    if depo_limit.sec_code == idStock
                        and depo_limit.trdaccid == account
                        and depo_limit.limit_kind == limit_kind then
                        if positionType == "lots" then
                            return math.floor(depo_limit.currentbal / lot)
                        else
                            return math.floor(depo_limit.currentbal)
                        end
                    end
                end
            else
                local depo_limit = getItem('depo_limits', 0)
                if depo_limit.sec_code == idStock
                    and depo_limit.trdaccid == account
                    and depo_limit.limit_kind == limit_kind then
                    if positionType == "lots" then
                        return math.floor(depo_limit.currentbal / lot)
                    else
                        return math.floor(depo_limit.currentbal)
                    end
                end
            end
        end

        -- ���� ������� �� ����������� � ������� �� �������, ���������� 0
        return 0
    end,

    -- ������� ������� ������
    getPositionCurrency = function(self, idStock, class, params)
        local account = params.account   -- ��� �����
        local limit_kind = params.limit_kind  -- ��� ������ (�����), ��� ���� ����� ������ ���� 0, ��� ��������� 2
        local client_code = params.client_code  -- ��� �������, ����� ��� ��������� ������� �� ������
        local positionType = params.positionType -- ��� ����������� ������� � ������� "������� ������� �� �������� ���������" (1 - � �����, 2 - � ������ ���������� � ����)
        -- ��������, ��� ������� 1 ���� USDRUB ���� ������� � ���� "������" ����������� 1, ������ 1000
        -- 1 ��� ����� ��������� ����� ������������ � ������� "������� �� ������������" � ���� "������� �������" ��� 1, ��� 10

        local num = getNumberOf('money_limits')
        if num > 0 then
            -- ������� ������
            local cur = string.sub(idStock, 1, 3)
            local lot = tonumber(getParamEx(class, idStock, 'LOTSIZE').param_value)
            if num > 1 then
                for i = 0, num - 1 do
                    local money_limit = getItem('money_limits', i)
                    if money_limit.currcode == cur
                        and money_limit.client_code == client_code
                        and money_limit.limit_kind == limit_kind then
                        if positionType == "lots" then
                            return math.floor(money_limit.currentbal / lot)
                        else
                            return math.floor(money_limit.currentbal)
                        end
                    end
                end
            else
                local money_limit = getItem('money_limits', 0)
                if money_limit.currcode == cur
                    and money_limit.client_code == client_code
                    and money_limit.limit_kind == limit_kind then
                    if positionType == "lots" then
                        return math.floor(money_limit.currentbal / lot)
                    else
                        return math.floor(money_limit.currentbal)
                    end
                end
            end
        end

        -- ���� ������� �� ����������� � ������� �� �������, ���������� 0
        return 0
    end,

}

return DomainService
