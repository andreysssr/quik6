---

local EventKeyboardManager = {
    --
    name = "EventKeyboardManager",

    -- ����� ����� � �� ��������
    dataKeys = {},

    -- ���������� �� ����� ����������
    listeners = {},

    --
    resolver = {},

    -- �����������
    new = function(self, container)
        self.resolver = container:get("Resolver")

        local file = container:get("config").dataPath.keyboardKeys
        local name = Autoload:getPathFile(file)
        self.dataKeys = dofile(name)

        return self
    end,

    -- ���������� ����������
    attach = function(self, key, handler)
        self.listeners[key] = handler
    end,

    --
    trigger = function(self, key)
        local handler = ""
        local event = {}

        if isset(self.listeners[key]) then
            -- ���� ��������� �� �������� ���
            handler = self.listeners[key]
            event.code = key
            event.attachKey = self.dataKeys[key]

            return self.resolver:resolve(handler, event)
        else
            -- ���� ��������� �� ��������� ��� - �������� ���������
            local _key = self.dataKeys[key]

            if isset(self.listeners[_key]) then
                handler = self.listeners[_key]

                event.code = key
                event.attachKey = self.dataKeys[key]

                return self.resolver:resolve(handler, event)
            end
        end
    end
}

return EventKeyboardManager
