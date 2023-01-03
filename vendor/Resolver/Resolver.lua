--- Resolver ������ ���������� �� ������ (listeners - ����������)

local Resolver = {
    -- �������� ������
    name = "Resolver",

    container = {},

    new = function(self, container)
        self.container = container

        return self
    end,

    -- �������� ����������� �� ������, �������, ������� � �������� ��� ������� ��� ���������
    resolve = function(self, handler, ...)
        local args = { ... }

        if is_function(handler) then
            return handler(unpack(args))
        end

        if is_string(handler) then
            return self:createHandler(handler, unpack(args))
        end

        if is_array(handler) then
            for i = 1, #handler do
                self:createHandler(handler[i], unpack(args))
            end
        end
    end,

    --
    createHandler = function(self, handler, params1, params2, params3)
        -- ��������� ��� ������� �� ��� � ����� (���� ����� �������� ����� @)
        -- �������� EventHandler_Logger			- ����� ������ ����� handle
        -- �������� EventHandler_Logger@write	- ����� ������ ����� write
        local names = explode("@", handler)

        local handlerName = names[1]    -- ��� �������
        local methodName = names[2]        -- ����� �������

        -- �������� ������ �� ����������
        local handlerObj = self.container:get(handlerName)

        -- ������ �� ������ ���� �� ������ (new)
        if not handlerObj then
            error("\r\n\r\n" .. "Error: ������ (" .. tostring(handler) .. ") �� ������ ���� �� ������ (new), � ������ ����������� [return self]")
        end

        -- ���� ��� ����� ����� ����� ������� @
        if not_nil(methodName) then
            -- ��������� ������� ������ � �������
            if not_method_exists(handlerObj, methodName) then
                error("\r\n\r\n" .. "Error: � ������� (" .. handlerName .. ") ����������� ����� (" .. methodName .. ")", 2)
            end

            return handlerObj[methodName](handlerObj, params1, params2, params3)
        end

        -- ��������� ������� ������ (handle) � �������
        if not_method_exists(handlerObj, "handle") then
            error("\r\n\r\n" .. "Error: � ������� (" .. handlerName .. ") ����������� ����� (handle)", 2)
        end

        return handlerObj:handle(params1, params2, params3)
    end
}

return Resolver
