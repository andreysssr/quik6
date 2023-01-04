--- Handler PoleShortAllow

local Handler = {
    --
    name = "Handler_PoleShortAllow",

    --
    container = {},

    --
    storage = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")

        return self
    end,

    --
    getParams = function(self, idStock)
        local shortAllow = self.storage:getAllowedShortToId(idStock)

        if shortAllow then
            return { shortAllow_data = "V" }
        else
            return {}
        end
    end,
}

return Handler
