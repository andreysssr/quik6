---  Api Futures

local Api = {

    --
    name = function(self, container)
        extended(self, container:get("Quik_ApiFutures"))

        return self
    end,
}

return Api
