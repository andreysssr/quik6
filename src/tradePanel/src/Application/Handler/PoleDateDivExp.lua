--- Handler PoleDateDivExp

local Handler = {
    --
    name = "Handler_PoleDateDivExp",

    --
    container = {},

    --
    storage = {},

    --
    new = function(self, container)
        self.container = container
        self.storage = container:get("Storage")

        return self
    end,

    --
    getParams = function(self, idSock)
        local class = self.storage:getClassToId(idSock)

        if class == "SPBFUT" then
            local days = d0(getParamEx(class, idSock, "DAYS_TO_MAT_DATE").param_value)

            if days <= 3 then
                return {
                    dateDivExp_data = days,
                    dateDivExp_condition = "warning",
                }
            else
                return {
                    dateDivExp_data = days,
                }
            end
        end

        return {}
    end,

}

return Handler
