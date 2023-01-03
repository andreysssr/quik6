--

local Container = {
    -- �������� ������
    name = "ServiceManager",

    -- ������ ����������� ������
    abstractFactories = {},

    -- ������ �����������
    -- ������� ����������� ���� ��������� � ������ ������ ��� ������ ����������� (���������� ���������� �����������)
    -- @var string[]
    aliases = {},

    -- ��������� ��������������� �������� ������� ��� ���������� ��� ���
    -- @param bool
    allowOverride = false,

    -- ������ ������ (���� � ���� ���������� �����, ���� ���������� �������)
    -- @var string[] | callable[]
    factories = {},

    -- ������ ��� ����������� �������� (��� ��������� ��� ��������� ���)
    -- @var array
    services = {},

    -- ���������/���������� ����� ����������� �� ����� ������.
    -- ���������� ��� ��� (��� ������ ������ - ��������� ����� ���������)
    -- ������ ������������
    -- config.shared["MyService"] = true	// ����� �����, ���� ���� �������� "����� ������ �� ���������" ����� false
    -- config.shared["MyOtherService"] = false
    -- @var boolean[]
    shared = {},

    -- ������ �� ������ ���� ������ �� ���������?
    sharedByDefault = true,

    -- ��������� ����� ��� ��������?
    configured = false,

    -- ������������ ����������� ������� �� ������.
    cachedAbstractFactories = {},

    -- ������� ����� ���������
    -- @param array $config
    new = function(self, config)
        self:configure(config)
        return self;
    end,

    -- ��������� ����
    load = function(self, name)
        local object = Autoload:get(name)

        if is_nil(object) then
            error("\r\n\r\n" .. "Error: �� ������� ������ (����������� - return) ��� ������ (" .. name .. ")")
        end

        if not key_exists(object, "new") then
            error("\r\n\r\n" .. "Error: � ������� (" .. name .. ") ����������� ����� (new)")
        end

        return object
    end,

    -- ������� ����������� ������
    get = function(self, name)
        if name == "" then
            error("\r\n\r\n" .. "Error: � ������� � ���������� [ get() ] �� ��������� ��� �������", 2)
        end

        -- �� �������� � �������� ����, ���������� �� �� ����������� ������;
        -- ��� ����� ������� �����.
        if isset(self.services[name]) then
            return self.services[name]
        end

        -- ����������, ������ �� ������ ���� �����.
        local sharedService = true
        if isset(self.shared[name]) then
            sharedService = self.shared[name]
        else
            sharedService = self.sharedByDefault
        end

        -- ���� � ����������� ��� �� ����� ������ ����� ������ ������ � ���������� ���.
        if empty(self.aliases) then
            local object = self:doCreate(name)

            -- ���� ����������� ��� ������� ��������� - �������� ���.
            if sharedService then
                self.services[name] = object;
            end

            return object
        end

        -- ������ �� ����� ���� � ���������, ������� ����� ���� ������������.
        local resolvedName = ""
        if isset(self.aliases[name]) then
            resolvedName = self.aliases[name]
        else
            resolvedName = name
        end

        -- ��������� ����������� ������ � ��� ������,
        -- ���� ������������� ������ �������� ����� �����������.
        local sharedAlias = false

        if sharedService and isset(self.services[resolvedName]) then
            sharedAlias = true
        end

        -- ���� ��������� �������� ��� ����� ������, �� ���������.
        if sharedAlias then
            self.services[name] = self.services[resolvedName];
            return self.services[resolvedName]
        end

        -- � ���� ������ �� ������ ������� ������.
        -- ��� ����� �� ���������� ����������� ���.
        local object = self:doCreate(resolvedName)

        -- ��������� ������ �� �����, ���� �� ������ ���� �����.
        if sharedService then
            self.services[resolvedName] = object;
        end

        -- ����� ��������� ��� �����������; ��� ��������� ������������ ������� �� ������ ������������ ��� ������.
        if sharedAlias then
            self.services[name] = object;
        end

        return object
    end,

    -- ��������� ������������� ������
    has = function(self, name)
        -- ������� ��������� ������ � �������, ����� �������� ���������� �������� ���������������� ��������.
        if isset(self.services[name]) or isset(self.factories[name]) then
            return true;
        end

        -- ���� name �� �������� �����������, �� ���������.
        if empty(self.aliases[name]) then
            return false;
        end

        -- ��������� ����������.
        local resolvedName = self.aliases[name]
        if isset(self.services[resolvedName]) or isset(self.factories[resolvedName]) then
            return true;
        end

        return false;
    end,

    -- �������, ����� �� �������� ������������� ��������� ����������.
    -- @param bool flag
    setAllowOverride = function(self, flag)
        self.allowOverride = flag
    end,

    -- �������� ����, ����������� �� ������ �������������� ������� ����������.
    -- @return bool
    getAllowOverride = function(self)
        return self.allowOverride
    end,

    -- ��������� ���������� �����
    --[[
      ���������� ������� ����� �������

      - services: ��� ������ => ���� ����������� ������

      - aliases: alias => ��� ������ � ������� service (name = value).

      - factories: ��� ������ => ���� ������; ������� ����� ���� ������
                    �����������, ���������� �������, �������������� � ���������� �����, ��� ���������� �������
                    ���������� �� ��������� ���������� ����������.

      - shared: ��� ������ => ���� ������; ���� - ��� ���������� ��������, �����������
                    ���������� �� ����, �������� �� ������ ����� ��� ���.

      - shared_by_default: ���������� ��������, �����������, ������ �� ������
                    � ���� ���������� ���� ������ �� ���������.
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

    -- �������� ���������.
    -- @param string alias
    -- @param string target
    -- ���� alias ��� ���������� ��� ������ � ��������������� ��������� - ����� �������� ������
    setAlias = function(self, alias, target)
        if isset(self.services[alias]) or (not self.allowOverride) then
            error("Container - [ERROR]: ��������� ���������� �� �����������", 2)
        end

        self:mapAliasToTarget(alias, target);
    end,

    -- ������� ������� ��� ������� ����� ������.
    -- @param string name Service name
    -- @param string|callable|Factory\FactoryInterface $factory �������, � ������� ����� ��������� �����.
    -- ���� name ��� ���������� ��� ������ � ��������������� ��������� - ����� �������� ������
    setFactory = function(self, name, factory)
        if isset(self.services[name]) and not self.allowOverride then
            error("Container - [ERROR]- ��������� ���������� �� �����������", 2)
        end

        if not isset(self.factories[name]) then
            self.factories[name] = {}
        end

        self.factories[name] = array_merge(self.factories[name], factory)
    end,

    -- ��������� ����� �������.
    -- @param string name - ��� ��������
    -- @param array|object service
    -- ���� name ��� ���������� ��� ������ � ��������������� ��������� - ����� �������� ������
    setService = function(self, name, service)
        if isset(self.services[name]) and not self.allowOverride then
            error("Container - [ERROR]- ��������� ���������� �� �����������", 2)
        end

        if not isset(self.services[name]) then
            self.services[name] = {}
        end

        --self.services[name] = array_merge(self.services[name], service)
        self.services[name] = service
    end,

    -- �������� ������� ������ ������� � �������.
    -- @param string name - ��� ��������
    -- @param boolean flag ������� �� �������� ���� ������� ��� ���.
    -- ���� name ��� ���������� ��� ������ � ��������������� ��������� - ����� �������� ������
    setShared = function(self, name, flag)
        if isset(self.services[name]) and not self.allowOverride then
            error("Container - [ERROR]- ��������� ���������� �� �����������", 2)
        end

        self.shared[name] = flag
    end,

    -- ���������� ������ ��� �������� ��� ������ "new"
    --  �������� ��� ����
    -- 1 <= #t - ������ �����
    -- 2 <= #t - ������ �����
    -- 3 <= #t - ������ ����� � �.�.
    array_unpack = function(self, t, nexNumber)
        -- ���� ���������� ������ ��� -
        -- �������� ��������� � ������� ��������� ������� "t"
        -- ����� � i ���������� ����� ���������� ��������� ������� "t"
        local i = nexNumber or 1

        if i <= #t then
            return self:get(t[i]), self:array_unpack(t, i + 1)
        end
    end,

    -- ���������� ������ � �������������� �������������
    getFactoryArray = function(self, name, objectsArray)
        local object = self:load(name)

        return object:new(self:array_unpack(objectsArray))
    end,

    -- ���������� ������ � ������������
    getFactoryString = function(self, name, factory)
        local object = self:load(name)

        return object:new(self:get(factory))
    end,

    -- �������� ������� ��� ������� ����� ������
    -- @param  string name
    -- @return callable
    getFactory = function(self, name)
        local factory = ""

        if isset(self.factories[name]) then
            factory = self.factories[name]
        else
            factory = nil
        end

        -- ���� � ������������ "dependency" ������� ���
        -- ����� ��������� ���������� �� �����
        -- ! �������� ������������ ������� ������ ���� � ����� namespace
        if is_nil(factory) then
            local object = self:load(name)

            if is_function(object) then
                return object(self)
            end

            if is_object(object) then
                return object:new(self)
            end
        end

        -- ���� � ������������ "dependency" ����������� ������ �������
        if is_string(factory) then
            return self:getFactoryString(name, factory)
        end

        -- ���� � ������������ "dependency" ����������� ������ ��������
        -- �������� ��� ������� ��������� � �� ���� - ���������
        if is_function(factory) then
            return factory(self)
        end

        -- ���� � ������������ "dependency" ����������� ������ ��������
        -- ������ �������� ��������� ��������
        if is_array(factory) then
            return self:getFactoryArray(name, factory)
        end
    end,

    -- �������� ����� ��������� � ��� ����������� ������
    -- ��� ����� �������������� � ������������������ �����, �� ��������� ���, ���� �� �� ������� ����������� ������������
    -- @param  string|function|array  resolvedName
    -- @return object:new()|object:new(object_1, object_2)|function(container)
    doCreate = function(self, resolvedName)
        return self:getFactory(resolvedName)
    end,

    -- ��������� ������ ��� ��������� ��������� ����� "new"
    validateServiceNames = function(self)
        if self.configured then
            error("Container - [ERROR]: ��������� �������� ����������", 2)
        end

        return ;
    end,

    -- �����������, ��� ��� ���������� �������� ���������� (��. ����), ���������/�������� ���.
    -- ��� �������� �����, ��� �������� ����������� ����������� �� ������������ ������������������,
    -- ��������� ��������� ������������ ����������� ������ �������� ���������� �� ���������� ����������� ������.
    -- @param string $alias
    -- @param string $target
    mapAliasToTarget = function(self, alias, target)
        -- target - ��� ���� ���������, ���� ���-�� ���
        -- ���� ��� ���������, ��������� ���
        if isset(self.aliases[target]) then
            self.aliases[alias] = self.aliases[target]
        else
            self.aliases[alias] = target
        end

        if alias == self.aliases[alias] then
            error("����������� �������� Alias �� Alias", 2)
        end
    end,
}

return Container
