--- подписка на события

-- создаём необходимые репозитории
app:attach("appStarted", "Action_CreateRepositories")

-- подписываем источники данных
app:attach("appStarted", "Action_CreateDsD")
app:attach("appStarted", "Action_CreateDsH1")

-- создаём Entity BasePrice для инструментов по домашке
app:attach("appStarted", "Action_CreateEntityBasePrice")

-- обновляем расчётные данные для basePrice всех инструментов
app:attach("appStarted", "Action_UpdateBasePrice")

-- создаём Entity Stock инструменты по домашке
app:attach("appStarted", "Action_CreateEntityStock")

-- вызвать пересчёт максимального количества лотов для всех бумаг
app:attach("appStarted", "Action_CalculateMaxLotsEntityStock")

-- создаём Entity TradeParams для инструментов по домашке
app:attach("appStarted", "Action_CreateEntityTradeParams")

-- добавить уровни и линию basePrice на график
app:attach("appStarted", "Action_AddLevelsToChart")

-- обновляем нарисованные линии - сдвигаются в право по времени (каждые 4 минуты)
app:attach("appRun", "Action_AddLevelsToChart@updateLocation")

-- создание панели торговли
app:attach("appStarted", "Action_CreatePanelTrade")
app:attach("ClosedPanelTrade", "Action_CreatePanelTrade")

-- создание панели оповещений
app:attach("appStarted", "Action_CreatePanelAlert")
app:attach("ClosedPanelAlert", "Action_CreatePanelAlert")

-- торговая панель создана - нужно заполнение
app:attach("CreatedPanelTrade", "EventHandler_CompletePanelTrade")

-- мигание индикатора на торговой панели
app:attach("appRun", "Action_IndicatorPanelTrade")

-- отправляем транзакции если они есть
app:attach("appRun", "TransactDispatcher@dispatch")

-- обновляем расчётные данные для basePrice всех инструментов
app:attach("appRun", "Action_UpdateBasePrice")

-- обновить поля в торговой панели по таймеру
app:attach("appRun", "EventHandler_PanelTrade_TimerUpdatePoleLastPrice")
app:attach("appRun", "EventHandler_PanelTrade_TimerUpdatePoleLevel")
app:attach("appRun", "EventHandler_PanelTrade_TimerUpdatePoleStrong")
app:attach("appRun", "EventHandler_PanelTrade_TimerUpdatePoleLine")

--- appStopped
-- удаляет все метки и линии на всех графиках
app:attach("appStopped", "EventHandler_CleanAllChart")

-- закрываем все источники данных
app:attach("appStopped", "EventHandler_ClosePanel")

--- ===========================================================
---		Domain Events
--- ===========================================================
-- события обратных функций onOrder, onStopOrder, onTrade
app:attach("Callback_OrderAndStopOrder", "EventHandler_Callback_ParseCallback@parseOrderAndStopOrder")
app:attach("Callback_Trade", "EventHandler_Callback_ChangePositionEntityStock@changePosition")

-- поменялся статус транзакции
app:attach("EntityTransact_ChangedTransactStatus",	"EventHandler_ChangeConditionEntityStock")

-- произошла смена базовой цены инструмента basePrice
-- поменять положение линий базовой цены на графике
app:attach("BasePrice_ChangedBasePrice", "EventHandler_ChangeLocationBasePriceLineOnChart")

-- произошла смена активной бумаги в микросервисе
-- обновить состояние инструмента в Торговой панели
app:attach("MicroService_ChangedActiveStock", "EventHandler_PanelTrade_UpdatePoleStock")

-- обновить надпись активного инструмента в графике (Active)
app:attach("MicroService_ChangedActiveStock", "EventHandler_ChangeChartActive")

-- команда на отправку транзакций
app:attach("Command_AddStop", "EventHandler_Command_AddStop")
app:attach("Command_AddStopLinked", "EventHandler_Command_AddStopLinked")
app:attach("Command_DeleteOrdersAndStopOrders", "EventHandler_Command_DeleteOrdersAndStopOrders")

-- открыта позиция - сохранить params в кеше
app:attach("EntityStock_OpenedPosition", "EventHandler_PositionCache_AddRemoveToCache@addCache")
app:attach("EntityParams_UpdatedParams", "EventHandler_PositionCache_AddRemoveToCache@addCache")
app:attach("EntityStock_OpenedPosition", "EventHandler_PanelAlert_AddToPanelAlert@openedPosition")

-- закрыта позиция
-- удаляем данные из кеша
app:attach("EntityStock_ClosedPosition", "EventHandler_PositionCache_AddRemoveToCache@removeCache")
app:attach("EntityStock_ClosedPosition", "EventHandler_PanelAlert_AddToPanelAlert@closedPosition")

-- при изменении позиции - обновить поле позиции
app:attach("EntityStock_ChangedPosition", "EventHandler_PanelTrade_UpdatePolePosition")

-- при поступлении данных ордеров и стоп-ордеров - обновить поле заявки
app:attach("Callback_OrderAndStopOrder", "EventHandler_PanelTrade_UpdatePoleOrdersAll")

app:attach("Callback_OrderAndStopOrder", "EventHandler_UpdateMaxLots")
app:attach("EntityStock_ChangedMaxLots", "EventHandler_PanelTrade_UpdatePoleMaxLots")
app:attach("EntityStock_ChangedStatus", "EventHandler_PanelTrade_UpdatePoleStock@changedStatus")

-- кликнули по полю торговой панели
app:attach("PanelTrade_Clicked_stock", "EventHandler_ClickedPanelTrade_PoleStock")

app:attach("PanelTrade_Clicked_take2", "EventHandler_ClickedPanelTrade_PoleTake@select2")
app:attach("PanelTrade_Clicked_take3", "EventHandler_ClickedPanelTrade_PoleTake@select3")
app:attach("PanelTrade_Clicked_take4", "EventHandler_ClickedPanelTrade_PoleTake@select4")
app:attach("PanelTrade_Clicked_take5", "EventHandler_ClickedPanelTrade_PoleTake@select5")
app:attach("PanelTrade_Clicked_take6", "EventHandler_ClickedPanelTrade_PoleTake@select6")
app:attach("PanelTrade_Clicked_take7", "EventHandler_ClickedPanelTrade_PoleTake@select7")
app:attach("PanelTrade_Clicked_take8", "EventHandler_ClickedPanelTrade_PoleTake@select8")

--
app:attach("EntityStock_ChangedTake", "EventHandler_PanelTrade_UpdatePoleTake")

app:attach("PanelTrade_Clicked_commentView", "EventHandler_ClickedPanelTrade_PoleCommentView")
app:attach("PanelTrade_Clicked_comment", "EventHandler_ClickedPanelTrade_PoleComment")
app:attach("PanelTrade_Clicked_lastPrice", "EventHandler_ClickedPanelTrade_PoleLastPrice")
app:attach("PanelTrade_Clicked_marker1", "EventHandler_ClickedPanelTrade_PoleMarker1")

-- меняем значение в панели
app:attach("PanelTrade_Clicked_markerTrend", "EventHandler_ClickedPanelTrade_PoleMarkerTrend")

-- добавляем/удаляем тренд на график бумаги при изменении нажатия на (markerTrend)
app:attach("PanelTrade_Clicked_markerTrend", "EventHandler_ClickedPanelTrade_UpdateTrendToChart")

-- обновляем значения по таймеру раз в 15 минут включённых в список
app:attach("appRun", "EventHandler_TimerUpdateTrendToChart")

-- добавляет маркер тренд на график для бумаг у которых есть комментарий в домашке
app:attach("appStarted", "EventHandler_PrepareViewMarkerTrendToChart")

-- appStarted если есть сильный уровень - поменять состояние микросервисе состояния
app:attach("appStarted", "EventHandler_PrepareViewStrongLevel")

-- меняем значение в панели
app:attach("PanelTrade_Clicked_markerDayBar", "EventHandler_ClickedPanelTrade_PoleMarkerDayBar")

-- добавляем/удаляем линию на график бумаги при изменении нажатия на (PoleDayBar)
app:attach("PanelTrade_Clicked_markerDayBar", "EventHandler_ClickedPanelTrade_UpdateBarDayLinesToChart")

-- показывает уровни вчерашнего дневного бара hi, low, close
app:attach("appStarted", "EventHandler_PrepareViewHiLowCloseDayBar")

-- обновляем значения по таймеру включённых в список
app:attach("appRun", "EventHandler_TimerUpdateBarDayLinesToChart")

-- обновить уровни  на графике
app:attach("ChangedLinesInCharts", "EventHandler_UpdateBaseLinesInCharts")

-- меняем значение в панели
app:attach("PanelTrade_Clicked_markerHourBar", "EventHandler_ClickedPanelTrade_PoleMarkerHourBar")

-- добавляем/удаляем линию на график бумаги при изменении нажатия на (PoleDayBar)
app:attach("PanelTrade_Clicked_markerHourBar", "EventHandler_ClickedPanelTrade_UpdateBarHourLinesToChart")

-- обновляем значения по таймеру включённых в список
app:attach("appRun", "EventHandler_TimerUpdateBarHourLinesToChart")

-- меняем значение в панели
app:attach("PanelTrade_Clicked_markerMirrorLineHiLow", "EventHandler_ClickedPanelTrade_PoleMarkerMirrorLineHiLow")

-- добавляем/удаляем линию на график бумаги при изменении нажатия на (PoleDayBar)
app:attach("PanelTrade_Clicked_markerMirrorLineHiLow", "EventHandler_ClickedPanelTrade_UpdateMirrorHiLowLinesToChart")

-- показывает уровни вчерашнего дневного бара hi, low, close
app:attach("appStarted", "EventHandler_PrepareViewMarkerMirrorLineHiLow")

-- обновляем значения по таймеру включённых в список
app:attach("appRun", "EventHandler_TimerUpdateMirrorLinesToChart")

-- обновляем значения по таймеру для уровней интервала
app:attach("appRun", "EventHandler_ViewLevelsToChart@updateLocation")

-- обновляем значения по таймеру для уровней базовой цены
-- BasePrice_ChangedBasePrice
app:attachKey("appRun", "EventHandler_ViewBasePriceToChart@updateLocation")
app:attachKey("ChangedLinesInCharts", "EventHandler_ViewBasePriceToChart@updateLocation")
app:attachKey("BasePrice_ChangedBasePrice", "EventHandler_ViewBasePriceToChart@eventUpdateLocation")
