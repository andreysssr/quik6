---  Api Futures

local Api = {

    --
    name = function(self, container)
        extended(self, container:get("Quik_Currency"))

        return self
    end,

}

return Api
