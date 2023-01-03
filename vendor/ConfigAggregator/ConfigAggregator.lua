--- ��������� ������������

local ConfigAggregator = {
    --
    name = "ConfigAggregator",

    -- ������ ���� ����������� ������
    files = {},

    -- ����� ��������� ������������
    config = {},

    -- ��������� ����� �� ������ � ������
    addFiles = function(self, ...)
        local arg = { ... }

        for i, value in ipairs(arg) do
            self.files[#self.files + 1] = value
        end
    end,

    --
    new = function(self, arrayFiles)
        -- ������������� ������ ������ � ���������� �� 1 �������� (unpack)
        for i = 1, #arrayFiles do
            self:addFiles(unpack(arrayFiles[i]))
        end

        -- �������� ���������� �������� � ������ �� ����� �����
        self.config = self:loadConfigFromProviders(self.files)

        return self
    end,

    -- ���������� ������
    getMergedConfig = function(self)
        return self.config
    end,

    --
    loadConfigFromProviders = function(self, providers)
        local config = {}

        for i = 1, #providers do
            config = array_merge(config, dofile(providers[i]))
        end

        return config
    end,
}

return ConfigAggregator
