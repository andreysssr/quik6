---

-- �������� ������ namespace ����������
local psr0 = dofile(basePath .. "config\\psr0.lua")

-- �������� ���� � ����� namespace ����������
local path_psr0_app = basePath .. "src\\" .. appDir .. "config\\psr0.lua"

-- ���� ����� ���� ����, �� ���������� namespace ���������� � namespace ����������
if File:exists(path_psr0_app) then
    local psr0_app = File:get(path_psr0_app)

    psr0 = array_merge(psr0, psr0_app)
end

return dofile(basePath .. "vendor\\Autoload\\Autoload.lua"):new(psr0)
