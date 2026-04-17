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
      "ISNULL(lastname, '') AS lastName, " & _
      "ISNULL(firstname, '') AS firstName, " & _
      "ISNULL(article_title, '') AS articleTitle, " & _
      "ISNULL(journal_name, '') AS journalName, " & _
      "ISNULL(keywords, '') AS keywords, " & _
      "ISNULL(method_keywords, '') AS methodKeywords, " & _
      "ISNULL(ranking, '') AS ranking, " & _
      "ISNULL(utd_journal, '') AS utdJournal, " & _
      "ISNULL(ft_journal, '') AS ftJournal, " & _
      "ISNULL(CONVERT(varchar(10), acceptance_date, 23), '') AS accdate, " & _
      "ISNULL(area, '') AS area, " & _
      "ISNULL(position, '') AS position, " & _
      "ISNULL(CONVERT(varchar(10), pub_date, 23), '') AS pubdate, " & _
      "ISNULL(CAST(pub_year AS varchar(10)), '') AS [year], " & _
      "ISNULL(author_rank, '') AS authorRank, " & _
      "ISNULL(CAST(num_authors AS varchar(20)), '') AS numAuthors, " & _
      "ISNULL(article_link, '') AS articleLink, " & _
      "ISNULL(CONVERT(varchar(10), end_date_rawls, 23), '') AS endDateAtRawls, " & _
      "ISNULL(CONVERT(varchar(10), start_date_rawls, 23), '') AS startDateAtRawls " & _
      "FROM dbo.rawls_publications " & _
      "ORDER BY acceptance_date DESC"

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
