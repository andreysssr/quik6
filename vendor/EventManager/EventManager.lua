---

local EventManager = {
    --
    name = "EventManager",

    -- подписанные события и их слушатели
    events = {},

    -- для использования при создании события в trigger().
    eventPrototype = "",

    --
    resolver = {},

    --new = function(self, resolver, event)
    new = function(self, container)
        self.resolver = container:get("Resolver")
        self.eventPrototype = container:get("EventManager_Event")

        return self
    end,

    -- установить другой прототип события
    setEventPrototype = function(self, prototype)
        self.eventPrototype = prototype
    end,

    -- прикрепить подписчика
    attach = function(self, eventName, listener)
        if not is_string(eventName) then
            error('Событие должно быть строкой')
        end

        local event = {}
        event[eventName] = {}

        -- mark просмотреть структуру event
        self.events = array_merge(self.events, event)
        self.events[eventName][#self.events[eventName] + 1] = listener
    end,

    -- вызывается передача события подписчикам
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
            error('Событие не имеет имени; не может вызвать!')
        end

        -- создаём пустой массив подписчиков
        local listeners = {}

        -- если подписчики на данное событие есть - добавляем их в массив
        if isset(self.events[name]) then
            listeners = self.events[name]

            -- также добавляем к уже имеющимся подписчиков на все события
            if isset(self.events["*"]) then
                listeners = array_merge(listeners, self.events["*"])
            end
            -- если подписчиков на конкретное событие нет - добавляем только подписчиков на все события
        elseif isset(self.events["*"]) then
            listeners = self.events["*"]
        end

        -- у события устанавливаем остановку в false - т.е. продолжать обработку
        -- если установлена true - остановить дальнейшую обработку
        event:stopPropagation(false)

        local response = {}

        -- если есть подписчики на событие - вызываем их по очереди и передаём в каждый - событие
        if not empty(listeners) then

            for _, listener in pairs(listeners) do
                response[#response + 1] = self.resolver:resolve(listener, event)

                -- если у события вызвали остановку дальнейшей обработки в других подписчиках прекращается
                if event:propagationIsStopped() then
                    return response
                end
            end

            return response
        end

        -- если подписчиков нет - возвращаем пустой результат
        return response
    end,
}

return EventManager
