---

return {
    dependencies = {
        -- �������
        factories = {
            -- ��������� ���������� �������� ��� ��������� �������� ������� �� �������
            ["Config_positionSetting"] = function(container)
                local broker = container:get("config").broker
                if is_nil(broker) then
                    error("\r\n\r\n" .. "Error: � (configApp.lua) �� ������ (broker)")
                end

                local configName = broker .. "PositionSetting"
                local positionSetting = container:get("config")[configName]

                if not_nil(positionSetting) then
                    return positionSetting
                end

                error("\r\n\r\n" .. "Error: � (configApp.lua) ����������� ��������� ��� ������� (" .. broker .. ")")
            end,

            ["Config_stock"] = function(container)
                local broker = container:get("config").broker
                if is_nil(broker) then
                    error("\r\n\r\n" .. "Error: � (configApp.lua) �� ������ (broker)")
                end

                local configName = broker .. "Stock"
                local config_stock = container:get("config")[configName]

                if not_nil(config_stock) then
                    return config_stock
                end

                error("\r\n\r\n" .. "Error: � (configApp.lua) ����������� ��������� ��� ������� (" .. broker .. ")")
            end,

            ["Config_futures"] = function(container)
                local broker = container:get("config").broker
                if is_nil(broker) then
                    error("\r\n\r\n" .. "Error: � (configApp.lua) �� ������ (broker)")
                end

                local configName = broker .. "Futures"
                local config_futures = container:get("config")[configName]

                if not_nil(config_futures) then
                    return config_futures
                end

                error("\r\n\r\n" .. "Error: � (configApp.lua) ����������� ��������� ��� ������� (" .. broker .. ")")
            end,

            ["Config_currency"] = function(container)
                local broker = container:get("config").broker
                if is_nil(broker) then
                    error("\r\n\r\n" .. "Error: � (configApp.lua) �� ������ (broker)")
                end

                local configName = broker .. "Currency"
                local config_currency = container:get("config")[configName]

                if not_nil(config_currency) then
                    return config_currency
                end

                error("\r\n\r\n" .. "Error: � (configApp.lua) ����������� ��������� ��� ������� (" .. broker .. ")")
            end,

            ["Config_firmId"] = function(container)
                local broker = container:get("config").broker
                if is_nil(broker) then
                    error("\r\n\r\n" .. "Error: � (configApp.lua) �� ������ (broker)")
                end

                local firmIdName = broker .. "Firm_id"
                local firm_id = container:get("config")[firmIdName]

                if not_nil(firm_id) then
                    return firm_id
                end

                error("\r\n\r\n" .. "Error: � (configApp.lua) ����������� ��������� ��� ������� (" .. broker .. ")")
            end,

            ["Config_trade"] = function(container)
                local modeTrade = container:get("config").modeTrade
                if is_nil(modeTrade) then
                    error("\r\n\r\n" .. "Error: � (configApp.lua) �� ������ (modeTrade) ��� ���������� (trade)")
                end

                local nameTrade = modeTrade .. "Trade"

                local config_trade = container:get("config")[nameTrade]

                if not_nil(config_trade) then
                    return config_trade
                end

                error("\r\n\r\n" .. "Error: � (configApp.lua) ����������� ��������� ��� modeTrade (" .. modeTrade .. ")")

            end,

        },

    },

    --- ����� ��������
    -- demo - ����� ������������ - ������������ ����� (demo Quik),
    -- vtb - ����� �������� - ������������ ����� (Quik VTB)

    broker = "demo",
    --broker = "vtb",

    demoFirm_id = "",
    vtbFirm_id = "",

    -- container:get("Config_account") - ������� �� ��������� (broker)
    -- ��������� ������ (Quik demo)
    -- ���: U0203083 � ������: 33233902
    demoFutures = {
        account = "SPBFUT000a4",
        client_code = "SPBFUT000a4",
    },

    demoStock = {
        account = "NL0011100043", -- ���� ����
        client_code = "10178",
    },

    demoCurrency = {
        account = "MB1000100002", -- ���� ����
        client_code = "10178",
    },

    -- container:get("Config_account") - ������� �� ��������� (broker)
    -- ��������� ������ (Quik VTB)
    vtbFutures = {
        account = "",
        client_code = "",
    },

    vtbStock = {
        account = "", -- ���� ����
        client_code = "",
    },

    vtbCurrency = {
        account = "", -- ���� ����
        client_code = "",
    },

    vtbPositionSetting = {
        futures = {
            account = "",
            client_code = "",
            -- ��� ����������� ������� � ������� "������� ������� �� �������� ���������" (1 - � �����, 2 - � ������ ���������� � ����)
            -- ��������, ��� ������� 1 ���� USDRUB ���� ������� � ���� "������" ����������� 1, ������ 1000
            -- 1 ��� ����� ��������� ����� ������������ � ������� "������� �� ������������" � ���� "������� �������" ��� 1, ��� 10
            positionType = "lots",
        },

        stock = {
            account = "",
            client_code = "",
            limit_kind = 2, -- ��� ������ (�����), ��� ���� ����� ������ ���� 0, ��� ��������� 2
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

    --- ����� ��������
    -- test - ����� �������� 1 ����� + ���������� ����� �� ����
    -- norm - ����� �������� ���������� ����� �� 1 ����

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
