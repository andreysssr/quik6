--- Middleware PrintCallback - для просмотра пришедших данных

local Middleware = {

    name = "Middleware_PrintCallback",

    container = {},

    counter = 1,

    new = function(self, container)
        self.container = container

        return self
    end,

    process = function(self, request, handler)
        dd(request.name, 1)
        dd(request.data, 1)
        --
        handler:handle(request)
    end,
}

return Middleware

