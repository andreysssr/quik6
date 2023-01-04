--- Handler PoleRating

local Handler = {
    --
    name = "Handler_PoleRating",

    --
    storage = {},

    --
    new = function(self, container)
        self.storage = container:get("Storage")

        return self
    end,

    --
    getParams = function(self, idStock)
        --
        local rating = self.storage:getRating(idStock)

        local result = {}

        if not_nil(rating) then
            result.rating_data = rating
        end

        return result
    end,
}

return Handler
