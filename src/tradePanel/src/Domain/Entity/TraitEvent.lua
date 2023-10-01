--- Trait Entity

local Trait = {

    name = "Entity_Trait",

    new = function(self)
        return self
    end,

    -- добавить событие
    registerEvent = function(self, eventName, eventParams)
        local event = {
            eventName = eventName,
            params = eventParams,
        }

        self.events[#self.events + 1] = event
    end,

    -- вернуть события
    releaseEvents = function(self)
        local _events = copy(self.events)

        self.events = {}

        return _events
    end,
}

return Trait
