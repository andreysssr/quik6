-- ����� ��� ������ � Quik

local Quik = {
    --
    name = "Quik",

    new = function(self)

        return self
    end,

    -- �������� ���������� id - ������ �����������
    checkingId = function(self, id)
        if not_string(id) then
            error("\r\n" .. "Error: Id (������) ������ ���� (�������). ��������: (" .. type(id) .. ") - (" .. tostring(id) .. ")", 3)
        end
    end,

    -- �������� ����������� ������
    checkingClass = function(self, class)
        if not_string(class) then
            error("\r\n" .. "Error: Class (������) ������ ���� (�������). ��������: (" .. type(class) .. ") - (" .. tostring(class) .. ")", 3)
        end
    end,

    -- ������� ��������� ���� ��� ���������
    getStepPrice = function(self, id, class)
        self:checkingId(id)
        self:checkingClass(class)

        local stepPrice = getParamEx2(class, id, "STEPPRICE").param_value
        return tonumber(stepPrice)
    end,

    -- ������� ����������� ��� �����������
    getStepSize = function(self, id, class)
        self:checkingId(id)
        self:checkingClass(class)

        local status, retval = pcall(getSecurityInfo, class, id)

        if is_nil(retval) then
            error("\n\n" .. "Error: ��� ����������� (" .. id .. "), class - (" .. class .. ") ��� ������ � ������� ����. \n" ..
                "- ���� ��� (�����) ��� (������) - �������� ���� �������� � �������� ������ \n" ..
                "- ���� ��� (�������) - �������� ������� ���� ���������� � ����� � (homework.csv) �������� �������� ������"
            )
        end

        return getSecurityInfo(class, id).min_price_step
    end,

    -- ������� ������ ����
    getLotSize = function(self, id, class)
        self:checkingId(id)
        self:checkingClass(class)

        return getSecurityInfo(class, id).lot_size
    end,

    -- ������� ������������ �����������
    getName = function(self, id, class)
        self:checkingId(id)
        self:checkingClass(class)

        return getSecurityInfo(class, id).name
    end,

    -- ������� �������� ������������ �����������
    getNameShort = function(self, id, class)
        self:checkingId(id)
        self:checkingClass(class)

        return getSecurityInfo(class, id).short_name
    end,

    -- ������� ���� ���������
    getNameShort = function(self, id, class)
        self:checkingId(id)
        self:checkingClass(class)

        return getSecurityInfo(class, id).mat_date
    end,

    --
    getLastPrice = function(self, id, class)
        self:checkingId(id)
        self:checkingClass(class)

        return tonumber(getParamEx(class, id, "last").param_value)
    end,
}

return Quik
