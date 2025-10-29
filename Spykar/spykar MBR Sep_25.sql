

#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
#|||||||||||||||||||||||||||||||||||||||||||   Spykar Monthly Report Sep 2025 - EBO    ||||||||||||||||||||||||||||||||||||||||||||||||||||
#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

# Overall( 3 years )
CALL dummy.`P1_P2_automation_CustomerDemographics_spykar`('2022-10-01','2025-09-30','','365',10,70,10,'dummy');


#////////////////////////////////////////////// Brand snapshot ////////////////////////////////////////////////////
CALL dummy.`Brand_snapshot_spykarV2`('2025-09-01','2025-09-30','2024-09-01','2024-09-30','2025-08-01','2025-08-31','EBO','dummy');

#////////////////////////////////////////////// ////////////////////////////////////////////////////
-- 1Year
CALL dummy.`KPI_overview_spykar`('2024-10-01','2025-09-30','EBO','dummy');#
#////////////////////////////////////////////// ////////////////////////////////////////////////////
-- 3Year
CALL dummy.`Lapsation__spykar`('2022-10-01','2025-09-30','EBO','','','dummy',60,720,60);#
#////////////////////////////////////////////// ////////////////////////////////////////////////////
-- 3Year
CALL dummy.`DropRateAndVisitMigration_spykar`('2022-10-01','2025-09-30','','','EBO',10,'dummy');#
#////////////////////////////////////////////// ////////////////////////////////////////////////////
CALL dummy.`Customer_overview_spykar`('2022-10-01','2025-09-30','EBO','365','dummy');#
#////////////////////////////////////////////// ////////////////////////////////////////////////////
CALL dummy.Bill_Banding_spykar ('2025-09-01','2025-09-30','EBO','','365',2500,12500,2500,'dummy');
#////////////////////////////////////////////// ////////////////////////////////////////////////////
-- 1Year
CALL dummy.`ATV_movement_spykar`('2024-10-01','2025-09-30',2500,12500,2500,'EBO','dummy');
#////////////////////////////////////////////// ////////////////////////////////////////////////////
CALL dummy.`Redemption_snapshot_spykar`('2025-01-01','2025-09-30','2024-10-01','2025-09-30','2025-01-01','2025-09-30','2024-01-01','2024-12-31','1','1','EBO','spykarrewards');

#////////////////////////////////////////////// ////////////////////////////////////////////////////
CALL dummy.`Repeat_cohort_Spykar`('2024-10-01','2025-09-30','EBO','dummy');
CALL dummy.`Repeat_cohort_Spykar_2`('2019-01-01','2025-09-30','EBO','dummy');


#////////////////////////////////////////////// ////////////////////////////////////////////////////

-- Store Performance :
-- •	Top 10 store basis - Transacting base / Basis Sales / Basis Repeater / Basis Redemption 
-- •	Bottom 10 store basis - Transacting base / Basis Sales / Basis Repeater / Basis Redemption

-- Top 10
-- `Transacting Base`

SELECT a.Storecode,b.Lpaasstore AS `Store Name`,
COUNT(DISTINCT Mobile)`Transacting Base`
FROM dummy.spykar_temp_txn a
LEFT JOIN spykarrewards.store_master b
ON a.storecode COLLATE utf8mb4_unicode_ci=b.storecode
WHERE txndate>='2025-09-01' AND txndate<='2025-09-30'
AND tag_='L' AND store_type='EBO'
GROUP BY 1
ORDER BY 3 DESC
LIMIT 10;

SELECT*FROM dummy.spykar_temp_txn;

-- ``Total Sales``

SELECT a.Storecode,b.Lpaasstore AS `Store Name`,
SUM(amount)`Total Sales`,SUM(CASE WHEN tag_='L' THEN amount END) Loyalty_Sales
FROM dummy.spykar_temp_txn a
LEFT JOIN spykarrewards.store_master b
ON a.storecode COLLATE utf8mb4_unicode_ci=b.storecode
WHERE  txndate>='2025-09-01' AND txndate<='2025-09-30' AND store_type='EBO'
GROUP BY 1
ORDER BY 3 DESC
LIMIT 10;

-- `Repeaters`

SELECT a.Storecode,b.Lpaasstore AS `Store Name`,
COUNT(DISTINCT (CASE WHEN frequencycount>1 THEN mobile  END)) AS Repeaters
FROM dummy.spykar_temp_txn a
LEFT JOIN spykarrewards.store_master b
ON a.storecode COLLATE utf8mb4_unicode_ci=b.storecode
WHERE txndate>='2025-09-01' AND txndate<='2025-09-30' AND tag_='L' AND store_type='EBO'
GROUP BY 1
ORDER BY 3 DESC
LIMIT 10;

-- `Points redeemed`

SELECT a.Storecode,b.Lpaasstore AS `Store Name`,
SUM(Pointsspent)`Points Redeemed`
FROM dummy.spykar_temp_txn a
LEFT JOIN spykarrewards.store_master b
ON a.storecode COLLATE utf8mb4_unicode_ci=b.storecode
WHERE txndate>='2025-09-01' AND txndate<='2025-09-30' AND tag_='L' AND store_type='EBO'
GROUP BY 1
ORDER BY 3 DESC
LIMIT 10;

-- Bottom ----------------------------------
-- `Transacting Base`

SELECT a.Storecode,b.Lpaasstore AS `Store Name`,
COUNT(DISTINCT Mobile)`Transacting Base`
FROM dummy.spykar_temp_txn a
LEFT JOIN spykarrewards.store_master b
ON a.storecode COLLATE utf8mb4_unicode_ci=b.storecode
WHERE txndate>='2025-09-01' AND txndate<='2025-09-30' AND tag_='L' AND store_type='EBO'
AND tag_='L'
GROUP BY 1
ORDER BY 3 ASC
LIMIT 10;


-- ``Total Sales``

SELECT a.Storecode,b.Lpaasstore AS `Store Name`,
SUM(amount)`Total Sales` ,SUM(CASE WHEN tag_='L' THEN amount END) Loyalty_Sales
FROM dummy.spykar_temp_txn a
LEFT JOIN spykarrewards.store_master b
ON a.storecode COLLATE utf8mb4_unicode_ci=b.storecode
WHERE txndate>='2025-09-01' AND txndate<='2025-09-30' AND store_type='EBO'
GROUP BY 1
HAVING `Total Sales` >1
ORDER BY 3 ASC
LIMIT 10;#12;

-- `Repeaters`
SELECT a.Storecode,b.Lpaasstore AS `Store Name`,
COUNT(DISTINCT (CASE WHEN frequencycount>1 THEN mobile  END)) AS Repeaters
FROM dummy.spykar_temp_txn a
LEFT JOIN spykarrewards.store_master b
ON a.storecode COLLATE utf8mb4_unicode_ci=b.storecode
WHERE txndate>='2025-09-01' AND txndate<='2025-09-30'  AND tag_='L' AND store_type='EBO'
GROUP BY 1
ORDER BY 3 ASC
LIMIT 10;

-- `Points redeemed`

SELECT a.Storecode,b.Lpaasstore AS `Store Name`,
SUM(Pointsspent)`Points Redeemed`
FROM dummy.spykar_temp_txn a
LEFT JOIN spykarrewards.store_master b
ON a.storecode COLLATE utf8mb4_unicode_ci=b.storecode
WHERE  txndate>='2025-09-01' AND txndate<='2025-09-30' AND tag_='L' AND store_type='EBO'
GROUP BY 1
ORDER BY 3 ASC
LIMIT 11;



-- Customer KPI : Top 20 customer basis sales in the reporting month.


SELECT a.Mobile,SUM(amount)`Sep_25 Sales`
FROM dummy.spykar_temp_txn a
LEFT JOIN dummy.spykar_temp_member b
ON a.Mobile COLLATE utf8mb4_unicode_ci=b.Mobile
WHERE txndate>='2025-09-01' AND txndate<='2025-09-30'
AND a.tag_='L' AND a.store_type='EBO' 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 50;



#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
#|||||||||||||||||||||||||||||||||||||||||||  Additional KPI data -  EBO Store   ||||||||||||||||||||||||||||||||||||||||||||||||||||
#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||



-- daily sales & bills
SELECT txndate DATE,SUM(amount)`Total Sales`,
COUNT(DISTINCT uniquebillno )`Total Bills`
FROM dummy.spykar_temp_txn 
WHERE txndate>='2025-09-01' AND txndate<='2025-09-30' AND store_type='EBO'
GROUP BY 1;

-- daily enrolments
SELECT modifiedenrolledon AS Enrolledon,
COUNT(DISTINCT Mobile)Enrolments
 FROM dummy.spykar_temp_member 
WHERE modifiedenrolledon>='2025-09-01' AND modifiedenrolledon<='2025-09-30'
AND store_type='EBO'  
GROUP BY 1
;
SELECT * FROM dummy.spykar_temp_txn;

-- daywise storewise sales & txn
SELECT txndate DATE,a.Storecode,b.lpaasstore AS Storename,SUM(amount)`Total Sales`,
COUNT(DISTINCT uniquebillno )`Total Bills`
FROM dummy.spykar_temp_txn a
LEFT JOIN spykarrewards.store_master b
ON a.storecode=b.storecode
WHERE txndate>='2025-09-01' AND txndate<='2025-09-30' AND store_type='EBO'
GROUP BY 1,2
;

-- Storewise Enrolments
SELECT 
enrolledstorecode AS `Enrolled StoreCode`,b.lpaasstore AS Storename,
COUNT(DISTINCT Mobile)Enrolments
 FROM dummy.spykar_temp_member  a
LEFT JOIN spykarrewards.store_master b
ON a.enrolledstorecode=b.storecode
WHERE modifiedenrolledon>='2025-09-01' AND modifiedenrolledon<='2025-09-30'
AND store_type='EBO'  
GROUP BY 1
;

-- MOM enrolments 12M
SELECT CONCAT(LEFT(MONTHNAME(modifiedenrolledon),3),"-",YEAR(modifiedenrolledon))Months,
COUNT(DISTINCT Mobile)Enrolments
 FROM dummy.spykar_temp_member 
WHERE modifiedenrolledon>='2024-10-01' AND modifiedenrolledon<='2025-09-30'
AND store_type='EBO'  
GROUP BY 1
ORDER BY modifiedenrolledon
;

-- MOM storewiswe sales & txn -12M

SELECT CONCAT(LEFT(MONTHNAME(txndate),3),"-",YEAR(txndate))Months,a.Storecode,b.lpaasstore AS Storename,SUM(amount)`Total Sales`,
COUNT(DISTINCT uniquebillno )`Total Bills`
FROM dummy.spykar_temp_txn a
LEFT JOIN spykarrewards.store_master b
ON a.storecode=b.storecode
WHERE txndate>='2024-10-01'  AND txndate<='2025-09-30' AND store_type='EBO'
GROUP BY 1,2
ORDER BY txndate
;
-- MOM storewise enrolments 12M
SELECT CONCAT(LEFT(MONTHNAME(modifiedenrolledon),3),"-",YEAR(modifiedenrolledon))Months,
enrolledstorecode AS `Enrolled StoreCode`,b.lpaasstore AS Storename,
COUNT(DISTINCT Mobile)Enrolments
 FROM dummy.spykar_temp_member  a
LEFT JOIN spykarrewards.store_master b
ON a.enrolledstorecode=b.storecode
WHERE modifiedenrolledon>='2024-10-01' AND modifiedenrolledon<='2025-09-30'
AND store_type='EBO'  
GROUP BY 1,2
ORDER BY modifiedenrolledon
;


--  Active & dormant & Lapsed


 -- Sep 25
SELECT 'Sep-25' AS MONTH,CASE WHEN recency<=545 THEN 'Active' WHEN recency BETWEEN 546 AND 1096 THEN 'Dormant' ELSE 'Lapsed' END AS tag,
COUNT(DISTINCT mobile)ct
FROM(
SELECT Mobile,DATEDIFF('2025-09-30', MAX(txndate)) AS 'recency'
 FROM dummy.spykar_temp_txn
 WHERE txndate<='2025-09-30' AND tag_='L' AND store_type='EBO'
 GROUP BY 1
 )b
GROUP BY 2;

 -- Aug 25
SELECT 'Aug-25' AS MONTH,CASE WHEN recency<=545 THEN 'Active' WHEN recency BETWEEN 546 AND 1096 THEN 'Dormant' ELSE 'Lapsed' END AS tag,
COUNT(DISTINCT mobile)ct
FROM(
SELECT Mobile,DATEDIFF('2025-08-31', MAX(txndate)) AS 'recency'
 FROM dummy.spykar_temp_txn
 WHERE txndate<='2025-08-31' AND tag_='L' AND store_type='EBO'
 GROUP BY 1
 )b
GROUP BY 2;

 -- July 25
SELECT 'July-25' AS MONTH,CASE WHEN recency<=545 THEN 'Active' WHEN recency BETWEEN 546 AND 1096 THEN 'Dormant' ELSE 'Lapsed' END AS tag,COUNT(DISTINCT mobile)ct
FROM(
SELECT Mobile,DATEDIFF('2025-07-31', MAX(txndate)) AS 'recency'
 FROM dummy.spykar_temp_txn
 WHERE txndate<='2025-07-31' AND tag_='L' AND store_type='EBO'
 GROUP BY 1
 )b
GROUP BY 2;

 -- June 25
SELECT 'June-25' AS MONTH,CASE WHEN recency<=545 THEN 'Active' WHEN recency BETWEEN 546 AND 1096 THEN 'Dormant' ELSE 'Lapsed' END AS tag,COUNT(DISTINCT mobile)ct
FROM(
SELECT Mobile,DATEDIFF('2025-06-30', MAX(txndate)) AS 'recency'
 FROM dummy.spykar_temp_txn
 WHERE txndate<='2025-06-30' AND tag_='L' AND store_type='EBO'
 GROUP BY 1
 )b
GROUP BY 2;

 -- May 25
SELECT 'May-25' AS MONTH,CASE WHEN recency<=545 THEN 'Active' WHEN recency BETWEEN 546 AND 1096 THEN 'Dormant' ELSE 'Lapsed' END AS tag,COUNT(DISTINCT mobile)ct
FROM(
SELECT Mobile,DATEDIFF('2025-05-31', MAX(txndate)) AS 'recency'
 FROM dummy.spykar_temp_txn
 WHERE txndate<='2025-05-31' AND tag_='L' AND store_type='EBO'
 GROUP BY 1
 )b
GROUP BY 2;
  
  -- April 25
SELECT 'April-25' AS MONTH,CASE WHEN recency<=545 THEN 'Active' WHEN recency BETWEEN 546 AND 1096 THEN 'Dormant' ELSE 'Lapsed' END AS tag,COUNT(DISTINCT mobile)ct
FROM(
SELECT Mobile,DATEDIFF('2025-04-30', MAX(txndate)) AS 'recency'
 FROM dummy.spykar_temp_txn	
 WHERE txndate<='2025-04-30' AND tag_='L' AND store_type='EBO'
 GROUP BY 1
 )b
GROUP BY 2;

  -- Mar 25
SELECT 'Mar-25' AS MONTH,CASE WHEN recency<=545 THEN 'Active' WHEN recency BETWEEN 546 AND 1096 THEN 'Dormant' ELSE 'Lapsed' END AS tag,COUNT(DISTINCT mobile)ct
FROM(
SELECT Mobile,DATEDIFF('2025-03-31', MAX(txndate)) AS 'recency'
 FROM dummy.spykar_temp_txn
 WHERE txndate<='2025-03-31' AND tag_='L' AND store_type='EBO'
 GROUP BY 1
 )b
GROUP BY 2;

  -- Feb 25
SELECT 'Feb-25' AS MONTH,CASE WHEN recency<=545 THEN 'Active' WHEN recency BETWEEN 546 AND 1096 THEN 'Dormant' ELSE 'Lapsed' END AS tag,COUNT(DISTINCT mobile)ct
FROM(
SELECT Mobile,DATEDIFF('2025-02-28', MAX(txndate)) AS 'recency'
 FROM dummy.spykar_temp_txn
 WHERE txndate<='2025-02-28' AND tag_='L' AND store_type='EBO'
 GROUP BY 1
 )b
GROUP BY 2;


 -- jan 25
SELECT 'Jan-25' AS MONTH,CASE WHEN recency<=545 THEN 'Active' WHEN recency BETWEEN 546 AND 1096 THEN 'Dormant' ELSE 'Lapsed' END AS tag,COUNT(DISTINCT mobile)ct
FROM(
SELECT Mobile,DATEDIFF('2025-01-31', MAX(txndate)) AS 'recency'
 FROM dummy.spykar_temp_txn
 WHERE txndate<='2025-01-31' AND tag_='L' AND store_type='EBO'
 GROUP BY 1
 )b
GROUP BY 2;

 -- Dec 24
SELECT 'Dec-24' AS MONTH,CASE WHEN recency<=545 THEN 'Active' WHEN recency BETWEEN 546 AND 1096 THEN 'Dormant' ELSE 'Lapsed' END AS tag,COUNT(DISTINCT mobile)ct
FROM(
SELECT Mobile,DATEDIFF('2024-12-31', MAX(txndate)) AS 'recency'
 FROM dummy.spykar_temp_txn
 WHERE txndate<='2024-12-31' AND tag_='L' AND store_type='EBO'
 GROUP BY 1
 )b
GROUP BY 2;

-- Nov 24
SELECT 'Nov-24' AS MONTH,CASE WHEN recency<=545 THEN 'Active' WHEN recency BETWEEN 546 AND 1096 THEN 'Dormant' ELSE 'Lapsed' END AS tag,COUNT(DISTINCT mobile)ct
FROM(
SELECT Mobile,DATEDIFF('2024-11-30', MAX(txndate)) AS 'recency'
 FROM dummy.spykar_temp_txn
 WHERE txndate<='2024-11-30' AND tag_='L' AND store_type='EBO'
 GROUP BY 1
 )b
GROUP BY 2;


-- Oct 24
SELECT 'Oct-24' AS MONTH,CASE WHEN recency<=545 THEN 'Active' WHEN recency BETWEEN 546 AND 1096 THEN 'Dormant' ELSE 'Lapsed' END AS tag,COUNT(DISTINCT mobile)ct
FROM(
SELECT Mobile,DATEDIFF('2024-10-31', MAX(txndate)) AS 'recency'
 FROM dummy.spykar_temp_txn
 WHERE txndate<='2024-10-31' AND tag_='L' AND store_type='EBO'
 GROUP BY 1
 )b
GROUP BY 2;


-- Sept 24
SELECT 'Sept-24' AS MONTH,CASE WHEN recency<=545 THEN 'Active' WHEN recency BETWEEN 546 AND 1096 THEN 'Dormant' ELSE 'Lapsed' END AS tag,COUNT(DISTINCT mobile)ct
FROM(
SELECT Mobile,DATEDIFF('2024-09-30', MAX(txndate)) AS 'recency'
 FROM dummy.spykar_temp_txn
 WHERE txndate<='2024-09-30' AND tag_='L' AND store_type='EBO'
 GROUP BY 1
 )b
GROUP BY 2;
 

#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
#||||||||||||||||||||||||||||||  Spykar Monthly Report Aug 2025 - Yellow Ticket(YT)   ||||||||||||||||||||||||||||||||||||||||||||||||
#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


#////////////////////////////////////////////// Brand snapshot ////////////////////////////////////////////////////
CALL `Brand_snapshot_spykarV2`('2025-09-01','2025-09-30','2024-09-01','2024-09-30','2025-08-01','2025-08-31','YT','dummy');

#////////////////////////////////////////////// ////////////////////////////////////////////////////
-- 1Year
CALL `KPI_overview_spykar`('2024-10-01','2025-09-30','YT','dummy');#
#////////////////////////////////////////////// ////////////////////////////////////////////////////
-- 3Year
CALL `Lapsation__spykar`('2022-10-01','2025-09-30','YT','','','dummy',60,720,60);#
#////////////////////////////////////////////// ////////////////////////////////////////////////////
-- 3Year
CALL `DropRateAndVisitMigration_spykar`('2022-10-01','2025-09-30','','','YT',10,'dummy');#
#////////////////////////////////////////////// ////////////////////////////////////////////////////
CALL `Customer_overview_spykar`('2022-10-01','2025-09-30','YT','365','dummy');#
#////////////////////////////////////////////// ////////////////////////////////////////////////////
CALL Bill_Banding_spykar ('2025-09-01','2025-09-30','YT','','365',2500,12500,2500,'dummy');
#////////////////////////////////////////////// ////////////////////////////////////////////////////
-- 1Year
CALL `ATV_movement_spykar`('2024-10-01','2025-09-30',2500,12500,2500,'YT','dummy');
#////////////////////////////////////////////// ////////////////////////////////////////////////////
CALL `Redemption_snapshot_spykar`('2025-01-01','2025-09-30','2024-10-01','2025-09-30','2025-01-01','2025-09-30','2024-01-01','2024-12-31','1','1','YT','spykarrewards');

#////////////////////////////////////////////// ////////////////////////////////////////////////////
CALL `Repeat_cohort_Spykar`('2024-10-01','2025-09-30','YT','dummy');
CALL `Repeat_cohort_Spykar_2`('2019-01-01','2025-09-30','YT','dummy');


#////////////////////////////////////////////// ////////////////////////////////////////////////////

-- Store Performance :
-- •	Top 10 store basis - Transacting base / Basis Sales / Basis Repeater / Basis Redemption 
-- •	Bottom 10 store basis - Transacting base / Basis Sales / Basis Repeater / Basis Redemption

-- Top 10
-- `Transacting Base`

SELECT a.Storecode,b.Lpaasstore AS `Store Name`,
COUNT(DISTINCT Mobile)`Transacting Base`
FROM dummy.spykar_temp_txn a
LEFT JOIN spykarrewards.store_master b
ON a.storecode COLLATE utf8mb4_unicode_ci=b.storecode
WHERE txndate>='2025-09-01' AND txndate<='2025-09-30'
AND tag_='L' AND store_type='YT'
GROUP BY 1
ORDER BY 3 DESC
LIMIT 10;


-- ``Total Sales``

SELECT a.Storecode,b.Lpaasstore AS `Store Name`,
SUM(amount)`Total Sales`,SUM(CASE WHEN tag_='L' THEN amount END) Loyalty_Sales
FROM dummy.spykar_temp_txn a
LEFT JOIN spykarrewards.store_master b
ON a.storecode COLLATE utf8mb4_unicode_ci=b.storecode
WHERE  txndate>='2025-09-01' AND txndate<='2025-09-30' AND store_type='YT'
GROUP BY 1
ORDER BY 3 DESC
LIMIT 10;

-- `Repeaters`

SELECT a.Storecode,b.Lpaasstore AS `Store Name`,
COUNT(DISTINCT (CASE WHEN frequencycount>1 THEN mobile  END)) AS Repeaters
FROM dummy.spykar_temp_txn a
LEFT JOIN spykarrewards.store_master b
ON a.storecode COLLATE utf8mb4_unicode_ci=b.storecode
WHERE txndate>='2025-09-01' AND txndate<='2025-09-30' AND tag_='L' AND store_type='YT'
GROUP BY 1
ORDER BY 3 DESC
LIMIT 10;

-- `Points redeemed`

SELECT a.Storecode,b.Lpaasstore AS `Store Name`,
SUM(Pointsspent)`Points Redeemed`
FROM dummy.spykar_temp_txn a
LEFT JOIN spykarrewards.store_master b
ON a.storecode COLLATE utf8mb4_unicode_ci=b.storecode
WHERE txndate>='2025-09-01' AND txndate<='2025-09-30' AND tag_='L' AND store_type='YT'
GROUP BY 1
ORDER BY 3 DESC
LIMIT 10;

-- Bottom ----------------------------------
-- `Transacting Base`

SELECT a.Storecode,b.Lpaasstore AS `Store Name`,
COUNT(DISTINCT Mobile)`Transacting Base`
FROM dummy.spykar_temp_txn a
LEFT JOIN spykarrewards.store_master b
ON a.storecode COLLATE utf8mb4_unicode_ci=b.storecode
WHERE txndate>='2025-09-01' AND txndate<='2025-09-30' AND tag_='L' AND store_type='YT'
AND tag_='L'
GROUP BY 1
ORDER BY 3 ASC
LIMIT 10;


-- ``Total Sales``

SELECT a.Storecode,b.Lpaasstore AS `Store Name`,
SUM(amount)`Total Sales` ,SUM(CASE WHEN tag_='L' THEN amount END) Loyalty_Sales
FROM dummy.spykar_temp_txn a
LEFT JOIN spykarrewards.store_master b
ON a.storecode COLLATE utf8mb4_unicode_ci=b.storecode
WHERE txndate>='2025-09-01' AND txndate<='2025-09-30' AND store_type='YT'
GROUP BY 1
HAVING `Total Sales` >1
ORDER BY 3 ASC
LIMIT 10#12;

-- `Repeaters`
SELECT a.Storecode,b.Lpaasstore AS `Store Name`,
COUNT(DISTINCT (CASE WHEN frequencycount>1 THEN mobile  END)) AS Repeaters
FROM dummy.spykar_temp_txn a
LEFT JOIN spykarrewards.store_master b
ON a.storecode COLLATE utf8mb4_unicode_ci=b.storecode
WHERE txndate>='2025-09-01' AND txndate<='2025-09-30'  AND tag_='L' AND store_type='YT'
GROUP BY 1
ORDER BY 3 ASC
LIMIT 10;

-- `Points redeemed`

SELECT a.Storecode,b.Lpaasstore AS `Store Name`,
SUM(Pointsspent)`Points Redeemed`
FROM dummy.spykar_temp_txn a
LEFT JOIN spykarrewards.store_master b
ON a.storecode COLLATE utf8mb4_unicode_ci=b.storecode
WHERE  txndate>='2025-09-01' AND txndate<='2025-09-30' AND tag_='L' AND store_type='YT'
GROUP BY 1
ORDER BY 3 ASC
LIMIT 11;



-- Customer KPI : Top 20 customer basis sales in the reporting month.


SELECT a.Mobile,SUM(amount)`Aug25 Sales`
FROM dummy.spykar_temp_txn a
LEFT JOIN dummy.spykar_temp_member b
ON a.Mobile COLLATE utf8mb4_unicode_ci=b.Mobile
WHERE txndate>='2025-09-01' AND txndate<='2025-09-30'
AND a.tag_='L' AND a.store_type='YT' 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 50;


#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
#|||||||||||||||||||||||||||||||||||||||||||  Additional KPI data -  YT Store   ||||||||||||||||||||||||||||||||||||||||||||||||||||
#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


-- daily sales & bills
SELECT txndate DATE,SUM(amount)`Total Sales`,
COUNT(DISTINCT uniquebillno )`Total Bills`
FROM dummy.spykar_temp_txn 
WHERE txndate>='2025-09-01' AND txndate<='2025-09-30' AND store_type='YT'
GROUP BY 1;

-- daily enrolments
SELECT modifiedenrolledon AS Enrolledon,
COUNT(DISTINCT Mobile)Enrolments
 FROM dummy.spykar_temp_member 
WHERE modifiedenrolledon>='2025-09-01' AND modifiedenrolledon<='2025-09-30'
AND store_type='YT'  
GROUP BY 1
;
SELECT * FROM dummy.spykar_temp_txn;

-- daywise storewise sales & txn
SELECT txndate DATE,a.Storecode,b.lpaasstore AS Storename,SUM(amount)`Total Sales`,
COUNT(DISTINCT uniquebillno )`Total Bills`
FROM dummy.spykar_temp_txn a
LEFT JOIN spykarrewards.store_master b
ON a.storecode=b.storecode
WHERE txndate>='2025-09-01' AND txndate<='2025-09-30' AND store_type='YT'
GROUP BY 1,2
;

-- Storewise Enrolments
SELECT 
enrolledstorecode AS `Enrolled StoreCode`,b.lpaasstore AS Storename,
COUNT(DISTINCT Mobile)Enrolments
 FROM dummy.spykar_temp_member  a
LEFT JOIN spykarrewards.store_master b
ON a.enrolledstorecode=b.storecode
WHERE modifiedenrolledon>='2025-09-01' AND modifiedenrolledon<='2025-09-30'
AND store_type='YT'  
GROUP BY 1
;

-- MOM enrolments 12M
SELECT CONCAT(LEFT(MONTHNAME(modifiedenrolledon),3),"-",YEAR(modifiedenrolledon))Months,
COUNT(DISTINCT Mobile)Enrolments
 FROM dummy.spykar_temp_member 
WHERE modifiedenrolledon>='2024-10-01' AND modifiedenrolledon<='2025-09-30'
AND store_type='YT'  
GROUP BY 1
ORDER BY modifiedenrolledon
;

-- MOM storewiswe sales & txn -12M

SELECT CONCAT(LEFT(MONTHNAME(txndate),3),"-",YEAR(txndate))Months,a.Storecode,b.lpaasstore AS Storename,SUM(amount)`Total Sales`,
COUNT(DISTINCT uniquebillno )`Total Bills`
FROM dummy.spykar_temp_txn a
LEFT JOIN spykarrewards.store_master b
ON a.storecode=b.storecode
WHERE txndate>='2024-10-01'  AND txndate<='2025-09-30' AND store_type='YT'
GROUP BY 1,2
ORDER BY txndate
;
-- MOM storewise enrolments 12M
SELECT CONCAT(LEFT(MONTHNAME(modifiedenrolledon),3),"-",YEAR(modifiedenrolledon))Months,
enrolledstorecode AS `Enrolled StoreCode`,b.lpaasstore AS Storename,
COUNT(DISTINCT Mobile)Enrolments
 FROM dummy.spykar_temp_member  a
LEFT JOIN spykarrewards.store_master b
ON a.enrolledstorecode=b.storecode
WHERE modifiedenrolledon>='2024-10-01' AND modifiedenrolledon<='2025-09-30'
AND store_type='YT'  
GROUP BY 1,2
ORDER BY modifiedenrolledon
;


--  Active & dormant & Lapsed


 -- Sep 25
SELECT 'Sep-25' AS MONTH,CASE WHEN recency<=545 THEN 'Active' WHEN recency BETWEEN 546 AND 1096 THEN 'Dormant' ELSE 'Lapsed' END AS tag,COUNT(DISTINCT mobile)ct
FROM(
SELECT Mobile,DATEDIFF('2025-09-30', MAX(txndate)) AS 'recency'
 FROM dummy.spykar_temp_txn
 WHERE txndate<='2025-09-30' AND tag_='L' AND store_type='YT'
 GROUP BY 1
 )b
GROUP BY 2;


 -- Aug 25
SELECT 'Aug-25' AS MONTH,CASE WHEN recency<=545 THEN 'Active' WHEN recency BETWEEN 546 AND 1096 THEN 'Dormant' ELSE 'Lapsed' END AS tag,COUNT(DISTINCT mobile)ct
FROM(
SELECT Mobile,DATEDIFF('2025-08-31', MAX(txndate)) AS 'recency'
 FROM dummy.spykar_temp_txn
 WHERE txndate<='2025-08-31' AND tag_='L' AND store_type='YT'
 GROUP BY 1
 )b
GROUP BY 2;

 -- July 25
SELECT 'July-25' AS MONTH,CASE WHEN recency<=545 THEN 'Active' WHEN recency BETWEEN 546 AND 1096 THEN 'Dormant' ELSE 'Lapsed' END AS tag,COUNT(DISTINCT mobile)ct
FROM(
SELECT Mobile,DATEDIFF('2025-07-31', MAX(txndate)) AS 'recency'
 FROM dummy.spykar_temp_txn
 WHERE txndate<='2025-07-31' AND tag_='L' AND store_type='YT'
 GROUP BY 1
 )b
GROUP BY 2;

 -- June 25
SELECT 'June-25' AS MONTH,CASE WHEN recency<=545 THEN 'Active' WHEN recency BETWEEN 546 AND 1096 THEN 'Dormant' ELSE 'Lapsed' END AS tag,COUNT(DISTINCT mobile)ct
FROM(
SELECT Mobile,DATEDIFF('2025-06-30', MAX(txndate)) AS 'recency'
 FROM dummy.spykar_temp_txn
 WHERE txndate<='2025-06-30' AND tag_='L' AND store_type='YT'
 GROUP BY 1
 )b
GROUP BY 2;

 -- May 25
SELECT 'May-25' AS MONTH,CASE WHEN recency<=545 THEN 'Active' WHEN recency BETWEEN 546 AND 1096 THEN 'Dormant' ELSE 'Lapsed' END AS tag,COUNT(DISTINCT mobile)ct
FROM(
SELECT Mobile,DATEDIFF('2025-05-31', MAX(txndate)) AS 'recency'
 FROM dummy.spykar_temp_txn
 WHERE txndate<='2025-05-31' AND tag_='L' AND store_type='YT'
 GROUP BY 1
 )b
GROUP BY 2;
  
  -- April 25
SELECT 'April-25' AS MONTH,CASE WHEN recency<=545 THEN 'Active' WHEN recency BETWEEN 546 AND 1096 THEN 'Dormant' ELSE 'Lapsed' END AS tag,COUNT(DISTINCT mobile)ct
FROM(
SELECT Mobile,DATEDIFF('2025-04-30', MAX(txndate)) AS 'recency'
 FROM dummy.spykar_temp_txn
 WHERE txndate<='2025-04-30' AND tag_='L' AND store_type='YT'
 GROUP BY 1
 )b
GROUP BY 2;

  -- Mar 25
SELECT 'Mar-25' AS MONTH,CASE WHEN recency<=545 THEN 'Active' WHEN recency BETWEEN 546 AND 1096 THEN 'Dormant' ELSE 'Lapsed' END AS tag,COUNT(DISTINCT mobile)ct
FROM(
SELECT Mobile,DATEDIFF('2025-03-31', MAX(txndate)) AS 'recency'
 FROM dummy.spykar_temp_txn
 WHERE txndate<='2025-03-31' AND tag_='L' AND store_type='YT'
 GROUP BY 1
 )b
GROUP BY 2;

  -- Feb 25
SELECT 'Feb-25' AS MONTH,CASE WHEN recency<=545 THEN 'Active' WHEN recency BETWEEN 546 AND 1096 THEN 'Dormant' ELSE 'Lapsed' END AS tag,COUNT(DISTINCT mobile)ct
FROM(
SELECT Mobile,DATEDIFF('2025-02-28', MAX(txndate)) AS 'recency'
 FROM dummy.spykar_temp_txn
 WHERE txndate<='2025-02-28' AND tag_='L' AND store_type='YT'
 GROUP BY 1
 )b
GROUP BY 2;


 -- jan 25
SELECT 'Jan-25' AS MONTH,CASE WHEN recency<=545 THEN 'Active' WHEN recency BETWEEN 546 AND 1096 THEN 'Dormant' ELSE 'Lapsed' END AS tag,COUNT(DISTINCT mobile)ct
FROM(
SELECT Mobile,DATEDIFF('2025-01-31', MAX(txndate)) AS 'recency'
 FROM dummy.spykar_temp_txn
 WHERE txndate<='2025-01-31' AND tag_='L' AND store_type='YT'
 GROUP BY 1
 )b
GROUP BY 2;

 -- Dec 24
SELECT 'Dec-24' AS MONTH,CASE WHEN recency<=545 THEN 'Active' WHEN recency BETWEEN 546 AND 1096 THEN 'Dormant' ELSE 'Lapsed' END AS tag,COUNT(DISTINCT mobile)ct
FROM(
SELECT Mobile,DATEDIFF('2024-12-31', MAX(txndate)) AS 'recency'
 FROM dummy.spykar_temp_txn
 WHERE txndate<='2024-12-31' AND tag_='L' AND store_type='YT'
 GROUP BY 1
 )b
GROUP BY 2;

-- Nov 24
SELECT 'Nov-24' AS MONTH,CASE WHEN recency<=545 THEN 'Active' WHEN recency BETWEEN 546 AND 1096 THEN 'Dormant' ELSE 'Lapsed' END AS tag,COUNT(DISTINCT mobile)ct
FROM(
SELECT Mobile,DATEDIFF('2024-11-30', MAX(txndate)) AS 'recency'
 FROM dummy.spykar_temp_txn
 WHERE txndate<='2024-11-30' AND tag_='L' AND store_type='YT'
 GROUP BY 1
 )b
GROUP BY 2;


-- Oct 24
SELECT 'Oct-24' AS MONTH,CASE WHEN recency<=545 THEN 'Active' WHEN recency BETWEEN 546 AND 1096 THEN 'Dormant' ELSE 'Lapsed' END AS tag,COUNT(DISTINCT mobile)ct
FROM(
SELECT Mobile,DATEDIFF('2024-10-31', MAX(txndate)) AS 'recency'
 FROM dummy.spykar_temp_txn
 WHERE txndate<='2024-10-31' AND tag_='L' AND store_type='YT'
 GROUP BY 1
 )b
GROUP BY 2;


-- Sept 24
SELECT 'Sept-24' AS MONTH,CASE WHEN recency<=545 THEN 'Active' WHEN recency BETWEEN 546 AND 1096 THEN 'Dormant' ELSE 'Lapsed' END AS tag,COUNT(DISTINCT mobile)ct
FROM(
SELECT Mobile,DATEDIFF('2024-09-30', MAX(txndate)) AS 'recency'
 FROM dummy.spykar_temp_txn
 WHERE txndate<='2024-09-30' AND tag_='L' AND store_type='YT'
 GROUP BY 1
 )b
GROUP BY 2;
 
 
 
 -- Truncate temp table once data get extracted 
 
