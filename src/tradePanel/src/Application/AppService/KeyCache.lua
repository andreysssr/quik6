--- ��������� ���� ���� - ����� �� ����������� ����� - ��� �������� � �������

local KeyCache = {

    --
    name = "AppService_KeyCache",

    --
    config = {},

    new = function(self, container)
        self.config = container:get("config").namesCache

        return self
    end,

    getKey = function(self, id, namesCache)
        if not_string(id) then
            error("Error: id ��� ���� ������ ���� �������. ��������: (" .. getType(namesCache) .. ") -  (" .. tostring(namesCache) .. ")", 2)
        end

        if not_string(namesCache) then
            error("Error: ���� ��� ���� ������ ���� �������. ��������: (" .. getType(namesCache) .. ") -  (" .. tostring(namesCache) .. ")", 2)
        end

        if not_key_exists(self.config, namesCache) then
            error("Error: � (config) � ������ ��� ����� (namesCache) ����������� ����: (" .. namesCache .. ")", 2)
        end

        return id .. "_" .. self.config[namesCache]
    end,
}

return KeyCache
