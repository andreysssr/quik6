---

local Next = {
    --
    name = "Pipeline_Next",

    --
    middlewareHandler = {},

    --
    queue = {},

    --
    resolver = {},

    --
    new = function(self, container)
        self.resolver = container:get("Resolver_Middleware")

        return self
    end,

    -- сохраняем полученную очередь
    fakeNew = function(self, queue, handler)
        self.queue = queue
        self.middlewareHandler = handler

        return self
    end,

    --
    handle = function(self, request)
        if self.queue:isEmpty() then
            self.queue = nil
            return self.resolver:resolve(self.middlewareHandler):handle(request)
        end

        local middleware = self.resolver:resolve(self.queue:dequeue())
        return middleware:process(request, self)
    end
}

return Next
