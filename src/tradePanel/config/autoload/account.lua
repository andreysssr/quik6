---

return {
    dependencies = {
        -- фабрики
        factories = {
            -- получение параметров настроек для получения открытых позиций по бумагам
            ["Config_positionSetting"] = function(container)
                local broker = container:get("config").broker
                if is_nil(broker) then
                    error("\r\n\r\n" .. "Error: В (configApp.lua) не указан (broker)")
                end

                local configName = broker .. "PositionSetting"
                local positionSetting = container:get("config")[configName]

                if not_nil(positionSetting) then
                    return positionSetting
                end

                error("\r\n\r\n" .. "Error: В (configApp.lua) отсутствуют настройки для брокера (" .. broker .. ")")
            end,

            ["Config_stock"] = function(container)
                local broker = container:get("config").broker
                if is_nil(broker) then
                    error("\r\n\r\n" .. "Error: В (configApp.lua) не указан (broker)")
                end

                local configName = broker .. "Stock"
                local config_stock = container:get("config")[configName]

                if not_nil(config_stock) then
                    return config_stock
                end

                error("\r\n\r\n" .. "Error: В (configApp.lua) отсутствуют настройки для брокера (" .. broker .. ")")
            end,

            ["Config_futures"] = function(container)
                local broker = container:get("config").broker
                if is_nil(broker) then
                    error("\r\n\r\n" .. "Error: В (configApp.lua) не указан (broker)")
                end

                local configName = broker .. "Futures"
                local config_futures = container:get("config")[configName]

                if not_nil(config_futures) then
                    return config_futures
                end

                error("\r\n\r\n" .. "Error: В (configApp.lua) отсутствуют настройки для брокера (" .. broker .. ")")
            end,

            ["Config_currency"] = function(container)
                local broker = container:get("config").broker
                if is_nil(broker) then
                    error("\r\n\r\n" .. "Error: В (configApp.lua) не указан (broker)")
                end

                local configName = broker .. "Currency"
                local config_currency = container:get("config")[configName]

                if not_nil(config_currency) then
                    return config_currency
                end

                error("\r\n\r\n" .. "Error: В (configApp.lua) отсутствуют настройки для брокера (" .. broker .. ")")
            end,

            ["Config_firmId"] = function(container)
                local broker = container:get("config").broker
                if is_nil(broker) then
                    error("\r\n\r\n" .. "Error: В (configApp.lua) не указан (broker)")
                end

                local firmIdName = broker .. "Firm_id"
                local firm_id = container:get("config")[firmIdName]

                if not_nil(firm_id) then
                    return firm_id
                end

                error("\r\n\r\n" .. "Error: В (configApp.lua) отсутствуют настройки для брокера (" .. broker .. ")")
            end,

            ["Config_trade"] = function(container)
                local modeTrade = container:get("config").modeTrade
                if is_nil(modeTrade) then
                    error("\r\n\r\n" .. "Error: В (configApp.lua) не указан (modeTrade) для параметров (trade)")
                end

                local nameTrade = modeTrade .. "Trade"

                local config_trade = container:get("config")[nameTrade]

                if not_nil(config_trade) then
                    return config_trade
                end

                error("\r\n\r\n" .. "Error: В (configApp.lua) отсутствуют настройки для modeTrade (" .. modeTrade .. ")")

            end,

        },

    },

    --- выбор аккаунта
    -- demo - режим разработчика - используются счета (demo Quik),
    -- vtb - режим торговли - используются счета (Quik VTB)

    broker = "demo",
    --broker = "vtb",

    demoFirm_id = "",
    vtbFirm_id = "",

    -- container:get("Config_account") - зависит он настройки (broker)
    -- настройки счетов (Quik demo)
    -- имя: U0203083 и пароль: 33233902
    demoFutures = {
        account = "SPBFUT000a4",
        client_code = "SPBFUT000a4",
    },

    demoStock = {
        account = "NL0011100043", -- счёт депо
        client_code = "10178",
    },

    demoCurrency = {
        account = "MB1000100002", -- счёт депо
        client_code = "10178",
    },

    -- container:get("Config_account") - зависит он настройки (broker)
    -- настройки счетов (Quik VTB)
    vtbFutures = {
        account = "",
        client_code = "",
    },

    vtbStock = {
        account = "", -- счёт депо
        client_code = "",
    },

    vtbCurrency = {
        account = "", -- счёт депо
        client_code = "",
    },

    vtbPositionSetting = {
        futures = {
            account = "",
            client_code = "",
            -- Тип отображения баланса в таблице "Таблица лимитов по денежным средствам" (1 - в лотах, 2 - с учетом количества в лоте)
            -- Например, при покупке 1 лота USDRUB одни брокеры в поле "Баланс" транслируют 1, другие 1000
            -- 1 лот акций Сбербанка может отображаться в таблице "Позиции по инструментов" в поле "Текущий остаток" как 1, или 10
            positionType = "lots",
        },

        stock = {
            account = "",
            client_code = "",
            limit_kind = 2, -- Тип лимита (акции), для демо счета должно быть 0, для реального 2
            positionType = "lots",
        },

        currency = {
            account = "",
            client_code = "",
            limit_kind = 2,
            positionType = "lots",
        }
    },

    demoPositionSetting = {
        futures = {
            account = "SPBFUT000a4",
            client_code = "SPBFUT000a4",
            positionType = "lots",
        },

        stock = {
            account = "NL0011100043",
            client_code = "10178",
            limit_kind = 0,
            positionType = "lots",
        },

        currency = {
            account = "MB1000100002",
            client_code = "10178",
            limit_kind = 0,
            positionType = "lots",
        }
    },

    --- режим торговли
    -- test - режим торговли 1 лотом + соблюдение риска на стоп
    -- norm - режим торговли соблюдение риска на 1 стоп

    modeTrade = "norm",

    testTrade = {
        mode = "test",
        moneyRisk = 30,
    },

    normTrade = {
        mode = "norm",
        moneyRisk = 100,
    },
}
