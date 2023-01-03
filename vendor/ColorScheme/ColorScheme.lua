--- ColorsPanel

local ColorScheme = {
    --
    name = "ColorScheme",

    -- dataColors
    colors = {},

    colorsMap = {

        default = function(colors)
            return colors.white, colors.black, colors.white, colors.black
        end,

        disabled = function(colors)
            return colors.white, colors.gray_5, colors.white, colors.gray_5
        end,

        -- цветовые схемы по bootstrap
        -- blue
        blue_1 = function(colors)
            return colors.blue_1, colors.black, colors.blue_1, colors.black
        end,

        blue_2 = function(colors)
            return colors.blue_2, colors.black, colors.blue_2, colors.black
        end,

        blue_3 = function(colors)
            return colors.blue_3, colors.black, colors.blue_3, colors.black
        end,

        blue_4 = function(colors)
            return colors.blue_4, colors.black, colors.blue_4, colors.black
        end,

        blue_5 = function(colors)
            return colors.blue_5, colors.white, colors.blue_5, colors.white
        end,

        blue_6 = function(colors)
            return colors.blue_6, colors.white, colors.blue_6, colors.white
        end,

        blue_7 = function(colors)
            return colors.blue_7, colors.white, colors.blue_7, colors.white
        end,

        blue_8 = function(colors)
            return colors.blue_8, colors.white, colors.blue_8, colors.white
        end,

        blue_9 = function(colors)
            return colors.blue_9, colors.white, colors.blue_9, colors.white
        end,

        -- blue_blue
        blue_blue_1 = function(colors)
            return colors.blue_1, colors.blue_5, colors.blue_1, colors.blue_5
        end,

        blue_blue_2 = function(colors)
            return colors.blue_2, colors.blue_6, colors.blue_2, colors.blue_6
        end,

        blue_blue_3 = function(colors)
            return colors.blue_3, colors.blue_7, colors.blue_3, colors.blue_7
        end,

        blue_blue_4 = function(colors)
            return colors.blue_4, colors.blue_8, colors.blue_4, colors.blue_8
        end,

        blue_blue_5 = function(colors)
            return colors.blue_5, colors.blue_9, colors.blue_5, colors.blue_9
        end,

        -- blue_white
        blue_white_1 = function(colors)
            return colors.blue_1, colors.white, colors.blue_1, colors.white
        end,

        blue_white_2 = function(colors)
            return colors.blue_2, colors.white, colors.blue_2, colors.white
        end,

        blue_white_3 = function(colors)
            return colors.blue_3, colors.white, colors.blue_3, colors.white
        end,

        blue_white_4 = function(colors)
            return colors.blue_4, colors.white, colors.blue_4, colors.white
        end,

        blue_white_5 = function(colors)
            return colors.blue_5, colors.white, colors.blue_5, colors.white
        end,

        -- indigo светло-фиолетовый
        indigo_1 = function(colors)
            return colors.indigo_1, colors.black, colors.indigo_1, colors.black
        end,

        indigo_2 = function(colors)
            return colors.indigo_2, colors.black, colors.indigo_2, colors.black
        end,

        indigo_3 = function(colors)
            return colors.indigo_3, colors.black, colors.indigo_3, colors.black
        end,

        indigo_4 = function(colors)
            return colors.indigo_4, colors.white, colors.indigo_4, colors.white
        end,

        indigo_5 = function(colors)
            return colors.indigo_5, colors.white, colors.indigo_5, colors.white
        end,

        indigo_6 = function(colors)
            return colors.indigo_6, colors.white, colors.indigo_6, colors.white
        end,

        indigo_7 = function(colors)
            return colors.indigo_7, colors.white, colors.indigo_7, colors.white
        end,

        indigo_8 = function(colors)
            return colors.indigo_8, colors.white, colors.indigo_8, colors.white
        end,

        indigo_9 = function(colors)
            return colors.indigo_9, colors.white, colors.indigo_9, colors.white
        end,

        -- indigo_indigo
        indigo_indigo_1 = function(colors)
            return colors.indigo_1, colors.indigo_5, colors.indigo_1, colors.indigo_5
        end,

        indigo_indigo_2 = function(colors)
            return colors.indigo_2, colors.indigo_6, colors.indigo_2, colors.indigo_6
        end,

        indigo_indigo_3 = function(colors)
            return colors.indigo_3, colors.indigo_7, colors.indigo_3, colors.indigo_7
        end,

        indigo_indigo_4 = function(colors)
            return colors.indigo_4, colors.indigo_8, colors.indigo_4, colors.indigo_8
        end,

        indigo_indigo_5 = function(colors)
            return colors.indigo_5, colors.indigo_9, colors.indigo_5, colors.indigo_9
        end,

        -- indigo_white
        indigo_white_1 = function(colors)
            return colors.indigo_1, colors.white, colors.indigo_1, colors.white
        end,

        indigo_white_2 = function(colors)
            return colors.indigo_2, colors.white, colors.indigo_2, colors.white
        end,

        indigo_white_3 = function(colors)
            return colors.indigo_3, colors.white, colors.indigo_3, colors.white
        end,

        indigo_white_4 = function(colors)
            return colors.indigo_4, colors.white, colors.indigo_4, colors.white
        end,

        indigo_white_5 = function(colors)
            return colors.indigo_5, colors.white, colors.indigo_5, colors.white
        end,

        -- purple фиолетовый
        purple_1 = function(colors)
            return colors.purple_1, colors.black, colors.purple_1, colors.black
        end,

        purple_2 = function(colors)
            return colors.purple_2, colors.black, colors.purple_2, colors.black
        end,

        purple_3 = function(colors)
            return colors.purple_3, colors.black, colors.purple_3, colors.black
        end,

        purple_4 = function(colors)
            return colors.purple_4, colors.black, colors.purple_4, colors.black
        end,

        purple_5 = function(colors)
            return colors.purple_5, colors.white, colors.purple_5, colors.white
        end,

        purple_6 = function(colors)
            return colors.purple_6, colors.white, colors.purple_6, colors.white
        end,

        purple_7 = function(colors)
            return colors.purple_7, colors.white, colors.purple_7, colors.white
        end,

        purple_8 = function(colors)
            return colors.purple_8, colors.white, colors.purple_8, colors.white
        end,

        purple_9 = function(colors)
            return colors.purple_9, colors.white, colors.purple_9, colors.white
        end,

        -- purple_purple
        purple_purple_1 = function(colors)
            return colors.purple_1, colors.purple_5, colors.purple_1, colors.purple_5
        end,

        purple_purple_2 = function(colors)
            return colors.purple_2, colors.purple_6, colors.purple_2, colors.purple_6
        end,

        purple_purple_3 = function(colors)
            return colors.purple_3, colors.purple_7, colors.purple_3, colors.purple_7
        end,

        purple_purple_4 = function(colors)
            return colors.purple_4, colors.purple_8, colors.purple_4, colors.purple_8
        end,

        purple_purple_5 = function(colors)
            return colors.purple_5, colors.purple_9, colors.purple_5, colors.purple_9
        end,

        -- purple_white
        purple_white_1 = function(colors)
            return colors.purple_1, colors.white, colors.purple_1, colors.white
        end,

        purple_white_2 = function(colors)
            return colors.purple_2, colors.white, colors.purple_2, colors.white
        end,

        purple_white_3 = function(colors)
            return colors.purple_3, colors.white, colors.purple_3, colors.white
        end,

        purple_white_4 = function(colors)
            return colors.purple_4, colors.white, colors.purple_4, colors.white
        end,

        purple_white_5 = function(colors)
            return colors.purple_5, colors.white, colors.purple_5, colors.white
        end,

        -- pink - светло-красный
        pink_1 = function(colors)
            return colors.pink_1, colors.black, colors.pink_1, colors.black
        end,

        pink_2 = function(colors)
            return colors.pink_2, colors.black, colors.pink_2, colors.black
        end,

        pink_3 = function(colors)
            return colors.pink_3, colors.black, colors.pink_3, colors.black
        end,

        pink_4 = function(colors)
            return colors.pink_4, colors.black, colors.pink_4, colors.black
        end,

        pink_5 = function(colors)
            return colors.pink_5, colors.white, colors.pink_5, colors.white
        end,

        pink_6 = function(colors)
            return colors.pink_6, colors.white, colors.pink_6, colors.white
        end,

        pink_7 = function(colors)
            return colors.pink_7, colors.white, colors.pink_7, colors.white
        end,

        pink_8 = function(colors)
            return colors.pink_8, colors.white, colors.pink_8, colors.white
        end,

        pink_9 = function(colors)
            return colors.pink_9, colors.white, colors.pink_9, colors.white
        end,

        -- pink_pink
        pink_pink_1 = function(colors)
            return colors.pink_1, colors.pink_5, colors.pink_1, colors.pink_5
        end,

        pink_pink_2 = function(colors)
            return colors.pink_2, colors.pink_6, colors.pink_2, colors.pink_6
        end,

        pink_pink_3 = function(colors)
            return colors.pink_3, colors.pink_7, colors.pink_3, colors.pink_7
        end,

        pink_pink_4 = function(colors)
            return colors.pink_4, colors.pink_8, colors.pink_4, colors.pink_8
        end,

        pink_pink_5 = function(colors)
            return colors.pink_5, colors.pink_9, colors.pink_5, colors.pink_9
        end,

        -- pink_white
        pink_white_1 = function(colors)
            return colors.pink_1, colors.white, colors.pink_1, colors.white
        end,

        pink_white_2 = function(colors)
            return colors.pink_2, colors.white, colors.pink_2, colors.white
        end,

        pink_white_3 = function(colors)
            return colors.pink_3, colors.white, colors.pink_3, colors.white
        end,

        pink_white_4 = function(colors)
            return colors.pink_4, colors.white, colors.pink_4, colors.white
        end,

        pink_white_5 = function(colors)
            return colors.pink_5, colors.white, colors.pink_5, colors.white
        end,

        -- red
        red_1 = function(colors)
            return colors.red_1, colors.black, colors.red_1, colors.black
        end,

        red_2 = function(colors)
            return colors.red_2, colors.black, colors.red_2, colors.black
        end,

        red_3 = function(colors)
            return colors.red_3, colors.black, colors.red_3, colors.black
        end,

        red_4 = function(colors)
            return colors.red_4, colors.black, colors.red_4, colors.black
        end,

        red_5 = function(colors)
            return colors.red_5, colors.white, colors.red_5, colors.white
        end,

        red_6 = function(colors)
            return colors.red_6, colors.white, colors.red_6, colors.white
        end,

        red_7 = function(colors)
            return colors.red_7, colors.white, colors.red_7, colors.white
        end,

        red_8 = function(colors)
            return colors.red_8, colors.white, colors.red_8, colors.white
        end,

        red_9 = function(colors)
            return colors.red_9, colors.white, colors.red_9, colors.white
        end,

        -- red_red
        red_red_1 = function(colors)
            return colors.red_1, colors.red_6, colors.red_1, colors.red_6
        end,

        red_red_2 = function(colors)
            return colors.red_2, colors.red_7, colors.red_2, colors.red_7
        end,

        red_red_3 = function(colors)
            return colors.red_3, colors.red_8, colors.red_3, colors.red_8
        end,

        red_red_4 = function(colors)
            return colors.red_4, colors.red_9, colors.red_4, colors.red_9
        end,

        red_red_5 = function(colors)
            return colors.red_5, colors.red_9, colors.red_5, colors.red_9
        end,

        -- red_white
        red_white_1 = function(colors)
            return colors.red_1, colors.white, colors.red_1, colors.white
        end,

        red_white_2 = function(colors)
            return colors.red_2, colors.white, colors.red_2, colors.white
        end,

        red_white_3 = function(colors)
            return colors.red_3, colors.white, colors.red_3, colors.white
        end,

        red_white_4 = function(colors)
            return colors.red_4, colors.white, colors.red_4, colors.white
        end,

        red_white_5 = function(colors)
            return colors.red_5, colors.white, colors.red_5, colors.white
        end,

        -- orange
        orange_1 = function(colors)
            return colors.orange_1, colors.black, colors.orange_1, colors.black
        end,

        orange_2 = function(colors)
            return colors.orange_2, colors.black, colors.orange_2, colors.black
        end,

        orange_3 = function(colors)
            return colors.orange_3, colors.black, colors.orange_3, colors.black
        end,

        orange_4 = function(colors)
            return colors.orange_4, colors.black, colors.orange_4, colors.black
        end,

        orange_5 = function(colors)
            return colors.orange_5, colors.black, colors.orange_5, colors.black
        end,

        orange_6 = function(colors)
            return colors.orange_6, colors.black, colors.orange_6, colors.black
        end,

        orange_7 = function(colors)
            return colors.orange_7, colors.white, colors.orange_7, colors.white
        end,

        orange_8 = function(colors)
            return colors.orange_8, colors.white, colors.orange_8, colors.white
        end,

        orange_9 = function(colors)
            return colors.orange_9, colors.white, colors.orange_9, colors.white
        end,

        -- orange_orange
        orange_orange_1 = function(colors)
            return colors.orange_1, colors.orange_6, colors.orange_1, colors.orange_6
        end,

        orange_orange_2 = function(colors)
            return colors.orange_2, colors.orange_7, colors.orange_2, colors.orange_7
        end,

        orange_orange_3 = function(colors)
            return colors.orange_3, colors.orange_8, colors.orange_3, colors.orange_8
        end,

        orange_orange_4 = function(colors)
            return colors.orange_4, colors.orange_9, colors.orange_4, colors.orange_9
        end,

        orange_orange_5 = function(colors)
            return colors.orange_5, colors.orange_9, colors.orange_5, colors.orange_9
        end,

        -- orange_white
        orange_white_1 = function(colors)
            return colors.orange_1, colors.white, colors.orange_1, colors.white
        end,

        orange_white_2 = function(colors)
            return colors.orange_2, colors.white, colors.orange_2, colors.white
        end,

        orange_white_3 = function(colors)
            return colors.orange_3, colors.white, colors.orange_3, colors.white
        end,

        orange_white_4 = function(colors)
            return colors.orange_4, colors.white, colors.orange_4, colors.white
        end,

        orange_white_5 = function(colors)
            return colors.orange_5, colors.white, colors.orange_5, colors.white
        end,

        -- yellow
        yellow_1 = function(colors)
            return colors.yellow_1, colors.black, colors.yellow_1, colors.black
        end,

        yellow_2 = function(colors)
            return colors.yellow_2, colors.black, colors.yellow_2, colors.black
        end,

        yellow_3 = function(colors)
            return colors.yellow_3, colors.black, colors.yellow_3, colors.black
        end,

        yellow_4 = function(colors)
            return colors.yellow_4, colors.black, colors.yellow_4, colors.black
        end,

        yellow_5 = function(colors)
            return colors.yellow_5, colors.black, colors.yellow_5, colors.black
        end,

        yellow_6 = function(colors)
            return colors.yellow_6, colors.black, colors.yellow_6, colors.black
        end,

        yellow_7 = function(colors)
            return colors.yellow_7, colors.black, colors.yellow_7, colors.black
        end,

        yellow_8 = function(colors)
            return colors.yellow_8, colors.white, colors.yellow_8, colors.white
        end,

        yellow_9 = function(colors)
            return colors.yellow_9, colors.white, colors.yellow_9, colors.white
        end,

        -- yellow_yellow
        yellow_yellow_1 = function(colors)
            return colors.yellow_1, colors.yellow_6, colors.yellow_1, colors.yellow_6
        end,

        yellow_yellow_2 = function(colors)
            return colors.yellow_2, colors.yellow_7, colors.yellow_2, colors.yellow_7
        end,

        yellow_yellow_3 = function(colors)
            return colors.yellow_3, colors.yellow_8, colors.yellow_3, colors.yellow_8
        end,

        yellow_yellow_4 = function(colors)
            return colors.yellow_4, colors.yellow_9, colors.yellow_4, colors.yellow_9
        end,

        yellow_yellow_5 = function(colors)
            return colors.yellow_5, colors.yellow_9, colors.yellow_5, colors.yellow_9
        end,

        -- yellow_white
        yellow_white_1 = function(colors)
            return colors.yellow_1, colors.white, colors.yellow_1, colors.white
        end,

        yellow_white_2 = function(colors)
            return colors.yellow_2, colors.white, colors.yellow_2, colors.white
        end,

        yellow_white_3 = function(colors)
            return colors.yellow_3, colors.white, colors.yellow_3, colors.white
        end,

        yellow_white_4 = function(colors)
            return colors.yellow_4, colors.white, colors.yellow_4, colors.white
        end,

        yellow_white_5 = function(colors)
            return colors.yellow_5, colors.white, colors.yellow_5, colors.white
        end,

        -- green
        green_1 = function(colors)
            return colors.green_1, colors.black, colors.green_1, colors.black
        end,

        green_2 = function(colors)
            return colors.green_2, colors.black, colors.green_2, colors.black
        end,

        green_3 = function(colors)
            return colors.green_3, colors.black, colors.green_3, colors.black
        end,

        green_4 = function(colors)
            return colors.green_4, colors.black, colors.green_4, colors.black
        end,

        green_5 = function(colors)
            return colors.green_5, colors.white, colors.green_5, colors.white
        end,

        green_6 = function(colors)
            return colors.green_6, colors.white, colors.green_6, colors.white
        end,

        green_7 = function(colors)
            return colors.green_7, colors.white, colors.green_7, colors.white
        end,

        green_8 = function(colors)
            return colors.green_8, colors.white, colors.green_8, colors.white
        end,

        green_9 = function(colors)
            return colors.green_9, colors.white, colors.green_9, colors.white
        end,

        -- green_green
        green_green_1 = function(colors)
            return colors.green_1, colors.green_5, colors.green_1, colors.green_5
        end,

        green_green_2 = function(colors)
            return colors.green_2, colors.green_6, colors.green_2, colors.green_6
        end,

        green_green_3 = function(colors)
            return colors.green_3, colors.green_7, colors.green_3, colors.green_7
        end,

        green_green_4 = function(colors)
            return colors.green_4, colors.green_8, colors.green_4, colors.green_8
        end,

        green_green_5 = function(colors)
            return colors.green_5, colors.green_9, colors.green_5, colors.green_9
        end,

        -- green_white
        green_white_1 = function(colors)
            return colors.green_1, colors.white, colors.green_1, colors.white
        end,

        green_white_2 = function(colors)
            return colors.green_2, colors.white, colors.green_2, colors.white
        end,

        green_white_3 = function(colors)
            return colors.green_3, colors.white, colors.green_3, colors.white
        end,

        green_white_4 = function(colors)
            return colors.green_4, colors.white, colors.green_4, colors.white
        end,

        green_white_5 = function(colors)
            return colors.green_5, colors.white, colors.green_5, colors.white
        end,

        -- teal светло-зелёный
        teal_1 = function(colors)
            return colors.teal_1, colors.black, colors.teal_1, colors.black
        end,

        teal_2 = function(colors)
            return colors.teal_2, colors.black, colors.teal_2, colors.black
        end,

        teal_3 = function(colors)
            return colors.teal_3, colors.black, colors.teal_3, colors.black
        end,

        teal_4 = function(colors)
            return colors.teal_4, colors.black, colors.teal_4, colors.black
        end,

        teal_5 = function(colors)
            return colors.teal_5, colors.black, colors.teal_5, colors.black
        end,

        teal_6 = function(colors)
            return colors.teal_6, colors.black, colors.teal_6, colors.black
        end,

        teal_7 = function(colors)
            return colors.teal_7, colors.white, colors.teal_7, colors.white
        end,

        teal_8 = function(colors)
            return colors.teal_8, colors.white, colors.teal_8, colors.white
        end,

        teal_9 = function(colors)
            return colors.teal_9, colors.white, colors.teal_9, colors.white
        end,

        -- teal_teal
        teal_teal_1 = function(colors)
            return colors.teal_1, colors.teal_6, colors.teal_1, colors.teal_6
        end,

        teal_teal_2 = function(colors)
            return colors.teal_2, colors.teal_7, colors.teal_2, colors.teal_7
        end,

        teal_teal_3 = function(colors)
            return colors.teal_3, colors.teal_8, colors.teal_3, colors.teal_8
        end,

        teal_teal_4 = function(colors)
            return colors.teal_4, colors.teal_9, colors.teal_4, colors.teal_9
        end,

        teal_teal_5 = function(colors)
            return colors.teal_5, colors.teal_9, colors.teal_5, colors.teal_9
        end,

        -- teal_white
        teal_white_1 = function(colors)
            return colors.teal_1, colors.white, colors.teal_1, colors.white
        end,

        teal_white_2 = function(colors)
            return colors.teal_2, colors.white, colors.teal_2, colors.white
        end,

        teal_white_3 = function(colors)
            return colors.teal_3, colors.white, colors.teal_3, colors.white
        end,

        teal_white_4 = function(colors)
            return colors.teal_4, colors.white, colors.teal_4, colors.white
        end,

        teal_white_5 = function(colors)
            return colors.teal_5, colors.white, colors.teal_5, colors.white
        end,

        -- cyan светло-синий
        cyan_1 = function(colors)
            return colors.cyan_1, colors.black, colors.cyan_1, colors.black
        end,

        cyan_2 = function(colors)
            return colors.cyan_2, colors.black, colors.cyan_2, colors.black
        end,

        cyan_3 = function(colors)
            return colors.cyan_3, colors.black, colors.cyan_3, colors.black
        end,

        cyan_4 = function(colors)
            return colors.cyan_4, colors.black, colors.cyan_4, colors.black
        end,

        cyan_5 = function(colors)
            return colors.cyan_5, colors.black, colors.cyan_5, colors.black
        end,

        cyan_6 = function(colors)
            return colors.cyan_6, colors.black, colors.cyan_6, colors.black
        end,

        cyan_7 = function(colors)
            return colors.cyan_7, colors.white, colors.cyan_7, colors.white
        end,

        cyan_8 = function(colors)
            return colors.cyan_8, colors.white, colors.cyan_8, colors.white
        end,

        cyan_9 = function(colors)
            return colors.cyan_9, colors.white, colors.cyan_9, colors.white
        end,

        -- cyan_cyan
        cyan_cyan_1 = function(colors)
            return colors.cyan_1, colors.cyan_6, colors.cyan_1, colors.cyan_6
        end,

        cyan_cyan_2 = function(colors)
            return colors.cyan_2, colors.cyan_7, colors.cyan_2, colors.cyan_7
        end,

        cyan_cyan_3 = function(colors)
            return colors.cyan_3, colors.cyan_8, colors.cyan_3, colors.cyan_8
        end,

        cyan_cyan_4 = function(colors)
            return colors.cyan_4, colors.cyan_9, colors.cyan_4, colors.cyan_9
        end,

        cyan_cyan_5 = function(colors)
            return colors.cyan_5, colors.cyan_9, colors.cyan_5, colors.cyan_9
        end,

        -- gray
        gray_1 = function(colors)
            return colors.gray_1, colors.black, colors.gray_1, colors.black
        end,

        gray_2 = function(colors)
            return colors.gray_2, colors.black, colors.gray_2, colors.black
        end,

        gray_3 = function(colors)
            return colors.gray_3, colors.black, colors.gray_3, colors.black
        end,

        gray_4 = function(colors)
            return colors.gray_4, colors.black, colors.gray_4, colors.black
        end,

        gray_5 = function(colors)
            return colors.gray_5, colors.black, colors.gray_5, colors.black
        end,

        gray_6 = function(colors)
            return colors.gray_6, colors.white, colors.gray_6, colors.white
        end,

        gray_7 = function(colors)
            return colors.gray_7, colors.white, colors.gray_7, colors.white
        end,

        gray_8 = function(colors)
            return colors.gray_8, colors.white, colors.gray_8, colors.white
        end,

        gray_9 = function(colors)
            return colors.gray_9, colors.white, colors.gray_9, colors.white
        end,

        -- gray_gray
        gray_gray_1 = function(colors)
            return colors.gray_1, colors.gray_5, colors.gray_1, colors.gray_5
        end,

        gray_gray_2 = function(colors)
            return colors.gray_2, colors.gray_6, colors.gray_2, colors.gray_6
        end,

        gray_gray_3 = function(colors)
            return colors.gray_3, colors.gray_7, colors.gray_3, colors.gray_7
        end,

        gray_gray_4 = function(colors)
            return colors.gray_4, colors.gray_8, colors.gray_4, colors.gray_8
        end,

        gray_gray_5 = function(colors)
            return colors.gray_5, colors.gray_9, colors.gray_5, colors.gray_9
        end,

        -- gray_white
        gray_white_1 = function(colors)
            return colors.gray_1, colors.white, colors.gray_1, colors.white
        end,

        gray_white_2 = function(colors)
            return colors.gray_2, colors.white, colors.gray_2, colors.white
        end,

        gray_white_3 = function(colors)
            return colors.gray_3, colors.white, colors.gray_3, colors.white
        end,

        gray_white_4 = function(colors)
            return colors.gray_4, colors.white, colors.gray_4, colors.white
        end,

        gray_white_5 = function(colors)
            return colors.gray_5, colors.white, colors.gray_5, colors.white
        end,

    },

    new = function(self, container)
        local dataPath = container:get("config").colorSchemePath

        local name = Autoload:getPathFile(dataPath)
        self.colors = dofile(name)

        return self
    end,

    get = function(self, name)
        if isset(self.colorsMap[name]) then
            return self.colorsMap[name](self.colors)
        end

        return name
    end
}

return ColorScheme
