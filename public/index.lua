--- index_futures

isRun = true

function OnInit()
    -- ���������� ������� ���� �������
    basePath = string.gsub(getScriptPath(), "public", "");
end

function main()
    -- �������� ���������� ����������
    appDir = "tradePanel\\"

    -- ���������� ��������� ����
    dofile(basePath .. "bootstrap\\bootstrap.lua")

    -- �������� ����������
    app = Container:get("Application")

    -- ����������� ����� � middleware
    Autoload:get("configApp_middleware")

    -- ����������� ����� � ������������
    Autoload:get("configApp_listeners")
    Autoload:get("configApp_listenersKey")

    -- ������ ���������� ��� app:runDev()
    app:run()
end

-- ������� ���������� ����� ��������� ��������� QUIK.
function OnClose()
    -- ��������� ����������
    isRun = false
end;

-- ��������� ������ ������
function OnStop()
    -- ��������� ����������
    isRun = false

    -- �� ��������� ������� �������� � 3 �������
    return 3000
end

-- ���������� ��� �����������, ����������, ��������
function OnOrder(order)
    -- ������ �������/�������/��������� (posted/deleted/executed)
    local _status = ""

    -- ������ �������
    if checkBit(order.flags, 0) then
        _status = "posted"
    else
        -- ������ �� ������� (������� ��� ���������)
        if checkBit(order.flags, 1) then
            _status = "deleted"
        else
            _status = "executed"
        end
    end

    -- ������ �� �������/������� (buy/sell)
    local _operation = ""

    if checkBit(order.flags, 2) then
        _operation = "sell"
    else
        _operation = "buy"
    end

    -- ������ �������� ��� �������� (limit/market)
    local _typeTrade = ""

    if checkBit(order.flags, 3) then
        _typeTrade = "limit"
    else
        _typeTrade = "market"
    end

    local _order = {
        typeSending = "order",

        status = _status, -- ������ ������ (posted/deleted/executed)
        operation = _operation, -- ����������� �������� (buy/sell)
        typeTrade = _typeTrade, -- ��� ������ (limit/market)

        sec_code = order.sec_code, -- ��� ������ - �����
        class_code = order.class_code, -- ����� ������

        trans_id = order.trans_id, -- ����� ����������
        order_num = order.order_num, -- ����� ������

        price = order.price, -- ����
        qty = order.qty, -- ���������� �����

        firmid = order.firmid,
    }

    app:enQueue("order", _order)
end

-- ���������� ��� �����������, ����������, ��������
function OnStopOrder(stopOrder)
    -- ����-������ �������/�������/��������� (posted/deleted/executed)
    local _status = ""

    -- ������ �������
    if checkBit(stopOrder.flags, 0) then
        _status = "posted"
    else
        -- ������ �� ������� (�������� ��� ���������)
        if checkBit(stopOrder.flags, 1) then
            _status = "deleted"
        else
            _status = "executed"
        end
    end

    -- ������ �� �������/������� (buy/sell)
    local _operation = ""

    if checkBit(stopOrder.flags, 2) then
        _operation = "sell"
    else
        _operation = "buy"
    end

    -- ������ �������� ��� �������� (limit/market)
    local _typeTrade = ""

    if checkBit(stopOrder.flags, 3) then
        _typeTrade = "limit"
    else
        _typeTrade = "market"
    end

    -- ��� ����-������
    local _typeStopOrder = "stopOne"

    if stopOrder.stop_order_type == "3" or stopOrder.stop_order_type == 3 then
        _typeStopOrder = "stopLink"
    end

    local _stopOrder = {
        typeSending = "stopOrder",

        status = _status, -- ������ ������ (posted/deleted/executed)
        operation = _operation, -- ����������� �������� (buy/sell)
        typeTrade = _typeTrade, -- ��� ������ (limit/market)

        sec_code = stopOrder.sec_code, -- ��� ������ - �����
        class_code = stopOrder.class_code, -- ����� ������

        trans_id = stopOrder.trans_id, -- ����� ����������
        order_num = stopOrder.order_num, -- ����� ������

        price = stopOrder.price, -- ����
        qty = stopOrder.qty, -- ���������� �����
        stopPrice = stopOrder.condition_price, -- ���� ����

        -- ��������� ������ - ����� ��������� ������
        link_order_num = stopOrder.co_order_num,
        link_price = stopOrder.co_order_price,

        -- ��� ���� ������
        -- "1" � ����-�����,
        -- "2" � ������� �� ������� �����������,
        -- "3" � �� ��������� �������,
        typeStopOrder = _typeStopOrder
    }

    app:enQueue("stopOrder", _stopOrder)
end

-- ������� ���������� ���������� QUIK ��� ��������� ������ (������� ������).
function OnTrade(trade)
    -- ������ �������/�������/��������� (posted/deleted/executed)
    local _status = ""

    -- ������ �������
    if checkBit(trade.flags, 0) then
        _status = "posted"
    else
        -- ������ �� ������� (������� ��� ���������)
        if checkBit(trade.flags, 1) then
            _status = "deleted"
        else
            _status = "executed"
        end
    end

    -- ������ �� �������/������� (buy/sell)
    local _operation = ""

    if checkBit(trade.flags, 2) then
        _operation = "sell"
    else
        _operation = "buy"
    end

    -- ������ �������� ��� �������� (limit/market)
    local _typeTrade = ""

    if checkBit(trade.flags, 3) then
        _typeTrade = "limit"
    else
        _typeTrade = "market"
    end

    local _trade = {
        status = _status, -- ������ ������ (posted/deleted/executed)
        operation = _operation, -- ����������� �������� (buy/sell)
        typeTrade = _typeTrade, -- ��� ������ (limit/market)

        sec_code = trade.sec_code, -- ��� ������ - �����
        class_code = trade.class_code, -- ����� ������

        trans_id = trade.trans_id, -- ����� ����������
        order_num = trade.order_num, -- ����� ������

        price = trade.price, -- ����
        qty = trade.qty, -- ���������� �����
    }

    app:enQueue("trade", _trade)
end

-- ������� ���������� ���������� QUIK ��� ��������� ������ �� ���������� ������������ (������� ����������).
function OnTransReply(trans_reply)
    local _transReply = {
        trans_status = trans_reply.status,

        sec_code = trans_reply.sec_code, -- ��� ������ - �����
        class_code = trans_reply.class_code, -- ����� ������

        trans_id = trans_reply.trans_id, -- ����� ����������
        order_num = trans_reply.order_num, -- ����� ������

        price = trans_reply.price, -- ����
        qty = trans_reply.qty, -- ���������� �����
    }

    app:enQueue("transReply", _transReply)
end;
