SELECT
  ISNULL(lastname, '') AS lastName,
  ISNULL(firstname, '') AS firstName,
  ISNULL(article_title, '') AS articleTitle,
  ISNULL(journal_name, '') AS journalName,
  ISNULL(keywords, '') AS keywords,
  ISNULL(method_keywords, '') AS methodKeywords,
  ISNULL(ranking, '') AS ranking,
  ISNULL(utd_journal, '') AS utdJournal,
  ISNULL(ft_journal, '') AS ftJournal,
  ISNULL(CONVERT(varchar(10), acceptance_date, 23), '') AS accdate,
  ISNULL(area, '') AS area,
  ISNULL(position, '') AS position,
  ISNULL(CONVERT(varchar(10), pub_date, 23), '') AS pubdate,
  ISNULL(CAST(pub_year AS varchar(10)), '') AS [year],
  ISNULL(author_rank, '') AS authorRank,
  ISNULL(CAST(num_authors AS varchar(20)), '') AS numAuthors,
  ISNULL(article_link, '') AS articleLink,
  ISNULL(CONVERT(varchar(10), end_date_rawls, 23), '') AS endDateAtRawls,
  ISNULL(CONVERT(varchar(10), start_date_rawls, 23), '') AS startDateAtRawls
FROM dbo.rawls_publications
ORDER BY acceptance_date DESC;
