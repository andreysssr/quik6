--- Middleware FilterStopOrder

local Middleware = {
    --
    name = "Middleware_FilterStopOrder",

    -- ��������� id �������
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

        -- ������ ������ ������ ��� � trans_id �� �������
        if not self.data[key] then
            self.data[key] = 1

            return true
        end

        return false
    end,

    -- ��������� stopOrder
    process = function(self, request, handler)
        -- ��� stopOrder
        if request.name == "stopOrder" then
            -- ���� ��������� �������� ������
            if self:allowNext(request) then

                -- ������� ��������� ������
                handler:handle(request)
            end

            return
        end

        -- ���� name ~= stopOrder
        handler:handle(request)
    end,
}

return Middleware
