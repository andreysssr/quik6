-- ����� ��������� ����������� � �������� ������

-- ��������� �������� ����������
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

-- ������ ����� ��������� � ������������� ������������
app:attachKey("Shift", "EventHandler_Key_SelectActiveStock@revers")

-- ������� ����� - 38
app:attachKey("NumPad 8", "EventHandler_Key_SelectActiveStock@upDown")

-- ������� ���� - 40
app:attachKey("NumPad 2", "EventHandler_Key_SelectActiveStock@upDown")

-- ��������� �������� ������
app:attachKey("Q", "EventHandler_Key_ZaprosLimit@buy0")		 -- ������ 0
app:attachKey("W", "EventHandler_Key_ZaprosLimit@buy5")		 -- ������ 5
app:attachKey("E", "EventHandler_Key_ZaprosLimit@buy10")	 -- ������ 10

app:attachKey("Z", "EventHandler_Key_ZaprosLimit@sell0")	-- ������� 0
app:attachKey("X", "EventHandler_Key_ZaprosLimit@sell5")	-- ������� 5
app:attachKey("C", "EventHandler_Key_ZaprosLimit@sell10")	-- ������� 10

-- ������� �������� ������
app:attachKey("A", "EventHandler_Key_RemoveZapros@removeZapros")

-- ������� ��� order � stopOrder
app:attachKey("D", "EventHandler_Key_DeleteOrdersAndStopOrders@delete")

-- ������ �������� �������
app:attachKey("G", "EventHandler_Key_ClosePositionLimit@closePosition")
-- �������� ������� �� �����
app:attachKey("Space", "EventHandler_Key_ClosePositionMarket@closePosition")

-- ������ �������� ������� �� ������ ���� � �������
app:attachKey("Y", "EventHandler_Key_OpenPositionLimit@openPositionSell")	-- �������
app:attachKey("B", "EventHandler_Key_OpenPositionLimit@openPositionBuy")	-- ������

-- �������� ������� �� ���� ���������� hi � low
app:attachKey("R", "EventHandler_Key_ZaprosLimitHiLow@buy")	-- ������ �� ���� hi
app:attachKey("V", "EventHandler_Key_ZaprosLimitHiLow@sell")	-- ������� �� ���� low

-- �������� ������� �� �����
app:attachKey("NumPad *", "EventHandler_Key_OpenPositionMarket@openPositionSell")	-- ������� �� �����
app:attachKey("NumPad .", "EventHandler_Key_OpenPositionMarket@openPositionBuy")	-- ������ �� �����

-- �������������� ����� ����� ���������� ��������
app:attachKey("K", "EventHandler_Key_RecoveryStop@recoveryStop")

-- �������������� ����� ���� ��� ������ �� �� ����������
app:attachKey("L", "EventHandler_Key_RecoveryStop@recoveryStopLast")

-- ������� �������� ������������ ����� ��� �����
app:attachKey("I", "Action_CalculateMaxLotsEntityStock")

-- ����������/��������� ������� ������ ������� ����
app:attachKey("P", "EventHandler_ViewBasePriceToChart")

-- ��������/����������  ��� ����� ����� ������
app:attachKey("[", "EventHandler_ViewHiLowCloseDayBarAll")

-- ��������/����������  ��� ����� ����� ���������� (������ ���)
-- 10 ��� �����, 9-10 ��� ���������
app:attachKey("]", "EventHandler_ViewHiLowHour1BarAll")

-- ����������/��������� ������� ������ ��� ������������ � ������� �� ������ �����������
app:attachKey("'", "EventHandler_MarkerTrendToChartOnOff")
