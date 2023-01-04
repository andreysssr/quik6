---

return {
    -- panels
    panels = {
        alert = {
            title = "Оповещение",
            name = "alert",
            size = {
                width = 980,
                height = 300,
            },
            location = {
                left = 680,
                top = 0,
            },
        },
        system = {
            title = "Системные настойки",
            name = "system",
            size = {
                width = 300,
                height = 300,
            },
            location = {
                left = 0,
                top = 0,
            },
        },
        trade = {
            title = "Торговая панель",
            name = "trade",
            size = {
                width = 1920,
                height = 945,
            },
            location = {
                left = 0,
                top = 350,
            },
            -- количество графиков на 1 мониторе
            numberGraphs = 12,
            indicator = {
                row = 1,
                col = 49,
                on = "gray_4",
                off = "gray_2",
            }
        },
    },
}
