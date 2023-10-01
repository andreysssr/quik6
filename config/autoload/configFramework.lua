--- Framework

return {
    dependencies = {
        -- по умолчанию использовать уже загруженные сервисы
        shared_by_default = true,

        -- фабрики
        factories = {
            -- приложение
            --["Application"] = {
            --	"EventManager",
            --	"EventKeyboardManager"
            --},

            -- обработчик событий
            --["EventManager"] = {
            --	"Resolver",
            --	"EventManager_Event"
            --},

            -- обработчик нажатий на клавиатуру
            --["EventKeyboardManager"] = {
            --	"Resolver",
            --	"EventKeyboardManager_dataKeyboardKeys"
            --},

            --
            --["EventKeyboardManager_dataKeyboardKeys"] = function(container)
            --	return container:load("EventKeyboardManager_dataKeyboardKeys")
            --end,

            -- отправка событий
            --["EventSender"] = "Application",

            -- цветовые схемы
            --["ColorScheme"] = "ColorScheme_dataColors",

            --["ColorScheme_dataColors"] = function(container)
            --	return container:load("ColorScheme_dataColors")
            --end,

            -- диспетчер событий в Entity
            --["EventDispatcher"] = "EventSender",

        },

        -- алиасы
        aliases = {
            --["App"] = "Application"
        },

        -- сервисы
        services = {
            --ff = function()
            --	dd("отработала функция из контейнера")
            --end
        },

        -- false - при каждом вызове сервиса загружать его заново
        shared = {
            ["Queue"] = false,
            --["Repository_Interface"] = false,

        },
    },

    -- пути
    dirPath = {
        -- параметры для кеширования
        cacheParams = {
            dir = "var_cache",
            ext = "lua"
        },

        -- параметры для логирования
        logParams = {
            dir = "var_logs",
            ext = "csv"
        },
    },


}

