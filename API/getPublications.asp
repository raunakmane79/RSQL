<%@ Language="VBScript" %>
<%
Option Explicit
Response.Buffer = True
Response.ContentType = "application/json"

Dim conn, rs, sql, connStr

On Error Resume Next

' =========================
' CHANGE THIS CONNECTION STRING
' =========================

' Option A: SQL login
connStr = "Provider=SQLOLEDB;" & _
          "Data Source=bamsql.ba.ttu.edu;" & _
          "Initial Catalog=rawlsresearch;" & _
          "User ID=ramane;" & _
          "Password=Ram@ne2;"

' Option B: Windows auth
' connStr = "Provider=SQLOLEDB;" & _
'           "Data Source=bamsql.ba.ttu.edu;" & _
'           "Initial Catalog=rawlsresearch;" & _
'           "Integrated Security=SSPI;"

Set conn = Server.CreateObject("ADODB.Connection")
conn.Open connStr

If Err.Number <> 0 Then
    WriteJsonError "Database connection failed: " & Err.Description
    Response.End
End If

sql = "SELECT " & _
      "ISNULL([Lastname], '') AS lastName, " & _
      "ISNULL([Firstname], '') AS firstName, " & _
      "ISNULL([articletitle], '') AS articleTitle, " & _
      "ISNULL([journalname], '') AS journalName, " & _
      "ISNULL([Keywords], '') AS keywords, " & _
      "ISNULL([Method Keywords], '') AS methodKeywords, " & _
      "ISNULL([Ranking - Updated], '') AS ranking, " & _
      "ISNULL([UTD Journal], '') AS utdJournal, " & _
      "ISNULL([Financial Times Journal], '') AS ftJournal, " & _
      "ISNULL(CONVERT(varchar(10), [Acceptance Date], 23), '') AS accdate, " & _
      "ISNULL([Area], '') AS area, " & _
      "ISNULL([Position], '') AS position, " & _
      "ISNULL(CONVERT(varchar(10), [pubdate], 23), '') AS pubdate, " & _
      "ISNULL(CAST([Author Rank] AS varchar(20)), '') AS authorRank, " & _
      "ISNULL(CAST([Number of Authors] AS varchar(20)), '') AS numAuthors, " & _
      "ISNULL([Article Link], '') AS articleLink, " & _
      "ISNULL(CAST([year] AS varchar(10)), '') AS [year], " & _
      "ISNULL(CAST([End date at Rawls] AS varchar(50)), '') AS endDateAtRawls " & _
      "FROM dbo.rawls_publications " & _
      "ORDER BY [Acceptance Date] DESC"

Set rs = conn.Execute(sql)

If Err.Number <> 0 Then
    WriteJsonError "Query failed: " & Err.Description
    Response.End
End If

Response.Write "["

Dim firstRow
firstRow = True

Do Until rs.EOF
    If Not firstRow Then Response.Write ","
    firstRow = False

    Response.Write "{"
    Response.Write """lastName"":""" & JsonEscape(rs("lastName")) & ""","
    Response.Write """firstName"":""" & JsonEscape(rs("firstName")) & ""","
    Response.Write """articleTitle"":""" & JsonEscape(rs("articleTitle")) & ""","
    Response.Write """journalName"":""" & JsonEscape(rs("journalName")) & ""","
    Response.Write """keywords"":""" & JsonEscape(rs("keywords")) & ""","
    Response.Write """methodKeywords"":""" & JsonEscape(rs("methodKeywords")) & ""","
    Response.Write """ranking"":""" & JsonEscape(rs("ranking")) & ""","
    Response.Write """utdJournal"":""" & JsonEscape(rs("utdJournal")) & ""","
    Response.Write """ftJournal"":""" & JsonEscape(rs("ftJournal")) & ""","
    Response.Write """accdate"":""" & JsonEscape(rs("accdate")) & ""","
    Response.Write """area"":""" & JsonEscape(rs("area")) & ""","
    Response.Write """position"":""" & JsonEscape(rs("position")) & ""","
    Response.Write """pubdate"":""" & JsonEscape(rs("pubdate")) & ""","
    Response.Write """authorRank"":""" & JsonEscape(rs("authorRank")) & ""","
    Response.Write """numAuthors"":""" & JsonEscape(rs("numAuthors")) & ""","
    Response.Write """articleLink"":""" & JsonEscape(rs("articleLink")) & ""","
    Response.Write """year"":""" & JsonEscape(rs("year")) & ""","
    Response.Write """endDateAtRawls"":""" & JsonEscape(rs("endDateAtRawls")) & """"
    Response.Write "}"

    rs.MoveNext
Loop

Response.Write "]"

If Not rs Is Nothing Then
    If rs.State = 1 Then rs.Close
    Set rs = Nothing
End If

If Not conn Is Nothing Then
    If conn.State = 1 Then conn.Close
    Set conn = Nothing
End If

Response.End

Sub WriteJsonError(msg)
    Response.Status = "500 Internal Server Error"
    Response.Write "{""error"":""" & JsonEscape(msg) & """}"
End Sub

Function JsonEscape(val)
    Dim s
    s = CStr("" & val)
    s = Replace(s, "\", "\\")
    s = Replace(s, """", "\""")
    s = Replace(s, vbCrLf, "\n")
    s = Replace(s, vbCr, "\n")
    s = Replace(s, vbLf, "\n")
    JsonEscape = s
End Function
%>
