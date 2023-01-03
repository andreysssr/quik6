--- Bootstrap App

-- функции для работы с переменными
dofile( basePath .. "vendor\\LuaExtensions\\Variable.lua" );

-- класс для проверки данных
dofile( basePath .. "vendor\\LuaExtensions\\Assert.lua" );

-- функции для отладки
dofile( basePath .. "vendor\\LuaExtensions\\Debugging.lua" );

-- функции для работы с разными типами
dofile( basePath .. "vendor\\LuaExtensions\\General.lua" );

-- функции для работы с массивами
dofile( basePath .. "vendor\\LuaExtensions\\Array.lua" );

-- функции для работы с числами
dofile( basePath .. "vendor\\LuaExtensions\\Number.lua" );

-- функции для работы со строками
dofile( basePath .. "vendor\\LuaExtensions\\String.lua" );

-- функции для проверки работы с классами
dofile( basePath .. "vendor\\LuaExtensions\\Class.lua" );

-- функции для работы с файлами
dofile( basePath .. "vendor\\LuaExtensions\\File.lua" );

-- функции для работы с директориями
dofile( basePath .. "vendor\\LuaExtensions\\Dir.lua" );

-- функции для работы с битами - проверка
dofile( basePath .. "vendor\\LuaExtensions\\Bit.lua" );

-- Создаём автолоад загрузчик
Autoload = dofile(basePath .. "config\\autoload.lua")

-- создаём контейнер
Container = Autoload:get("configFramework_container")
