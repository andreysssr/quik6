--- Entity Stock

local Entity_Stock = {
    --
    name = "Entity_Stock",

    -- расчёт доступного количества лотов
    serviceMaxLots = {},

    -- коэффициент для увеличения количества лотов
    -- при сравнении с максимальным количеством лотов для покупки
    ratio = 0,

    --
    serviceBasePrice = {},

    --
    serviceCorrectPrice = {},

    -- настройки для запроса
    settingZapros = {},

    -- настройки для стопа запроса для - StopOrderLimit
    settingZaprosOffset = {},

    -- настройки для стопа
    settingStop = {},

    -- настройки для переноса стопа
    settingStopMove = {},

    -- настройки для тейка
    settingTake = {},

    --
    validator = {},

    --
    servicePosition = {},

    --
    new = function(self, container)
        self.serviceMaxLots = container:get("DomainService_CalculateMaxLots")
        self.ratio = container:get("Config_ratio")
        self.serviceBasePrice = container:get("DomainService_GetBasePrice")
        self.serviceCorrectPrice = container:get("DomainService_CorrectPrice")

        self.settingZapros = container:get("config").zapros
        self.settingZaprosOffset = container:get("config").zaprosOffset
        self.settingStop = container:get("config").stop
        self.settingStopMove = container:get("config").stopMove
        self.settingTake = container:get("config").take

        self.validator = container:get("AppService_Validator")
        self.servicePosition = container:get("AppService_GetPosition")

        local trait = container:get("Entity_TraitEvent")
        extended(self, trait)

        return self
    end,

    -- вернуть id
    getId = function(self)
        return self.id
    end,

    -- вернуть класс
    getClass = function(self)
        return self.class
    end,

    -- возвращает противоположное значение операции
    getReverseOperation = function(self, operation)
        self.validator:check_buy_sell(operation)

        if operation == "sell" then
            return "buy"
        end

        if operation == "buy" then
            return "sell"
        end

        return operation
    end,

    -- меняем статус бумаги
    changeStatus = function(self, typeStatus)
        -- если текущий статус бумаги не изменился
        if self.trade.status == typeStatus then
            return
        end

        -- меняем значение статуса
        self.trade.status = typeStatus

        -- регистрация события
        self:registerEvent("EntityStock_ChangedStatus", {
            id = self.id,
            status = self.trade.status
        })
    end,

    -- проверка статуса инструмента
    checkStatus = function(self)
        -- если лотов не, но есть позиции или выставлен запрос
        if self.trade.lots == 0 and (self:hasPosition() or self:hasZapros()) then
            self:changeStatus("limitedActive")

            return
        end

        -- если лотов не, и нет позиций
        if self.trade.lots == 0 then
            self:changeStatus("notActive")

            return
        end

        -- MaxLots < Lots И ((есть позиции) ИЛИ (есть заявки))
        -- становится частично активным:
        --		можно снять заявки
        --		закрыть позиции
        if self.trade.maxLots <= (self.trade.lots * self.ratio) and (self:hasPosition() or self:hasZapros()) then
            self:changeStatus("limitedActive")

            return
        end

        -- MaxLots < Lots
        -- 		становится не активным
        if self.trade.maxLots < (self.trade.lots * self.ratio) then
            self:changeStatus("notActive")

            return
        end

        -- MaxLots > Lots
        -- 		становится активным (если был частично активен или не активен)
        if self.trade.maxLots >= (self.trade.lots * self.ratio) then
            self:changeStatus("active")

            return
        end
    end,

    -- вернуть статус бумаги
    getStatus = function(self)
        return self.trade.status
    end,

    -- прибавляем полученную позицию к текущей
    addPosition = function(self, qty)
        self.validator:checkParamNumber(qty, "qty")

        -- получаем количество лотов в позиции
        local result = self.position.qty + qty

        -- удаляем нули - чтобы число было целым
        self.position.qty = d0(result)

        -- если позиция была закрыта
        if self.position.qty == 0 then
            self.position.operation = ""
            return
        end

        -- если позиция была в лонг
        if self.position.qty > 0 then
            self.position.operation = "buy"
            return
        end

        -- если позиция была в шорт
        if self.position.qty < 0 then
            self.position.operation = "sell"
            return
        end
    end,

    -- проверка наличия открытых позиции
    hasPosition = function(self)
        if self.position.qty == 0 then
            return false
        end

        return true
    end,

    -- вернуть параметры поизиции
    getPositionParams = function(self)
        return self.position
    end,

    -- вернуть количество лотов в наличии
    getPositionQty = function(self)
        return self.position.qty
    end,

    -- вернуть количество лотов для открытия позиции
    getLots = function(self)
        return self.trade.lots
    end,

    -- вернуть максимально возможное количество лотов для всего депозита
    getMaxLots = function(self)
        return self.trade.maxLots
    end,

    -- вернуть параметры запроса
    getZaprosParams = function(self)
        local params = self.zapros.zaprosParams
        params.lots = self.trade.lots

        return params
    end,

    -- добавить запрос
    addZapros = function(self, zapros)
        self.validator:checkParamNotNil(zapros, "zapros")

        self.zapros.list[#self.zapros.list + 1] = zapros

        self:registerEvent("EntityStock_AddedZapros", {
            id = self.id,
            zapros = zapros
        })
    end,

    -- вернуть запрос (если он есть)
    getZapros = function(self)
        local numLastZapros = #self.zapros.list

        -- если массив целый не нарушен исполнением первых запросов
        -- тогда будет возвращать начиная с последнего запроса
        -- если было добавлено 2 элемента и первый удалён - тогда он не отработает
        -- если было добавлено больше 2 элементов и один из первых удалён - тогда он отработает,
        -- но отдаст не последний
        if isset(self.zapros.list[numLastZapros]) then
            return self.zapros.list[numLastZapros]
        end

        -- вернёт любой из найденных
        -- если было добавлено 2 запроса и первый исполнился - вернёт второй (и псоледний)
        for i, _ in pairs(self.zapros.list) do
            return self.zapros.list[i]
        end

        return {}
    end,

    -- удалить zapros по номеру
    removeZapros = function(self, orderNum)
        self.validator:checkParamNumber(orderNum, "orderNum")

        for i, _ in pairs(self.zapros.list) do
            if self.zapros.list[i].order_num == orderNum then
                self.zapros.list[i] = nil
            end
        end
    end,

    -- проверить наличие запроса
    hasZapros = function(self, order_num)

        -- есть ли хотя бы 1 запрос
        if is_nil(order_num) then
            if empty(self.zapros.list) then
                return false
            end

            return true
        end

        -- если был передан номер и номер найден
        for i, _ in pairs(self.zapros.list) do
            if self.zapros.list[i].order_num == order_num then
                return true
            end
        end

        -- запрос с таким номером не существует
        return false
    end,

    -- вернуть параметры стопа
    getStopParams = function(self)
        local params = self.stop.stopParams
        params.lots = self.trade.lots

        return params
    end,

    -- вернуть параметры стопа для переноса в безубыток
    getStopMoveParams = function(self)
        local params = self.stop.moveParams
        params.lots = self.trade.lots

        return params
    end,

    -- возвращает добавленный idParams последнего добавленного стопа
    -- либо вернёт 0 - если было закрытие позиции - то произошло обнуление
    getRecoveryIdParams = function(self)
        return self.stop.recoveryIdParams
    end,

    -- добавить стоп
    addStop = function(self, stop)
        self.validator:checkParamNotNil(stop, "stop")

        -- добавляем стоп в массив стопов
        self.stop.list[#self.stop.list + 1] = stop

        -- сохранить idParams последнего добавленного стопа в резервную ячейку
        -- чтобы можно было востановить стоп (клавишей L) при случайном удалении (клавишей D)
        self.stop.recoveryIdParams = stop.idParams

        self:registerEvent("EntityStock_AddedStop", {
            id = self.id,
            stop = stop
        })
    end,

    -- вернуть стоп (если он есть)
    getStop = function(self)
        local numLastStop = #self.stop.list

        -- если массив целый не нарушен исполнением первых запросов
        -- тогда будет возвращать начиная с последнего запроса
        -- если было добавлено 2 элемента и первый удалён - тогда он не отработает
        -- если было добавлено больше 2 элементов и один из первых удалён - тогда он отработает,
        -- но отдаст не последний
        if isset(self.stop.list[numLastStop]) then
            return self.stop.list[numLastStop]
        end

        -- вернёт любой из найденных
        -- если было добавлено 2 запроса и первый исполнился - вернёт второй (и последний)
        for i, _ in pairs(self.stop.list) do
            return self.stop.list[i]
        end

        return {}
    end,

    -- удалить стоп по номеру
    removeStop = function(self, orderNum)
        self.validator:checkParamNumber(orderNum, "orderNum")

        for i, _ in pairs(self.stop.list) do
            if self.stop.list[i].order_num == orderNum then
                self.stop.list[i] = nil
            end
        end
    end,

    -- проверить наличие стопа
    hasStop = function(self)
        if empty(self.stop.list) then
            return false
        end

        return true
    end,

    -- вернуть параметры тейка
    getTakeParams = function(self)
        local params = self.take.takeParams
        params.lots = self.trade.lots

        return params
    end,

    -- добавить тейк
    addTake = function(self, take)
        self.validator:checkParamNotNil(take, "take")

        self.take.list[#self.take.list + 1] = take

        self:registerEvent("EntityStock_AddedTake", {
            id = self.id,
            take = take
        })
    end,

    -- вернуть тейк (если он есть)
    getTake = function(self)
        local numLastTake = #self.take.list

        -- если массив целый не нарушен исполнением первых запросов
        -- тогда будет возвращать начиная с последнего запроса
        -- если было добавлено 2 элемента и первый удалён - тогда он не отработает
        -- если было добавлено больше 2 элементов и один из первых удалён - тогда он отработает,
        -- но отдаст не последний
        if isset(self.take.list[numLastTake]) then
            return self.take.list[numLastTake]
        end

        -- вернёт любой из найденных
        -- если было добавлено 2 запроса и первый исполнился - вернёт второй (и псоледний)
        for i, _ in pairs(self.take.list) do
            return self.take.list[i]
        end

        return {}
    end,

    -- удалить take по номеру
    removeTake = function(self, orderNum)
        self.validator:checkParamNumber(orderNum, "orderNum")

        for i, _ in pairs(self.take.list) do
            if self.take.list[i].order_num == orderNum then
                self.take.list[i] = nil
            end
        end
    end,

    -- проверить наличие тейка
    hasTake = function(self)
        if empty(self.take.list) then
            return false
        end

        return true
    end,

    -- вернуть idParams выставленных стопов
    -- обычно стоп один, но если использовать по 2 заявки (10%, 5%) - стопов будет 2
    getAllStopParams = function(self)
        local arrIdParams = {}

        for key, arr in pairs(self.stop.list) do
            arrIdParams[arr.idParams] = 1
        end

        return arrIdParams
    end,

    -- смена размера тейка, включение и отключение
    changeTake = function(self, selectSize)
        -- 2, 3, 4, 5, 6, 7, 8
        self.validator:checkTake(selectSize)

        -- если тейк был включен и его выключили
        if self.take.selectSize == selectSize and self.take.status then
            -- отключаем тейк
            self.take.status = false

            -- массив с ключами idParams
            local arrIdParams = self:getAllStopParams()

            -- удаляем стоп
            self:registerEvent("Command_DeleteOrdersAndStopOrders", {
                idStock = self.id,
            })

            -- добавляем обычный стоп
            for numIdParams, v in pairs(arrIdParams) do
                self:registerEvent("Command_AddStop", {
                    idStock = self.id,
                    idParams = numIdParams
                })
            end

            -- используется для переключения в торговой панели
            self:registerEvent("EntityStock_ChangedTake", {
                idStock = self.id,
            })

            return
        end

        -- если тейк был выключен и его включили
        if self.take.selectSize == selectSize and not self.take.status then
            -- включаем тейк
            self.take.status = true

            -- массив с ключами idParams
            local arrIdParams = self:getAllStopParams()

            -- удаляем стоп
            self:registerEvent("Command_DeleteOrdersAndStopOrders", {
                idStock = self.id,
            })

            -- добавляем стоп со связанной заявкой
            for numIdParams, v in pairs(arrIdParams) do
                self:registerEvent("Command_AddStopLinked", {
                    idStock = self.id,
                    idParams = numIdParams
                })
            end

            -- используется для переключения в торговой панели
            self:registerEvent("EntityStock_ChangedTake", {
                idStock = self.id,
            })

            return
        end

        -- если выбран другой размер тейка
        if self.take.selectSize ~= selectSize then
            self.take.selectSize = selectSize

            -- включаем тейк
            self.take.status = true

            -- массив с ключами idParams
            local arrIdParams = self:getAllStopParams()

            -- удаляем стоп
            self:registerEvent("Command_DeleteOrdersAndStopOrders", {
                idStock = self.id,
            })

            -- добавляем стоп со связанной заявкой
            for numIdParams, v in pairs(arrIdParams) do
                self:registerEvent("Command_AddStopLinked", {
                    idStock = self.id,
                    idParams = numIdParams
                })
            end

            -- используется для переключения в торговой панели
            self:registerEvent("EntityStock_ChangedTake", {
                idStock = self.id,
            })

            return
        end
    end,

    -- активен ли тейк
    isActiveTake = function(self)
        return self.take.status
    end,

    -- вернуть выбранный размер тейка - selectSize
    getTakeSize = function(self)
        return self.take.selectSize
    end,

    -- разбираем зарос
    parseRoleZapros = function(self, params)
        -- добавляем запрос в zapros.list
        if params.status == "posted" then
            self:addZapros({
                idParams = params.idParams, -- используется только при отладке для сверки номера
                typeSending = params.typeSending,
                order_num = params.order_num,
            })

            return
        end

        -- удаляем запрос
        if params.status == "deleted" then
            self:removeZapros(params.order_num)

            return
        end

        -- запрос исполнился - выставляем стоп
        if params.status == "executed" then
            -- если есть запрос с таким номером и он был исполнен (значит была выставлена заявка)
            -- если заявка была по рынку - то заявки с таким номером не существует - сразу приходит (executed)
            if self:hasZapros(params.order_num) and params.typeSending == "order" then
                if self.take.status then
                    -- добавляем стоп со связанной заявкой
                    self:registerEvent("Command_AddStopLinked", {
                        idStock = self.id,
                        idParams = params.idParams
                    })
                else
                    -- добавляем обычный стоп
                    self:registerEvent("Command_AddStop", {
                        idStock = self.id,
                        idParams = params.idParams
                    })
                end

                -- создаём событье позиция открыта
                self:registerEvent("EntityStock_OpenedPosition", {
                    idStock = self.id,
                    idParams = params.idParams,
                    operation = self.position.operation,
                    qty = self.position.qty,
                })
            end

            -- удаляем из списка активных ордеров исполненный ордер
            self:removeZapros(params.order_num)
        end
    end,

    -- сохраняем idParams удаляемого стопа
    -- если был удалён случайно - чтобы можно было выставить заново
    saveLastStopDeletedIdParams = function(self, order_num)
        for i, _ in pairs(self.stop.list) do
            if self.stop.list[i].order_num == order_num then
                self.stop.lastRemovedIdParams = self.stop.list[i].idParams
            end
        end
    end,

    -- обнуляем последний удалённый idParams стопа
    -- удаляется при исполнении стопа
    resetLastStopDeletedIdParams = function(self)
        self.stop.lastRemovedIdParams = 0
    end,

    -- разбираем стоп
    parseRoleStop = function(self, params)
        -- добавляем запрос в stop.list
        if params.status == "posted" then
            self:addStop({
                idParams = params.idParams,
                typeSending = params.typeSending,
                order_num = params.order_num,
            })

            return
        end

        -- удаляем запрос
        if params.status == "deleted" then
            self:saveLastStopDeletedIdParams(params.order_num)
            self:removeStop(params.order_num)

            return
        end

        -- удаляем запрос
        if params.status == "executed" then
            self:removeStop(params.order_num)

            return
        end
    end,

    -- разбираем тейк
    parseRoleTake = function(self, params)
        -- добавляем запрос в take.list
        if params.status == "posted" then
            self:addTake({
                idParams = params.idParams,
                typeSending = params.typeSending,
                order_num = params.order_num,
            })

            return
        end

        -- удаляем запрос
        if params.status == "deleted" then
            self:removeTake(params.order_num)

            return
        end

        -- удаляем запрос
        if params.status == "executed" then
            self:removeTake(params.order_num)

            return
        end
    end,

    -- изменить состояние
    changeCondition = function(self, params)
        self.validator:checkParamNotNil(params, " params для changeStage(params) ")

        -- если есть роль - тогда разбираем параметры по роли
        if isset(params.role) and params.role ~= "" then
            if params.role == "zapros" then
                self:parseRoleZapros(params)

                return
            end

            if params.role == "stop" then
                self:parseRoleStop(params)

                return
            end

            if params.role == "take" then
                self:parseRoleTake(params)

                return
            end
        end
    end,

    -- изменить позиции
    changePosition = function(self)
        -- количество лотов
        local qty = self.servicePosition:getPosition(self.id)

        self.position.qty = qty

        if qty == 0 then
            self.position.operation = ""
        elseif qty < 0 then
            self.position.operation = "sell"
        elseif qty > 0 then
            self.position.operation = "buy"
        end

        -- регистрируем событие
        self:registerEvent("EntityStock_ChangedPosition", {
            idStock = self.id,
            operation = self.position.operation,
            qty = self.position.qty,
        })

        -- если позиция закрыта посылаем команду на удаление order и stopOrder
        if not self:hasPosition() then
            -- обнуляем резевный idParams
            self.stop.recoveryIdParams = 0

            -- отдаём команду удалить все order и stopOrder
            self:registerEvent("Command_DeleteOrdersAndStopOrders", {
                idStock = self.id,
            })

            -- создаём событие - позиция закрыта
            self:registerEvent("EntityStock_ClosedPosition", {
                idStock = self.id,
            })
        end
    end,

    -- рассчитать максимальное количество лотов
    calculateMaxLots = function(self)
        -- направление операции для расчёта максимального количества лотов
        local operation = "buy"

        -- если есть позиции или есть запрос
        -- тогда MaxLots нужно расчитывать в ту же сторону
        if self:hasPosition() then
            if self.position.operation == "sell" then
                operation = "sell"
            end
        end

        -- получаем новое значение maxLots
        local maxLots = self.serviceMaxLots:getMaxLots(self.id, self.class, operation)

        if is_nil(maxLots) then
            error("\r\n" .. "Error: Не получен (maxLots) от ( serviceMaxLots:getMaxLots() ) для инструмента (" .. self.id .. ")")
        end

        if not_number(maxLots) then
            error("\r\n" .. "Error: (maxLots) должен быть числом для инструмента (" .. self.id .. ")")
        end

        -- если текущее значение не равно новому расчётному
        if self.trade.maxLots ~= maxLots then
            -- обновляем текущий maxLots
            self.trade.maxLots = maxLots

            -- регистрируем событие - изменился максимальный размер лотов возможных к покупке/продаже
            self:registerEvent("EntityStock_ChangedMaxLots", {
                idStock = self.id,
                maxLots = self.trade.maxLots,
            })

            -- проверить статус инструмента
            self:checkStatus()
        end
    end,
}

return Entity_Stock
