
#################### KPIs #####################

SELECT region,COUNT(DISTINCT mobile) AS New_Enrolment FROM member_report a
JOIN store_master b ON a.enrolledstorecode=b.storecode
WHERE modifiedenrolledon BETWEEN '2025-06-01' AND '2025-06-30'
GROUP BY 1;

SELECT region,SUM(itemnetamount)AS Total_Sale,COUNT(DISTINCT uniquebillno) AS Total_bill,
COUNT(DISTINCT txnmappedmobile) AS Total_Txn_Cust,
SUM(itemnetamount)/COUNT(DISTINCT uniquebillno) AS ABV,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS Repeaters,
COUNT(DISTINCT CASE WHEN dayssincelastvisit>730 THEN txnmappedmobile END) AS Win_back_customer
FROM sku_report_loyalty a JOIN store_master b
ON a.modifiedstorecode=b.storecode
WHERE modifiedtxndate BETWEEN '2025-06-01' AND '2025-06-30'
GROUP BY 1;

 SELECT region,COUNT(DISTINCT txnmappedmobile) AS Newly_Enrolled_Transacted FROM sku_report_loyalty a
 JOIN store_master b ON a.modifiedstorecode=b.storecode
 WHERE modifiedtxndate BETWEEN '2025-06-01' AND '2025-06-30' AND txnmappedmobile IN
 (SELECT DISTINCT mobile FROM member_report
 WHERE modifiedtxndate BETWEEN '2025-06-01' AND '2025-06-30')
 GROUP BY 1;

SELECT region,COUNT(DISTINCT txnmappedmobile) AS mobile FROM sku_report_loyalty a
JOIN store_master b ON a.modifiedstorecode=b.storecode
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2025-06-30'
GROUP BY 1;

SELECT region,COUNT(DISTINCT txnmappedmobile) AS Declining_Base_Cust
 FROM
(SELECT txnmappedmobile,modifiedtxndate,dayssincelastvisit,region FROM sku_report_loyalty a
 JOIN store_master b ON a.modifiedstorecode=b.storecode
 WHERE modifiedtxndate BETWEEN '2025-06-01' AND '2025-06-30'
 GROUP BY 1,2,3,4) a
 WHERE dayssincelastvisit BETWEEN 366 AND 730
 GROUP BY 1;
 

########################Loyalty -NonLoyalty Comparison#####################


SELECT MONTHNAME,YEAR,SUM(sales)total_sales,SUM(bills)total_bills FROM 
(SELECT MONTHNAME(modifiedtxndate)MONTHNAME,YEAR(modifiedtxndate)YEAR,uniquebillno,
SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2025-06-30'
GROUP BY 1,2
UNION
SELECT MONTHNAME(modifiedtxndate)MONTHNAME,YEAR(modifiedtxndate)YEAR,uniquebillno,
SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM sku_report_nonloyalty
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2025-06-30'
GROUP BY 1,2)a
GROUP BY 1,2;


SELECT MONTHNAME(modifiedtxndate)MONTHNAME,
YEAR(modifiedtxndate)YEAR,
SUM(itemnetamount) AS Loyalty_Sales,
COUNT(DISTINCT uniquebillno) AS Loyalty_BIlls,
SUM(itemnetamount)/COUNT(DISTINCT uniquebillno) AS Loyalty_ATV
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2025-06-30'
GROUP BY 1,2;


SELECT MONTHNAME(modifiedtxndate)MONTHNAME,
YEAR(modifiedtxndate)YEAR,
SUM(itemnetamount) AS NonLoyalty_Sales,
COUNT(DISTINCT uniquebillno) AS NonLoyalty_BIlls,
SUM(itemnetamount)/COUNT(DISTINCT uniquebillno) AS NonLoyalty_ATV
FROM sku_report_nonloyalty
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2025-06-30'
GROUP BY 1,2;


####################### Bill Banding Bucketing #######################

SELECT 
CASE 
WHEN Sales<=2500 THEN '0-2500'
WHEN Sales BETWEEN 2501 AND 5000 THEN '2501-5000'
WHEN Sales BETWEEN 5001 AND 7500 THEN '5001-7500'
WHEN Sales BETWEEN 7501 AND 10000 THEN '7501-10000'
WHEN Sales BETWEEN 10001 AND 12500 THEN '10001-12500'
WHEN Sales >12500 THEN '12500+'
END AS `Bucket`,
COUNT(DISTINCT txnmappedmobile) AS Customer,SUM(Sales) AS Sales,
SUM(bill) AS Bills,
SUM(Repeater) AS Repeats,
SUM(Repeat_Sales) AS Repeat_Sales,
SUM(Repeat_Bills) AS Repeat_Bills
FROM 
(SELECT txnmappedmobile,SUM(itemnetamount) AS Sales,COUNT(DISTINCT uniquebillno) AS bill,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS Repeater,
SUM( CASE WHEN frequencycount>1 THEN itemnetamount END) AS Repeat_Sales,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END) AS Repeat_Bills
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2025-06-01' AND '2025-06-30'
GROUP BY 1)a
GROUP BY 1;
    
    
#################### Point KPIs #####################


SELECT COUNT(DISTINCT CASE WHEN pointsspent>0 THEN txnmappedmobile END) AS Redeemers,
SUM(PointsCollected)Point_Issued,
SUM(CASE WHEN pointsspent>0 THEN pointsspent END) AS Point_Redeemed,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN a.uniquebillno END) AS Redemption_Bills,
SUM(CASE WHEN pointsspent>0 THEN a.itemnetamount END) AS Redemption_Sales,
SUM(CASE WHEN pointsspent>0 THEN a.itemnetamount END)/
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN a.uniquebillno END) AS Redemption_ABV,
SUM(pointscollected)/SUM(pointsspent) AS Earn_Burn_Ratio
FROM
(SELECT txnmappedmobile,uniquebillno,itemnetamount,modifiedtxndate FROM sku_report_loyalty
GROUP BY 1,2) a 
JOIN
(SELECT mobile,uniquebillno,pointsspent,PointsCollected FROM txn_report_accrual_redemption
GROUP BY 1,2) b
ON a.txnmappedmobile = b.mobile
AND a.uniquebillno = b.uniquebillno
WHERE modifiedtxndate BETWEEN '2025-06-01' AND '2025-06-30';


SELECT SUM(pointslapsed) AS Point_Expire
FROM lapse_report
WHERE lapsingdate BETWEEN '2025-06-01' AND '2025-06-30';


##################### Redemption Overview (EBO) #######################


SELECT MONTHNAME(txndate) AS Month_Name,
YEAR(txndate) AS Month_Year,
SUM(PointsCollected) AS Point_Issued 
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-06-01' AND '2025-06-30' 
GROUP BY 1,2;

SELECT MONTHNAME(txndate) AS Month_Name,
YEAR(txndate) AS Month_Year,
SUM(PointsCollected) AS Point_Issued 
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2023-06-01' AND '2024-06-30' 
GROUP BY 1,2;


SELECT MONTHNAME(txndate) AS Month_Name,
YEAR(txndate) AS Month_Year,
SUM(pointsspent) AS Point_Redeemed
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-06-01' AND '2025-06-30' 
GROUP BY 1,2;

SELECT MONTHNAME(txndate) AS Month_Name,
YEAR(txndate) AS Month_Year,
SUM(pointsspent) AS Point_Redeemed 
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2023-06-01' AND '2024-06-30' 
GROUP BY 1,2;


################## Customer Overview ########################

SELECT 
CASE 
WHEN Recency<=365 THEN 'Active'
WHEN Recency BETWEEN 366 AND 730 THEN 'Dormant'
WHEN Recency>730 THEN 'Lapse' 
END AS customer, 
COUNT(DISTINCT txnmappedmobile) AS Customer,
SUM(Sales) AS Sales,COUNT(DISTINCT a.modifiedbillno) AS Bills,
SUM(pointscollected) AS Point_Accrual,
SUM(CASE WHEN pointsspent>0 THEN Sales END) AS Point_Redeemed,
SUM(CASE WHEN pointsspent>0 THEN Sales END) AS Redemption_Sales,
SUM(Sales)/COUNT(DISTINCT a.modifiedbillno) AS ABV,
SUM(Recency)/COUNT(DISTINCT txnmappedmobile) AS AVG_Recency
FROM 
(SELECT txnmappedmobile,modifiedbillno,modifiedtxndate,DATEDIFF('2025-07-24',MAX(modifiedtxndate)) AS Recency,
SUM(itemnetamount) AS Sales,
SUM(itemnetamount)/COUNT(DISTINCT modifiedbillno) AS ABV
FROM sku_report_loyalty 
GROUP BY 1,2)a
JOIN
(SELECT mobile,modifiedbillno,pointsspent,pointscollected 
FROM txn_report_accrual_redemption 
GROUP BY 1,2)b
ON a.txnmappedmobile = b.mobile 
AND a.modifiedbillno = b.modifiedbillno
GROUP BY 1;


###################### Win-back #####################


SELECT
Month_Name,
CASE 
WHEN Recency BETWEEN 730 AND 820 THEN '730-820' 
WHEN Recency BETWEEN 821 AND 910 THEN '820-910'  
WHEN Recency BETWEEN 911 AND 1000 THEN '910-1000'  
WHEN Recency BETWEEN 1001 AND 1200 THEN '1000-1200' 
WHEN Recency BETWEEN 1201 AND 1500 THEN '1200-1500'   
WHEN Recency BETWEEN 1501 AND 2000 THEN '1500-2000'  
WHEN Recency>2000 THEN '2000+' 
END AS `Win Back`,
COUNT(DISTINCT txnmappedmobile) AS Customer
FROM 
(SELECT MONTHNAME(modifiedtxndate) AS Month_Name,
DATEDIFF('2025-07-22',MAX(modifiedtxndate)) AS Recency,
txnmappedmobile FROM sku_report_loyalty
GROUP BY 3) a
GROUP BY 1,2;

###################### Repeat Cohort ######################


SELECT MONTHNAME(a.FirsttxnDate) AS firstmonth,MONTHNAME(b.modifiedtxndate) AS Txn_month,
COUNT(DISTINCT a.txnmappedmobile) AS Total_customer FROM 
(SELECT txnmappedmobile,MIN(modifiedtxndate) AS FirsttxnDate FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2025-06-30' 
GROUP BY 1)a JOIN 
(SELECT txnmappedmobile,modifiedtxndate FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2025-06-30' 
GROUP BY 1,2)b ON a.txnmappedmobile=b.txnmappedmobile
GROUP BY 1,2;

#################### Store Code Data###################


SELECT storecode,lpaasstore,
COUNT(DISTINCT a.txnmappedmobile) AS Customer,
COUNT(DISTINCT CASE WHEN max_feq>1 THEN a.txnmappedmobile END) AS Repeater,
SUM(CASE WHEN max_feq>1 THEN sales END) AS Repeater_Sales,
SUM(Sales) AS Sales,SUM(Bills) AS Bills,
SUM(Sales)/SUM(Bills) AS ABV
FROM
(SELECT txnmappedmobile,MIN(frequencycount) AS min_Feq,MAX(frequencycount) AS max_Feq
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2025-06-01' AND '2025-06-30'
GROUP BY 1)a
JOIN
(SELECT a.txnmappedmobile,b.storecode,lpaasstore,SUM(itemnetamount) AS Sales, 
COUNT(DISTINCT uniquebillno) AS Bills
FROM sku_report_loyalty a
JOIN store_master b
ON a.modifiedstorecode=b.storecode
WHERE modifiedtxndate BETWEEN '2025-06-01' AND '2025-06-30'
GROUP BY 1)c
ON a.txnmappedmobile=c.txnmappedmobile
GROUP BY 1,2;


SELECT 
b.storecode,
lpaasstore,
SUM(pointsspent) AS Redeemers 
FROM txn_report_accrual_redemption a
JOIN store_master b
ON a.storecode=b.storecode
WHERE txndate BETWEEN '2025-06-01' AND '2025-06-30' AND mobile IN(SELECT txnmappedmobile FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2025-06-01' AND '2025-06-30' AND txnmappedmobile IS NOT NULL
GROUP BY 1)
GROUP BY 1,2;


SELECT 
b.storecode,
lpaasstore,
SUM(itemnetamount) AS Previous_sale 
FROM sku_report_loyalty a
JOIN store_master b
ON a.modifiedstorecode=b.storecode
WHERE txndate BETWEEN '2025-01-01' AND '2025-03-31' 
GROUP BY 1,2;
 
 ##########################Tier Wise Data#########################
 
 
SELECT tier,COUNT(DISTINCT txnmappedmobile) AS Customers,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS Repeater,
COUNT(DISTINCT modifiedtxndate,txnmappedmobile) AS visits,
AVG(COUNT(DISTINCT  modifiedtxndate)) AS AVG_Visit,
SUM(itemnetamount) AS Customer_Sales,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS Repeater_Sales,
COUNT(DISTINCT uniquebillno) AS Loyalty_Bills,
SUM(itemnetamount)/COUNT(DISTINCT uniquebillno) AS ABV,
SUM(itemnetamount)/COUNT(DISTINCT txnmappedmobile) AS AMV
FROM sku_report_loyalty a
JOIN member_report b
ON a.txnmappedmobile=b.mobile
WHERE modifiedtxndate BETWEEN '2025-06-01' AND '2025-06-30'
GROUP BY 1;

WITH customer_data AS
(SELECT txnmappedmobile,COUNT(DISTINCT modifiedtxndate)visit
FROM sku_report_loyalty WHERE modifiedtxndate BETWEEN '2025-06-01' AND '2025-06-30'
GROUP BY 1),
tier AS
(SELECT mobile,tier AS t1 FROM member_report)
SELECT COUNT(DISTINCT txnmappedmobile)custopmer,AVG(visit)AVG ,t1 FROM customer_data a JOIN tier b
ON a.txnmappedmobile=b.mobile
GROUP BY 3;


SELECT tier,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.pointsspent END) AS Redeemers,
SUM(PointsCollected) AS Point_colleted,
SUM(a.pointsspent) AS Redeemed
FROM txn_report_accrual_redemption a
JOIN member_report b
ON a.mobile=b.mobile
WHERE txndate BETWEEN '2025-06-01' AND '2025-06-30'
GROUP BY 1;


#################Tier Wise New Loyalty Sales Parameter########

SELECT tier,
COUNT(DISTINCT CASE WHEN min_f=1 THEN txnmappedmobile END) AS New_Customer,
SUM(CASE WHEN min_f=1 THEN Bills END) AS New_Bills,
SUM(CASE WHEN min_f=1 THEN Sales END) AS New_Sales
FROM
(SELECT tier,txnmappedmobile,MIN(frequencycount) AS min_f,MAX(frequencycount) AS max_f,
COUNT(DISTINCT uniquebillno) AS Bills,SUM(itemnetamount) AS Sales
FROM sku_report_loyalty a
JOIN member_report b
ON a.txnmappedmobile=b.mobile
WHERE modifiedtxndate BETWEEN '2025-06-01' AND '2025-06-30'
GROUP BY 1,2)a
GROUP BY 1;

#######################Tier Wise Frequency Distribution#############


SELECT tier,
CASE 
WHEN Visit=1 THEN '1'
WHEN Visit=2 THEN '2'
WHEN Visit=3 THEN '3'
WHEN Visit=4 THEN '4'
WHEN Visit=5 THEN '5'
WHEN visit>5 THEN '5+'
END AS `Tier`,
COUNT(DISTINCT txnmappedmobile) AS Customer
FROM
(SELECT tier,txnmappedmobile,COUNT(DISTINCT modifiedtxndate) AS Visit
FROM sku_report_loyalty a
JOIN member_report b
ON a.txnmappedmobile=b.mobile
WHERE modifiedtxndate BETWEEN '2025-06-01' AND '2025-06-30'
GROUP BY 1,2) a
GROUP BY 1,2;

###################Tier wise spend bucket#############

ELECT tier,
CASE 
WHEN sales BETWEEN 0 AND 1000 THEN '0-1000'
WHEN sales BETWEEN 1001 AND 2500 THEN '1001-2500'
WHEN sales BETWEEN 2501 AND 4000 THEN '2501-4000'
WHEN sales BETWEEN 4001 AND 6000 THEN '4001-6000'
WHEN sales BETWEEN 6001 AND 10000 THEN '6001-10000'
WHEN sales>10000 THEN '10000+'
END AS `Spend Bucket`,
COUNT(DISTINCT txnmappedmobile) AS Customer
FROM
(SELECT tier,txnmappedmobile,SUM(itemnetamount) AS sales
FROM sku_report_loyalty a
JOIN member_report b
ON a.txnmappedmobile=b.mobile
WHERE modifiedtxndate BETWEEN '2025-06-01' AND '2025-06-30' AND itemnetamount>0
GROUP BY 1,2
)a
GROUP BY 1,2;


#################Tier Movement #############

## PREVIOUS MONTH

CREATE TABLE dummy.Umesh_Migration_tier_2025_May_report
(mobile VARCHAR(20),max_tier_change_data VARCHAR(20),TierNo VARCHAR(10),Tier VARCHAR(20));

INSERT INTO dummy.Umesh_Migration_tier_2025_May_report(mobile,max_tier_change_data,TierNo,Tier)
SELECT mobile,MAX(DATE(tierchangedate))max_tier_change_data,
MAX(CASE
WHEN currenttier='Orange' THEN 1
WHEN currenttier='Silver' THEN 2
WHEN currenttier='Gold' THEN 3
ELSE NULL END) AS TierNo,
CurrentTier AS Tier
FROM killersignatureclub.tier_report_log WHERE DATE(tierchangedate)<='2025-05-31'
GROUP BY 1;#1516027 row(s) affected



ALTER TABLE dummy.Umesh_Migration_tier_2025_May_report  ADD INDEX mobile(mobile),
ADD INDEX max_tier_change_data(max_tier_change_data),ADD currenttier VARCHAR(50);


UPDATE dummy.Umesh_Migration_tier_2025_May_report a
LEFT JOIN killersignatureclub.tier_report_log b 
ON a.mobile =b.mobile
AND a.max_tier_change_data =DATE(b.tierchangedate) 
SET a.currenttier=b.currenttier, 
Tier=
CASE
WHEN TierNo=1 THEN 'Orange'
WHEN TierNo=2 THEN 'Silver'
WHEN TierNo=3 THEN 'Gold'
ELSE NULL END #1516027 row(s) affected

ALTER TABLE dummy.Umesh_Migration_tier_2025_May_report 
CONVERT TO CHARACTER SET latin1 COLLATE 'latin1_swedish_ci';

SELECT DISTINCT tier FROM dummy.Umesh_Migration_tier_2025_May_report;


#### CURRENT MONTH

CREATE TABLE dummy.Umesh_Migration_tier_2025_jun1_report
(mobile VARCHAR(20),max_tier_change_data VARCHAR(20),TierNo VARCHAR(10),Tier VARCHAR(20));

INSERT INTO dummy.Umesh_Migration_tier_2025_jun1_report(mobile,max_tier_change_data,TierNo,Tier)
SELECT mobile,MAX(DATE(tierchangedate))max_tier_change_data,
MAX(CASE
WHEN currenttier='Orange' THEN 1
WHEN currenttier='Silver' THEN 2
WHEN currenttier='Gold' THEN 3
ELSE NULL END) AS TierNo,
CurrentTier AS Tier
FROM killersignatureclub.tier_report_log WHERE DATE(tierchangedate)<='2025-06-30'
GROUP BY 1;#1545387 row(s) affected


ALTER TABLE dummy.Umesh_Migration_tier_2025_jun1_report  ADD INDEX mobile(mobile),
ADD INDEX max_tier_change_data(max_tier_change_data),ADD currenttier VARCHAR(50);

UPDATE dummy.Umesh_Migration_tier_2025_jun1_report a
LEFT JOIN killersignatureclub.tier_report_log b 
ON a.mobile=b.mobile   
AND a.max_tier_change_data=DATE(b.tierchangedate)  
SET a.currenttier=b.currenttier, 
Tier=
CASE
WHEN TierNo=1 THEN 'Orange'
WHEN TierNo=2 THEN 'Silver'
WHEN TierNo=3 THEN 'Gold'
ELSE NULL END #1545387 row(s) affected


ALTER TABLE dummy.Umesh_Migration_tier_2025_jun1_report 
CONVERT TO CHARACTER SET latin1 COLLATE 'latin1_swedish_ci';


SELECT a.Tier AS Previous_Month_Tier,b.tier AS Current_Month_Tier,COUNT(DISTINCT a.mobile)customers 
FROM dummy.Umesh_Migration_tier_2025_jan_report a
LEFT JOIN dummy.Umesh_Migration_tier_2025_jun_report b ON a.mobile = b.mobile GROUP BY 1,2;


####################Fraud_Mobile Report#############


CREATE TABLE dummy.fraud_mobile1(mobile VARCHAR(20))

LOAD DATA LOCAL INFILE "C:\\Users\\intern_dataanalyst2\\Downloads\\Fraud_Mobile.csv"
INTO TABLE dummy.fraud_mobile1
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;



SELECT 
a.Mobile,
Txndate,
SUM(amount)Sales,
COUNT(DISTINCT uniquebillno)Bills,
COUNT(DISTINCT a.Mobile,txndate) Visit,
SUM(pointscollected) AS Point_Collected,
SUM(pointsspent) AS Point_Redeemed
FROM killersignatureclub.txn_report_accrual_redemption a 
-- right join dummy.fraud_mobile1 b ON a.mobile COLLATE utf8mb4_unicode_ci = b.mobile
WHERE txndate BETWEEN '2025-05-01' AND '2025-09-30'
AND Mobile COLLATE utf8mb4_0900_ai_ci IN(SELECT mobile FROM dummy.fraud_mobile1)
GROUP BY mobile,Txndate;






