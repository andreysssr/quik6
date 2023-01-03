---

local EventKeyboardManager = {
    --
    name = "EventKeyboardManager",

    -- карта кодов и их значений
    dataKeys = {},

    -- подписчики на клики клавиатуры
    listeners = {},

    --
    resolver = {},

    -- конструктор
    new = function(self, container)
        self.resolver = container:get("Resolver")

        local file = container:get("config").dataPath.keyboardKeys
        local name = Autoload:getPathFile(file)
        self.dataKeys = dofile(name)

        return self
    end,

    -- прикрепить подписчика
    attach = function(self, key, handler)
        self.listeners[key] = handler
    end,

    --
    trigger = function(self, key)
        local handler = ""
        local event = {}

        if isset(self.listeners[key]) then
            -- если подписаны на цифровой код
            handler = self.listeners[key]
            event.code = key
            event.attachKey = self.dataKeys[key]

            return self.resolver:resolve(handler, event)
        else
            -- если подписаны на строковый код - значение цифрового
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
