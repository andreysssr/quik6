--- namespace App

local psr0 = {
    Action = basePath .. "src\\" .. appDir .. "src\\Application\\Action",
    EventHandler = basePath .. "src\\" .. appDir .. "src\\Application\\EventHandler",
    Factory = basePath .. "src\\" .. appDir .. "src\\Application\\Factory",
    Handler = basePath .. "src\\" .. appDir .. "src\\Application\\Handler",
    Middleware = basePath .. "src\\" .. appDir .. "src\\Application\\Middleware",
    AppService = basePath .. "src\\" .. appDir .. "src\\Application\\AppService",
    UseCase = basePath .. "src\\" .. appDir .. "src\\Application\\UseCase",
    MicroService = basePath .. "src\\" .. appDir .. "src\\Application\\MicroService",

    DomainService = basePath .. "src\\" .. appDir .. "src\\Domain\\DomainService",
    Dto = basePath .. "src\\" .. appDir .. "src\\Domain\\Dto",
    Entity = basePath .. "src\\" .. appDir .. "src\\Domain\\Entity",
    EntityService = basePath .. "src\\" .. appDir .. "src\\Domain\\EntityService",
    Repository = basePath .. "src\\" .. appDir .. "src\\Domain\\Repository",

    configApp = basePath .. "src\\" .. appDir .. "config",

    Dev = basePath .. "src\\" .. appDir .. "dev",
    Test = basePath .. "src\\" .. appDir .. "Test",
}

return psr0
