---
--[[
-- подключение файла
-- проверка существование файла
-- проверка пустой файл или нет
-- создание файла
-- запись в файл
-- чтение файла в строку
-- чтение файла в массив
-- чтение файла построчно
-- чтение файла csv

-- проверка существование директории
-- создание директории
-- получить список файлов в директории
]]
--[[
r 	(по умолчанию), откроется файл только для чтения
w 	откроется файл для записи. Перезаписывает содержимое или создаёт новый файл
a 	добавить файл. Напишите до конца или создай нет новый файл. операции репозиции игнорируются.
r+	откроется файл в режиме чтения и записи. Файл должен существовать.
w+  откроется файл для записи. очищает существующее содержимое или создаёт новый файл.
a+  добавится файл в режиме чтения. напишите до конца или создайте новый файл. операции перемещения
влияют на режим чтения.
]]
--[[
local file = io.open("test.txt", "r")
local content = file:read("a")
file:close()
return content

*all		а считывает всё содержимое
*line		l считывает одну строку из файла
L считывает одну строку из файла, но сохраняет символ конца строки
*number		n считывает строку под номером из файла. это читается до конца допустимой последовательности
(integer)	[number] считывает [number] символы из файла. этот режим не использует ковычки.
]]

File = {
    -- подключение файла
    get = function(self, filePath)
        return dofile(filePath)
    end,

    -- проверка существование файла
    exists = function(self, filePath)
        local file = io.open(filePath)
        -- открыт ли файл
        if file ~= nil then
            io.close(file)
            return true
        end
        return false
    end,

    -- проверка пустой файл или нет
    empty = function(self, filePath)
        -- Создает, или открывает для чтения/добавления файл
        local file = io.open(filePath, "a+")

        -- Встает в конец файла, получает номер позиции
        local position = file:seek("end", 0);

        local statusEmpty = true

        -- Если файл еще пустой
        if position == 0 then
            statusEmpty = false
        end
        io.close(file)

        return statusEmpty
    end,

    -- создание файла
    create = function(self, filePath)
        -- Создает файл в режиме "записи"
        local file = io.open(filePath, "w")
        -- Закрывает файл
        io.close(file)
    end,

    -- запись в файл в режиме (добавления)
    writeAdd = function(self, filePath, data)
        -- Создает, или открывает для чтения/добавления файл
        local file = io.open(filePath, "a+")
        -- Записывает в файл строки
        file:write(data)
        -- Сохраняет изменения в файле
        file:flush()
        -- Закрывает файл
        io.close(file)
    end,

    -- запись в файл в режиме (обновления)
    writeUpdate = function(self, filePath, data)
        -- Создает, или открывает для чтения/добавления файл
        local file = io.open(filePath, "w+")
        -- Записывает в файл строки
        file:write(data)
        -- Сохраняет изменения в файле
        file:flush()
        -- Закрывает файл
        io.close(file)
    end,

    -- чтение файла в строку
    readContent = function(self, filePath)
        -- Создает, или открывает для чтения/добавления файл
        local file = io.open(filePath, "a+")
        local content = file:read("*a")
        -- Закрывает файл
        io.close(file)

        return content
    end,

    -- чтение файла в массив
    readToArray = function(self, filePath)
        local array = {}

        -- Создает, или открывает для чтения/добавления файл
        local file = io.open(filePath, "a+")

        -- Перебирает строки файла, выводит их содержимое в сообщениях
        for line in file:lines() do
            array[#array + 1] = line
        end

        -- Закрывает файл
        io.close(file)

        return array
    end,

    -- чтение файла csv
    readCsv = function(self, filePath)
        local array = {}

        -- Создает, или открывает для чтения/добавления файл
        local file = io.open(filePath, "a+")

        -- Перебирает строки файла, выводит их содержимое в сообщениях
        for line in file:lines() do
            array[#array + 1] = explode(";", line)
        end

        -- Закрывает файл
        io.close(file)

        return array
    end,

    -- удаление файла
    -- Удаляет файл или директорию с заданным именем.
    -- Директории должны быть пусты. Если функция не может провести удаления,
    -- она возвращает nil, плюс строку, содержащую описание ошибки.
    remove = function(self, filePath)
        os.remove(filePath)
    end
}
