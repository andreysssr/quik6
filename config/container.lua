---

-- получаем конфигурацию - по схеме Laminas
local config = Autoload:get("configFramework_config")

local dependencies = config['dependencies']
config["dependencies"] = nil
dependencies['services']['config'] = config

-- создаём контейнер с зависимостями
local container = Autoload:get("ServiceManager"):new(dependencies)

return container
