--- Resolver создаёт обработчик из строки (listeners - подписчики)

local Resolver = {
    -- название класса
    name = "Resolver",

    container = {},

    new = function(self, container)
        self.container = container

        return self
    end,

    -- создание обработчика из строки, функции, массива и передача ему события для обработки
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
        -- разделяем имя объекта на имя и метод (если метод прописан через @)
        -- например EventHandler_Logger			- будет вызван метод handle
        -- например EventHandler_Logger@write	- будет вызван метод write
        local names = explode("@", handler)

        local handlerName = names[1]    -- имя объекта
        local methodName = names[2]        -- метод объекта

        -- получаем объект из контейнера
        local handlerObj = self.container:get(handlerName)

        -- объект не вернул себя из метода (new)
        if not handlerObj then
            error("\r\n\r\n" .. "Error: Объект (" .. tostring(handler) .. ") не вернул себя из метода (new), в методе отсутствует [return self]")
        end

        -- если был задан метод после символа @
        if not_nil(methodName) then
            -- проверяем наличие метода у объекта
            if not_method_exists(handlerObj, methodName) then
                error("\r\n\r\n" .. "Error: У объекта (" .. handlerName .. ") отсутствует метод (" .. methodName .. ")", 2)
            end

            return handlerObj[methodName](handlerObj, params1, params2, params3)
        end

        -- проверяем наличие метода (handle) у объекта
        if not_method_exists(handlerObj, "handle") then
            error("\r\n\r\n" .. "Error: У объекта (" .. handlerName .. ") отсутствует метод (handle)", 2)
        end

        return handlerObj:handle(params1, params2, params3)
    end
}

return Resolver
