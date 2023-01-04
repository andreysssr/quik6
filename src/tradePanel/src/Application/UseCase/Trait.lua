--- Trait UseCase

local Trait = {

    name = "UseCase_Trait",

    new = function(self)
        return self
    end,

    -- ���������� ��������������� �������� ��������
    getReverseOperation = function(self, operation)
        if operation == "sell" then
            return "buy"
        end

        if operation == "buy" then
            return "sell"
        end

        return operation
    end,

    -- ������� ���������� �������� �������
    getAbsoluteQty = function(self, qty)
        return math.abs(qty)
    end,
}

return Trait
