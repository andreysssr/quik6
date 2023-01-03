---

-- получаем список namespace фреймворка
local psr0 = dofile(basePath .. "config\\psr0.lua")

-- получаем путь к файлу namespace приложения
local path_psr0_app = basePath .. "src\\" .. appDir .. "config\\psr0.lua"

-- если такой файл есть, то объединяем namespace приложения с namespace фреймворка
if File:exists(path_psr0_app) then
    local psr0_app = File:get(path_psr0_app)

    psr0 = array_merge(psr0, psr0_app)
end

return dofile(basePath .. "vendor\\Autoload\\Autoload.lua"):new(psr0)
