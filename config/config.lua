---

local aggregator = Autoload:get("ConfigAggregator"):new({
    Dir:getListFiles(basePath .. "config\\autoload"), -- добавляет все файлы в директории
    Dir:getListFiles(basePath .. "src\\" .. appDir .. "config\\autoload"),
})

return aggregator:getMergedConfig()
