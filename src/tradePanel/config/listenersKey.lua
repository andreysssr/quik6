-- смена активного инструмента в торговой панели

-- отключить активный инструмент
app:attachKey("0", "EventHandler_Key_SelectActiveStock@numberOff")

app:attachKey("1", "EventHandler_Key_SelectActiveStock@numberSelect")
app:attachKey("2", "EventHandler_Key_SelectActiveStock@numberSelect")
app:attachKey("3", "EventHandler_Key_SelectActiveStock@numberSelect")
app:attachKey("4", "EventHandler_Key_SelectActiveStock@numberSelect")
app:attachKey("5", "EventHandler_Key_SelectActiveStock@numberSelect")
app:attachKey("6", "EventHandler_Key_SelectActiveStock@numberSelect")
app:attachKey("7", "EventHandler_Key_SelectActiveStock@numberSelect")
app:attachKey("8", "EventHandler_Key_SelectActiveStock@numberSelect")
app:attachKey("9", "EventHandler_Key_SelectActiveStock@numberSelect")

-- реверс между последним и предпоследним инструментом
app:attachKey("Shift", "EventHandler_Key_SelectActiveStock@revers")

-- стрелка вверх - 38
app:attachKey("NumPad 8", "EventHandler_Key_SelectActiveStock@upDown")

-- стрелка вниз - 40
app:attachKey("NumPad 2", "EventHandler_Key_SelectActiveStock@upDown")

-- отправить лимитный запрос
app:attachKey("Q", "EventHandler_Key_ZaprosLimit@buy0")		 -- купить 0
app:attachKey("W", "EventHandler_Key_ZaprosLimit@buy5")		 -- купить 5
app:attachKey("E", "EventHandler_Key_ZaprosLimit@buy10")	 -- купить 10

app:attachKey("Z", "EventHandler_Key_ZaprosLimit@sell0")	-- продать 0
app:attachKey("X", "EventHandler_Key_ZaprosLimit@sell5")	-- продать 5
app:attachKey("C", "EventHandler_Key_ZaprosLimit@sell10")	-- продать 10

-- удалить лимитный запрос
app:attachKey("A", "EventHandler_Key_RemoveZapros@removeZapros")

-- удалить все order и stopOrder
app:attachKey("D", "EventHandler_Key_DeleteOrdersAndStopOrders@delete")

-- мягкое закрытие позиции
app:attachKey("G", "EventHandler_Key_ClosePositionLimit@closePosition")
-- закрытие позиции по рынку
app:attachKey("Space", "EventHandler_Key_ClosePositionMarket@closePosition")

-- мягкое открытие позиции по лучшей цене в стакане
app:attachKey("Y", "EventHandler_Key_OpenPositionLimit@openPositionSell")	-- продать
app:attachKey("B", "EventHandler_Key_OpenPositionLimit@openPositionBuy")	-- купить

-- открытие позиции по цене вчерашнего hi и low
app:attachKey("R", "EventHandler_Key_ZaprosLimitHiLow@buy")	-- купить по цене hi
app:attachKey("V", "EventHandler_Key_ZaprosLimitHiLow@sell")	-- продать по цене low

-- открытие позиции по рынку
app:attachKey("NumPad *", "EventHandler_Key_OpenPositionMarket@openPositionSell")	-- продать по рынку
app:attachKey("NumPad .", "EventHandler_Key_OpenPositionMarket@openPositionBuy")	-- купить по рынку

-- восстановление стопа после случайного удаления
app:attachKey("K", "EventHandler_Key_RecoveryStop@recoveryStop")

-- восстановление стопа если при сделке он не выставился
app:attachKey("L", "EventHandler_Key_RecoveryStop@recoveryStopLast")

-- вызвать пересчёт максимальных лотов для бумаг
app:attachKey("I", "Action_CalculateMaxLotsEntityStock")

-- выключение/включение маркера уровни базовой цены
app:attachKey("P", "EventHandler_ViewBasePriceToChart")

-- скрывает/показывает  все линии баров дневок
app:attachKey("[", "EventHandler_ViewHiLowCloseDayBarAll")

-- скрывает/показывает  все линии баров часовщиков (первый час)
-- 10 для акций, 9-10 для фьючерсов
app:attachKey("]", "EventHandler_ViewHiLowHour1BarAll")

-- выключение/включение маркера тренда для инструментов у которых не пустой комментарий
app:attachKey("'", "EventHandler_MarkerTrendToChartOnOff")
