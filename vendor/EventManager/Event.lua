---

local Event = {
    --
    name = "",

    -- цель мероприятия
    target = "",

    -- параметры события
    params = {},

    -- стоит ли останавливать дальнейшую обработку
    stopPropagation_value = false,

    -- наименование события
    new = function(self, name, params, target)
        if not is_nil(name) then
            self:setName(name)
        end

        if not is_nil(target) then
            self:setTarget(target)
        end

        if not is_nil(params) then
            self:setParams(params)
        end

        return self
    end,

    -- получить название события
    getName = function(self)
        return self.name
    end,

    -- получить цель события
    -- это может быть либо объект, либо имя статического метода.
    getTarget = function(self)
        return self.target
    end,

    -- установить параметры - перезаписывает параметры
    setParams = function(self, params)
        if not is_array(params) then
            error("Параметр должен быть массивом или объектом", 4)
        end

        self.params = params
    end,

    -- получить все параметры
    getParams = function(self)
        return self.params
    end,

    -- получить индивидуальный параметр
    getParam = function(self, name, default)
        -- проверить параметры, которые являются массивами или реализуют доступ к массивам
        if is_array(self.params) then
            if not isset(self.params[name]) then
                return default
            end

            return self.params[name]
        end

        if not isset(self.params.name) then
            return default
        end

        return self.params.name
    end,

    -- установить наименование события
    setName = function(self, name)
        self.name = name
    end,

    -- установить контекст события
    setTarget = function(self, target)
        self.target = target
    end,

    -- установить значение для отдельного параметра
    setParam = function(self, name, value)
        -- Массивы или объекты, реализующие доступ к массивам
        if is_array(self.params) then
            self.params[name] = value
            return
        end
    end,

    -- остановить дальнейшее распространение событий
    stopPropagation = function(self, flag)
        self.stopPropagation_value = flag
    end,

    -- остановлена ли дальнейшая обработка события
    propagationIsStopped = function(self)
        return self.stopPropagation_value
    end
}

return Event
