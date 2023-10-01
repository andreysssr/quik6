--- EventHandler Key

local EventHandler = {
    --
    name = "EventHandler_Key_RecoveryStop",

    --
    container = {},

    --
    storage = {},

    --
    entityServiceStock = {},

    --
    microservice = {},

    --
    useCaseStop = {},

    --
    useCaseStopLinked = {},

    --
    cache = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")
        self.entityServiceStock = container:get("EntityService_Stock")
        self.entityServiceParams = container:get("EntityService_TradeParams")

        self.microservice = container:get("MicroService_ActiveStockPanelTrade")
        self.useCaseStop = container:get("UseCase_AddStop")
        self.useCaseStopLinked = container:get("UseCase_AddStopLinked")
        self.cache = container:get("Cache") -- написать, папка хранилища постоянная

        return self
    end,

    -- получить активный инструмент
    getCurrentId = function(self)
        return self.microservice:getCurrentIdStock()
    end,

    -- восстановить стоп который был нечаянно удалён
    recoveryStop = function(self, event)
        local idStock = self:getCurrentId()

        if not self.cache:has(idStock .. "_params") then
            return
        end

        local statusTake = self.entityServiceStock:isActiveTake(idStock)

        if statusTake then
            self.useCaseStopLinked:addStop(idStock)
        else
            self.useCaseStop:addStop(idStock)
        end
    end,

    -- восстановить параметры последней открытой позиции
    recoveryStopLast = function(self)
        local idStock = self:getCurrentId()

        -- проверить кеш - если есть запись - востановить
        -- восстановить данные если есть открытые позиции по бумаге
        if self.entityServiceStock:hasPosition(idStock) then
            if not self.cache:has(idStock .. "_params") then
                return
            end

            local cacheParams = self.cache:getFile(idStock .. "_params")
            self.entityServiceParams:recoveryParams(idStock, cacheParams)

            local statusTake = self.entityServiceStock:isActiveTake(idStock)

            -- при восстановлении записывается под номером 1 (idParams == 1)
            if statusTake then
                self.useCaseStopLinked:addStop(idStock)
            else
                self.useCaseStop:addStop(idStock)
            end
        end
    end,
}

return EventHandler
