-- View

local View = {
    -- название класса
    name = "View",

    --
    string = QTABLE_STRING_TYPE,

    new = function(self)
        return self
    end,

    -- создание id таблицы
    idTableCreate = function(self)
        return AllocTable()
    end,

    -- создание структуры таблицы (колонки)
    createStructure = function(self, idTable, header)

        for i = 1, #header, 1 do
            if not isset(self.typeParam[header[i]["type"]]) then
                error("такого типа данных в таблице нет" .. header[i]["type"])
            end

            AddColumn(idTable,
                i,
                header[i]["name"],
                true,
                self.typeParam[header[i]["type"]],
                header[i]["width"]
            );
        end
    end,

    -- отобразить таблицу в программе с заголовком
    showTable = function(self, idTable, title)
        CreateWindow(idTable)
        SetWindowCaption(idTable, title);
    end,

    -- установить положение таблицы в программе
    setPosition = function(self, idTable, margin_left, margin_top, width_table, height_table)
        return SetWindowPos(idTable, margin_left, margin_top, width_table, height_table)
    end,

    -- проверить закрыта ли таблица
    isClosed = function(self, idTable)
        return IsWindowClosed(idTable)
    end,

    -- очистить все строки таблицы
    clearRows = function(self, idTable)
        return Clear(idTable)
    end,

    -- добавить строку в структуру таблицы
    addLine = function(self, idTable)
        return InsertRow(idTable, -1)
    end,

    -- Установить значение в ячейке. Пустое значение очищает ячейку
    setValue = function(self, idTable, row, col, data)
        local _data = data or ""
        return SetCell(idTable, row, col, tostring(_data))
    end,

    -- установить цветовые параметры для ячейки
    setColor = function(self, idTable, row, col, fon_color, text_color, selected_fon_color, selected_text_color)
        local _row = 1
        local _col = 1

        if row == "all" then
            _row = QTABLE_NO_INDEX
        else
            _row = row
        end

        if col == "all" then
            _col = QTABLE_NO_INDEX
        else
            _col = col
        end

        SetColor(idTable, _row, _col, fon_color, text_color, selected_fon_color, selected_text_color)
    end,

    -- плавное затухание в миллисекундах
    setFlash = function(self, idTable, row, col, fon_color, text_color, timeMs)
        local time_ms = timeMs or 500

        return Highlight(idTable, row, col, fon_color, text_color, time_ms)
    end,

    -- вернуть номер последней строки
    getLastRow = function(self, idTable)
        local rows, cols = GetTableSize(idTable)

        return rows
    end,

    -- Удалить таблицу
    delete = function(self, idTable)
        return DestroyTable(idTable)
    end
}

return View
