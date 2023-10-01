--- Application

local Application = {
    --
    name = "Application",

    -- режимы работы приложения по скорости
    modes = {
        trade = 200, -- открыта позиция - слежение за движением цены
        no_connection = 2000, -- наблюдение - торговля не идёт
    },

    -- установленный режим работы приложения
    mode = 200,

    -- менеджер событий
    eventManager = {},

    -- менеджер кликов на клавиатуру - вызывает обработчики
    -- которые подписаны на клавиши
    eventKeyboardManager = {},

    -- очередь
    queue = {},

    -- обработка Middleware
    pipeline = {},

    -- создание Middleware
    resolverMiddleware = {},

    -- конечный обработчик
    middlewareHandler = "",

    -- конструктор
    new = function(self, container)
        self.mode = self.modes.trade

        self.eventManager = container:get("EventManager")
        self.eventKeyboardManager = container:get("EventKeyboardManager")

        self.queue = container:get("Queue")
        self.pipeline = container:get("Pipeline")
        self.middlewareHandler = container:get("config").middlewareHandler

        return self
    end,

    -- добавляем middleware в очередь
    pipe = function(self, middleware)
        self.pipeline:pipe(middleware)
    end,

    -- обработчик очереди сообщений полученных от обратных функций
    handle = function(self)
        -- проверить данные из очереди, если очередь не пустая
        if not self:isEmptyQueue() then
            self.pipeline:process(self:deQueue(), self.middlewareHandler)
        end
    end,

    -- добавление подписчиков на события
    attach = function(self, event, listener)
        self.eventManager:attach(event, listener)
    end,

    -- добавление подписчиков для обработки нажатий на клавиши клавиатуры
    attachKey = function(self, key, listener)
        self.eventKeyboardManager:attach(key, listener)
    end,

    -- вызов обработчика события
    trigger = function(self, eventName, argv, target)
        return self.eventManager:trigger(eventName, argv, target)
    end,

    -- добавление данных в очередь
    enQueue = function(self, name, value)
        self.queue:enqueue({
            name = name,
            data = value
        })
    end,

    -- получение значения из очереди
    deQueue = function(self)
        return self.queue:dequeue()
    end,

    -- проверка очереди на пустоту
    isEmptyQueue = function(self)
        return self.queue:isEmpty()
    end,

    -- вернуть режим работы приложения
    getMode = function(self, mode)
        -- если нет соединения с сервером
        if mode == "no_connection" then
            return sleep(self.modes.no_connection)
        end

        -- установленный по умолчанию во время запуска приложения App
        return sleep(self.mode)
    end,

    -- проверяет подключение
    isConnected = function()
        if isConnected() == 1 then
            return true
        end

        return false
    end,

    -- запуск цикличной обработки
    run = function(self)
        -- маркер инициализации приложения
        local init = false

        -- счётчик запусков
        local countInit = 0

        -- если приложение не было остановлено
        while isRun do

            -- при первом запуске - не останавливаться
            if countInit == 0 then
                countInit = 1
            else
                self:getMode()
            end

            -- инициализация приложения если не было запущено и есть подключение
            if not init and self:isConnected() then
                -- запуск приложения - один раз (создание события)
                self:trigger("appStarted")

                -- установка маркера инициализации приложения
                init = true
            end

            -- если есть подключение и приложение не было остановлено
            while isRun and self:isConnected() do
                -- обработка полученных сообщений (order, stop_order, trade)
                -- от функций обратного вызова - OnOrder(), OnStopOrder(), OnTrade()
                self:handle()

                -- запуск цикличного вызова (создание события)
                self:trigger("appRun")

                self:getMode()
            end

            -- если связь потеряна - делаем паузу
            if isRun then
                self:getMode("no_connection")
            end
        end

        -- обработка завершения работы приложения:
        -- создание события - ("Приложение остановлено")
        -- (закрытие всех соединений, запись логов, закрытие всех лотов)
        self:trigger("appStopped")
    end,

    -- запуск цикличной обработки (для разработки)
    runDev = function(self)
        -- маркер инициализации приложения
        local init = false

        -- счётчик запусков
        local countInit = 0

        ---==========================================
        --- сколько раз нужно запустить приложение
        local configRun = 2

        ---------------------------------------------
        -- сколько циклов приложение отработало
        local countRun = 1
        ---==========================================

        -- если приложение не было остановлено
        while isRun do
            -- при первом запуске - не останавливаться
            if countInit == 0 then
                countInit = 1
            else
                self:getMode()
            end

            -- инициализация приложения если не было запущено и есть подключение
            if not init and self:isConnected() then
                -- запуск приложения - один раз (создание события)
                self:trigger("appStarted")

                -- установка маркера инициализации приложения
                init = true
            end

            -- если есть подключение и приложение не было остановлено
            while isRun and self:isConnected() do
                -- обработка полученных сообщений (order, stop_order, trade)
                -- от функций обратного вызова - OnOrder(), OnStopOrder(), OnTrade()
                self:handle()

                -- запуск цикличного вызова (создание события)
                self:trigger("appRun")

                self:getMode()

                if countRun == configRun then
                    isRun = false
                end

                countRun = countRun + 1
            end

            -- если связь потеряна - делаем паузу
            if isRun then
                self:getMode("no_connection")
            end
        end

        -- обработка завершения работы приложения:
        -- создание события - ("Приложение остановлено")
        -- (закрытие всех соединений, запись логов, закрытие всех лотов)
        self:trigger("appStopped")
    end
}

return Application
