1.

WITH CTE
AS
(SELECT YEAR(SO.OrderDate) AS Year,
        SUM(IL.ExtendedPrice - IL.TaxAmount) AS IncomePerYear,
        COUNT(DISTINCT MONTH(SO.OrderDate)) AS NumberOfDistinctMonths
 FROM   Sales.InvoiceLines IL
        JOIN Sales.Invoices I ON IL.InvoiceID = I.InvoiceID
        JOIN Sales.Orders SO ON I.OrderID=SO.OrderID
GROUP BY YEAR(SO.OrderDate))
SELECT Year,
       IncomePerYear,
       NumberOfDistinctMonths,
       CAST(IncomePerYear / NumberOfDistinctMonths * 12 AS DECIMAL(18, 2)) AS YearlyLinearIncome,
       CAST(((IncomePerYear / NumberOfDistinctMonths * 12) - LAG(IncomePerYear / NULLIF(NumberOfDistinctMonths, 0) * 12) OVER (ORDER BY Year)) /
       LAG(IncomePerYear / NumberOfDistinctMonths * 12) OVER (ORDER BY Year) * 100 AS DECIMAL(18, 2)) AS GrowthRate
FROM CTE
ORDER BY Year

2.

WITH CTE
AS
(SELECT YEAR(SI.InvoiceDate) AS TheYear,
        DATEPART(QUARTER,SI.InvoiceDate) AS TheQuater,
	    SC.CustomerName AS CustomerName,
	    SUM(SIL.ExtendedPrice - SIL.TaxAmount) AS IncomePerYear
FROM Sales.Customers SC
JOIN Sales.Invoices SI
ON SI.CustomerID= SC.CustomerID
JOIN Sales.InvoiceLines SIL
ON SIL.InvoiceID= SI.InvoiceID
GROUP BY YEAR(SI.InvoiceDate), DATEPART(QUARTER,SI.InvoiceDate), SC.CustomerName),
CTB AS
(SELECT CTE.TheYear,
        CTE.TheQuater,
	    CTE.CustomerName,
	    CTE.IncomePerYear,
	    DENSE_RANK()OVER(PARTITION BY TheYear, TheQuater ORDER BY IncomePerYear desc) AS DRNK
FROM CTE)
SELECT *
FROM CTB
WHERE DRNK<=5
ORDER BY TheYear,TheQuater, DRNK

3.

WITH CTE
AS
(SELECT SIL.StockItemID,
        SIL.Description AS StockItemName,
	    SUM(SIL.ExtendedPrice-SIL.TaxAmount) AS TotalProfit,
	    ROW_NUMBER() OVER (ORDER BY SUM(SIL.ExtendedPrice-SIL.TaxAmount) DESC) AS RN
FROM Sales.InvoiceLines SIL
GROUP BY SIL.StockItemID,
         SIL.Description)
SELECT CTE.StockItemID,
       CTE.StockItemName,
	   CTE.TotalProfit
FROM CTE
WHERE RN <= 10
ORDER BY TotalProfit desc       

4.

WITH CTE
AS
(SELECT WS.StockItemID AS StockItemID,
        WS.StockItemName,
	    WS.UnitPrice,
	    WS.RecommendedRetailPrice,
		WS.ValidTo,
        WS.RecommendedRetailPrice-WS.UnitPrice AS NominalProductProfit,
		ROW_NUMBER() OVER (ORDER BY (WS.RecommendedRetailPrice-WS.UnitPrice) DESC) AS RN
FROM Warehouse.StockItems WS)
SELECT CTE.RN,
       CTE.StockItemID,
       CTE.StockItemName,
	   CTE.UnitPrice,
	   CTE.RecommendedRetailPrice,
	   CTE.NominalProductProfit,
	   DENSE_RANK()OVER(ORDER BY NominalProductProfit DESC) AS DRANK
FROM CTE
WHERE CTE.ValidTo >= GETDATE() 
ORDER BY RN

5.

SELECT CAST(PS.SupplierID AS VARCHAR(10)) + ' - ' + PS.SupplierName AS SupplierDetails,
       STRING_AGG(CAST(WS.StockItemID AS VARCHAR(10)) + '  ' + WS.StockItemName, '/, ') WITHIN GROUP (ORDER BY WS.StockItemID) AS ProductDetails
FROM Purchasing.Suppliers PS
JOIN Warehouse.StockItems WS 
ON PS.SupplierID = WS.SupplierID
GROUP BY PS.SupplierID, PS.SupplierName

6. 

WITH CTE
AS
(SELECT SC.CustomerID,
       AC.CityName,
	   ACT.CountryName,
       ACT.Continent,
	   ACT.Region,
	   SUM(SIL.ExtendedPrice) AS TotalExtendedPrice
FROM Sales.Customers SC
JOIN Application.Cities AC
ON AC.CityID= SC.PostalCityID
JOIN Application.StateProvinces ASP
ON ASP.StateProvinceID= AC.StateProvinceID
JOIN Application.Countries ACT
ON ACT.CountryID= ASP.CountryID
JOIN Sales.Invoices SI
ON SI.CustomerID= SC.CustomerID
JOIN Sales.InvoiceLines SIL
ON SIL.InvoiceID= SI.InvoiceID
GROUP BY SC.CustomerID, AC.CityName, ACT.CountryName,ACT.Continent,ACT.Region),
CTB
AS
(SELECT *,
ROW_NUMBER()OVER(ORDER BY TotalExtendedPrice DESC) AS RN
FROM CTE)
SELECT *
FROM CTB
WHERE CTB.RN <=5
order by TotalExtendedPrice desc

7.

WITH CTE
AS
(SELECT YEAR(SO.OrderDate) AS OrderYear,
       CAST(MONTH(SO.OrderDate) AS VARCHAR) AS OrderMonth,
       SUM(SIL.ExtendedPrice - SIL.TaxAmount) AS MonthlyTotal,
       SUM(SUM(SIL.ExtendedPrice - SIL.TaxAmount)) OVER (PARTITION BY YEAR(SO.OrderDate) ORDER BY MONTH(SO.OrderDate)) AS CumulativeTotal,
	   MONTH(SO.OrderDate) AS OM
FROM   Sales.Orders SO
JOIN Sales.Invoices SI 
ON SI.OrderID = SO.OrderID
JOIN Sales.InvoiceLines SIL 
ON SIL.InvoiceID = SI.InvoiceID
GROUP BY YEAR(SO.OrderDate), MONTH(SO.OrderDate)
UNION ALL
SELECT YEAR(SO.OrderDate) AS OrderYear,
       'Grand_Total' AS OrderMonth,
       SUM(SIL.ExtendedPrice - SIL.TaxAmount) AS MonthlyTotal,
       SUM(SIL.ExtendedPrice - SIL.TaxAmount) AS MonthlyTotal,
	   13 AS OM
FROM Sales.Orders SO
JOIN Sales.Invoices SI 
ON SI.OrderID = SO.OrderID
JOIN Sales.InvoiceLines SIL 
ON SIL.InvoiceID = SI.InvoiceID
GROUP BY YEAR(SO.OrderDate))
SELECT CTE.OrderYear,
       CTE.OrderMonth,
	   CTE.MonthlyTotal,
	   CTE.CumulativeTotal
FROM CTE
ORDER BY OrderYear, OM

8.

WITH CTE
AS
(SELECT YEAR(SO.OrderDate) AS OrderYEAR,
       MONTH(SO.OrderDate) AS OrderMonth,
       COUNT(SO.OrderID) AS CountOfOrders
FROM Sales.Orders SO
GROUP BY YEAR(SO.OrderDate), MONTH(SO.OrderDate))
SELECT OrderMonth,    
       ISNULL([2013], 0) AS [2013],
       ISNULL([2014], 0) AS [2014],
       ISNULL([2015], 0) AS [2015],
       ISNULL([2016], 0) AS [2016]
FROM
CTE
PIVOT (Sum(CTE.CountOfOrders) FOR OrderYEAR IN ([2013],[2014],[2015],[2016])) AS PVT
ORDER BY OrderMonth

9.

WITH CTE
AS
(SELECT SC.CustomerID,
        SC.CustomerName,
        MAX(SO.OrderDate) AS LastOrderDate 
FROM Sales.Customers SC
JOIN Sales.Orders SO
ON SC.CustomerID = SO.CustomerID
GROUP BY SC.CustomerID, SC.CustomerName
),
CTB AS
(SELECT MAX(SO.OrderDate) AS GlobalLastOrderDate
FROM Sales.Orders SO),
CTD AS
(SELECT SC.CustomerID,
        SC.CustomerName,
        SO.OrderDate,
        LAG(SO.OrderDate) OVER (PARTITION BY SC.CustomerID ORDER BY SO.OrderDate) AS PreviousOrderDate
FROM Sales.Customers SC
JOIN Sales.Orders SO
ON SC.CustomerID = SO.CustomerID)
SELECT CTD.CustomerID,
       CTD.CustomerName,
       CTD.OrderDate,
       CTD.PreviousOrderDate,
       CTE.LastOrderDate,
       CTB.GlobalLastOrderDate,
       DATEDIFF(DAY, CTE.LastOrderDate, CTB.GlobalLastOrderDate) AS DaysSinceLastOrder, 
       AVG(DATEDIFF(DAY, CTD.PreviousOrderDate, CTD.OrderDate)) OVER (PARTITION BY CTD.CustomerID) AS AvgDaysBetweenOrders,
CASE WHEN DATEDIFF(DAY, CTE.LastOrderDate, CTB.GlobalLastOrderDate) > 2 * AVG(DATEDIFF(DAY, CTD.PreviousOrderDate, CTD.OrderDate)) OVER (PARTITION BY CTD.CustomerID)
     THEN 'Potential Churn'
     ELSE 'Active'
     END AS CustomerStatus
FROM CTD
JOIN CTE
ON CTD.CustomerID = CTE.CustomerID
CROSS JOIN CTB

10.

WITH CTE
AS
(SELECT SCC.CustomerCategoryName,
        SC.CustomerName,
CASE   WHEN sc.CustomerName LIKE 'TAILSPIN%' THEN '1'
	   WHEN sc.CustomerName LIKE 'WINGTIP%' THEN '2'
       ELSE sc.CustomerName
	   END AS CustomerName1
FROM Sales.CustomerCategories SCC
JOIN Sales.Customers SC
ON SCC.CustomerCategoryID= SC.CustomerCategoryID),
CTB 
AS
(SELECT CTE.CustomerCategoryName,
	   COUNT(DISTINCT CTE.CustomerName1) AS CustomerCOUNT
FROM CTE
GROUP BY CTE.CustomerCategoryName),
CTD
AS
(SELECT SUM(CTB.CustomerCOUNT) AS TotalCustCount
FROM CTB)
SELECT CTB.CustomerCategoryName,
       CTB.CustomerCOUNT,
	   CTD.TotalCustCount,
	   CONCAT(FORMAT((CTB.CustomerCOUNT*1.0/CTD.TotalCustCount) * 100,'N2'),'%') AS DistributionFactor
FROM CTB
CROSS JOIN CTD



