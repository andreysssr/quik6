--- ������ � �����������

-- ���������� ��� ����������
-- @return string "number", "string", "function", "boolean", "nil", "table"
getType = function(value)
    return type(value)
end

--unset - �������� ���������� (����������� ���������� �������� nil)
unset = function(value)
    value = nil
end
