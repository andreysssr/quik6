---

Dir = {
    -- �������� ������������� �����
    exists = function(self, directory)
        if os.rename(directory, directory) then
            return true
        end
        return false
    end,

    -- ������� �����
    create = function(self, dirPath)
        os.execute("mkdir " .. dirPath)
    end,

    -- ������� ������ ������ ����������
    getListFiles = function(self, dirPath)
        local listFiles = {}

        -- ������ ����������
        local dir = io.popen('chcp 1251|dir /a-d /b "' .. dirPath .. '"', "r")

        -- ���������� ��� ������
        for line in dir:lines() do
            listFiles[#listFiles + 1] = dirPath .. "\\" .. line
        end

        -- ��������� �������� ���� (����������)
        dir:close()

        return listFiles
    end
}
