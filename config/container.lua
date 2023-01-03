---

-- �������� ������������ - �� ����� Laminas
local config = Autoload:get("configFramework_config")

local dependencies = config['dependencies']
config["dependencies"] = nil
dependencies['services']['config'] = config

-- ������ ��������� � �������������
local container = Autoload:get("ServiceManager"):new(dependencies)

return container
