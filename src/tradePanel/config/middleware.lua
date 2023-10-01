-- фильтруют сообщения от функций обратного вызова,

-- чтобы проходило по 1 сообщению
app:pipe("Middleware_FilterOrder")
app:pipe("Middleware_FilterStopOrder")

-- создание событий Callback
app:pipe("Middleware_CreateCallback")
