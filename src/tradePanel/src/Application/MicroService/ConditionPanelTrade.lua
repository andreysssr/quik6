--- MicroService ConditionPanelTrade

local MicroService = {
    --
    name = "MicroService_ConditionPanelTrade",

    --
    container = {},

    --
    storage = {},

    --
    data = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")

        return self
    end,

    --
    createIdStock = function(self, idStock, param, value)
        if is_nil(self.data[idStock]) then
            self.data[idStock] = {}
        end

        if is_nil(self.data[idStock][param]) then
            self.data[idStock][param] = value
        end
    end,

    --
    ChangeMarker1 = function(self, idStock)
        self:createIdStock(idStock, "marker1", false)

        if self.data[idStock].marker1 == true then
            self.data[idStock].marker1 = false
        else
            self.data[idStock].marker1 = true
        end
    end,

    --
    getMarker1 = function(self, idStock)
        local dto = {}

        if self.data[idStock].marker1 == true then
            dto.marker1_condition = "active"
        else
            dto.marker1_condition = "default"
        end

        return dto
    end,

    --
    ChangeMarker2 = function(self, idStock)
        self:createIdStock(idStock, "marker2", false)

        if self.data[idStock].marker2 == true then
            self.data[idStock].marker2 = false
        else
            self.data[idStock].marker2 = true
        end
    end,

    --
    getMarker2 = function(self, idStock)
        local dto = {}

        if self.data[idStock].marker2 == true then
            dto.marker2_condition = "active"
        else
            dto.marker2_condition = "default"
        end

        return dto
    end,

    --
    changeMarkerTrend = function(self, idStock)
        self:createIdStock(idStock, "markerTrend", false)

        if self.data[idStock].markerTrend == true then
            self.data[idStock].markerTrend = false
        else
            self.data[idStock].markerTrend = true
        end
    end,

    --
    getMarkerTrend = function(self, idStock)
        local dto = {}

        if self.data[idStock].markerTrend == true then
            dto.markerTrend_condition = "active"
        else
            dto.markerTrend_condition = "default"
        end

        return dto
    end,

    --
    getMarkerTrendListTrue = function(self)
        local listMarkerVolumeTrue = {}

        for idStock, v in pairs(self.data) do
            if self.data[idStock].markerTrend then
                listMarkerVolumeTrue[idStock] = 1
            end
        end

        return listMarkerVolumeTrue
    end,

    --
    getMarkerTrendStatus = function(self, idStock)
        if isset(self.data[idStock]) and isset(self.data[idStock].markerTrend) then
            if self.data[idStock].markerTrend == true then
                return true
            end

        end

        return false
    end,

    --
    changeMarkerDayBar = function(self, idStock)
        self:createIdStock(idStock, "markerDayBar", false)

        if self.data[idStock].markerDayBar == true then
            self.data[idStock].markerDayBar = false
        else
            self.data[idStock].markerDayBar = true
        end
    end,

    --
    getMarkerDayBar = function(self, idStock)
        local dto = {}

        if self.data[idStock].markerDayBar == true then
            dto.markerDayBar_condition = "active"
        else
            dto.markerDayBar_condition = "default"
        end

        return dto
    end,

    --
    getMarkerDayBarListTrue = function(self)
        local listDayBarTrue = {}

        for idStock, v in pairs(self.data) do
            if self.data[idStock].markerDayBar then
                listDayBarTrue[idStock] = 1
            end
        end

        return listDayBarTrue
    end,

    --
    getMarkerDayBarStatus = function(self, idStock)
        if isset(self.data[idStock]) and isset(self.data[idStock].markerDayBar) then
            if self.data[idStock].markerDayBar == true then
                return true
            end

        end

        return false
    end,

    --
    changeMarkerHourBar = function(self, idStock)
        self:createIdStock(idStock, "markerHourBar", false)

        if self.data[idStock].markerHourBar == true then
            self.data[idStock].markerHourBar = false
        else
            self.data[idStock].markerHourBar = true
        end
    end,

    --
    getMarkerHourBar = function(self, idStock)
        local dto = {}

        if self.data[idStock].markerHourBar == true then
            dto.markerHourBar_condition = "active"
        else
            dto.markerHourBar_condition = "default"
        end

        return dto
    end,

    --
    getMarkerHourBarListTrue = function(self)
        local listHourBarTrue = {}

        for idStock, v in pairs(self.data) do
            if self.data[idStock].markerHourBar then
                listHourBarTrue[idStock] = 1
            end
        end

        return listHourBarTrue
    end,

    --
    getMarkerHourBarStatus = function(self, idStock)
        if isset(self.data[idStock]) and isset(self.data[idStock].markerHourBar) then
            if self.data[idStock].markerHourBar == true then
                return true
            end

        end

        return false
    end,

    --
    changeMarkerMirrorLineHiLow = function(self, idStock)
        self:createIdStock(idStock, "markerMirrorLineHiLow", false)

        if self.data[idStock].markerMirrorLineHiLow == true then
            self.data[idStock].markerMirrorLineHiLow = false
        else
            self.data[idStock].markerMirrorLineHiLow = true
        end
    end,

    --
    getMarkerMirrorLineHiLow = function(self, idStock)
        local dto = {}

        if self.data[idStock].markerMirrorLineHiLow == true then
            dto.markerMirrorLineHiLow_condition = "active"
        else
            dto.markerMirrorLineHiLow_condition = "default"
        end

        return dto
    end,

    --
    getMarkerMirrorLineHiLowListTrue = function(self)
        local listMirrorLineHiLowTrue = {}

        for idStock, v in pairs(self.data) do
            if self.data[idStock].markerMirrorLineHiLow then
                listMirrorLineHiLowTrue[idStock] = 1
            end
        end

        return listMirrorLineHiLowTrue
    end,

    --
    getMarkerMirrorLineHiLowStatus = function(self, idStock)
        if isset(self.data[idStock]) and isset(self.data[idStock].markerMirrorLineHiLow) then
            if self.data[idStock].markerMirrorLineHiLow == true then
                return true
            end

        end

        return false
    end,

    --
    changeCommentView = function(self, idStock)
        self:createIdStock(idStock, "commentView", false)

        if self.data[idStock].commentView == true then
            self.data[idStock].commentView = false
        else
            self.data[idStock].commentView = true
        end
    end,

    --
    getCommentView = function(self, idStock)
        local dto = {}

        if self.data[idStock].commentView == false then
            -- выключенный параметр кнопки
            dto.commentView_condition = "default"

            -- текст комментария
            dto.comment_data = self.storage:getCommentToId(idStock)
            dto.comment_condition = "default"

        else
            -- включенный параметр кнопки
            dto.commentView_condition = "active"

            -- пустой текст
            dto.comment_data = ""
            dto.comment_condition = "active"
        end

        return dto
    end,

    --
    changeComment = function(self, idStock)
        self:createIdStock(idStock, "comment", false)

        if self.data[idStock].comment == true then
            self.data[idStock].comment = false
        else
            self.data[idStock].comment = true
        end
    end,

    --
    getComment = function(self, idStock)
        local dto = {}

        if self.data[idStock].comment == false then
            -- выключенный параметр поля
            dto.comment_condition = "default"
        else
            -- включенный параметр поля
            dto.comment_condition = "select"
        end

        return dto
    end,

    --
    changeLastPrice = function(self, idStock)
        self:createIdStock(idStock, "lastPrice", false)

        if self.data[idStock].lastPrice == true then
            self.data[idStock].lastPrice = false
        else
            self.data[idStock].lastPrice = true
        end
    end,

    --
    getLastPrice = function(self, idStock)
        local dto = {}

        if self.data[idStock].lastPrice == false then
            -- выключенный параметр поля
            dto.lastPrice_condition = "default"
        else
            -- включенный параметр поля
            dto.lastPrice_condition = "active"
        end

        return dto
    end,
}

return MicroService
