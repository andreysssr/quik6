--- Trait UseCase

local Trait = {

    name = "UseCase_Trait",

    new = function(self)
        return self
    end,

    -- возвращает противоположное значение операции
    getReverseOperation = function(self, operation)
        if operation == "sell" then
            return "buy"
        end

        if operation == "buy" then
            return "sell"
        end

        return operation
    end,

    -- вернуть абсолютное значение позиции
    getAbsoluteQty = function(self, qty)
        return math.abs(qty)
    end,
}

return Trait
