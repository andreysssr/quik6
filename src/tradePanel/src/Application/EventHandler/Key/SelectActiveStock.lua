--- EventHandler Key

local EventHandler = {
    --
    name = "EventHandler_Key_SelectActiveStock",

    --
    microservice = {},

    -- номер строки = idStock
    rowLinkId = {},

    -- idStock = номер стрки
    idLinkRow = {},

    --
    new = function(self, container)
        self.microservice = container:get("MicroService_ActiveStockPanelTrade")
        self.rowLinkId = container:get("Panels_PanelTrade"):getRowLinkId()

        self:prepareIdLinkRow()

        return self
    end,

    -- подготавливаем массив с ключами idStock и в значении номер строки в торговой панели
    prepareIdLinkRow = function(self)
        for row, idStock in pairs(self.rowLinkId) do
            self.idLinkRow[idStock] = row
        end
    end,

    -- 1, 2, 3, 4, 5, 6, 7, 8, 9,
    numberSelect = function(self, event)
        local row = tonumber(event.attachKey)

        local idStock = self.rowLinkId[row]

        self.microservice:changeActive(idStock)
    end,

    -- 0
    numberOff = function(self)
        self.microservice:resetCurrent()
    end,

    -- Shift
    revers = function(self)
        self.microservice:reversCurrent()
    end,

    -- стрелка вверх (up), стрелка вниз (down)
    upDown = function(self, event)
        -- up
        if event.attachKey == "NumPad 8" then
            self:upNext()
        end

        -- down
        if event.attachKey == "NumPad 2" then
            self:downNext()
        end
    end,

    -- двигаться вверх от активного
    upNext = function(self)
        -- получаем текущий активный инструмент в торговой панели
        local idStock = self.microservice:getCurrentIdStock()

        -- если текущий инструмент выключен - останавливаем обработку
        if idStock == "" then
            return
        end

        -- получаем номер строки активного инструмента в торговой панели
        local row = self.idLinkRow[idStock]

        -- уменьшаем на 1
        local row_1 = row - 1

        -- уменьшаем на 2
        local row_2 = row - 2

        -- id следующей бумаги
        local nextIdStock = ""

        -- если есть номер на 1 выше - значит вызываем его
        if isset(self.rowLinkId[row_1]) then
            nextIdStock = self.rowLinkId[row_1]
            self.microservice:changeActive(nextIdStock)

            return
        end

        -- если есть номер на 2 выше - значит вызываем его (были перед разделительной строкой)
        if isset(self.rowLinkId[row_2]) then
            nextIdStock = self.rowLinkId[row_2]
            self.microservice:changeActive(nextIdStock)

            return
        end

        -- если таких номеров нет - выключаем инструмент (поднялись вверх выше 1)
        self.microservice:resetCurrent()
    end,

    -- двигаться вниз от активного
    downNext = function(self)
        -- получаем текущий активный инструмент в торговой панели
        local idStock = self.microservice:getCurrentIdStock()

        -- если текущий инструмент выключен - останавливаем обработку
        if idStock == "" then
            return
        end

        -- получаем номер строки активного инструмента в торговой панели
        local row = self.idLinkRow[idStock]

        -- уменьшаем на 1
        local row_1 = row + 1

        -- уменьшаем на 2
        local row_2 = row + 2

        -- id следующей бумаги
        local nextIdStock = ""

        -- если есть номер на 1 выше - значит вызываем его
        if isset(self.rowLinkId[row_1]) then
            nextIdStock = self.rowLinkId[row_1]
            self.microservice:changeActive(nextIdStock)

            return
        end

        -- если есть номерна 2 выше - значит вызываем его (были перед разделительной строкой)
        if isset(self.rowLinkId[row_2]) then
            nextIdStock = self.rowLinkId[row_2]
            self.microservice:changeActive(nextIdStock)

            return
        end

        -- если таких номеров нет - выключаем инструмент (спустились ниже самого нижнего инструмента)
        self.microservice:resetCurrent()
    end
}

return EventHandler
