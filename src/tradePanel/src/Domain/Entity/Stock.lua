--- Entity Stock

local Entity_Stock = {
    --
    name = "Entity_Stock",

    -- ������ ���������� ���������� �����
    serviceMaxLots = {},

    -- ����������� ��� ���������� ���������� �����
    -- ��� ��������� � ������������ ����������� ����� ��� �������
    ratio = 0,

    --
    serviceBasePrice = {},

    --
    serviceCorrectPrice = {},

    -- ��������� ��� �������
    settingZapros = {},

    -- ��������� ��� ����� ������� ��� - StopOrderLimit
    settingZaprosOffset = {},

    -- ��������� ��� �����
    settingStop = {},

    -- ��������� ��� �������� �����
    settingStopMove = {},

    -- ��������� ��� �����
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

    -- ������� id
    getId = function(self)
        return self.id
    end,

    -- ������� �����
    getClass = function(self)
        return self.class
    end,

    -- ���������� ��������������� �������� ��������
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

    -- ������ ������ ������
    changeStatus = function(self, typeStatus)
        -- ���� ������� ������ ������ �� ���������
        if self.trade.status == typeStatus then
            return
        end

        -- ������ �������� �������
        self.trade.status = typeStatus

        -- ����������� �������
        self:registerEvent("EntityStock_ChangedStatus", {
            id = self.id,
            status = self.trade.status
        })
    end,

    -- �������� ������� �����������
    checkStatus = function(self)
        -- ���� ����� ��, �� ���� ������� ��� ��������� ������
        if self.trade.lots == 0 and (self:hasPosition() or self:hasZapros()) then
            self:changeStatus("limitedActive")

            return
        end

        -- ���� ����� ��, � ��� �������
        if self.trade.lots == 0 then
            self:changeStatus("notActive")

            return
        end

        -- MaxLots < Lots � ((���� �������) ��� (���� ������))
        -- ���������� �������� ��������:
        --		����� ����� ������
        --		������� �������
        if self.trade.maxLots <= (self.trade.lots * self.ratio) and (self:hasPosition() or self:hasZapros()) then
            self:changeStatus("limitedActive")

            return
        end

        -- MaxLots < Lots
        -- 		���������� �� ��������
        if self.trade.maxLots < (self.trade.lots * self.ratio) then
            self:changeStatus("notActive")

            return
        end

        -- MaxLots > Lots
        -- 		���������� �������� (���� ��� �������� ������� ��� �� �������)
        if self.trade.maxLots >= (self.trade.lots * self.ratio) then
            self:changeStatus("active")

            return
        end
    end,

    -- ������� ������ ������
    getStatus = function(self)
        return self.trade.status
    end,

    -- ���������� ���������� ������� � �������
    addPosition = function(self, qty)
        self.validator:checkParamNumber(qty, "qty")

        -- �������� ���������� ����� � �������
        local result = self.position.qty + qty

        -- ������� ���� - ����� ����� ���� �����
        self.position.qty = d0(result)

        -- ���� ������� ���� �������
        if self.position.qty == 0 then
            self.position.operation = ""
            return
        end

        -- ���� ������� ���� � ����
        if self.position.qty > 0 then
            self.position.operation = "buy"
            return
        end

        -- ���� ������� ���� � ����
        if self.position.qty < 0 then
            self.position.operation = "sell"
            return
        end
    end,

    -- �������� ������� �������� �������
    hasPosition = function(self)
        if self.position.qty == 0 then
            return false
        end

        return true
    end,

    -- ������� ��������� ��������
    getPositionParams = function(self)
        return self.position
    end,

    -- ������� ���������� ����� � �������
    getPositionQty = function(self)
        return self.position.qty
    end,

    -- ������� ���������� ����� ��� �������� �������
    getLots = function(self)
        return self.trade.lots
    end,

    -- ������� ����������� ��������� ���������� ����� ��� ����� ��������
    getMaxLots = function(self)
        return self.trade.maxLots
    end,

    -- ������� ��������� �������
    getZaprosParams = function(self)
        local params = self.zapros.zaprosParams
        params.lots = self.trade.lots

        return params
    end,

    -- �������� ������
    addZapros = function(self, zapros)
        self.validator:checkParamNotNil(zapros, "zapros")

        self.zapros.list[#self.zapros.list + 1] = zapros

        self:registerEvent("EntityStock_AddedZapros", {
            id = self.id,
            zapros = zapros
        })
    end,

    -- ������� ������ (���� �� ����)
    getZapros = function(self)
        local numLastZapros = #self.zapros.list

        -- ���� ������ ����� �� ������� ����������� ������ ��������
        -- ����� ����� ���������� ������� � ���������� �������
        -- ���� ���� ��������� 2 �������� � ������ ����� - ����� �� �� ����������
        -- ���� ���� ��������� ������ 2 ��������� � ���� �� ������ ����� - ����� �� ����������,
        -- �� ������ �� ���������
        if isset(self.zapros.list[numLastZapros]) then
            return self.zapros.list[numLastZapros]
        end

        -- ����� ����� �� ���������
        -- ���� ���� ��������� 2 ������� � ������ ���������� - ����� ������ (� ���������)
        for i, _ in pairs(self.zapros.list) do
            return self.zapros.list[i]
        end

        return {}
    end,

    -- ������� zapros �� ������
    removeZapros = function(self, orderNum)
        self.validator:checkParamNumber(orderNum, "orderNum")

        for i, _ in pairs(self.zapros.list) do
            if self.zapros.list[i].order_num == orderNum then
                self.zapros.list[i] = nil
            end
        end
    end,

    -- ��������� ������� �������
    hasZapros = function(self, order_num)

        -- ���� �� ���� �� 1 ������
        if is_nil(order_num) then
            if empty(self.zapros.list) then
                return false
            end

            return true
        end

        -- ���� ��� ������� ����� � ����� ������
        for i, _ in pairs(self.zapros.list) do
            if self.zapros.list[i].order_num == order_num then
                return true
            end
        end

        -- ������ � ����� ������� �� ����������
        return false
    end,

    -- ������� ��������� �����
    getStopParams = function(self)
        local params = self.stop.stopParams
        params.lots = self.trade.lots

        return params
    end,

    -- ������� ��������� ����� ��� �������� � ���������
    getStopMoveParams = function(self)
        local params = self.stop.moveParams
        params.lots = self.trade.lots

        return params
    end,

    -- ���������� ����������� idParams ���������� ������������ �����
    -- ���� ����� 0 - ���� ���� �������� ������� - �� ��������� ���������
    getRecoveryIdParams = function(self)
        return self.stop.recoveryIdParams
    end,

    -- �������� ����
    addStop = function(self, stop)
        self.validator:checkParamNotNil(stop, "stop")

        -- ��������� ���� � ������ ������
        self.stop.list[#self.stop.list + 1] = stop

        -- ��������� idParams ���������� ������������ ����� � ��������� ������
        -- ����� ����� ���� ����������� ���� (�������� L) ��� ��������� �������� (�������� D)
        self.stop.recoveryIdParams = stop.idParams

        self:registerEvent("EntityStock_AddedStop", {
            id = self.id,
            stop = stop
        })
    end,

    -- ������� ���� (���� �� ����)
    getStop = function(self)
        local numLastStop = #self.stop.list

        -- ���� ������ ����� �� ������� ����������� ������ ��������
        -- ����� ����� ���������� ������� � ���������� �������
        -- ���� ���� ��������� 2 �������� � ������ ����� - ����� �� �� ����������
        -- ���� ���� ��������� ������ 2 ��������� � ���� �� ������ ����� - ����� �� ����������,
        -- �� ������ �� ���������
        if isset(self.stop.list[numLastStop]) then
            return self.stop.list[numLastStop]
        end

        -- ����� ����� �� ���������
        -- ���� ���� ��������� 2 ������� � ������ ���������� - ����� ������ (� ���������)
        for i, _ in pairs(self.stop.list) do
            return self.stop.list[i]
        end

        return {}
    end,

    -- ������� ���� �� ������
    removeStop = function(self, orderNum)
        self.validator:checkParamNumber(orderNum, "orderNum")

        for i, _ in pairs(self.stop.list) do
            if self.stop.list[i].order_num == orderNum then
                self.stop.list[i] = nil
            end
        end
    end,

    -- ��������� ������� �����
    hasStop = function(self)
        if empty(self.stop.list) then
            return false
        end

        return true
    end,

    -- ������� ��������� �����
    getTakeParams = function(self)
        local params = self.take.takeParams
        params.lots = self.trade.lots

        return params
    end,

    -- �������� ����
    addTake = function(self, take)
        self.validator:checkParamNotNil(take, "take")

        self.take.list[#self.take.list + 1] = take

        self:registerEvent("EntityStock_AddedTake", {
            id = self.id,
            take = take
        })
    end,

    -- ������� ���� (���� �� ����)
    getTake = function(self)
        local numLastTake = #self.take.list

        -- ���� ������ ����� �� ������� ����������� ������ ��������
        -- ����� ����� ���������� ������� � ���������� �������
        -- ���� ���� ��������� 2 �������� � ������ ����� - ����� �� �� ����������
        -- ���� ���� ��������� ������ 2 ��������� � ���� �� ������ ����� - ����� �� ����������,
        -- �� ������ �� ���������
        if isset(self.take.list[numLastTake]) then
            return self.take.list[numLastTake]
        end

        -- ����� ����� �� ���������
        -- ���� ���� ��������� 2 ������� � ������ ���������� - ����� ������ (� ���������)
        for i, _ in pairs(self.take.list) do
            return self.take.list[i]
        end

        return {}
    end,

    -- ������� take �� ������
    removeTake = function(self, orderNum)
        self.validator:checkParamNumber(orderNum, "orderNum")

        for i, _ in pairs(self.take.list) do
            if self.take.list[i].order_num == orderNum then
                self.take.list[i] = nil
            end
        end
    end,

    -- ��������� ������� �����
    hasTake = function(self)
        if empty(self.take.list) then
            return false
        end

        return true
    end,

    -- ������� idParams ������������ ������
    -- ������ ���� ����, �� ���� ������������ �� 2 ������ (10%, 5%) - ������ ����� 2
    getAllStopParams = function(self)
        local arrIdParams = {}

        for key, arr in pairs(self.stop.list) do
            arrIdParams[arr.idParams] = 1
        end

        return arrIdParams
    end,

    -- ����� ������� �����, ��������� � ����������
    changeTake = function(self, selectSize)
        -- 2, 3, 4, 5, 6, 7, 8
        self.validator:checkTake(selectSize)

        -- ���� ���� ��� ������� � ��� ���������
        if self.take.selectSize == selectSize and self.take.status then
            -- ��������� ����
            self.take.status = false

            -- ������ � ������� idParams
            local arrIdParams = self:getAllStopParams()

            -- ������� ����
            self:registerEvent("Command_DeleteOrdersAndStopOrders", {
                idStock = self.id,
            })

            -- ��������� ������� ����
            for numIdParams, v in pairs(arrIdParams) do
                self:registerEvent("Command_AddStop", {
                    idStock = self.id,
                    idParams = numIdParams
                })
            end

            -- ������������ ��� ������������ � �������� ������
            self:registerEvent("EntityStock_ChangedTake", {
                idStock = self.id,
            })

            return
        end

        -- ���� ���� ��� �������� � ��� ��������
        if self.take.selectSize == selectSize and not self.take.status then
            -- �������� ����
            self.take.status = true

            -- ������ � ������� idParams
            local arrIdParams = self:getAllStopParams()

            -- ������� ����
            self:registerEvent("Command_DeleteOrdersAndStopOrders", {
                idStock = self.id,
            })

            -- ��������� ���� �� ��������� �������
            for numIdParams, v in pairs(arrIdParams) do
                self:registerEvent("Command_AddStopLinked", {
                    idStock = self.id,
                    idParams = numIdParams
                })
            end

            -- ������������ ��� ������������ � �������� ������
            self:registerEvent("EntityStock_ChangedTake", {
                idStock = self.id,
            })

            return
        end

        -- ���� ������ ������ ������ �����
        if self.take.selectSize ~= selectSize then
            self.take.selectSize = selectSize

            -- �������� ����
            self.take.status = true

            -- ������ � ������� idParams
            local arrIdParams = self:getAllStopParams()

            -- ������� ����
            self:registerEvent("Command_DeleteOrdersAndStopOrders", {
                idStock = self.id,
            })

            -- ��������� ���� �� ��������� �������
            for numIdParams, v in pairs(arrIdParams) do
                self:registerEvent("Command_AddStopLinked", {
                    idStock = self.id,
                    idParams = numIdParams
                })
            end

            -- ������������ ��� ������������ � �������� ������
            self:registerEvent("EntityStock_ChangedTake", {
                idStock = self.id,
            })

            return
        end
    end,

    -- ������� �� ����
    isActiveTake = function(self)
        return self.take.status
    end,

    -- ������� ��������� ������ ����� - selectSize
    getTakeSize = function(self)
        return self.take.selectSize
    end,

    -- ��������� �����
    parseRoleZapros = function(self, params)
        -- ��������� ������ � zapros.list
        if params.status == "posted" then
            self:addZapros({
                idParams = params.idParams, -- ������������ ������ ��� ������� ��� ������ ������
                typeSending = params.typeSending,
                order_num = params.order_num,
            })

            return
        end

        -- ������� ������
        if params.status == "deleted" then
            self:removeZapros(params.order_num)

            return
        end

        -- ������ ���������� - ���������� ����
        if params.status == "executed" then
            -- ���� ���� ������ � ����� ������� � �� ��� �������� (������ ���� ���������� ������)
            -- ���� ������ ���� �� ����� - �� ������ � ����� ������� �� ���������� - ����� �������� (executed)
            if self:hasZapros(params.order_num) and params.typeSending == "order" then
                if self.take.status then
                    -- ��������� ���� �� ��������� �������
                    self:registerEvent("Command_AddStopLinked", {
                        idStock = self.id,
                        idParams = params.idParams
                    })
                else
                    -- ��������� ������� ����
                    self:registerEvent("Command_AddStop", {
                        idStock = self.id,
                        idParams = params.idParams
                    })
                end

                -- ������ ������� ������� �������
                self:registerEvent("EntityStock_OpenedPosition", {
                    idStock = self.id,
                    idParams = params.idParams,
                    operation = self.position.operation,
                    qty = self.position.qty,
                })
            end

            -- ������� �� ������ �������� ������� ����������� �����
            self:removeZapros(params.order_num)
        end
    end,

    -- ��������� idParams ���������� �����
    -- ���� ��� ����� �������� - ����� ����� ���� ��������� ������
    saveLastStopDeletedIdParams = function(self, order_num)
        for i, _ in pairs(self.stop.list) do
            if self.stop.list[i].order_num == order_num then
                self.stop.lastRemovedIdParams = self.stop.list[i].idParams
            end
        end
    end,

    -- �������� ��������� �������� idParams �����
    -- ��������� ��� ���������� �����
    resetLastStopDeletedIdParams = function(self)
        self.stop.lastRemovedIdParams = 0
    end,

    -- ��������� ����
    parseRoleStop = function(self, params)
        -- ��������� ������ � stop.list
        if params.status == "posted" then
            self:addStop({
                idParams = params.idParams,
                typeSending = params.typeSending,
                order_num = params.order_num,
            })

            return
        end

        -- ������� ������
        if params.status == "deleted" then
            self:saveLastStopDeletedIdParams(params.order_num)
            self:removeStop(params.order_num)

            return
        end

        -- ������� ������
        if params.status == "executed" then
            self:removeStop(params.order_num)

            return
        end
    end,

    -- ��������� ����
    parseRoleTake = function(self, params)
        -- ��������� ������ � take.list
        if params.status == "posted" then
            self:addTake({
                idParams = params.idParams,
                typeSending = params.typeSending,
                order_num = params.order_num,
            })

            return
        end

        -- ������� ������
        if params.status == "deleted" then
            self:removeTake(params.order_num)

            return
        end

        -- ������� ������
        if params.status == "executed" then
            self:removeTake(params.order_num)

            return
        end
    end,

    -- �������� ���������
    changeCondition = function(self, params)
        self.validator:checkParamNotNil(params, " params ��� changeStage(params) ")

        -- ���� ���� ���� - ����� ��������� ��������� �� ����
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

    -- �������� �������
    changePosition = function(self)
        -- ���������� �����
        local qty = self.servicePosition:getPosition(self.id)

        self.position.qty = qty

        if qty == 0 then
            self.position.operation = ""
        elseif qty < 0 then
            self.position.operation = "sell"
        elseif qty > 0 then
            self.position.operation = "buy"
        end

        -- ������������ �������
        self:registerEvent("EntityStock_ChangedPosition", {
            idStock = self.id,
            operation = self.position.operation,
            qty = self.position.qty,
        })

        -- ���� ������� ������� �������� ������� �� �������� order � stopOrder
        if not self:hasPosition() then
            -- �������� �������� idParams
            self.stop.recoveryIdParams = 0

            -- ����� ������� ������� ��� order � stopOrder
            self:registerEvent("Command_DeleteOrdersAndStopOrders", {
                idStock = self.id,
            })

            -- ������ ������� - ������� �������
            self:registerEvent("EntityStock_ClosedPosition", {
                idStock = self.id,
            })
        end
    end,

    -- ���������� ������������ ���������� �����
    calculateMaxLots = function(self)
        -- ����������� �������� ��� ������� ������������� ���������� �����
        local operation = "buy"

        -- ���� ���� ������� ��� ���� ������
        -- ����� MaxLots ����� ����������� � �� �� �������
        if self:hasPosition() then
            if self.position.operation == "sell" then
                operation = "sell"
            end
        end

        -- �������� ����� �������� maxLots
        local maxLots = self.serviceMaxLots:getMaxLots(self.id, self.class, operation)

        if is_nil(maxLots) then
            error("\r\n" .. "Error: �� ������� (maxLots) �� ( serviceMaxLots:getMaxLots() ) ��� ����������� (" .. self.id .. ")")
        end

        if not_number(maxLots) then
            error("\r\n" .. "Error: (maxLots) ������ ���� ������ ��� ����������� (" .. self.id .. ")")
        end

        -- ���� ������� �������� �� ����� ������ ����������
        if self.trade.maxLots ~= maxLots then
            -- ��������� ������� maxLots
            self.trade.maxLots = maxLots

            -- ������������ ������� - ��������� ������������ ������ ����� ��������� � �������/�������
            self:registerEvent("EntityStock_ChangedMaxLots", {
                idStock = self.id,
                maxLots = self.trade.maxLots,
            })

            -- ��������� ������ �����������
            self:checkStatus()
        end
    end,
}

return Entity_Stock
