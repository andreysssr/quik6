--- MicroService ActiveStockPanelTrade - Управляет активным инструментом в торговой панели

local MicroService = {
    --
    name = "MicroService_ActiveStockPanelTrade",

    --
    container = {},

    --
    entityService = {},

    --
    eventSender = {},

    -- массив в котором ключами являются idStock - для проверки полученного idStock
    arrayIdStock = {},

    -- хранит текущий и предыдущий idStock
    dataActive = {
        current = "",
        prev = "",
    },

    --
    new = function(self, container)
        self.container = container
        self.entityService = container:get("EntityService_Stock")
        self.eventSender = container:get("AppService_EventSender")

        self:prepareArrayIdStock()

        return self
    end,

    -- подготавливает массив - где ключами являются idStock
    prepareArrayIdStock = function(self)
        local arrayStock = self.container:get("Storage"):getHomeworkId()

        for i = 1, #arrayStock do
            self.arrayIdStock[arrayStock[i]] = 1
        end
    end,

    -- проверка текущего инструмента дна доступность
    checkCurrentStock = function(self)
        if self.dataActive.current ~= "" then
            local idStock = self.dataActive.current

            if not self.entityService:isActive(idStock) then
                self.dataActive.prev = self.dataActive.current

                -- текущий id очищаем
                self.dataActive.current = ""
            end
        end
    end,

    -- переключение текущего в дефолтное состояние
    resetCurrent = function(self)
        local actions = {}

        --	если был включен любой id
        if self.dataActive.current ~= "" then
            -- переносим текущий инструмент в предыдущий
            self.dataActive.prev = self.dataActive.current

            -- добавляем id для выключение
            actions.off = self.dataActive.prev

            -- очищаем текущий id
            self.dataActive.current = ""

            -- применяем изменения
            self:commit(actions)
        end
    end,

    -- переключение на предыдущую бумагу
    reversCurrent = function(self)
        local actions = {}

        -- если (текущий не пустой) и (предыдущий не пустой)
        --	если был включен любой id
        if self.dataActive.current ~= "" and self.dataActive.prev ~= "" then

            -- если предыдущая бумага не разрешена к торговле
            -- тогда выключаем текущую бумагу
            if not self:allowedAction(self.dataActive.prev) then
                self:resetCurrent()

                return
            end

            local newActiveStock = self.dataActive.prev

            -- переносим текущий инструмент в предыдущий
            self.dataActive.prev = self.dataActive.current

            -- добавляем id для выключение
            actions.off = self.dataActive.prev

            -- включаем текущий id
            self.dataActive.current = newActiveStock

            -- добавляем id для включения
            actions.on = self.dataActive.current

            -- применяем изменения
            self:commit(actions)

            return
        end

        -- если (текущий не пустой), а (предыдущий пустой)
        if self.dataActive.current ~= "" and self.dataActive.prev == "" then
            self.dataActive.prev = self.dataActive.current

            -- добавляем id для выключение
            actions.off = self.dataActive.prev

            -- очищаем текущий
            self.dataActive.current = ""

            -- применяем изменения
            self:commit(actions)

            return
        end

        -- если (текущий пустой), а (предыдущий не пустой)
        if self.dataActive.current == "" and self.dataActive.prev ~= "" then

            -- если предыдущая бумага не разрешена к торговле
            -- тогда выключаем текущую бумагу
            if not self:allowedAction(self.dataActive.prev) then
                -- очищаем предыдущий
                self.dataActive.prev = ""

                return
            end

            self.dataActive.current = self.dataActive.prev

            -- добавляем id для выключение
            actions.on = self.dataActive.current

            -- очищаем предыдущий
            self.dataActive.prev = ""

            -- применяем изменения
            self:commit(actions)

            return
        end
    end,

    -- разрешено ли включение бумаги
    allowedAction = function(self, idStock)
        local status = self.entityService:getStatus(idStock)

        if status == "active" or status == "limitedActive" then
            return true
        end

        return false
    end,

    -- изменить активный инструмент
    changeActive = function(self, idStock)
        if isset(self.arrayIdStock[idStock]) then
            -- кликнули на (ДОСТУПНЫЙ к торговле) id
            if self:allowedAction(idStock) then
                -- 1 панель не активна - кликаем
                --		текущий пустой,
                if self.dataActive.current == "" then
                    local actions = {}

                    self.dataActive.prev = self.dataActive.current

                    self.dataActive.current = idStock

                    -- добавляем id для включения
                    actions.on = self.dataActive.current

                    -- применяем изменения
                    self:commit(actions)

                    return
                end

                -- 2 панель активна - кликаем на другой
                --		текущий не пустой,
                if self.dataActive.current ~= "" and self.dataActive.current ~= idStock then
                    local actions = {}

                    self.dataActive.prev = self.dataActive.current

                    -- выключаем тот что был включённым
                    actions.off = self.dataActive.prev

                    -- в текущий записываем тот по которому кликнули
                    self.dataActive.current = idStock

                    -- добавляем id для включения
                    actions.on = self.dataActive.current

                    -- применяем изменения
                    self:commit(actions)

                    return
                end
            end

            -- кликнули на (НЕ ДОСТУПНЫЙ к торговле) id
            if not self:allowedAction(idStock) then
                local actions = {}

                --	если был включен любой id
                if self.dataActive.current ~= "" then
                    -- переносим текущий инстурмент в предыдущий
                    self.dataActive.prev = self.dataActive.current

                    -- добавляем id для выключение
                    actions.off = self.dataActive.prev

                    --
                    self.dataActive.current = ""

                    -- применяем изменения
                    self:commit(actions)
                end
            end
        end
    end,

    -- возвращает текущую активную бумагу если есть иначер вернёт: ""
    getCurrentIdStock = function(self)
        return self.dataActive.current
    end,

    -- создаёт событие
    commitAction = function(self, action, id)
        self.eventSender:send("MicroService_ChangedActiveStock", {
            id = id,
            stock = action
        })
    end,

    -- фиксирует изменения
    commit = function(self, actions)
        for action, id in pairs(actions) do
            self:commitAction(action, id)
        end
    end,
}

return MicroService
