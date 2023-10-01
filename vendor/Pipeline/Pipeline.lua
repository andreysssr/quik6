---

local Pipeline = {
    --
    name = "Pipeline",

    -- Queue
    pipeline = {},

    --
    container = {},

    --
    new = function(self, container)
        self.pipeline = container:get("Queue")
        self.container = container

        return self
    end,

    --
    process = function(self, request, handler)
        return self.container:get("Pipeline_Next"):fakeNew(clone(self.pipeline), handler):handle(request)
    end,

    -- добавляет middleware в текущий pipeline
    pipe = function(self, middleware)
        self.pipeline:enqueue(middleware)
    end
}

return Pipeline
