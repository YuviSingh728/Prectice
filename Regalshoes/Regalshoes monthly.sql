
###########Brand Snapshot

SELECT 
-- case 
-- when txndate>='2024-09-01' and '2024-09-01' then 'Sep-24'
-- when txndate BETWEEN '2025-09-01' AND '2025-09-01' THEN 'Sep-25'
-- end as `Period`, 
COUNT(DISTINCT storecode) Store_Count,
COUNT(DISTINCT mobile)Customer,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN mobile END) AS Repeaters,
COUNT(DISTINCT uniquebillno) AS Bills,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END) AS Repeaters_Bills, 
SUM(amount) AS Sales,
SUM(CASE WHEN frequencycount>1 THEN amount END) AS Repeaters_Sales,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END) Redeemed,
SUM(amount)/COUNT(DISTINCT mobile) AS AMV,
SUM(CASE WHEN frequencycount>1 THEN amount END)/COUNT(DISTINCT CASE WHEN frequencycount>1 THEN mobile END) AS Repeater_AMV,
SUM(amount)/COUNT(DISTINCT uniquebillno) AS ATV,
SUM(CASE WHEN frequencycount>1 THEN amount END)/COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END) AS Repeaters_Bills
FROM txn_report_accrual_redemption
WHERE txndate>='2024-09-01' AND txndate<='2024-09-30'
-- ((txndate between '2024-09-01' and '2024-09-30')or
-- (txndate between '2025-09-01' and '2025-09-30'))
AND storecode NOT LIKE '%demo%';



SELECT 
-- case 
-- when txndate>='2024-09-01' and '2024-09-01' then 'Sep-24'
-- when txndate BETWEEN '2025-09-01' AND '2025-09-01' THEN 'Sep-25'
-- end as `Period`, 
COUNT(DISTINCT storecode) Store_Count,
COUNT(DISTINCT mobile)Customer,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN mobile END) AS Repeaters,
COUNT(DISTINCT uniquebillno) AS Bills,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END) AS Repeaters_Bills, 
SUM(amount) AS Sales,
SUM(CASE WHEN frequencycount>1 THEN amount END) AS Repeaters_Sales,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END) Redeemed,
SUM(amount)/COUNT(DISTINCT mobile) AS AMV,
SUM(CASE WHEN frequencycount>1 THEN amount END)/COUNT(DISTINCT CASE WHEN frequencycount>1 THEN mobile END) AS Repeater_AMV,
SUM(amount)/COUNT(DISTINCT uniquebillno) AS ATV,
SUM(CASE WHEN frequencycount>1 THEN amount END)/COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END) AS Repeaters_Bills
FROM txn_report_accrual_redemption
WHERE txndate>='2025-09-01' AND txndate<='2025-09-30'
-- ((txndate between '2024-09-01' and '2024-09-30')or
-- (txndate between '2025-09-01' and '2025-09-30'))
AND storecode NOT LIKE '%demo%';


SELECT COUNT(DISTINCT mobile) enroll FROM member_report
WHERE modifiedenrolledon>='2024-07-01' 
AND modifiedenrolledon<='2024-07-31'
AND enrolledstore NOT LIKE '%demo%';


SELECT COUNT(DISTINCT mobile) enroll FROM member_report
WHERE modifiedenrolledon>='2025-09-01' 
AND modifiedenrolledon<='2025-09-30'
AND enrolledstore NOT LIKE '%demo%';



##############KPIs Overview

############Customer
SELECT CONCAT(LEFT(MONTHNAME(txndate),3),'-',RIGHT(YEAR(txndate),2)) AS Months,
COUNT(DISTINCT mobile) AS Customer,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN mobile END)AS Repeaters,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END)AS Redeemers,
COUNT(DISTINCT mobile,txndate) AS Visits
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-10-01' AND '2025-09-30'
AND storecode NOT LIKE '%demo%'
GROUP BY 1
ORDER BY txndate;


############Points Data
SELECT CONCAT(LEFT(MONTHNAME(txndate),3),"-",RIGHT(YEAR(txndate),2)) AS Months,
SUM(pointscollected)AS Point_Accrued,
SUM(pointsspent)AS Point_Redeemed,
SUM(pointscollected)/SUM(pointsspent) AS Earn_Burn
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-10-01' AND '2025-09-30'
AND storecode NOT LIKE '%demo%'
GROUP BY 1
ORDER BY txndate;


############Lotalty And Nonloyalty Sales
SELECT CONCAT(LEFT(MONTHNAME(txndate),3),'-',RIGHT(YEAR(txndate),2)) AS Months, 
SUM(amount) Sales,SUM(CASE WHEN frequencycount>1 THEN amount END)AS Repeater_Sales,
SUM(CASE WHEN frequencycount>1 THEN amount END)/SUM(amount)'repeater_%'
 FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-10-01' AND '2025-09-30'
AND storecode NOT LIKE '%demo%'
GROUP BY 1
ORDER BY txndate;

SELECT CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),'-',RIGHT(YEAR(modifiedtxndate),2)) AS Months, 
SUM(itemnetamount) Sales
 FROM sku_report_nonloyalty
WHERE modifiedtxndate BETWEEN '2024-10-01' AND '2025-09-30'
AND modifiedstorecode NOT LIKE '%demo%'
GROUP BY 1
ORDER BY modifiedtxndate;

#############Loyalty And Nonloyalty Bills
SELECT CONCAT(LEFT(MONTHNAME(txndate),3),'-',RIGHT(YEAR(txndate),2)) Months, 
COUNT(DISTINCT uniquebillno) Bills,COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END) AS Repeater_Bills,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END)/COUNT(DISTINCT uniquebillno)AS '%_Repeater'
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-10-01' AND '2025-09-30'
AND storecode NOT LIKE '%demo%'
GROUP BY 1
ORDER BY txndate;


SELECT CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),'-',RIGHT(YEAR(modifiedtxndate),2)) AS Months, 
COUNT(DISTINCT uniquebillno) NonLoyalty_Bills
FROM sku_report_nonloyalty
WHERE modifiedtxndate BETWEEN '2024-10-01' AND '2025-09-30'
AND modifiedstorecode NOT LIKE '%demo%'
GROUP BY 1
ORDER BY modifiedtxndate;


###############Customer ABV

WITH Loyalty AS(
SELECT CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),'-',RIGHT(YEAR(modifiedtxndate),2)) Months,
SUM(itemnetamount)/COUNT(DISTINCT uniquebillno) AS ABV,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END)/COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END) AS Repeater_ABV,
SUM(itemqty)/COUNT(DISTINCT uniquebillno) AS ABS,
SUM(CASE WHEN frequencycount>1 THEN itemqty END)/COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END) AS Repeater_ABS,
SUM(itemnetamount)/SUM(itemqty) AS APP,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END)/SUM(CASE WHEN frequencycount>1 THEN itemqty END) AS Repeater_APP
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-10-01' AND '2025-09-30'
AND modifiedstorecode NOT LIKE '%demo%'
GROUP BY 1
ORDER BY modifiedtxndate),

Nonloyalty AS(
SELECT CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),'-',RIGHT(YEAR(modifiedtxndate),2)) Months,
SUM(itemnetamount)/COUNT(DISTINCT uniquebillno) AS Nonloyalty_ABV,
SUM(itemqty)/COUNT(DISTINCT uniquebillno) AS Nonloyalty_ABS,
SUM(itemnetamount)/SUM(itemqty) AS Nonloyalty_APP
FROM sku_report_nonloyalty
WHERE modifiedtxndate BETWEEN '2024-10-01' AND '2025-09-30'
AND modifiedstorecode NOT LIKE '%demo%'
GROUP BY 1
ORDER BY modifiedtxndate)

SELECT a.Months,
ABV,Repeater_ABV,Nonloyalty_ABV,ABS,Repeater_ABS,Nonloyalty_ABS,APP,Repeater_APP,Nonloyalty_APP
FROM loyalty a
JOIN nonloyalty b
USING(months);


##############Latency Bucket

WITH Lat AS(
SELECT txnmappedmobile,DATEDIFF(MAX(modifiedtxndate),MIN(modifiedtxndate))/
NULLIF((COUNT(DISTINCT modifiedtxndate)-1),0) AS Latency,
COUNT(DISTINCT uniquebillno) AS Repeat_Bills
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2023-08-01' AND '2025-07-31'
AND modifiedstorecode NOT LIKE '%demo%'
GROUP BY 1)

SELECT 
CASE 
WHEN Latency>=0 AND Latency<=10 THEN '0-10'
WHEN Latency>10 AND Latency<=20 THEN '10-20'
WHEN Latency>20 AND Latency<=30 THEN '20-30'
WHEN Latency>30 AND Latency<=40 THEN '30-40'
WHEN Latency>40 AND Latency<=50 THEN '40-50'
WHEN Latency>50 AND Latency<=60 THEN '50-60'
WHEN Latency>60 AND Latency<=70 THEN '60-70'
WHEN Latency>70 AND Latency<=80 THEN '70-80'
WHEN Latency>80 AND Latency<=90 THEN '80-90'
WHEN Latency>90 AND Latency<=100 THEN '90-100'
WHEN Latency>100 AND Latency<=110 THEN '100-110'
WHEN Latency>110 AND latency<=120 THEN '110-120'
WHEN latency>120 THEN '120+'
END AS `Latency Bucket`,SUM(Repeat_Bills) AS Bills
FROM lat
GROUP BY 1
ORDER BY Latency;


SELECT 
CASE 
WHEN Latency>=0 AND Latency<=10 THEN '0-10'
WHEN Latency>10 AND Latency<=20 THEN '10-20'
WHEN Latency>20 AND Latency<=30 THEN '20-30'
WHEN Latency>30 AND Latency<=40 THEN '30-40'
WHEN Latency>40 AND Latency<=50 THEN '40-50'
WHEN Latency>50 AND Latency<=60 THEN '50-60'
WHEN Latency>60 AND Latency<=70 THEN '60-70'
WHEN Latency>70 AND Latency<=80 THEN '70-80'
WHEN Latency>80 AND Latency<=90 THEN '80-90'
WHEN Latency>90 AND Latency<=100 THEN '90-100'
WHEN Latency>100 AND Latency<=110 THEN '100-110'
WHEN Latency>110 AND latency<=120 THEN '110-120'
WHEN latency>120 THEN '120+'
END AS `Latency Bucket`,COUNT(DISTINCT uniquebillno)bills FROM (
SELECT DISTINCT dayssincelastvisit latency,uniquebillno  
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2023-07-01' AND '2025-06-30'
AND modifiedstorecode NOT LIKE '%demo%' AND frequencycount>1)a GROUP BY 1
ORDER BY latency



SELECT DISTINCT CATEGORYNAME,SUBCATEGORYNAME,BRANDNAME FROM ITEM_MASTER
