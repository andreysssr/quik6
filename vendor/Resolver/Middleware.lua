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

        -- ������ �� ������ ���� �� ������ (new)
        if not handlerObj then
            error("\r\n\r\n" .. "Error: ������ (" .. tostring(middleware) .. ") �� ������ ���� �� ������ (new), � ������ ����������� [return self]")
        end

        -- ����������� ����� (handle) � ����� (process)
        if not_method_exists(handlerObj, "handle") and not_method_exists(handlerObj, "process") then
            error("\r\n\r\n" .. "Error: � ������� (" .. middleware .. ") ����������� ����� (handle) � (process)", 2)
        end

        return handlerObj
    end,
}

return ResolverMiddleware
