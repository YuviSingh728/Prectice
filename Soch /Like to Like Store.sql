###################Like To like Store##################

SELECT 
PERIOD,
COUNT(DISTINCT storecode) AS No_Store,COUNT(DISTINCT a.mobile) AS Customer,
SUM(amount) AS Sales,COUNT(DISTINCT uniquebillno) AS Bills,
COUNT(DISTINCT txndate,mobile) AS Visit,
COUNT(DISTINCT CASE WHEN Category='OneTimer' THEN a.mobile END) AS `OneTimer`,
COUNT(DISTINCT CASE WHEN category='OneTimer' THEN uniquebillno END) AS `OneTimer Bills`,
SUM(CASE WHEN category='OneTimer' THEN Amount END) AS `OneTimer Sales`,
COUNT(DISTINCT CASE WHEN Category='Repeater' THEN a.mobile END) AS `Repeater`,
COUNT(DISTINCT CASE WHEN category='Repeater' THEN uniquebillno END) AS `Repeater Bills`,
SUM(CASE WHEN category='Repeater' THEN amount END) AS `Repeater Sales`
FROM 
(SELECT CONCAT(LEFT(MONTHNAME(txndate),3), '-', RIGHT(YEAR(txndate),2)) AS PERIOD,
storecode,a.mobile,amount,uniquebillno,txndate,
 CASE WHEN (modifiedenrolledon = txndate AND TxnCount = 1) 
OR (txndate < modifiedenrolledon AND TxnCount = 1) 
OR (modifiedenrolledon IS NULL AND TxnCount = 1) 
THEN 'OneTimer'
ELSE 'Repeater'
END AS Category
FROM txn_report_accrual_redemption a JOIN member_report b
ON a.mobile=b.mobile
WHERE txndate BETWEEN '2022-04-01' AND '2025-07-31' 
AND storecode NOT LIKE '%demo%' 
AND storecode NOT LIKE '%Ecom%' 
AND storecode IN(        
SELECT storecode 
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2022-04-01' AND '2023-03-31'
AND storecode NOT LIKE '%demo%' 
AND storecode NOT LIKE '%Ecom%'
GROUP BY 1)
GROUP BY 1,2,3)a
GROUP BY 1;

SELECT CONCAT(LEFT(MONTHNAME(txndate),3), '-', RIGHT(YEAR(txndate),2)) AS PERIOD,
SUM(itemqty) AS Qty FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2022-04-01' AND '2025-07-31' 
AND modifiedstorecode NOT LIKE '%demo%' 
AND modifiedstorecode NOT LIKE '%Ecom%'
AND modifiedstorecode IN(        
SELECT storecode 
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2022-04-01' AND '2023-03-31'
AND storecode NOT LIKE '%demo%' 
AND storecode NOT LIKE '%Ecom%'
GROUP BY 1)
GROUP BY 1; 

################Store code 2022-23####################

SELECT DISTINCT storecode,store, 
DATEDIFF(CURDATE(),MIN(txndate)) AS vintage 
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2022-04-01' AND '2023-03-31'
AND storecode NOT LIKE '%demo%' 
AND storecode NOT LIKE '%Ecom%'
GROUP BY 1;

###################New Store##################


SELECT 
PERIOD,
COUNT(DISTINCT storecode) AS No_Store,COUNT(DISTINCT a.mobile) AS Customer,
SUM(amount) AS Sales,COUNT(DISTINCT uniquebillno) AS Bills,
COUNT(DISTINCT txndate,mobile) AS Visit,
COUNT(DISTINCT CASE WHEN Category='OneTimer' THEN a.mobile END) AS `OneTimer`,
COUNT(DISTINCT CASE WHEN category='OneTimer' THEN uniquebillno END) AS `OneTimer Bills`,
SUM(CASE WHEN category='OneTimer' THEN Amount END) AS `OneTimer Sales`,
COUNT(DISTINCT CASE WHEN Category='Repeater' THEN a.mobile END) AS `Repeater`,
COUNT(DISTINCT CASE WHEN category='Repeater' THEN uniquebillno END) AS `Repeater Bills`,
SUM(CASE WHEN category='Repeater' THEN amount END) AS `Repeater Sales`
FROM 
(SELECT CONCAT(LEFT(MONTHNAME(txndate),3), '-', RIGHT(YEAR(txndate),2)) AS PERIOD,
storecode,a.mobile,amount,uniquebillno,txndate,
 CASE WHEN (modifiedenrolledon = txndate AND TxnCount = 1) 
OR (txndate < modifiedenrolledon AND TxnCount = 1) 
OR (modifiedenrolledon IS NULL AND TxnCount = 1) 
THEN 'OneTimer'
ELSE 'Repeater'
END AS Category
FROM txn_report_accrual_redemption a JOIN member_report b
ON a.mobile=b.mobile
WHERE txndate BETWEEN '2022-04-01' AND '2025-07-31' 
AND storecode NOT LIKE '%demo%' 
AND storecode NOT LIKE '%Ecom%' 
AND storecode NOT IN(        
SELECT storecode 
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2022-04-01' AND '2023-03-31'
AND storecode NOT LIKE '%demo%' 
AND storecode NOT LIKE '%Ecom%'
GROUP BY 1)
GROUP BY 1,2,3)a
GROUP BY 1;

SELECT CONCAT(LEFT(MONTHNAME(txndate),3), '-', RIGHT(YEAR(txndate),2)) AS PERIOD,
SUM(itemqty) AS Qty FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2022-04-01' AND '2025-07-31' 
AND modifiedstorecode NOT LIKE '%demo%' 
AND modifiedstorecode NOT LIKE '%Ecom%'
AND modifiedstorecode NOT IN(        
SELECT storecode 
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2022-04-01' AND '2023-03-31'
AND storecode NOT LIKE '%demo%' 
AND storecode NOT LIKE '%Ecom%'
GROUP BY 1)
GROUP BY 1;

#######################Fy Data 2022-23-24-25################

SELECT 
CASE 
WHEN txndate BETWEEN '2022-04-01' AND '2023-03-31' THEN 'FY-22-23'
WHEN txndate BETWEEN '2023-04-01' AND '2024-03-31' THEN 'FY-23-24'
WHEN txndate BETWEEN '2024-04-01' AND '2025-03-31' THEN 'FY-24-25'
WHEN txndate BETWEEN '2025-04-01' AND '2026-03-31' THEN 'FY-25-26'
END AS `Period`,
COUNT(DISTINCT modifiedstorecode) AS Store,
SUM(itemnetamount) AS Loyalty_Sales,
COUNT(DISTINCT modifiedstorecode,txndate) AS Operational_Days
FROM sku_report_loyalty
WHERE (( txndate BETWEEN '2022-04-01' AND '2023-03-31')OR
( txndate BETWEEN '2023-04-01' AND '2024-03-31')OR
( txndate BETWEEN '2024-04-01' AND '2025-03-31')OR
( txndate BETWEEN '2025-04-01' AND '2026-03-31'))
GROUP BY 1;

SELECT 
CASE 
WHEN txndate BETWEEN '2022-04-01' AND '2023-03-31' THEN 'FY-22-23'
WHEN txndate BETWEEN '2023-04-01' AND '2024-03-31' THEN 'FY-23-24'
WHEN txndate BETWEEN '2024-04-01' AND '2025-03-31' THEN 'FY-24-25'
WHEN txndate BETWEEN '2025-04-01' AND '2026-03-31' THEN 'FY-25-26'
END AS `Period`,
COUNT(DISTINCT modifiedstorecode) AS Store,
SUM(amount) AS Loyalty_Sales,
COUNT(DISTINCT modifiedstorecode,txndate) AS Operational_Days
FROM sku_report_nonloyalty
WHERE (( txndate BETWEEN '2022-04-01' AND '2023-03-31')OR
( txndate BETWEEN '2023-04-01' AND '2024-03-31')OR
( txndate BETWEEN '2024-04-01' AND '2025-03-31')OR
( txndate BETWEEN '2025-04-01' AND '2026-03-31'))
GROUP BY 1;



################ Storewise Sales ####################

SELECT
storecode,
CASE
WHEN txndate BETWEEN '2022-04-01' AND '2023-03-31' THEN 'FY_22-23' 
WHEN txndate BETWEEN '2023-04-01' AND '2024-03-31' THEN 'FY_23-24'
WHEN txndate BETWEEN '2024-04-01' AND '2025-03-31' THEN 'FY_24-25'
WHEN txndate BETWEEN '2025-04-01' AND '2026-03-31' THEN 'FY_25-26'
END AS `Period`,
DATEDIFF('2025-08-17',MIN(txndate)) AS vintage, 
 SUM(amount) AS Sales
 FROM txn_report_accrual_redemption
WHERE ((txndate BETWEEN '2022-04-01' AND '2023-03-31') OR
(txndate BETWEEN '2023-04-01' AND '2024-03-31') OR
(txndate BETWEEN '2024-04-01' AND '2025-03-31') OR
(txndate BETWEEN '2025-04-01' AND '2026-03-31')) 
AND storecode NOT LIKE '%demo%' 
AND storecode NOT LIKE '%Ecom%'
GROUP BY 1,2;

############Storewise Redeemers#########

SELECT Periods,
COUNT(DISTINCT CASE WHEN Points_sum>0 THEN a.mobile END) AS Redeemers,
SUM(CASE WHEN Points_sum>0 THEN Sales END) AS Redeemers_Sales,
COUNT(DISTINCT CASE WHEN Category='Repeater' THEN a.mobile END) AS `Repeater`
FROM 
(SELECT a.mobile,CONCAT(LEFT(MONTHNAME(txndate),3), '-', RIGHT(YEAR(txndate),2)) AS Periods,
SUM(a.pointsspent)Points_sum,SUM(amount)Sales,
CASE WHEN (modifiedenrolledon = txndate AND TxnCount = 1) 
OR (txndate < modifiedenrolledon AND TxnCount = 1) 
OR (modifiedenrolledon IS NULL AND TxnCount = 1) 
THEN 'OneTimer'
ELSE 'Repeater'
END AS Category
FROM txn_report_accrual_redemption a
LEFT JOIN member_report b
ON a.mobile=b.mobile
WHERE storecode NOT LIKE '%demo%' 
AND storecode NOT LIKE '%Ecom%' 
AND txndate<='2025-07-31' 
GROUP BY 1,2)a
GROUP BY 1;


################Month,Region,Category#################

SELECT categoryname,SUM(itemnetamount) AS sales FROM sku_report_loyalty a
JOIN item_master b
ON a.uniqueitemcode=b.uniqueitemcode
WHERE modifiedtxndate BETWEEN '2022-04-01' AND '2025-07-31'
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedstorecode NOT LIKE '%ecom%'
GROUP BY 1
ORDER BY sales DESC;



SELECT categoryname,
CASE WHEN city IN ('Bangalore','Chennai','Pune') THEN city ELSE 'other city 'END city,
SUM(itemnetamount) AS Sales
FROM sku_report_loyalty a
JOIN item_master b
	ON a.uniqueitemcode=b.uniqueitemcode
JOIN store_master c
	ON a.modifiedstorecode=c.storecode
WHERE modifiedtxndate BETWEEN '2022-04-01' AND '2025-07-31'
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedstorecode NOT LIKE '%ecom%'
AND categoryname IN('Saree','Kurta','Salwar Suit','Unstitch','Kurta Set','Pant','Tunic')
-- and city in('Bangalore','Chennai','Pune')
GROUP BY 1,2;


SELECT Categoryname,Region,SUM(itemnetamount) AS Sales
FROM sku_report_loyalty a
JOIN item_master b
	ON a.uniqueitemcode=b.uniqueitemcode
JOIN store_master c
	ON a.modifiedstorecode=c.storecode
WHERE modifiedtxndate BETWEEN '2022-04-01' AND '2025-07-31'
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedstorecode NOT LIKE '%ecom%'
AND region IS NOT NULL
AND categoryname IN('Saree','Kurta','Salwar Suit','Unstitch','Kurta Set','Pant','Tunic')
GROUP BY 1,2;

SELECT Categoryname,
MONTHNAME(modifiedtxndate)AS PERIOD,
SUM(itemnetamount) AS sales
FROM sku_report_loyalty a
JOIN item_master b
ON a.uniqueitemcode=b.uniqueitemcode
WHERE modifiedtxndate BETWEEN '2022-04-01' AND '2025-07-31'
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedstorecode NOT LIKE '%ecom%'
AND categoryname IN('Saree','Kurta','Salwar Suit','Unstitch','Kurta Set','Pant','Tunic')
GROUP BY 1,2;


