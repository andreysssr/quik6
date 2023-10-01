--- Factory CreateEntityStock фабрика для создания EntityStock

local Factory = {
    --
    name = "Factory_CreateEntityStock",

    --
    container = {},

    --
    servicePosition = {},

    --
    storage = {},

    --
    calculateLots = {},

    -- search
    search = {},

    --
    entityRepository = {},

    -- выставлять тейк или нет при выставлении стопа
    takeStatus = false,

    -- размер тейка по умолчанию
    selectSize = 3,

    --
    new = function(self, container)
        self.container = container

        self.servicePosition = self.container:get("AppService_GetPosition")
        self.positionSetting = self.container:get("Config_positionSetting")

        self.storage = container:get("Storage")
        self.calculateLots = container:get("AppService_CalculateLotsToMoneyRisk")
        self.search = container:get("Quik_Search")
        self.entityRepository = container:get("Repository_Stock")
        self.takeStatus = container:get("config").takeStatus
        self.selectSize = container:get("config").selectSize

        return self
    end,

    -- создание Entity_BasePrice и сохранение его в репозиторий
    createEntity = function(self, idStock)
        if is_nil(idStock) then
            error("\r\n" .. "Error: Создаваемый Entity не имеет тикера. Получено: (" .. type(idStock) .. ") - " .. tostring(idStock), 2)
        end

        --local id = idStock
        local class = self.storage:getClassToId(idStock)

        -- разрешён ли шорт для инструмента
        local statusAllowedShort = self.storage:getAllowedShortToId(idStock)

        -- сколько лотов можно купить исходя из 7% риска от размера интервала
        local lots = self.calculateLots:getLots(idStock, class)

        -- класс EntityStock
        local classEntity = self.container:get("Entity_Stock")

        -- максимальное количество лотов доступное к сделке для инструмента
        --local maxLots = self.container:get("DomainService_CalculateMaxLots"):getMaxLots(idStock, class)
        --- будет вызван пересчёт максимального количества лотов, здесь не вызывать чтобы не делать
        --- дважды одну работу

        -- получить позиции бумаги
        local position = 0

        -- фьючерсы и опционы
        if class == 'SPBFUT' or class == 'SPBOPT' then
            position = self.servicePosition:getPositionFutures(idStock, class, self.positionSetting.futures)
        end

        -- акции
        if class == 'TQBR' or class == 'QJSIM' then
            position = self.servicePosition:getPositionStock(idStock, class, self.positionSetting.stock)
        end

        -- валюта
        if class == 'CETS' then
            position = self.servicePosition:getPositionCurrency(idStock, class, self.positionSetting.currency)
        end

        -- направление позиции
        local operation = ""

        if position < 0 then
            operation = "sell"
        end

        if position > 0 then
            operation = "buy"
        end

        local entity = {
            id = idStock,
            class = class,

            events = {},

            trade = {
                -- активен ли инструмент
                -- по умолчанию инструмент активен
                -- active, limitedActive, notActive
                status = "active",

                -- разрешены ли шорты
                statusAllowedShort = statusAllowedShort,

                -- количество лотов для троговли
                lots = lots or 0,

                -- максимальное количество лотов
                --maxLots = maxLots,
                maxLots = -1, -- такое значение чтобы при первом пересчёте и сравнении вызвалось изменение статуса
            },

            -- если позиция sell - число будет отрицательное
            position = {
                qty = position,
                operation = operation, -- "", "buy", "sell,
            },

            zapros = {
                list = {}
            },

            stop = {
                -- хранится idParams последнего удалённого стопа
                -- если нечаянно удалили - можно выставить повторно
                -- обнуляется: при закрытии позиции
                recoveryIdParams = 0,

                list = {},
            },

            take = {
                -- включён тейк или выключен
                status = self.takeStatus,
                -- значения: 2, 3, 4, 5, 6
                selectSize = self.selectSize,

                list = {}
            },

            -- параметры цены для расчётов
            basePrice = {},
        }

        -- если есть позиции устанавливаем номер idParams для восстановления
        if position ~= 0 then
            entity.stop.recoveryIdParams = 1
        end

        extended(entity, classEntity)

        self.entityRepository:save(entity)
    end,

}

return Factory
