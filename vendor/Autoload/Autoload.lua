---

local Autoload = {
    --
    name = "Autoload",

    -- ���� ��� ����������� �������
    psr0 = {},

    --
    new = function(self, psr0)
        self.psr0 = psr0

        return self
    end,

    -- �������� ���� �� �����
    -- ��� ������ ��� ��������� ������ ����
    builderPath = function(self, path, ext)
        -- �������� ext
        -- nil - ��� ������
        -- csv - ��� ������
        -- DIR - ��� ����������
        local _ext = ""
        local typePath = "file"

        -- ���� ���������� ���������� - ����������� ���
        if not_nil(ext) then
            _ext = "." .. ext
        end

        -- ���� ���������� ����� (DIR) - ������ ��� ���� �� ����������
        if _ext == ".DIR" then
            typePath = "dir"
        end

        -- ���� ��� ����������� - ��� ������ ���� � ����� (psr0)
        if key_exists(self.psr0, path) then
            if typePath == "dir" then
                -- ��� ���������� ��������� ext �� �����
                -- ���� ��� ���������� - �� ��� ����������� ��� �� ��������� ����
                return str_replace("_", "\\", self.psr0[path])
            end
            -- ��� ������ ��������� ext
            -- ���� ��� ���� - �� ��� ����������� ����� ���������� ��� �� ���
            return str_replace("_", "\\", self.psr0[path]) .. "\\" .. path .. _ext
        end

        -- ���� ��� ������������ - ����� ��� �� �����������
        local namespace = explode("_", path)

        -- ��������� ������� ������ ����� ���� � ����� (psr0)
        if key_exists(self.psr0, namespace[1]) then
            -- �������� ��� ������� ����������� � ����� _ �� ����������� � �����
            local parsed1 = str_replace("_", "\\", path)

            -- �������� ������ ����� ����� �� ���� �� ����� ����� (psr0)
            local parsed2 = str_replace(namespace[1], self.psr0[namespace[1]], parsed1)

            -- ���� ��� ���������� - ���������� ����������� ����
            if typePath == "dir" then
                return parsed2
            end

            -- ���� ��� ���� - ��������� ���������� � ����������
            return parsed2 .. _ext
        end

        error("Error: � ����� ����� (psr0) ��� ������ ��� - (" .. path .. ")", 3)
    end,

    -- ���������� ����
    get = function(self, path, ext)
        if is_nil(path) then
            error("\n" .. "Error: � Autoload:get(path) ������� �������� path = nil", 2)
        end

        local _ext = ext or "lua"

        local filePath = self:builderPath(path, _ext)

        -- ���� ���� ���������� - ���������� ���
        if File:exists(filePath) then
            return File:get(filePath)
        end

        if filePath == "" then
            error("\r\n\r\n" .. "Error: ��� ������� (" .. path .. "), ����������� ������ � (psr0.lua)", 2)
        end

        error("\r\n\r\n" .. "Error: ��� ������� (" .. path .. "), �� ���������� ����� (" .. path .. ")", 2)
    end,

    -- ������� ���� � �����
    getPathFile = function(self, path, ext)
        if is_nil(path) then
            error("\n" .. "Error: � Autoload:getPathFile(path) ������� �������� path = nil", 2)
        end

        return self:builderPath(path, ext)
    end,

    -- ������� ���� � ����������
    getPathDir = function(self, path)
        if is_nil(path) then
            error("\n" .. "Error: � Autoload:getPathDir(path) ������� �������� path = nil", 2)
        end

        return self:builderPath(path, "DIR")
    end,
}

return Autoload
