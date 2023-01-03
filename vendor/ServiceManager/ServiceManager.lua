--

local Container = {
    -- название класса
    name = "ServiceManager",

    -- Массив абстрактных фабрик
    abstractFactories = {},

    -- Массив псевдонимов
    -- Следует сопоставить один псевдоним с именем службы или другим псевдонимом (псевдонимы рекурсивно разрешаются)
    -- @var string[]
    aliases = {},

    -- Разрешить переопределение сервисов которые уже определены или нет
    -- @param bool
    allowOverride = false,

    -- Массив фабрик (либо в виде строкового имени, либо вызываемой функции)
    -- @var string[] | callable[]
    factories = {},

    -- Массив уже загруженных сервисов (это действует как локальный кэш)
    -- @var array
    services = {},

    -- Включение/отключение общих экземпляров по имени службы.
    -- Кешировать или нет (при каждом вызове - создавать новый экземпляр)
    -- пример конфигурации
    -- config.shared["MyService"] = true	// будет общим, даже если значение "общий доступ по умолчанию" равно false
    -- config.shared["MyOtherService"] = false
    -- @var boolean[]
    shared = {},

    -- Должны ли Службы быть общими по умолчанию?
    sharedByDefault = true,

    -- Диспетчер служб уже настроен?
    configured = false,

    -- Кэшированные абстрактные фабрики из строки.
    cachedAbstractFactories = {},

    -- создать новый контейнер
    -- @param array $config
    new = function(self, config)
        self:configure(config)
        return self;
    end,

    -- загрузить файл
    load = function(self, name)
        local object = Autoload:get(name)

        if is_nil(object) then
            error("\r\n\r\n" .. "Error: Не получен объект (отсутствует - return) для класса (" .. name .. ")")
        end

        if not key_exists(object, "new") then
            error("\r\n\r\n" .. "Error: В объекте (" .. name .. ") отсутствует метод (new)")
        end

        return object
    end,

    -- вернуть запрошенный сервис
    get = function(self, name)
        if name == "" then
            error("\r\n\r\n" .. "Error: В запросе к контейнеру [ get() ] не прописали имя объекта", 2)
        end

        -- Мы начинаем с проверки того, кэшировали ли мы запрошенный сервис;
        -- это самый быстрый метод.
        if isset(self.services[name]) then
            return self.services[name]
        end

        -- Определите, должна ли Служба быть общей.
        local sharedService = true
        if isset(self.shared[name]) then
            sharedService = self.shared[name]
        else
            sharedService = self.sharedByDefault
        end

        -- Если в псевдонимах нет ни одной записи тогда создаём объект и возвращаем его.
        if empty(self.aliases) then
            local object = self:doCreate(name)

            -- Если кеширование для объекта разрешено - кэшируем его.
            if sharedService then
                self.services[name] = object;
            end

            return object
        end

        -- Теперь мы имеем дело с запросами, которые могут быть псевдонимами.
        local resolvedName = ""
        if isset(self.aliases[name]) then
            resolvedName = self.aliases[name]
        else
            resolvedName = name
        end

        -- Следующее справедливо только в том случае,
        -- если запрашиваемая служба является общим псевдонимом.
        local sharedAlias = false

        if sharedService and isset(self.services[resolvedName]) then
            sharedAlias = true
        end

        -- Если псевдоним настроен как общая служба, мы закончили.
        if sharedAlias then
            self.services[name] = self.services[resolvedName];
            return self.services[resolvedName]
        end

        -- В этот момент мы должны создать объект.
        -- Для этого мы используем разрешенное имя.
        local object = self:doCreate(resolvedName)

        -- Кэшируйте объект на потом, если он должен быть общим.
        if sharedService then
            self.services[resolvedName] = object;
        end

        -- Также кэшируйте под псевдонимом; это позволяет обмениваться данными на основе используемое имя службы.
        if sharedAlias then
            self.services[name] = object;
        end

        return object
    end,

    -- проверяет существование службы
    has = function(self, name)
        -- Сначала проверьте службы и фабрики, чтобы ускорить выполнение наиболее распространенных запросов.
        if isset(self.services[name]) or isset(self.factories[name]) then
            return true;
        end

        -- Если name не является псевдонимом, мы закончили.
        if empty(self.aliases[name]) then
            return false;
        end

        -- Проверьте псевдонимы.
        local resolvedName = self.aliases[name]
        if isset(self.services[resolvedName]) or isset(self.factories[resolvedName]) then
            return true;
        end

        return false;
    end,

    -- Укажите, можно ли изменять установленные параметры контейнера.
    -- @param bool flag
    setAllowOverride = function(self, flag)
        self.allowOverride = flag
    end,

    -- Получить флаг, указывающий на статус неизменяемости данного контейнера.
    -- @return bool
    getAllowOverride = function(self)
        return self.allowOverride
    end,

    -- Настройка диспетчера служб
    --[[
      Допустимые главные ключи массива

      - services: имя службы => пары экземпляров службы

      - aliases: alias => имя услуги в массиве service (name = value).

      - factories: имя службы => пары фабрик; фабрики могут быть любыми
                    вызываемыми, строковыми именами, разрешающимися в вызываемый класс, или строковыми именами
                    разрешение на экземпляр Заводского интерфейса.

      - shared: имя службы => пары флагов; флаг - это логическое значение, указывающее
                    независимо от того, является ли услуга общей или нет.

      - shared_by_default: логическое значение, указывающее, должны ли службы
                    в этом экземпляре быть общими по умолчанию.
    ]]

    -- @param  array $config
    -- @return self
    configure = function(self, config)
        self:validateServiceNames()

        if isset(config['services']) then
            self.services = config['services']
        end

        if isset(config['factories']) then
            self.factories = config['factories']
        end

        if isset(config['shared']) then
            self.shared = config['shared']
        end

        if not empty(config['aliases']) then
            self.aliases = config['aliases']
            --self:mapAliasesToTargets()
        end

        if isset(config['shared_by_default']) then
            self.sharedByDefault = config['shared_by_default']
        end

        self.configured = true

        return self;
    end,

    -- Добавьте псевдоним.
    -- @param string alias
    -- @param string target
    -- если alias уже существует как служба и переопределения запрещены - будет выкинута ошибка
    setAlias = function(self, alias, target)
        if isset(self.services[alias]) or (not self.allowOverride) then
            error("Container - [ERROR]: Изменения контейнера не допускаются", 2)
        end

        self:mapAliasToTarget(alias, target);
    end,

    -- Укажите фабрику для данного имени службы.
    -- @param string name Service name
    -- @param string|callable|Factory\FactoryInterface $factory Фабрика, к которой нужно привязать карту.
    -- если name уже существует как служба и переопределения запрещены - будет выкинута ошибка
    setFactory = function(self, name, factory)
        if isset(self.services[name]) and not self.allowOverride then
            error("Container - [ERROR]- Изменения контейнера не допускаются", 2)
        end

        if not isset(self.factories[name]) then
            self.factories[name] = {}
        end

        self.factories[name] = array_merge(self.factories[name], factory)
    end,

    -- Составьте карту сервиса.
    -- @param string name - Имя значения
    -- @param array|object service
    -- если name уже существует как служба и переопределения запрещены - будет выкинута ошибка
    setService = function(self, name, service)
        if isset(self.services[name]) and not self.allowOverride then
            error("Container - [ERROR]- Изменения контейнера не допускаются", 2)
        end

        if not isset(self.services[name]) then
            self.services[name] = {}
        end

        --self.services[name] = array_merge(self.services[name], service)
        self.services[name] = service
    end,

    -- Добавьте правило общего доступа к службам.
    -- @param string name - Имя значения
    -- @param boolean flag Следует ли делиться этой услугой или нет.
    -- если name уже существует как служба и переопределения запрещены - будет выкинута ошибка
    setShared = function(self, name, flag)
        if isset(self.services[name]) and not self.allowOverride then
            error("Container - [ERROR]- Изменения контейнера не допускаются", 2)
        end

        self.shared[name] = flag
    end,

    -- возвращает массив как значения для метода "new"
    --  вызывает сам себя
    -- 1 <= #t - первый вызов
    -- 2 <= #t - второй вызов
    -- 3 <= #t - третий вызов и т.д.
    array_unpack = function(self, t, nexNumber)
        -- если вызывается первый раз -
        -- начинает обработку с первого параметра массива "t"
        -- иначе в i записывает номер следующего параметра массива "t"
        local i = nexNumber or 1

        if i <= #t then
            return self:get(t[i]), self:array_unpack(t, i + 1)
        end
    end,

    -- возвращает объект с перечисленными зависимостями
    getFactoryArray = function(self, name, objectsArray)
        local object = self:load(name)

        return object:new(self:array_unpack(objectsArray))
    end,

    -- возвращает объект с зависимостью
    getFactoryString = function(self, name, factory)
        local object = self:load(name)

        return object:new(self:get(factory))
    end,

    -- Получить фабрику для данного имени службы
    -- @param  string name
    -- @return callable
    getFactory = function(self, name)
        local factory = ""

        if isset(self.factories[name]) then
            factory = self.factories[name]
        else
            factory = nil
        end

        -- если в конфигурации "dependency" записей нет
        -- тогда загружаем содержимое из файла
        -- ! название запрошенного объекта должно быть в карте namespace
        if is_nil(factory) then
            local object = self:load(name)

            if is_function(object) then
                return object(self)
            end

            if is_object(object) then
                return object:new(self)
            end
        end

        -- если в конфигурации "dependency" зависимость задана строкой
        if is_string(factory) then
            return self:getFactoryString(name, factory)
        end

        -- если в конфигурации "dependency" зависимость задана функцией
        -- вызывает эту функцию передавая в неё себя - контейнер
        if is_function(factory) then
            return factory(self)
        end

        -- если в конфигурации "dependency" зависимость задана массивом
        -- каждый параметр заполняем объектом
        if is_array(factory) then
            return self:getFactoryArray(name, factory)
        end
    end,

    -- Создайте новый экземпляр с уже разрешенным именем
    -- Это очень чувствительный к производительности метод, не изменяйте его, если вы не провели тщательного бенчмаркинга
    -- @param  string|function|array  resolvedName
    -- @return object:new()|object:new(object_1, object_2)|function(container)
    doCreate = function(self, resolvedName)
        return self:getFactory(resolvedName)
    end,

    -- Запрещено второй раз создавать контейнер через "new"
    validateServiceNames = function(self)
        if self.configured then
            error("Container - [ERROR]: Повторное создание контейнера", 2)
        end

        return ;
    end,

    -- Предполагая, что имя псевдонима является допустимым (см. выше), разрешите/добавьте его.
    -- Это делается иначе, чем массовое отображение псевдонимов по соображениям производительности,
    -- поскольку алгоритмы эффективного отображения одного элемента отличаются от алгоритмов отображения многих.
    -- @param string $alias
    -- @param string $target
    mapAliasToTarget = function(self, alias, target)
        -- target - это либо псевдоним, либо что-то еще
        -- если это псевдоним, разрешите его
        if isset(self.aliases[target]) then
            self.aliases[alias] = self.aliases[target]
        else
            self.aliases[alias] = target
        end

        if alias == self.aliases[alias] then
            error("Циклическое указание Alias на Alias", 2)
        end
    end,
}

return Container
