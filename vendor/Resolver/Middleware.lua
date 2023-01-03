---

local ResolverMiddleware = {
    --
    name = "Resolver_Middleware",

    container = {},

    new = function(self, container)
        self.container = container

        return self
    end,

    resolve = function(self, middleware)
        local handlerObj = self.container:get(middleware)

        -- объект не вернул себя из метода (new)
        if not handlerObj then
            error("\r\n\r\n" .. "Error: Объект (" .. tostring(middleware) .. ") не вернул себя из метода (new), в методе отсутствует [return self]")
        end

        -- отсутствует метод (handle) и метод (process)
        if not_method_exists(handlerObj, "handle") and not_method_exists(handlerObj, "process") then
            error("\r\n\r\n" .. "Error: У объекта (" .. middleware .. ") отсутствует метод (handle) и (process)", 2)
        end

        return handlerObj
    end,
}

return ResolverMiddleware
