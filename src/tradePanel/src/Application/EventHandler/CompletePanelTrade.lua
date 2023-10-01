--- EventHandler CompletePanelTrade - описание

local EventHandler = {
    --
    name = "EventHandler_CompletePanelTrade",

    --
    container = {},

    --
    panelTrade = {},

    --
    storage = {},

    --
    entityServiceStock = {},

    --
    new = function(self, container)
        self.container = container
        self.panelTrade = container:get("Panels_PanelTrade")
        self.storage = container:get("Storage")
        self.entityServiceStock = container:get("EntityService_Stock")

        return self
    end,

    --
    handle = function(self)
        -- получаем массив тикеров по домашке
        local arrayTickers = self.storage:getHomeworkId()

        -- в цикле вызываем создание Entity BasePrice
        for i = 1, #arrayTickers do
            self:completed(arrayTickers[i])
        end
    end,

    --
    completed = function(self, idStock)
        local dto = {}

        --
        local stock = self.container:get("Handler_PoleStock"):getParams(idStock)
        array_merge(dto, stock)


        --
        local comment = self.container:get("Handler_PoleComment"):getParams(idStock)
        array_merge(dto, comment)


        --
        local position = self.container:get("Handler_PolePosition"):getParams(idStock)
        array_merge(dto, position)


        --
        local shortAllow = self.container:get("Handler_PoleShortAllow"):getParams(idStock)
        array_merge(dto, shortAllow)


        --
        local ordersAll = self.container:get("Handler_PoleOrdersAll"):getParams(idStock)
        array_merge(dto, ordersAll)


        ---- markerVolume
        --local markerVolume = self.container:get("Handler_PoleMarkerVolume"):getParams(idStock)
        --array_merge(dto, markerVolume)


        --
        local interval = self.container:get("Handler_PoleInterval"):getParams(idStock)
        array_merge(dto, interval)


        ----
        --local rating = self.container:get("Handler_PoleRating"):getParams(idStock)
        --array_merge(dto, rating)
        --
        --local barLimit = self.container:get("Handler_PoleBarLimit"):getParams(idStock)
        --array_merge(dto, barLimit)


        -- volume
        --local volume = self.container:get("Handler_PoleVolume"):getParams(idStock)
        --array_merge(dto, volume)


        ----
        --local gap = self.container:get("Handler_PoleGap"):getParams(idStock)
        --array_merge(dto, gap)
        --
        --
        ----
        --local atrOpen = self.container:get("Handler_PoleAtrOpen"):getParams(idStock)
        --array_merge(dto, atrOpen)
        --
        --
        ----
        --local atrFull = self.container:get("Handler_PoleAtrFull"):getParams(idStock)
        --array_merge(dto, atrFull)


        --
        --local barPrevious = self.container:get("Handler_PoleBarPrevious"):getParams(idStock)
        --array_merge(dto, barPrevious)
        --
        --
        ----
        --local barCurrent = self.container:get("Handler_PoleBarCurrent"):getParams(idStock)
        --array_merge(dto, barCurrent)


        --
        local level = self.container:get("Handler_PoleLevel"):getParams(idStock)
        array_merge(dto, level)


        --
        local strong = self.container:get("Handler_PoleStrong"):getParams(idStock)
        array_merge(dto, strong)


        ----
        --local center = self.container:get("Handler_PoleCenter"):getParams(idStock)
        --array_merge(dto, center)

        --
        local line = self.container:get("Handler_PoleLine"):getParams(idStock)
        array_merge(dto, line)


        --
        local lastPrice = self.container:get("Handler_PoleLastPrice"):getParams(idStock)
        array_merge(dto, lastPrice)


        --
        local lots = self.container:get("Handler_PoleLots"):getParams(idStock)
        array_merge(dto, lots)


        --
        local maxLots = self.container:get("Handler_PoleMaxLots"):getParams(idStock)
        array_merge(dto, maxLots)


        --
        local dateDivExp = self.container:get("Handler_PoleDateDivExp"):getParams(idStock)
        array_merge(dto, dateDivExp)


        --
        local take = self.container:get("Handler_PoleTake"):getParams(idStock)
        array_merge(dto, take)

        self.panelTrade:update(idStock, dto)
    end,

}

return EventHandler
