---

local aggregator = Autoload:get("ConfigAggregator"):new({
    Dir:getListFiles(basePath .. "config\\autoload"), -- ��������� ��� ����� � ����������
    Dir:getListFiles(basePath .. "src\\" .. appDir .. "config\\autoload"),
})

return aggregator:getMergedConfig()
