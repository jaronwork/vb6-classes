VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "TimeTicker"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

'�������ṹ��
Private Type LARGE_INTEGER

    LowPart As Long
    HighPart As Long

End Type

'��ȡʱ�����������ֵ
Private Declare Function QueryPerformanceCounter _
                Lib "kernel32" (lpPerformanceCount As LARGE_INTEGER) As Long

'��ȡ��Ƶ�ʣ�һ��������
Private Declare Function QueryPerformanceFrequency _
                Lib "kernel32" (lpFrequency As LARGE_INTEGER) As Long

'���ڽ����������ֽڸ��Ƶ�Currency���ͣ����ת���Ĺ���
Private Declare Sub CopyMemory _
                Lib "kernel32.dll" _
                Alias "RtlMoveMemory" (Destination As Any, _
                                       Source As Any, _
                                       ByVal Length As Long)

'��ʼʱ��
Private initTime  As LARGE_INTEGER

'ÿ���𶯴���
Private freqCount As LARGE_INTEGER

'����ʱ�����𶯼���ֵ
Private logTime   As LARGE_INTEGER

'ÿ���𶯴�����Currency��������
Private fFreq     As Currency

'��һ��������ת���ɸ߾���������
Private Function LargeIntToCurrency(liInput As LARGE_INTEGER) As Currency
    CopyMemory LargeIntToCurrency, liInput, LenB(liInput)
    LargeIntToCurrency = LargeIntToCurrency * 10000
End Function

'���ʼ��
Private Sub Class_Initialize()

    '��ȡ��������Ƶ��
    If QueryPerformanceFrequency(freqCount) > 0 Then
        If QueryPerformanceCounter(initTime) > 0 Then
        Else
            Err.Raise 11, , "��¼�𵴴���������"
        End If

    Else
        Err.Raise 11, , "��ȡ��Ƶ�ʳ�����"
    End If

    fFreq = LargeIntToCurrency(freqCount)
End Sub

'���ü�����
Public Sub ReInit()
    Call Class_Initialize
End Sub

'���ü������������ش��ϴ����ü�������ʼ����ʧ��������
Public Function ReInitGet() As Currency

    Dim cuStart As Currency

    Dim cuEnd   As Currency

    QueryPerformanceCounter logTime
    cuStart = LargeIntToCurrency(initTime)
    cuEnd = LargeIntToCurrency(logTime)
    ReInitGet = (cuEnd - cuStart) / fFreq
    QueryPerformanceCounter initTime
End Function

'���ش��ϴ����ü�������ʼ����ʧ���������������ü�����
Public Function SmoothGet() As Currency

    Dim cuStart As Currency

    Dim cuEnd   As Currency

    QueryPerformanceCounter logTime
    cuStart = LargeIntToCurrency(initTime)
    cuEnd = LargeIntToCurrency(logTime)
    SmoothGet = (cuEnd - cuStart) / fFreq
End Function
