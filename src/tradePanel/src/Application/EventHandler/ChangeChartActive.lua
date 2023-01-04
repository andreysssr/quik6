--- EventHandler ChangeChartActive - добавляет/удаляет маркер Active на графеке

local EventHandler = {
    --
    name = "EventHandler_ChangeChartActive",

    --
    microservice = {},

    --
    new = function(self, container)
        self.microservice = container:get("MicroService_MarkerActiveToChart")

        return self
    end,

    --
    handle = function(self, event)
        local id = event:getParam("id")
        local stock = event:getParam("stock")

        if stock == "on" then
            self.microservice:addMarkerActive(id)
        end

        if stock == "off" then
            self.microservice:removeMarkerActive(id)
        end
    end,
}

return EventHandler
