-- ���� ���� ������ ������������ � ��������� ����������

local LuaFileProvider = {

    --
    name = "ConfigAggregator_LuaFileProvider",

    --
    new = function(self)
        return self
    end,

    -- ���������� �����
    get = function(self, dirPath)
        return Dir:getListFiles(dirPath)
    end,
}

return LuaFileProvider
