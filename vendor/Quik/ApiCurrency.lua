---  Api Futures

local Api = {

    --
    name = function(self, container)
        extended(self, container:get("Quik"))

        return self
    end,
}

return Api
