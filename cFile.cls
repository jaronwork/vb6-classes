VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cFile"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

'<CSCC>
'--------------------------------------------------------------------------------
'    Component  : cFile
'    Project    : Recent
'
'    Description: ͨ���ļ�����
'
'    Modified   :
'--------------------------------------------------------------------------------
'</CSCC>
Private Declare Function PathFileExists _
                Lib "shlwapi.dll" _
                Alias "PathFileExistsA" (ByVal pszPath As String) As Boolean

Private Declare Function ShellExecute _
                Lib "shell32.dll" _
                Alias "ShellExecuteA" (ByVal hwnd As Long, _
                                       ByVal lpOperation As String, _
                                       ByVal lpFile As String, _
                                       ByVal lpParameters As String, _
                                       ByVal lpDirectory As String, _
                                       ByVal nShowCmd As Long) As Long
Private Declare Function DeleteFile Lib "kernel32" Alias "DeleteFileA" (ByVal lpFileName As String) As Long


'����ʼ����
Private Sub Class_Initialize()

End Sub

'������������д�ļ���
'<CSCM>
'--------------------------------------------------------------------------------
' Project    :       Recent
' Procedure  :       WriteToTextFile
' Description:       ���ļ�д���ı�
' Created by :       Project Administrator
' Machine    :       MYSOFT-SUNR01
' Date-Time  :       1-18-2015-14:30:32
'
' Parameters :       FilePath (String)
'                    Content (String)
'--------------------------------------------------------------------------------
'</CSCM>
Public Function WriteToTextFile(ByVal FilePath As String, _
                                ByVal Content As String) As Boolean

    On Error Resume Next

    Dim fileId As Long

    fileId = FreeFile

    If PathFileExists(FilePath) Then
        Open FilePath For Append As fileId
    Else
        Open FilePath For Output As fileId
    End If

    Print #fileId, Content;
    Close fileId

    If Err.Number > 0 Then
        WriteToTextFile = False
        Err.Clear
    Else
        WriteToTextFile = True
    End If

End Function

'<CSCM>
'--------------------------------------------------------------------------------
' Project    :       Recent
' Procedure  :       WriteLineToTextFile
' Description:       ���ļ�д���µ�һ���ı�
' Created by :       Project Administrator
' Machine    :       MYSOFT-SUNR01
' Date-Time  :       1-18-2015-14:29:53
'
' Parameters :       FilePath (String)
'                    Content (String)
'--------------------------------------------------------------------------------
'</CSCM>
Public Function WriteLineToTextFile(ByVal FilePath As String, _
                                    ByVal Content As String) As Boolean
    WriteLineToTextFile = WriteToTextFile(FilePath, vbCrLf & Content)
End Function

'���������������ļ���

'<CSCM>
'--------------------------------------------------------------------------------
' Project    :       ��⹹����Ŀ
' Procedure  :       ReadTextFile
' Description:       ��ȡָ��·����ȫ��
' Created by :       Project Administrator
' Machine    :       MYSOFT-SUNR01
' Date-Time  :       1-18-2015-15:14:52
'
' Parameters :       FilePath (String)
'--------------------------------------------------------------------------------
'</CSCM>
Public Function ReadTextFile(ByVal FilePath As String) As String

    Dim fileId As Long

    Dim fBin() As Byte

    Dim fSize  As Long

    fileId = FreeFile

    If FileExists(FilePath) = False Then
        Err.Raise 100, , "�ļ������ڣ�"
    End If
    
    fSize = FileLen(FilePath)
    ReDim fBin(fSize - 1)
    
    Open FilePath For Binary Access Read As fileId
        Get #fileId, , fBin
    Close fileId

    If Err.Number > 0 Then
        MsgBox Err.Description
        ReadTextFile = ""
    Else
        ReadTextFile = StrConv(fBin, vbUnicode)
    End If

End Function
 '�������������ļ�������
'<CSCM>
'--------------------------------------------------------------------------------
' Project    :       ��⹹����Ŀ
' Procedure  :       FileExists
' Description:       ����ָ��·���Ƿ�����ļ����У�
' Created by :       Project Administrator
' Machine    :       MYSOFT-SUNR01
' Date-Time  :       1-18-2015-15:16:31
'
' Parameters :       FilePath (String)
'--------------------------------------------------------------------------------
'</CSCM>
Public Function FileExists(ByVal FilePath As String) As Boolean
    FileExists = PathFileExists(FilePath)
End Function

'<CSCM>
'--------------------------------------------------------------------------------
' Project    :       ��⹹����Ŀ
' Procedure  :       Delete
' Description:       ɾ��ָ���ļ�
' Created by :       Project Administrator
' Machine    :       MYSOFT-SUNR01
' Date-Time  :       1-18-2015-16:59:10
'
' Parameters :       FilePath (String)
'--------------------------------------------------------------------------------
'</CSCM>
Public Sub Delete(ByVal FilePath As String)
    If FileExists(FilePath) Then
        If DeleteFile(FilePath) = 0 Then
            Err.Raise 11, , "�ļ�ɾ������"
        End If
    Else
        Err.Raise 12, , "�ļ�·�������ڣ�"
    End If
End Sub