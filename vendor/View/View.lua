-- View

local View = {
    -- �������� ������
    name = "View",

    --
    string = QTABLE_STRING_TYPE,

    new = function(self)
        return self
    end,

    -- �������� id �������
    idTableCreate = function(self)
        return AllocTable()
    end,

    -- �������� ��������� ������� (�������)
    createStructure = function(self, idTable, header)

        for i = 1, #header, 1 do
            if not isset(self.typeParam[header[i]["type"]]) then
                error("������ ���� ������ � ������� ���" .. header[i]["type"])
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

    -- ���������� ������� � ��������� � ����������
    showTable = function(self, idTable, title)
        CreateWindow(idTable)
        SetWindowCaption(idTable, title);
    end,

    -- ���������� ��������� ������� � ���������
    setPosition = function(self, idTable, margin_left, margin_top, width_table, height_table)
        return SetWindowPos(idTable, margin_left, margin_top, width_table, height_table)
    end,

    -- ��������� ������� �� �������
    isClosed = function(self, idTable)
        return IsWindowClosed(idTable)
    end,

    -- �������� ��� ������ �������
    clearRows = function(self, idTable)
        return Clear(idTable)
    end,

    -- �������� ������ � ��������� �������
    addLine = function(self, idTable)
        return InsertRow(idTable, -1)
    end,

    -- ���������� �������� � ������. ������ �������� ������� ������
    setValue = function(self, idTable, row, col, data)
        local _data = data or ""
        return SetCell(idTable, row, col, tostring(_data))
    end,

    -- ���������� �������� ��������� ��� ������
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

    -- ������� ��������� � �������������
    setFlash = function(self, idTable, row, col, fon_color, text_color, timeMs)
        local time_ms = timeMs or 500

        return Highlight(idTable, row, col, fon_color, text_color, time_ms)
    end,

    -- ������� ����� ��������� ������
    getLastRow = function(self, idTable)
        local rows, cols = GetTableSize(idTable)

        return rows
    end,

    -- ������� �������
    delete = function(self, idTable)
        return DestroyTable(idTable)
    end
}

return View
