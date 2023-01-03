--- Bootstrap App

-- ������� ��� ������ � �����������
dofile( basePath .. "vendor\\LuaExtensions\\Variable.lua" );

-- ����� ��� �������� ������
dofile( basePath .. "vendor\\LuaExtensions\\Assert.lua" );

-- ������� ��� �������
dofile( basePath .. "vendor\\LuaExtensions\\Debugging.lua" );

-- ������� ��� ������ � ������� ������
dofile( basePath .. "vendor\\LuaExtensions\\General.lua" );

-- ������� ��� ������ � ���������
dofile( basePath .. "vendor\\LuaExtensions\\Array.lua" );

-- ������� ��� ������ � �������
dofile( basePath .. "vendor\\LuaExtensions\\Number.lua" );

-- ������� ��� ������ �� ��������
dofile( basePath .. "vendor\\LuaExtensions\\String.lua" );

-- ������� ��� �������� ������ � ��������
dofile( basePath .. "vendor\\LuaExtensions\\Class.lua" );

-- ������� ��� ������ � �������
dofile( basePath .. "vendor\\LuaExtensions\\File.lua" );

-- ������� ��� ������ � ������������
dofile( basePath .. "vendor\\LuaExtensions\\Dir.lua" );

-- ������� ��� ������ � ������ - ��������
dofile( basePath .. "vendor\\LuaExtensions\\Bit.lua" );

-- ������ �������� ���������
Autoload = dofile(basePath .. "config\\autoload.lua")

-- ������ ���������
Container = Autoload:get("configFramework_container")
