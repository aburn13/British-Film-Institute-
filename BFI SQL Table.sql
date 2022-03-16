----CREATE NEW TABLE AND MERGE MULTIPLE TABLES TOGETHER

INSERT INTO PortfolioProject.dbo.BFI_Table
SELECT *
FROM PortfolioProject.dbo.Table_1 
UNION
SELECT *
FROM PortfolioProject.dbo.Table_2
UNION
SELECT *
FROM PortfolioProject.dbo.Table_3;

----REMOVE RANK COLUMN DUE TO DUPLICATE 

ALTER TABLE PortfolioProject.dbo.BFI_Table
DROP COLUMN Rank;

----SORT TOTAL GROSS INTO RELEASE YEAR FROM HIGHEST TO LOWEST(VISUAL 1)
--*DATA COLLECTED AROUND MID OCTOBER 2021*

SELECT [Release Year], SUM([Total Gross]) AS 'Total Gross'
FROM PortfolioProject.dbo.BFI_Table
GROUP BY [Release Year]
ORDER BY 1 DESC;

----SORT INTO COUNTRY OF ORIGIN (VISUAL 2)

SELECT [Country of Origin], SUM([Weekend Gross]) AS 'Total Gross'
FROM PortfolioProject.dbo.BFI_Table
GROUP BY [Country of Origin]
ORDER BY 2 DESC;

----LOOKING AT TOP DISTRIBUTORS (VISUAL 3)

SELECT Distributor, SUM([Weekend Gross]) AS 'Total Weekend Gross', COUNT([Weekend Gross]) AS 'Number of Movies'
FROM PortfolioProject.dbo.BFI_Table
GROUP BY Distributor
ORDER BY 2 DESC;

----CALCULATE PERCENT CHANGE EACH YEAR (VISUAL 4):

--CREATE TEMP TABLE FROM TOTALS QUERY

CREATE TABLE #BFI_Totals (
ReleaseYear int,
TotalWeekendGross int)

--INSERT QUERY INTO TEMP TABLE

INSERT INTO #BFI_Totals
SELECT [Release Year], SUM([Weekend Gross]) AS 'Total Weekend Gross' 
FROM PortfolioProject.dbo.BFI_Table
GROUP BY [Release Year]
ORDER BY 1 DESC;

SELECT *
FROM #BFI_Totals;

--USE SELF JOIN TO CALCULATE PERCENT CHANGE

SELECT prev.ReleaseYear, prev.TotalWeekendGross, new.ReleaseYear, new.TotalWeekendGross, 
(CAST(new.TotalWeekendGross - prev.TotalWeekendGross AS FLOAT) / prev.TotalWeekendGross)*100 AS PercentChange
FROM #BFI_Totals prev
LEFT JOIN #BFI_Totals new
	ON(prev.ReleaseYear + 1 = new.ReleaseYear)
ORDER BY prev.ReleaseYear;


