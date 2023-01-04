--- �������� �� �������

-- ������ ����������� �����������
app:attach("appStarted", "Action_CreateRepositories")

-- ����������� ��������� ������
app:attach("appStarted", "Action_CreateDsD")
app:attach("appStarted", "Action_CreateDsH1")

-- ������ Entity BasePrice ��� ������������ �� �������
app:attach("appStarted", "Action_CreateEntityBasePrice")

-- ��������� ��������� ������ ��� basePrice ���� ������������
app:attach("appStarted", "Action_UpdateBasePrice")

-- ������ Entity Stock ����������� �� �������
app:attach("appStarted", "Action_CreateEntityStock")

-- ������� �������� ������������� ���������� ����� ��� ���� �����
app:attach("appStarted", "Action_CalculateMaxLotsEntityStock")

-- ������ Entity TradeParams ��� ������������ �� �������
app:attach("appStarted", "Action_CreateEntityTradeParams")

-- �������� ������ � ����� basePrice �� ������
app:attach("appStarted", "Action_AddLevelsToChart")

-- ��������� ������������ ����� - ���������� � ����� �� ������� (������ 4 ������)
app:attach("appRun", "Action_AddLevelsToChart@updateLocation")

-- �������� ������ ��������
app:attach("appStarted", "Action_CreatePanelTrade")
app:attach("ClosedPanelTrade", "Action_CreatePanelTrade")

-- �������� ������ ����������
app:attach("appStarted", "Action_CreatePanelAlert")
app:attach("ClosedPanelAlert", "Action_CreatePanelAlert")

-- �������� ������ ������� - ����� ����������
app:attach("CreatedPanelTrade", "EventHandler_CompletePanelTrade")

-- ������� ���������� �� �������� ������
app:attach("appRun", "Action_IndicatorPanelTrade")

-- ���������� ���������� ���� ��� ����
app:attach("appRun", "TransactDispatcher@dispatch")

-- ��������� ��������� ������ ��� basePrice ���� ������������
app:attach("appRun", "Action_UpdateBasePrice")

-- �������� ���� � �������� ������ �� �������
app:attach("appRun", "EventHandler_PanelTrade_TimerUpdatePoleLastPrice")
app:attach("appRun", "EventHandler_PanelTrade_TimerUpdatePoleLevel")
app:attach("appRun", "EventHandler_PanelTrade_TimerUpdatePoleStrong")
app:attach("appRun", "EventHandler_PanelTrade_TimerUpdatePoleLine")

--- appStopped
-- ������� ��� ����� � ����� �� ���� ��������
app:attach("appStopped", "EventHandler_CleanAllChart")

-- ��������� ��� ��������� ������
app:attach("appStopped", "EventHandler_ClosePanel")

--- ===========================================================
---		Domain Events
--- ===========================================================
-- ������� �������� ������� onOrder, onStopOrder, onTrade
app:attach("Callback_OrderAndStopOrder", "EventHandler_Callback_ParseCallback@parseOrderAndStopOrder")
app:attach("Callback_Trade", "EventHandler_Callback_ChangePositionEntityStock@changePosition")

-- ��������� ������ ����������
app:attach("EntityTransact_ChangedTransactStatus",	"EventHandler_ChangeConditionEntityStock")

-- ��������� ����� ������� ���� ����������� basePrice
-- �������� ��������� ����� ������� ���� �� �������
app:attach("BasePrice_ChangedBasePrice", "EventHandler_ChangeLocationBasePriceLineOnChart")

-- ��������� ����� �������� ������ � ������������
-- �������� ��������� ����������� � �������� ������
app:attach("MicroService_ChangedActiveStock", "EventHandler_PanelTrade_UpdatePoleStock")

-- �������� ������� ��������� ����������� � ������� (Active)
app:attach("MicroService_ChangedActiveStock", "EventHandler_ChangeChartActive")

-- ������� �� �������� ����������
app:attach("Command_AddStop", "EventHandler_Command_AddStop")
app:attach("Command_AddStopLinked", "EventHandler_Command_AddStopLinked")
app:attach("Command_DeleteOrdersAndStopOrders", "EventHandler_Command_DeleteOrdersAndStopOrders")

-- ������� ������� - ��������� params � ����
app:attach("EntityStock_OpenedPosition", "EventHandler_PositionCache_AddRemoveToCache@addCache")
app:attach("EntityParams_UpdatedParams", "EventHandler_PositionCache_AddRemoveToCache@addCache")
app:attach("EntityStock_OpenedPosition", "EventHandler_PanelAlert_AddToPanelAlert@openedPosition")

-- ������� �������
-- ������� ������ �� ����
app:attach("EntityStock_ClosedPosition", "EventHandler_PositionCache_AddRemoveToCache@removeCache")
app:attach("EntityStock_ClosedPosition", "EventHandler_PanelAlert_AddToPanelAlert@closedPosition")

-- ��� ��������� ������� - �������� ���� �������
app:attach("EntityStock_ChangedPosition", "EventHandler_PanelTrade_UpdatePolePosition")

-- ��� ����������� ������ ������� � ����-������� - �������� ���� ������
app:attach("Callback_OrderAndStopOrder", "EventHandler_PanelTrade_UpdatePoleOrdersAll")

app:attach("Callback_OrderAndStopOrder", "EventHandler_UpdateMaxLots")
app:attach("EntityStock_ChangedMaxLots", "EventHandler_PanelTrade_UpdatePoleMaxLots")
app:attach("EntityStock_ChangedStatus", "EventHandler_PanelTrade_UpdatePoleStock@changedStatus")

-- �������� �� ���� �������� ������
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

-- ������ �������� � ������
app:attach("PanelTrade_Clicked_markerTrend", "EventHandler_ClickedPanelTrade_PoleMarkerTrend")

-- ���������/������� ����� �� ������ ������ ��� ��������� ������� �� (markerTrend)
app:attach("PanelTrade_Clicked_markerTrend", "EventHandler_ClickedPanelTrade_UpdateTrendToChart")

-- ��������� �������� �� ������� ��� � 15 ����� ���������� � ������
app:attach("appRun", "EventHandler_TimerUpdateTrendToChart")

-- ��������� ������ ����� �� ������ ��� ����� � ������� ���� ����������� � �������
app:attach("appStarted", "EventHandler_PrepareViewMarkerTrendToChart")

-- appStarted ���� ���� ������� ������� - �������� ��������� ������������ ���������
app:attach("appStarted", "EventHandler_PrepareViewStrongLevel")

-- ������ �������� � ������
app:attach("PanelTrade_Clicked_markerDayBar", "EventHandler_ClickedPanelTrade_PoleMarkerDayBar")

-- ���������/������� ����� �� ������ ������ ��� ��������� ������� �� (PoleDayBar)
app:attach("PanelTrade_Clicked_markerDayBar", "EventHandler_ClickedPanelTrade_UpdateBarDayLinesToChart")

-- ���������� ������ ���������� �������� ���� hi, low, close
app:attach("appStarted", "EventHandler_PrepareViewHiLowCloseDayBar")

-- ��������� �������� �� ������� ���������� � ������
app:attach("appRun", "EventHandler_TimerUpdateBarDayLinesToChart")

-- �������� ������  �� �������
app:attach("ChangedLinesInCharts", "EventHandler_UpdateBaseLinesInCharts")

-- ������ �������� � ������
app:attach("PanelTrade_Clicked_markerHourBar", "EventHandler_ClickedPanelTrade_PoleMarkerHourBar")

-- ���������/������� ����� �� ������ ������ ��� ��������� ������� �� (PoleDayBar)
app:attach("PanelTrade_Clicked_markerHourBar", "EventHandler_ClickedPanelTrade_UpdateBarHourLinesToChart")

-- ��������� �������� �� ������� ���������� � ������
app:attach("appRun", "EventHandler_TimerUpdateBarHourLinesToChart")

-- ������ �������� � ������
app:attach("PanelTrade_Clicked_markerMirrorLineHiLow", "EventHandler_ClickedPanelTrade_PoleMarkerMirrorLineHiLow")

-- ���������/������� ����� �� ������ ������ ��� ��������� ������� �� (PoleDayBar)
app:attach("PanelTrade_Clicked_markerMirrorLineHiLow", "EventHandler_ClickedPanelTrade_UpdateMirrorHiLowLinesToChart")

-- ���������� ������ ���������� �������� ���� hi, low, close
app:attach("appStarted", "EventHandler_PrepareViewMarkerMirrorLineHiLow")

-- ��������� �������� �� ������� ���������� � ������
app:attach("appRun", "EventHandler_TimerUpdateMirrorLinesToChart")

-- ��������� �������� �� ������� ��� ������� ���������
app:attach("appRun", "EventHandler_ViewLevelsToChart@updateLocation")

-- ��������� �������� �� ������� ��� ������� ������� ����
-- BasePrice_ChangedBasePrice
app:attachKey("appRun", "EventHandler_ViewBasePriceToChart@updateLocation")
app:attachKey("ChangedLinesInCharts", "EventHandler_ViewBasePriceToChart@updateLocation")
app:attachKey("BasePrice_ChangedBasePrice", "EventHandler_ViewBasePriceToChart@eventUpdateLocation")
