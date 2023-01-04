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

    -- ������� ����� Entity_Transact,
    newChild = function(self, params)
        self.validator:checkParamNotNil(params.idStock, "idStock")
        self.validator:checkParamNotNil(params.idParams, "idParams")
        self.validator:checkParamNotNil(params.role, "role")
        self.validator:checkParamNotNil(params.typeSending, "typeSending")

        -- ������ ����� ������
        local object = {
            events = {},

            status = "new",

            -- ���� ���������� � useCase - ����� 0
            -- ���� � ������� callback - �������� ���������� order_num
            order_num = params.order_num or 0,

            idStock = params.idStock,
            idParams = params.idParams,

            role = params.role,
            typeSending = params.typeSending,
        }

        extended(object, self)

        return object
    end,

    -- �������� ������
    changeStatus = function(self, status)
        self.validator:checkParamNotNil(status, "status")

        if status ~= "posted" and status ~= "executed" and status ~= "deleted" then
            error("\r\n" .. "Error: �� ������ ��� (��������) ������� (Entity_Transact). ��������: (" .. type(status) .. ") - " .. tostring(status), 2)
        end

        -- ���� ������ ������ ����� ������������ ������
        if self.status == status then
            return
        end

        -- ������ ������
        self.status = status

        -- ������������ ������� - ����� �������
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
