--- Middleware FilterStopOrder

local Middleware = {
    --
    name = "Middleware_FilterStopOrder",

    -- хранилище id номеров
    data = {},

    --
    new = function(self, container)

        return self
    end,

    --
    allowNext = function(self, request)
        local order_num = request.data.order_num
        local status = request.data.status

        local key = tostring(order_num) .. "_" .. status

        -- запрос пришёл первый раз и trans_id не нулевой
        if not self.data[key] then
            self.data[key] = 1

            return true
        end

        return false
    end,

    -- обработка stopOrder
    process = function(self, request, handler)
        -- для stopOrder
        if request.name == "stopOrder" then
            -- если разрешить передачу дальше
            if self:allowNext(request) then

                -- передаём обработку дальше
                handler:handle(request)
            end

            return
        end

        -- если name ~= stopOrder
        handler:handle(request)
    end,
}

return Middleware
