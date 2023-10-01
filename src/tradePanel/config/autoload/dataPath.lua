---

return {
    -- пути к исходникам данных
    dataPath = {
        homework = "data_csv_homework.csv",

        stockClassAccount = "data_csv_stockClassAccount.csv",
        stockAllowedToShort = "data_csv_stockAllowedToShort.csv",
        idChart = "data_csv_idChart.csv",

        keyboardKeys = "data_lua_keyboardKeys.lua",
    },

    -- пути к базам данных
    dbPath = {
        dbLevels = "db_levels.lua"
    },

    -- Chart
    chartPath = {
        center = "data_img_center.jpg",
        level = "data_img_level.jpg",
        line = "data_img_line.jpg",
        marker = "data_img_marker.jpg",
        microLine = "data_img_microLine.jpg",
        strong = "data_img_strong.jpg",

        hi = "data_img_hi.jpg",
        low = "data_img_low.jpg",
        close = "data_img_close.jpg",

        hi = "data_img_hiPrev1.jpg",
        low = "data_img_lowPrev1.jpg",
        close = "data_img_close.jpg",
        close = "data_img_close1.jpg",

        hiHour = "data_img_hiHour.jpg",
        lowHour = "data_img_lowHour.jpg",
    },

    -- пути к структурам для панелей
    panelsPath = {
        alert = "data_lua_structurePanelAlert.lua",
        system = "data_lua_structurePanelSystem.lua",
        trade = "data_lua_structurePanelTrade.lua",
    },
}
