--- EventHandler ChangedStage

local EventHandler = {
    --
    name = "EventHandler_ChangedOrders",

    --
    serviceTransact = {},

    --
    new = function(self, container)
        self.serviceTransact = container:get("EntityService_Transact")

        return self
    end,

    -- ��� order � stopOrder
    parseOrderAndStopOrder = function(self, event)
        local data = event:getParams()

        -- ���� ���� ���������� � (order_num) - ����� ������ � ��� ������
        if self.serviceTransact:has(data.order_num) then
            self.serviceTransact:changeStatus(data.order_num, data.status)

            return
        end

        -- ���� ���������� �� (trans_id)
        if self.serviceTransact:has(data.trans_id) then
            -- �������� ���������� ���������
            local params = self.serviceTransact:getParams(data.trans_id)

            local transact = {
                order_num = data.order_num,
                idStock = data.sec_code,
                idParams = data.trans_id,
                role = params.role,
                typeSending = data.typeSending,
            }

            -- ������ ����� ���������� � ����������� (order_num)
            self.serviceTransact:create(data.order_num, transact)

            -- ��������� ���������
            self.serviceTransact:changeStatus(data.order_num, data.status)
        end
    end,

    -- ������ ����-������ �� ��������� �������
    parseStopOrderLinked = function(self, event)
        local data = event:getParams()
        -- ���� ���� ���������� � (order_num) - ����� ������ � ��� ������
        if self.serviceTransact:has(data.order_num) then
            self.serviceTransact:changeStatus(data.order_num, data.status)

            return
        end

        -- ���� ���������� �� (trans_id)
        if self.serviceTransact:has(data.trans_id) then
            -- �������� ���������� ���������
            local params = self.serviceTransact:getParams(data.trans_id)
            local transactStopOrder = {
                order_num = data.order_num,
                idStock = data.sec_code,
                idParams = data.trans_id,

                role = params.role,
                typeSending = data.typeSending,
            }

            -- ������ ����� ���������� � ����������� (order_num)
            self.serviceTransact:create(data.order_num, transactStopOrder)

            -- ��������� ���������
            self.serviceTransact:changeStatus(data.order_num, data.status)
        end
    end,

}

return EventHandler
