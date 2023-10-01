--- index_futures

isRun = true

function OnInit()
    -- определяем базовый путь проекта
    basePath = string.gsub(getScriptPath(), "public", "");
end

function main()
    -- название директории приложения
    appDir = "tradePanel\\"

    -- подключаем стартовый файл
    dofile(basePath .. "bootstrap\\bootstrap.lua")

    -- создание приложения
    app = Container:get("Application")

    -- подключение файла с middleware
    Autoload:get("configApp_middleware")

    -- подключение файла с подписчиками
    Autoload:get("configApp_listeners")
    Autoload:get("configApp_listenersKey")

    -- запуск приложения или app:runDev()
    app:run()
end

-- функция вызывается перед закрытием терминала QUIK.
function OnClose()
    -- остановка приложения
    isRun = false
end;

-- остановка работы панели
function OnStop()
    -- остановка приложения
    isRun = false

    -- по умолчанию таймаут задается в 3 секунды
    return 3000
end

-- вызывается при выставлении, исполнении, удалении
function OnOrder(order)
    -- Заявка активна/удалена/исполнена (posted/deleted/executed)
    local _status = ""

    -- заявка активна
    if checkBit(order.flags, 0) then
        _status = "posted"
    else
        -- заявка не активна (удалена или исполнена)
        if checkBit(order.flags, 1) then
            _status = "deleted"
        else
            _status = "executed"
        end
    end

    -- заявка на продажу/покупку (buy/sell)
    local _operation = ""

    if checkBit(order.flags, 2) then
        _operation = "sell"
    else
        _operation = "buy"
    end

    -- заявка лимитная или рыночная (limit/market)
    local _typeTrade = ""

    if checkBit(order.flags, 3) then
        _typeTrade = "limit"
    else
        _typeTrade = "market"
    end

    local _order = {
        typeSending = "order",

        status = _status, -- статус заявки (posted/deleted/executed)
        operation = _operation, -- направление операции (buy/sell)
        typeTrade = _typeTrade, -- тип заявки (limit/market)

        sec_code = order.sec_code, -- код бумаги - тикер
        class_code = order.class_code, -- класс бумаги

        trans_id = order.trans_id, -- номер транзакции
        order_num = order.order_num, -- номер заявки

        price = order.price, -- цена
        qty = order.qty, -- количество лотов

        firmid = order.firmid,
    }

    app:enQueue("order", _order)
end

-- вызывается при выставлении, исполнении, удалении
function OnStopOrder(stopOrder)
    -- стоп-заявка активна/удалена/исполнена (posted/deleted/executed)
    local _status = ""

    -- заявка активна
    if checkBit(stopOrder.flags, 0) then
        _status = "posted"
    else
        -- заявка не активна (удалении или исполнена)
        if checkBit(stopOrder.flags, 1) then
            _status = "deleted"
        else
            _status = "executed"
        end
    end

    -- заявка на продажу/покупку (buy/sell)
    local _operation = ""

    if checkBit(stopOrder.flags, 2) then
        _operation = "sell"
    else
        _operation = "buy"
    end

    -- заявка лимитная или рыночная (limit/market)
    local _typeTrade = ""

    if checkBit(stopOrder.flags, 3) then
        _typeTrade = "limit"
    else
        _typeTrade = "market"
    end

    -- тип стоп-ордера
    local _typeStopOrder = "stopOne"

    if stopOrder.stop_order_type == "3" or stopOrder.stop_order_type == 3 then
        _typeStopOrder = "stopLink"
    end

    local _stopOrder = {
        typeSending = "stopOrder",

        status = _status, -- статус заявки (posted/deleted/executed)
        operation = _operation, -- направление операции (buy/sell)
        typeTrade = _typeTrade, -- тип заявки (limit/market)

        sec_code = stopOrder.sec_code, -- код бумаги - тикер
        class_code = stopOrder.class_code, -- класс бумаги

        trans_id = stopOrder.trans_id, -- номер транзакции
        order_num = stopOrder.order_num, -- номер заявки

        price = stopOrder.price, -- цена
        qty = stopOrder.qty, -- количество лотов
        stopPrice = stopOrder.condition_price, -- стоп цена

        -- связанная заявка - номер связанной заявки
        link_order_num = stopOrder.co_order_num,
        link_price = stopOrder.co_order_price,

        -- Вид стоп заявки
        -- "1" – стоп-лимит,
        -- "2" – условие по другому инструменту,
        -- "3" – со связанной заявкой,
        typeStopOrder = _typeStopOrder
    }

    app:enQueue("stopOrder", _stopOrder)
end

-- Функция вызывается терминалом QUIK при получении сделки (Таблица сделок).
function OnTrade(trade)
    -- сделка активна/удалена/исполнена (posted/deleted/executed)
    local _status = ""

    -- заявка активна
    if checkBit(trade.flags, 0) then
        _status = "posted"
    else
        -- заявка не активна (удалена или исполнена)
        if checkBit(trade.flags, 1) then
            _status = "deleted"
        else
            _status = "executed"
        end
    end

    -- заявка на продажу/покупку (buy/sell)
    local _operation = ""

    if checkBit(trade.flags, 2) then
        _operation = "sell"
    else
        _operation = "buy"
    end

    -- заявка лимитная или рыночная (limit/market)
    local _typeTrade = ""

    if checkBit(trade.flags, 3) then
        _typeTrade = "limit"
    else
        _typeTrade = "market"
    end

    local _trade = {
        status = _status, -- статус заявки (posted/deleted/executed)
        operation = _operation, -- направление операции (buy/sell)
        typeTrade = _typeTrade, -- тип заявки (limit/market)

        sec_code = trade.sec_code, -- код бумаги - тикер
        class_code = trade.class_code, -- класс бумаги

        trans_id = trade.trans_id, -- номер транзакции
        order_num = trade.order_num, -- номер заявки

        price = trade.price, -- цена
        qty = trade.qty, -- количество лотов
    }

    app:enQueue("trade", _trade)
end

-- Функция вызывается терминалом QUIK при получении ответа на транзакцию пользователя (Таблица транзакций).
function OnTransReply(trans_reply)
    local _transReply = {
        trans_status = trans_reply.status,

        sec_code = trans_reply.sec_code, -- код бумаги - тикер
        class_code = trans_reply.class_code, -- класс бумаги

        trans_id = trans_reply.trans_id, -- номер транзакции
        order_num = trans_reply.order_num, -- номер заявки

        price = trans_reply.price, -- цена
        qty = trans_reply.qty, -- количество лотов
    }

    app:enQueue("transReply", _transReply)
end;
