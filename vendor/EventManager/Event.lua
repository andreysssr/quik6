---

local Event = {
    --
    name = "",

    -- ���� �����������
    target = "",

    -- ��������� �������
    params = {},

    -- ����� �� ������������� ���������� ���������
    stopPropagation_value = false,

    -- ������������ �������
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

    -- �������� �������� �������
    getName = function(self)
        return self.name
    end,

    -- �������� ���� �������
    -- ��� ����� ���� ���� ������, ���� ��� ������������ ������.
    getTarget = function(self)
        return self.target
    end,

    -- ���������� ��������� - �������������� ���������
    setParams = function(self, params)
        if not is_array(params) then
            error("�������� ������ ���� �������� ��� ��������", 4)
        end

        self.params = params
    end,

    -- �������� ��� ���������
    getParams = function(self)
        return self.params
    end,

    -- �������� �������������� ��������
    getParam = function(self, name, default)
        -- ��������� ���������, ������� �������� ��������� ��� ��������� ������ � ��������
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

    -- ���������� ������������ �������
    setName = function(self, name)
        self.name = name
    end,

    -- ���������� �������� �������
    setTarget = function(self, target)
        self.target = target
    end,

    -- ���������� �������� ��� ���������� ���������
    setParam = function(self, name, value)
        -- ������� ��� �������, ����������� ������ � ��������
        if is_array(self.params) then
            self.params[name] = value
            return
        end
    end,

    -- ���������� ���������� ��������������� �������
    stopPropagation = function(self, flag)
        self.stopPropagation_value = flag
    end,

    -- ����������� �� ���������� ��������� �������
    propagationIsStopped = function(self)
        return self.stopPropagation_value
    end
}

return Event
