--- Middleware FilterOrder

local Middleware = {
    --
    name = "Middleware_FilterOrder",

    --
    container = {},

    -- хранилище id номеров
    data = {},

    -- хранилище id номеров
    tmp = {},

    --
    new = function(self, container)
        self.container = container

        return self
    end,

    -- разрешить отправку сообщения дальше или нет
    -- пропускаем только второе сообщение
    allowNextPosted = function(self, request)
        local order_num = request.data.order_num
        local status = request.data.status

        local key = tostring(order_num) .. "_" .. status

        -- запрос пришёл первый раз (номер транзакции бдует равен 0)
        if not self.tmp[key] then
            self.tmp[key] = 1

            return false
        end

        -- запрос пришёл второй раз (номер транзакции бдует заполнен)
        if self.tmp[key] and not self.data[key] then
            self.data[key] = 1

            return true
        end

        -- запрос пришёл третий и более раз
        if self.tmp[key] and self.data[key] then

            return false
        end
    end,

    -- разрешить отправку сообщения дальше или нет
    -- пропускаем только второе сообщение
    allowNextExecuted = function(self, request)
        local order_num = request.data.order_num
        local status = request.data.status

        local key = tostring(order_num) .. "_" .. status

        -- первый раз и есть trans_id
        if not self.tmp[key] and request.data.trans_id ~= 0 then
            self.tmp[key] = 1
            self.data[key] = 1

            return true
        end

        -- запрос пришёл 1 раз (номер транзакции пустой)
        if not self.tmp[key] and request.data.trans_id == 0 then
            self.tmp[key] = 1

            return false
        end

        -- запрос пришёл второй раз (номер транзакции будет заполнен)
        if self.tmp[key] and not self.data[key] then
            self.data[key] = 1

            return true
        end

        -- запрос пришёл третий раз
        if self.tmp[key] and self.data[key] then

            -- запрос пришёл 3 раз
            return false
        end

        return true
    end,

    -- разрешить отправку сообщения дальше или нет
    -- пропускаем только первое сообщение
    allowNextDeleted = function(self, request)
        local order_num = request.data.order_num
        local status = request.data.status

        local key = tostring(order_num) .. "_" .. status

        -- запрос пришёл 1 раз
        if not self.tmp[key] then
            self.tmp[key] = 1

            return true
        end

        -- запрос пришёл 2 раз
        if self.tmp[key] then

            return false
        end
    end,

    -- обработка order
    process = function(self, request, handler)
        -- для order
        if request.name == "order" then

            if request.data.status == "posted" then
                -- если разрешена передача сообщения дальше
                if self:allowNextPosted(request) then

                    -- передаём обработку дальше
                    handler:handle(request)
                end

                -- останавливаем обработку
                return
            elseif request.data.status == "executed" then
                -- если разрешена передача сообщения дальше
                if self:allowNextExecuted(request) then

                    -- передаём обработку дальше
                    handler:handle(request)
                end

                -- останавливаем обработку
                return
            elseif request.data.status == "deleted" then
                -- если разрешена передача сообщения дальше
                if self:allowNextDeleted(request) then

                    -- передаём обработку дальше
                    handler:handle(request)
                end

                -- останавливаем обработку
                return
            end
        end

        -- если name ~= order
        handler:handle(request)
    end,
}

return Middleware
