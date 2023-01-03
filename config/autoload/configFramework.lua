--- Framework

return {
    dependencies = {
        -- �� ��������� ������������ ��� ����������� �������
        shared_by_default = true,

        -- �������
        factories = {
            -- ����������
            --["Application"] = {
            --	"EventManager",
            --	"EventKeyboardManager"
            --},

            -- ���������� �������
            --["EventManager"] = {
            --	"Resolver",
            --	"EventManager_Event"
            --},

            -- ���������� ������� �� ����������
            --["EventKeyboardManager"] = {
            --	"Resolver",
            --	"EventKeyboardManager_dataKeyboardKeys"
            --},

            --
            --["EventKeyboardManager_dataKeyboardKeys"] = function(container)
            --	return container:load("EventKeyboardManager_dataKeyboardKeys")
            --end,

            -- �������� �������
            --["EventSender"] = "Application",

            -- �������� �����
            --["ColorScheme"] = "ColorScheme_dataColors",

            --["ColorScheme_dataColors"] = function(container)
            --	return container:load("ColorScheme_dataColors")
            --end,

            -- ��������� ������� � Entity
            --["EventDispatcher"] = "EventSender",

        },

        -- ������
        aliases = {
            --["App"] = "Application"
        },

        -- �������
        services = {
            --ff = function()
            --	dd("���������� ������� �� ����������")
            --end
        },

        -- false - ��� ������ ������ ������� ��������� ��� ������
        shared = {
            ["Queue"] = false,
            --["Repository_Interface"] = false,

        },
    },

    -- ����
    dirPath = {
        -- ��������� ��� �����������
        cacheParams = {
            dir = "var_cache",
            ext = "lua"
        },

        -- ��������� ��� �����������
        logParams = {
            dir = "var_logs",
            ext = "csv"
        },
    },


}

