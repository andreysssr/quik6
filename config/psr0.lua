--- namespace framework

local psr0 = {
    Application = basePath .. "vendor\\Application",
    Cache = basePath .. "vendor\\Cache",
    ColorScheme = basePath .. "vendor\\ColorScheme",
    ConfigAggregator = basePath .. "vendor\\ConfigAggregator",
    EventDispatcher = basePath .. "vendor\\EventDispatcher",
    EventKeyboardManager = basePath .. "vendor\\EventKeyboardManager",
    EventManager = basePath .. "vendor\\EventManager",
    Pipeline = basePath .. "vendor\\Pipeline",
    Panels = basePath .. "vendor\\Panels",
    Queue = basePath .. "vendor\\Queue",
    Quik = basePath .. "vendor\\Quik",
    Resolver = basePath .. "vendor\\Resolver",
    ServiceManager = basePath .. "vendor\\ServiceManager",
    Storage = basePath .. "vendor\\Storage",
    Timer = basePath .. "vendor\\Timer",
    TransactDispatcher = basePath .. "vendor\\TransactDispatcher",
    View = basePath .. "vendor\\View",

    configFramework = basePath .. "config",

    data = basePath .. "data",
    db = basePath .. "db",
    var = basePath .. "var",
}

return psr0
