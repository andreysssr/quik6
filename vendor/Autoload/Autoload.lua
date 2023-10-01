---

local Autoload = {
    --
    name = "Autoload",

    -- пути для подключения классов
    psr0 = {},

    --
    new = function(self, psr0)
        self.psr0 = psr0

        return self
    end,

    -- создание пути по имени
    -- для разных имён формируем разные пути
    builderPath = function(self, path, ext)
        -- варианты ext
        -- nil - для файлов
        -- csv - для файлов
        -- DIR - для директорий
        local _ext = ""
        local typePath = "file"

        -- если расширение существует - присваиваем его
        if not_nil(ext) then
            _ext = "." .. ext
        end

        -- если расширение равно (DIR) - меняем тип пути на директорию
        if _ext == ".DIR" then
            typePath = "dir"
        end

        -- если имя однословное - оно должно быть в карте (psr0)
        if key_exists(self.psr0, path) then
            if typePath == "dir" then
                -- для директорий добавлять ext не нужно
                -- если это директория - то для однословных имён не добавляем себя
                return str_replace("_", "\\", self.psr0[path])
            end
            -- для файлов добавляем ext
            -- если это файл - то для однословных путей прибавляем это же имя
            return str_replace("_", "\\", self.psr0[path]) .. "\\" .. path .. _ext
        end

        -- если имя многословное - делим его по разделителю
        local namespace = explode("_", path)

        -- проверяем наличие первой части пути в карте (psr0)
        if key_exists(self.psr0, namespace[1]) then
            -- заменяем все символы разделителя в имени _ на разделитель в путях
            local parsed1 = str_replace("_", "\\", path)

            -- заменяем первую часть имени на путь из карты путей (psr0)
            local parsed2 = str_replace(namespace[1], self.psr0[namespace[1]], parsed1)

            -- если это директория - возвращаем распаренный путь
            if typePath == "dir" then
                return parsed2
            end

            -- если это файл - добавляем расширение и возвращаем
            return parsed2 .. _ext
        end

        error("Error: В карте путей (psr0) нет записи для - (" .. path .. ")", 3)
    end,

    -- подключить файл
    get = function(self, path, ext)
        if is_nil(path) then
            error("\n" .. "Error: В Autoload:get(path) передан параметр path = nil", 2)
        end

        local _ext = ext or "lua"

        local filePath = self:builderPath(path, _ext)

        -- если файл существует - возвращаем его
        if File:exists(filePath) then
            return File:get(filePath)
        end

        if filePath == "" then
            error("\r\n\r\n" .. "Error: Для объекта (" .. path .. "), отсутствует запись в (psr0.lua)", 2)
        end

        error("\r\n\r\n" .. "Error: Для объекта (" .. path .. "), не существует файла (" .. path .. ")", 2)
    end,

    -- вернуть путь к файлу
    getPathFile = function(self, path, ext)
        if is_nil(path) then
            error("\n" .. "Error: В Autoload:getPathFile(path) передан параметр path = nil", 2)
        end

        return self:builderPath(path, ext)
    end,

    -- вернуть путь к директории
    getPathDir = function(self, path)
        if is_nil(path) then
            error("\n" .. "Error: В Autoload:getPathDir(path) передан параметр path = nil", 2)
        end

        return self:builderPath(path, "DIR")
    end,
}

return Autoload
