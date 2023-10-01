---

local Entity = {
    --
    name = "Entity_Transact",

    --
    validator = {},

    --
    new = function(self, container)
        local trait = container:get("Entity_TraitEvent")
        self.validator = container:get("AppService_Validator")

        extended(self, trait)

        return self
    end,

    -- создать новый Entity_Transact,
    newChild = function(self, params)
        self.validator:checkParamNotNil(params.idStock, "idStock")
        self.validator:checkParamNotNil(params.idParams, "idParams")
        self.validator:checkParamNotNil(params.role, "role")
        self.validator:checkParamNotNil(params.typeSending, "typeSending")

        -- создаём новый объект
        local object = {
            events = {},

            status = "new",

            -- если создавался в useCase - будет 0
            -- если в парсере callback - присвоит полученный order_num
            order_num = params.order_num or 0,

            idStock = params.idStock,
            idParams = params.idParams,

            role = params.role,
            typeSending = params.typeSending,
        }

        extended(object, self)

        return object
    end,

    -- поменять статус
    changeStatus = function(self, status)
        self.validator:checkParamNotNil(status, "status")

        if status ~= "posted" and status ~= "executed" and status ~= "deleted" then
            error("\r\n" .. "Error: Не верный тип (сататуса) объекта (Entity_Transact). Получено: (" .. type(status) .. ") - " .. tostring(status), 2)
        end

        -- если статус другой тогда обрабатываем дальше
        if self.status == status then
            return
        end

        -- меняем статус
        self.status = status

        -- регистрируем событие - смена статуса
        self:registerEvent("EntityTransact_ChangedTransactStatus", {
            idStock = self.idStock,
            params = {
                role = self.role,
                status = self.status,

                idParams = self.idParams,
                typeSending = self.typeSending,
                order_num = self.order_num,
            }
        })
    end,
}

return Entity
