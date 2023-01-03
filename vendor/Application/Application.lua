--- Application

local Application = {
    --
    name = "Application",

    -- ������ ������ ���������� �� ��������
    modes = {
        trade = 200, -- ������� ������� - �������� �� ��������� ����
        no_connection = 2000, -- ���������� - �������� �� ���
    },

    -- ������������� ����� ������ ����������
    mode = 200,

    -- �������� �������
    eventManager = {},

    -- �������� ������ �� ���������� - �������� �����������
    -- ������� ��������� �� �������
    eventKeyboardManager = {},

    -- �������
    queue = {},

    -- ��������� Middleware
    pipeline = {},

    -- �������� Middleware
    resolverMiddleware = {},

    -- �������� ����������
    middlewareHandler = "",

    -- �����������
    new = function(self, container)
        self.mode = self.modes.trade

        self.eventManager = container:get("EventManager")
        self.eventKeyboardManager = container:get("EventKeyboardManager")

        self.queue = container:get("Queue")
        self.pipeline = container:get("Pipeline")
        self.middlewareHandler = container:get("config").middlewareHandler

        return self
    end,

    -- ��������� middleware � �������
    pipe = function(self, middleware)
        self.pipeline:pipe(middleware)
    end,

    -- ���������� ������� ��������� ���������� �� �������� �������
    handle = function(self)
        -- ��������� ������ �� �������, ���� ������� �� ������
        if not self:isEmptyQueue() then
            self.pipeline:process(self:deQueue(), self.middlewareHandler)
        end
    end,

    -- ���������� ����������� �� �������
    attach = function(self, event, listener)
        self.eventManager:attach(event, listener)
    end,

    -- ���������� ����������� ��� ��������� ������� �� ������� ����������
    attachKey = function(self, key, listener)
        self.eventKeyboardManager:attach(key, listener)
    end,

    -- ����� ����������� �������
    trigger = function(self, eventName, argv, target)
        return self.eventManager:trigger(eventName, argv, target)
    end,

    -- ���������� ������ � �������
    enQueue = function(self, name, value)
        self.queue:enqueue({
            name = name,
            data = value
        })
    end,

    -- ��������� �������� �� �������
    deQueue = function(self)
        return self.queue:dequeue()
    end,

    -- �������� ������� �� �������
    isEmptyQueue = function(self)
        return self.queue:isEmpty()
    end,

    -- ������� ����� ������ ����������
    getMode = function(self, mode)
        -- ���� ��� ���������� � ��������
        if mode == "no_connection" then
            return sleep(self.modes.no_connection)
        end

        -- ������������� �� ��������� �� ����� ������� ���������� App
        return sleep(self.mode)
    end,

    -- ��������� �����������
    isConnected = function()
        if isConnected() == 1 then
            return true
        end

        return false
    end,

    -- ������ ��������� ���������
    run = function(self)
        -- ������ ������������� ����������
        local init = false

        -- ������� ��������
        local countInit = 0

        -- ���� ���������� �� ���� �����������
        while isRun do

            -- ��� ������ ������� - �� ���������������
            if countInit == 0 then
                countInit = 1
            else
                self:getMode()
            end

            -- ������������� ���������� ���� �� ���� �������� � ���� �����������
            if not init and self:isConnected() then
                -- ������ ���������� - ���� ��� (�������� �������)
                self:trigger("appStarted")

                -- ��������� ������� ������������� ����������
                init = true
            end

            -- ���� ���� ����������� � ���������� �� ���� �����������
            while isRun and self:isConnected() do
                -- ��������� ���������� ��������� (order, stop_order, trade)
                -- �� ������� ��������� ������ - OnOrder(), OnStopOrder(), OnTrade()
                self:handle()

                -- ������ ���������� ������ (�������� �������)
                self:trigger("appRun")

                self:getMode()
            end

            -- ���� ����� �������� - ������ �����
            if isRun then
                self:getMode("no_connection")
            end
        end

        -- ��������� ���������� ������ ����������:
        -- �������� ������� - ("���������� �����������")
        -- (�������� ���� ����������, ������ �����, �������� ���� �����)
        self:trigger("appStopped")
    end,

    -- ������ ��������� ��������� (��� ����������)
    runDev = function(self)
        -- ������ ������������� ����������
        local init = false

        -- ������� ��������
        local countInit = 0

        ---==========================================
        --- ������� ��� ����� ��������� ����������
        local configRun = 2

        ---------------------------------------------
        -- ������� ������ ���������� ����������
        local countRun = 1
        ---==========================================

        -- ���� ���������� �� ���� �����������
        while isRun do
            -- ��� ������ ������� - �� ���������������
            if countInit == 0 then
                countInit = 1
            else
                self:getMode()
            end

            -- ������������� ���������� ���� �� ���� �������� � ���� �����������
            if not init and self:isConnected() then
                -- ������ ���������� - ���� ��� (�������� �������)
                self:trigger("appStarted")

                -- ��������� ������� ������������� ����������
                init = true
            end

            -- ���� ���� ����������� � ���������� �� ���� �����������
            while isRun and self:isConnected() do
                -- ��������� ���������� ��������� (order, stop_order, trade)
                -- �� ������� ��������� ������ - OnOrder(), OnStopOrder(), OnTrade()
                self:handle()

                -- ������ ���������� ������ (�������� �������)
                self:trigger("appRun")

                self:getMode()

                if countRun == configRun then
                    isRun = false
                end

                countRun = countRun + 1
            end

            -- ���� ����� �������� - ������ �����
            if isRun then
                self:getMode("no_connection")
            end
        end

        -- ��������� ���������� ������ ����������:
        -- �������� ������� - ("���������� �����������")
        -- (�������� ���� ����������, ������ �����, �������� ���� �����)
        self:trigger("appStopped")
    end
}

return Application
