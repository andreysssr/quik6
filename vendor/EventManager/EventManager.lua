---

local EventManager = {
    --
    name = "EventManager",

    -- ����������� ������� � �� ���������
    events = {},

    -- ��� ������������� ��� �������� ������� � trigger().
    eventPrototype = "",

    --
    resolver = {},

    --new = function(self, resolver, event)
    new = function(self, container)
        self.resolver = container:get("Resolver")
        self.eventPrototype = container:get("EventManager_Event")

        return self
    end,

    -- ���������� ������ �������� �������
    setEventPrototype = function(self, prototype)
        self.eventPrototype = prototype
    end,

    -- ���������� ����������
    attach = function(self, eventName, listener)
        if not is_string(eventName) then
            error('������� ������ ���� �������')
        end

        local event = {}
        event[eventName] = {}

        -- mark ����������� ��������� event
        self.events = array_merge(self.events, event)
        self.events[eventName][#self.events[eventName] + 1] = listener
    end,

    -- ���������� �������� ������� �����������
    trigger = function(self, eventName, argv, target)
        local event = clone(self.eventPrototype)

        event:setName(eventName)

        if not is_nil(target) then
            event:setTarget(target)
        end

        if (argv) then
            event:setParams(argv)
        end

        return self:triggerListeners(event)
    end,

    --
    triggerListeners = function(self, event)
        local name = event:getName()

        if empty(name) then
            error('������� �� ����� �����; �� ����� �������!')
        end

        -- ������ ������ ������ �����������
        local listeners = {}

        -- ���� ���������� �� ������ ������� ���� - ��������� �� � ������
        if isset(self.events[name]) then
            listeners = self.events[name]

            -- ����� ��������� � ��� ��������� ����������� �� ��� �������
            if isset(self.events["*"]) then
                listeners = array_merge(listeners, self.events["*"])
            end
            -- ���� ����������� �� ���������� ������� ��� - ��������� ������ ����������� �� ��� �������
        elseif isset(self.events["*"]) then
            listeners = self.events["*"]
        end

        -- � ������� ������������� ��������� � false - �.�. ���������� ���������
        -- ���� ����������� true - ���������� ���������� ���������
        event:stopPropagation(false)

        local response = {}

        -- ���� ���� ���������� �� ������� - �������� �� �� ������� � ������� � ������ - �������
        if not empty(listeners) then

            for _, listener in pairs(listeners) do
                response[#response + 1] = self.resolver:resolve(listener, event)

                -- ���� � ������� ������� ��������� ���������� ��������� � ������ ����������� ������������
                if event:propagationIsStopped() then
                    return response
                end
            end

            return response
        end

        -- ���� ����������� ��� - ���������� ������ ���������
        return response
    end,
}

return EventManager
