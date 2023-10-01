-- структура для панели торговли

return {
    {
        header = {
            title = "[ Инструмент ]",
            width = 19
        },
        body = {
            name = "stock",
            type = "clickOn",
            colors = {
                active = "blue_blue_2",
                default = "",
                disable = "disabled",
                limited = "yellow_2",
            },
        },
    },
    {
        header = {
            title = "Направление",
            width = 30
        },
        body = {
            name = "comment",
            type = "clickOn",
            colors = {
                select = "yellow_2",
                active = "yellow_1",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "-",
            width = 3
        },
        body = {
            name = "divider",
            type = "clickOff",
            colors = {
                active = "",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "Позиция",
            width = 9
        },
        body = {
            name = "position",
            type = "clickOff",
            colors = {
                default = "",
                long = "green_2",
                short = "red_2",
            },
        },
    },
    {
        header = {
            title = "-",
            width = 3
        },
        body = {
            name = "dividerV",
            type = "clickOff",
            colors = {
                active = "",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "Шорт",
            width = 6
        },
        body = {
            name = "shortAllow",
            type = "clickOff",
            colors = {
                active = "",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "-",
            width = 3
        },
        body = {
            name = "divider",
            type = "clickOff",
            colors = {
                active = "",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "Заявки",
            width = 8
        },
        body = {
            name = "ordersAll",
            type = "clickOff",
            colors = {
                active = "yellow_3",
                default = "",
            },
        },
    },
    {
        header = {
            title = "-",
            width = 3
        },
        body = {
            name = "divider",
            type = "clickOff",
            colors = {
                active = "",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "Цена",
            width = 8
        },
        body = {
            name = "lastPrice",
            type = "clickOn",
            colors = {
                active = "yellow_2",
                default = "",
            },
        },
    },
    {
        header = {
            title = "-",
            width = 3
        },
        body = {
            name = "dividerV",
            type = "clickOff",
            colors = {
                active = "",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "[ M ]",
            width = 5
        },
        body = {
            name = "marker1",
            type = "clickOn",
            colors = {
                active = "cyan_4",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "[ S ]",
            width = 5
        },
        body = {
            name = "strong",
            type = "clickOn",
            colors = {
                active = "cyan_4",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "[ML]",
            width = 5
        },
        body = {
            name = "markerMirrorLineHiLow",
            type = "clickOn",
            colors = {
                active = "pink_4",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "[ D ]",
            width = 5
        },
        body = {
            name = "markerDayBar",
            type = "clickOn",
            colors = {
                active = "cyan_4",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "[ H ]",
            width = 5
        },
        body = {
            name = "markerHourBar",
            type = "clickOn",
            colors = {
                active = "teal_3",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "[ Tr ]",
            width = 5
        },
        body = {
            name = "markerTrend",
            type = "clickOn",
            colors = {
                active = "indigo_3",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "-",
            width = 3
        },
        body = {
            name = "dividerV",
            type = "clickOff",
            colors = {
                active = "",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "Инт-л",
            width = 7
        },
        body = {
            name = "interval",
            type = "clickOff",
            colors = {
                active = "",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "-",
            width = 3
        },
        body = {
            name = "dividerV",
            type = "clickOff",
            colors = {
                active = "",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "Bar Limit",
            width = 8
        },
        body = {
            name = "barLimit",
            type = "clickOff",
            colors = {
                limitColor = "yellow_3",
                touchColor = "indigo_2",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "-",
            width = 3
        },
        body = {
            name = "divider",
            type = "clickOff",
            colors = {
                active = "",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "Bar",
            width = 7
        },
        body = {
            name = "barPrevious",
            type = "clickOff",
            colors = {
                active = "",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "-",
            width = 3
        },
        body = {
            name = "divider",
            type = "clickOff",
            colors = {
                active = "",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "Bar",
            width = 7
        },
        body = {
            name = "barCurrent",
            type = "clickOff",
            colors = {
                color5 = "indigo_2",
                active = "",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "-",
            width = 3
        },
        body = {
            name = "divider",
            type = "clickOff",
            colors = {
                active = "",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "% level",
            width = 8
        },
        body = {
            name = "level",
            type = "clickOff",
            colors = {
                color5 = "cyan_5",
                color10 = "cyan_3",
                color15 = "cyan_1",

                default = "",
            },
        },
    },
    {
        header = {
            title = "-",
            width = 3
        },
        body = {
            name = "divider",
            type = "clickOff",
            colors = {
                active = "",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "% strong",
            width = 8
        },
        body = {
            name = "strong",
            type = "clickOff",
            colors = {
                color5 = "indigo_3",
                color10 = "indigo_1",

                default = "",
            },
        },
    },
    {
        header = {
            title = "-",
            width = 3
        },
        body = {
            name = "divider",
            type = "clickOff",
            colors = {
                active = "",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "% line",
            width = 8
        },
        body = {
            name = "line",
            type = "clickOff",
            colors = {
                color5 = "yellow_3",
                color10 = "yellow_1",

                default = "",
            },
        },
    },
    {
        header = {
            title = "-",
            width = 3
        },
        body = {
            name = "divider",
            type = "clickOff",
            colors = {
                active = "",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "V 2",
            width = 5
        },
        body = {
            name = "volume2",
            type = "clickOff",
            colors = {
                active = "pink_4",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "-",
            width = 3
        },
        body = {
            name = "divider",
            type = "clickOff",
            colors = {
                active = "",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "Max. Лотов",
            width = 13
        },
        body = {
            name = "maxLots",
            type = "clickOff",
            colors = {
                active = "",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "Лотов",
            width = 8
        },
        body = {
            name = "lots",
            type = "clickOff",
            colors = {
                active = "",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "-",
            width = 3
        },
        body = {
            name = "divider",
            type = "clickOff",
            colors = {
                active = "",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "Див | Экс",
            width = 10
        },
        body = {
            name = "dateDivExp",
            type = "clickOff",
            colors = {
                warning = "red_2",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "-",
            width = 3
        },
        body = {
            name = "dividerV",
            type = "clickOff",
            colors = {
                active = "red_2",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "[ 2 ]",
            width = 5
        },
        body = {
            name = "take2",
            type = "clickOn",
            lamp = true,
            colors = {
                on = "green_3",
                off = "red_2",
                default = "",
            },
        },
    },
    {
        header = {
            title = "[ 3 ]",
            width = 5
        },
        body = {
            name = "take3",
            type = "clickOn",
            lamp = true,
            colors = {
                on = "green_3",
                off = "red_2",
                default = "",
            },
        },
    },
    {
        header = {
            title = "[ 4 ]",
            width = 5
        },
        body = {
            name = "take4",
            type = "clickOn",
            lamp = true,
            colors = {
                on = "green_3",
                off = "red_2",
                default = "",
            },
        },
    },
    {
        header = {
            title = "[ 5 ]",
            width = 5
        },
        body = {
            name = "take5",
            type = "clickOn",
            lamp = true,
            colors = {
                on = "green_3",
                off = "red_2",
                default = "",
            },
        },
    },
    {
        header = {
            title = "[ 6 ]",
            width = 5
        },
        body = {
            name = "take6",
            type = "clickOn",
            lamp = true,
            colors = {
                on = "green_3",
                off = "red_2",
                default = "",
            },
        },
    },
    {
        header = {
            title = "[ 7 ]",
            width = 5
        },
        body = {
            name = "take7",
            type = "clickOn",
            lamp = true,
            colors = {
                on = "green_3",
                off = "red_2",
                default = "",
            },
        },
    },
    {
        header = {
            title = "[ 8 ]",
            width = 5
        },
        body = {
            name = "take8",
            type = "clickOn",
            lamp = true,
            colors = {
                on = "green_3",
                off = "red_2",
                default = "",
            },
        },
    },
    {
        header = {
            title = "-",
            width = 3
        },
        body = {
            name = "dividerV",
            type = "clickOff",
            colors = {
                active = "",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "[ Com-t ]",
            width = 9
        },
        body = {
            name = "commentView",
            type = "clickOn",
            lamp = true,
            colors = {
                active = "yellow_3",
                default = "",
                disable = "",
            },
        },
    },
    {
        header = {
            title = "-",
            width = 3
        },
        body = {
            name = "divider",
            type = "clickOff",
            colors = {
                active = "",
                default = "",
                disable = "",
            },
        },
    },
}
