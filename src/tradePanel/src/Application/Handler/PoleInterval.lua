--- Handler PoleInterval

local Handler = {
    --
    name = "Handler_PoleInterval",

    --
    storage = {},

    --
    new = function(self, container)
        self.storage = container:get("Storage")

        return self
    end,

    --
    getParams = function(self, idStock)
        local interval = self.storage:getIntervalToId(idStock)

        local result = {}

        if not_nil(interval) then
            result.interval_data = interval
        end

        return result
    end,
}

return Handler
