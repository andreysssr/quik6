---

return {
    -- обновление линий на графиках - для сдвига в право
    -- перерисовка всех линий на всех графиках - Action_AddLevelsToChart
    chartTimer = {
        timerName = "ChartUpdateLocation",
        timerPause = 240, -- обновление 1 раз в 4 минуты
    },

    -- обновление поля level в торговой панели
    timerUpdatePoleLevel = {
        timerName = "panelTradePoleLevel",
        timerPause = 10, -- в секундах
    },

    -- обновление поля strong в торговой панели
    timerUpdatePoleStrong = {
        timerName = "panelTradePoleStrong",
        timerPause = 10, -- в секундах
    },

    -- обновление поля center в торговой панели
    timerUpdatePoleCenter = {
        timerName = "panelTradePoleCenter",
        timerPause = 10, -- в секундах
    },

    -- обновление поля line в торговой панели
    timerUpdatePoleLine = {
        timerName = "panelTradePoleLine",
        timerPause = 10, -- в секундах
    },

    -- обновление поля line в торговой панели
    timerUpdatePoleBarLimit = {
        timerName = "panelTradePoleBarLimit",
        timerPause = 10, -- в секундах
    },

    -- обновление поля line в торговой панели
    timerUpdatePoleVolume = {
        timerName = "panelTradePoleVolume",
        timerPause = 10, -- в секундах
    },

    -- обновление поля center в торговой панели
    timerUpdatePoleLastPrice = {
        timerName = "panelTradePoleLastPrice",
        timerPause = 10, -- в секундах
    },

    -- обновление поля barCurrent в торговой панели
    timerUpdatePoleBarCurrent = {
        timerName = "panelTradeBarCurrent",
        timerPause = 9, -- в секундах
    },

    -- обновление поля barCurrent в торговой панели
    timerUpdatePoleBarPrevious = {
        timerName = "panelTradeBarPrevious",
        timerPause = 31, -- в секундах
    },

    -- обновление поля barCurrent в торговой панели
    timerUpdatePoleAtrClose = {
        timerName = "panelTradeAtrClose",
        timerPause = 9, -- в секундах
    },

    -- обновление поля barCurrent в торговой панели
    timerUpdatePoleAtrOpen = {
        timerName = "panelTradeAtrOpen",
        timerPause = 9, -- в секундах
    },

    -- обновление поля barCurrent в торговой панели
    timerUpdatePoleAtrFull = {
        timerName = "panelTradeAtrFull",
        timerPause = 9, -- в секундах
    },

    -- обновление поля barCurrent в торговой панели
    timerIndicatorPanelTrade = {
        timerName = "timerIndicatorPanelTrade",
        timerPause = 1, -- в секундах
    },

    -- обновление текста тренда на графике раз в 10 минут
    timerUpdateTrendToChart = {
        timerName = "timerUpdateTrendToChart",
        timerPause = 600, -- в секундах 600
    },

    -- обновление уровней вчерашнего дневного бара
    timerUpdateBarLinesToChart = {
        timerName = "timerUpdateBarLinesToChart",
        timerPause = 60, -- в секундах 600
    },

    -- обновление уровней вчерашнего дневного бара
    timerUpdateBarHourLinesToChart = {
        timerName = "timerUpdateBarHourLinesToChart",
        timerPause = 60, -- в секундах 600
    },

    -- обновление уровней вчерашнего дневного бара
    timerUpdateMirrorLinesToChart = {
        timerName = "timerUpdateMirrorLinesToChart",
        timerPause = 60, -- в секундах 600
    },

    -- обновление уровней вчерашнего дневного бара
    timerViewLevelsToChart = {
        timerName = "timerViewLevelsToChart",
        timerPause = 300, -- в секундах 600
    },

    -- обновление уровней вчерашнего дневного бара
    timerViewBasePriceToChart = {
        timerName = "timerViewBasePriceToChart",
        timerPause = 60, -- в секундах 600
    },
}
