---

return {
    -- panels
    panels = {
        alert = {
            title = "����������",
            name = "alert",
            size = {
                width = 980,
                height = 300,
            },
            location = {
                left = 680,
                top = 0,
            },
        },
        system = {
            title = "��������� ��������",
            name = "system",
            size = {
                width = 300,
                height = 300,
            },
            location = {
                left = 0,
                top = 0,
            },
        },
        trade = {
            title = "�������� ������",
            name = "trade",
            size = {
                width = 1920,
                height = 945,
            },
            location = {
                left = 0,
                top = 350,
            },
            -- ���������� �������� �� 1 ��������
            numberGraphs = 12,
            indicator = {
                row = 1,
                col = 49,
                on = "gray_4",
                off = "gray_2",
            }
        },
    },
}
