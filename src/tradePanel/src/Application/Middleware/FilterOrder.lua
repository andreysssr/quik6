--- Middleware FilterOrder

local Middleware = {
    --
    name = "Middleware_FilterOrder",

    --
    container = {},

    -- ��������� id �������
    data = {},

    -- ��������� id �������
    tmp = {},

    --
    new = function(self, container)
        self.container = container

        return self
    end,

    -- ��������� �������� ��������� ������ ��� ���
    -- ���������� ������ ������ ���������
    allowNextPosted = function(self, request)
        local order_num = request.data.order_num
        local status = request.data.status

        local key = tostring(order_num) .. "_" .. status

        -- ������ ������ ������ ��� (����� ���������� ����� ����� 0)
        if not self.tmp[key] then
            self.tmp[key] = 1

            return false
        end

        -- ������ ������ ������ ��� (����� ���������� ����� ��������)
        if self.tmp[key] and not self.data[key] then
            self.data[key] = 1

            return true
        end

        -- ������ ������ ������ � ����� ���
        if self.tmp[key] and self.data[key] then

            return false
        end
    end,

    -- ��������� �������� ��������� ������ ��� ���
    -- ���������� ������ ������ ���������
    allowNextExecuted = function(self, request)
        local order_num = request.data.order_num
        local status = request.data.status

        local key = tostring(order_num) .. "_" .. status

        -- ������ ��� � ���� trans_id
        if not self.tmp[key] and request.data.trans_id ~= 0 then
            self.tmp[key] = 1
            self.data[key] = 1

            return true
        end

        -- ������ ������ 1 ��� (����� ���������� ������)
        if not self.tmp[key] and request.data.trans_id == 0 then
            self.tmp[key] = 1

            return false
        end

        -- ������ ������ ������ ��� (����� ���������� ����� ��������)
        if self.tmp[key] and not self.data[key] then
            self.data[key] = 1

            return true
        end

        -- ������ ������ ������ ���
        if self.tmp[key] and self.data[key] then

            -- ������ ������ 3 ���
            return false
        end

        return true
    end,

    -- ��������� �������� ��������� ������ ��� ���
    -- ���������� ������ ������ ���������
    allowNextDeleted = function(self, request)
        local order_num = request.data.order_num
        local status = request.data.status

        local key = tostring(order_num) .. "_" .. status

        -- ������ ������ 1 ���
        if not self.tmp[key] then
            self.tmp[key] = 1

            return true
        end

        -- ������ ������ 2 ���
        if self.tmp[key] then

            return false
        end
    end,

    -- ��������� order
    process = function(self, request, handler)
        -- ��� order
        if request.name == "order" then

            if request.data.status == "posted" then
                -- ���� ��������� �������� ��������� ������
                if self:allowNextPosted(request) then

                    -- ������� ��������� ������
                    handler:handle(request)
                end

                -- ������������� ���������
                return
            elseif request.data.status == "executed" then
                -- ���� ��������� �������� ��������� ������
                if self:allowNextExecuted(request) then

                    -- ������� ��������� ������
                    handler:handle(request)
                end

                -- ������������� ���������
                return
            elseif request.data.status == "deleted" then
                -- ���� ��������� �������� ��������� ������
                if self:allowNextDeleted(request) then

                    -- ������� ��������� ������
                    handler:handle(request)
                end

                -- ������������� ���������
                return
            end
        end

        -- ���� name ~= order
        handler:handle(request)
    end,
}

return Middleware
