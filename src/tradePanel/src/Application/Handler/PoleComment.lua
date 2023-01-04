--- Handler PoleComment

local Handler = {
    --
    name = "Handler_PoleComment",

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
        local comment = self.storage:getCommentToId(idStock)

        return {
            comment_data = comment
        }
    end,
}

return Handler
