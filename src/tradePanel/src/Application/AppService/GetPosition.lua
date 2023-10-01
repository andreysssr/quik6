--- DomainService GetPosition - описание

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

    -- вернуть позици инструмента
    getPosition = function(self, idStock)
        local class = self.storage:getClassToId(idStock)

        -- фьючерсы и опционы
        if class == 'SPBFUT' or class == 'SPBOPT' then
            return self:getPositionFutures(idStock, class, self.positionSetting.futures)
        end

        -- акции
        if class == 'TQBR' or class == 'QJSIM' then
            return self:getPositionStock(idStock, class, self.positionSetting.stock)
        end

        -- валюта
        if class == 'CETS' then
            return self:getPositionCurrency(idStock, class, self.positionSetting.currency)
        end

    end,

    -- Тип отображения баланса в таблице "Таблица лимитов по денежным средствам" (1 - в лотах, 2 - с учетом количества в лоте)
    -- Например, при покупке 1 лота USDRUB одни брокеры в поле "Баланс" транслируют 1, другие 1000
    -- 1 лот акций Сбербанка может отображаться в таблице "Позиции по инструментов" в поле "Текущий остаток" как 1, или 10
    -- вернуть позиции фьючерсов
    getPositionFutures = function(self, idStock, class, params)
        local account = params.account
        local positionType = params.positionType

        local num = getNumberOf('futures_client_holding')
        if num > 0 then
            -- Находит размер лота
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

        -- Если позиция по инструменту в таблице не найдена, возвращает 0
        return 0
    end,

    -- вернуть позиции акций
    getPositionStock = function(self, idStock, class, params)
        local account = params.account   -- Код счета
        local limit_kind = params.limit_kind   -- Тип лимита (акции), для демо счета должно быть 0, для реального 2
        local positionType = params.positionType  -- Тип отображения баланса в таблице "Таблица лимитов по денежным средствам" (1 - в лотах, 2 - с учетом количества в лоте)

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

        -- Если позиция по инструменту в таблице не найдена, возвращает 0
        return 0
    end,

    -- вернуть позиции валюты
    getPositionCurrency = function(self, idStock, class, params)
        local account = params.account   -- Код счета
        local limit_kind = params.limit_kind  -- Тип лимита (акции), для демо счета должно быть 0, для реального 2
        local client_code = params.client_code  -- Код клиента, нужен для получения позиции по валюте
        local positionType = params.positionType -- Тип отображения баланса в таблице "Таблица лимитов по денежным средствам" (1 - в лотах, 2 - с учетом количества в лоте)
        -- Например, при покупке 1 лота USDRUB одни брокеры в поле "Баланс" транслируют 1, другие 1000
        -- 1 лот акций Сбербанка может отображаться в таблице "Позиции по инструментов" в поле "Текущий остаток" как 1, или 10

        local num = getNumberOf('money_limits')
        if num > 0 then
            -- Находит валюту
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

        -- Если позиция по инструменту в таблице не найдена, возвращает 0
        return 0
    end,

}

return DomainService
