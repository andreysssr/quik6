---

Dir = {
    -- Проверка существования папки
    exists = function(self, directory)
        if os.rename(directory, directory) then
            return true
        end
        return false
    end,

    -- создать папку
    create = function(self, dirPath)
        os.execute("mkdir " .. dirPath)
    end,

    -- вернуть список файлов директории
    getListFiles = function(self, dirPath)
        local listFiles = {}

        -- читаем директорию
        local dir = io.popen('chcp 1251|dir /a-d /b "' .. dirPath .. '"', "r")

        -- перебираем все строки
        for line in dir:lines() do
            listFiles[#listFiles + 1] = dirPath .. "\\" .. line
        end

        -- закрываем открытый файл (директории)
        dir:close()

        return listFiles
    end
}
