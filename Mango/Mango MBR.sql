
###########################Overall Data######################

SELECT COUNT(DISTINCT b.mobile) AS enrolledcustomer,
COUNT(DISTINCT b.enrolledstorecode) AS Enrolledstore,
COUNT(DISTINCT a.mobile) AS Transacting_customers,
SUM(amount) AS Sales,
COUNT(DISTINCT uniquebillno) AS No_of_Bills,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN a.mobile END) AS Repeaters,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END) AS Repeaters_Bills,
SUM(DISTINCT CASE WHEN frequencycount>1 THEN Amount END) AS Repeaters_Sales,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END) AS Redeemers,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN uniquebillno END) AS Redeemers_Bills,
SUM(DISTINCT CASE WHEN a.pointsspent>0 THEN Amount END) AS Redeemers_Sales,
SUM(pointscollected) AS Points_collected,
SUM(a.pointsspent) AS Redeemed,
SUM(amount)/COUNT(DISTINCT uniquebillno) AS ABV,
SUM(amount)/COUNT(DISTINCT a.mobile) AS AMV
FROM txn_report_accrual_redemption a
JOIN member_report b
ON a.mobile=b.mobile
WHERE  txndate<='2025-07-31';

###########################Overall Data######################


###########################Overall Store######################

SELECT COUNT(DISTINCT enrolledstore) AS Enrolledstore,
COUNT(DISTINCT mobile) AS EnrolledCustomer 
FROM member_report
WHERE enrolledon<='2025-07-31';

###########################Overall Store######################

########################### July_2023 ######################

SELECT COUNT(DISTINCT mobile) AS Transacting_customers,
SUM(amount) AS Sales,
COUNT(DISTINCT uniquebillno) AS No_of_Bills,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN mobile END) AS Repeaters,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END) AS Repeaters_Bills,
SUM(DISTINCT CASE WHEN frequencycount>1 THEN Amount END) AS Repeaters_Sales,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END) AS Redeemers,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END) AS Redeemers_Bills,
SUM(DISTINCT CASE WHEN pointsspent>0 THEN Amount END) AS Redeemers_Sales,
SUM(pointscollected) AS Points_collected,
SUM(pointsspent) AS Redeemed,
SUM(amount)/COUNT(DISTINCT uniquebillno) AS ABV,
SUM(amount)/COUNT(DISTINCT mobile) AS AMV
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2023-07-01' AND '2023-07-31';

########################### July_2023 ######################

########################### July_2024 ######################

SELECT COUNT(DISTINCT mobile) AS Transacting_customers,
SUM(amount) AS Sales,
COUNT(DISTINCT uniquebillno) AS No_of_Bills,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN mobile END) AS Repeaters,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END) AS Repeaters_Bills,
SUM(DISTINCT CASE WHEN frequencycount>1 THEN Amount END) AS Repeaters_Sales,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END) AS Redeemers,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END) AS Redeemers_Bills,
SUM(DISTINCT CASE WHEN pointsspent>0 THEN Amount END) AS Redeemers_Sales,
SUM(pointscollected) AS Points_collected,
SUM(pointsspent) AS Redeemed,
SUM(amount)/COUNT(DISTINCT uniquebillno) AS ABV,
SUM(amount)/COUNT(DISTINCT mobile) AS AMV
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-07-01' AND '2024-07-31';

########################### July_2024 ######################


########################### Jul,jul,Jun_23,24,25 ######################

SELECT
CASE 
WHEN txndate BETWEEN '2024-07-01' AND '2024-07-31' THEN 'Jul-24'
WHEN txndate BETWEEN '2025-06-01' AND '2025-06-30' THEN 'Jun-25'
WHEN txndate BETWEEN '2025-07-01' AND '2025-07-31' THEN 'Jul-25' 
END AS `Period`,
COUNT(DISTINCT b.mobile) AS enrolledcustomer,
COUNT(DISTINCT b.enrolledstorecode) AS Enrolledstore,
COUNT(DISTINCT a.mobile) AS Transacting_customers,
SUM(amount) AS Sales,
COUNT(DISTINCT uniquebillno) AS No_of_Bills,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN a.mobile END) AS Repeaters,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END) AS Repeaters_Bills,
SUM(DISTINCT CASE WHEN frequencycount>1 THEN Amount END) AS Repeaters_Sales,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END) AS Redeemers,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN uniquebillno END) AS Redeemers_Bills,
SUM(DISTINCT CASE WHEN a.pointsspent>0 THEN Amount END) AS Redeemers_Sales,
SUM(pointscollected) AS Points_collected,
SUM(a.pointsspent) AS Redeemed,
SUM(amount)/COUNT(DISTINCT uniquebillno) AS ABV,
SUM(amount)/COUNT(DISTINCT a.mobile) AS AMV
FROM txn_report_accrual_redemption a
JOIN member_report b
ON a.mobile=b.mobile
WHERE ((txndate BETWEEN '2024-07-01' AND '2024-07-31') OR
(txndate BETWEEN '2025-06-01' AND '2025-06-30') OR
(txndate BETWEEN '2025-07-01' AND '2025-07-31'))
GROUP BY 1;

########################### Jul,jul,Jun_23,24,25  ######################


###########################Jul_2023,2024,Jun_2025 Store######################

SELECT 
CASE
WHEN modifiedenrolledon BETWEEN '2023-07-01' AND '2023-07-31' THEN 'Jul-23'
WHEN modifiedenrolledon BETWEEN '2024-07-01' AND '2024-07-31' THEN 'Jul-24'
WHEN modifiedenrolledon BETWEEN '2025-06-01' AND '2025-06-30' THEN 'Jun-25'
END AS `Period`,
COUNT(DISTINCT enrolledstore) AS Enrolledstore,
COUNT(DISTINCT mobile) AS EnrolledCustomer 
FROM member_report
WHERE ((modifiedenrolledon BETWEEN '2023-07-01' AND '2023-07-31') OR
(modifiedenrolledon BETWEEN '2024-07-01' AND '2024-07-31') OR
(modifiedenrolledon BETWEEN '2025-06-01' AND '2025-06-30'))
GROUP BY 1;
 
SELECT COUNT(DISTINCT enrolledstore) AS Enrolledstore,
COUNT(DISTINCT mobile) AS EnrolledCustomer 
FROM member_report
WHERE modifiedenrolledon BETWEEN '2023-07-01' AND '2023-07-31';


SELECT COUNT(DISTINCT enrolledstore) AS Enrolledstore,
COUNT(DISTINCT mobile) AS EnrolledCustomer 
FROM member_report
WHERE modifiedenrolledon BETWEEN '2024-07-01' AND '2024-07-31';


SELECT COUNT(DISTINCT enrolledstore) AS Enrolledstore,
COUNT(DISTINCT mobile) AS EnrolledCustomer 
FROM member_report
WHERE modifiedenrolledon BETWEEN '2025-06-01' AND '2025-06-30';

###########################Jul_2023,2024,Jun_2025 Store######################

################### Active,Dormant,Lapse##############

SELECT 
CASE
WHEN Recency<=365 THEN 'Active'
WHEN Recency BETWEEN 366 AND 544 THEN 'Dormant'
WHEN Recency>544 THEN 'Lapse'
END AS `Status_1`,
COUNT(mobile) AS Customers,SUM(Sales) AS Sales,
SUM(Bills) AS Bills,
SUM(Point_Accrual) AS Point_Accrual,
SUM(point_Redeemed) AS point_Redeemed,
SUM(CASE WHEN Redemption_Sales>0 THEN Sales END) AS Redemption_Sales,
SUM(Sales)/SUM(DISTINCT Bills) AS ABV,
SUM(Recency)/COUNT(DISTINCT mobile) AS Avg_Recency
FROM
(SELECT mobile,
SUM(amount) AS Sales,
COUNT(DISTINCT uniquebillno) AS Bills,
SUM(pointscollected) AS Point_Accrual,
SUM(CASE WHEN pointsspent>0 THEN pointsspent END) AS point_Redeemed,
SUM(CASE WHEN pointsspent>0 THEN amount END) AS Redemption_Sales,
SUM(amount)/COUNT(DISTINCT uniquebillno) AS ABV,
DATEDIFF('2025-07-31',MAX(txndate)) AS Recency
FROM txn_report_accrual_redemption
WHERE txndate<='2025-07-31'
GROUP BY 1)a
GROUP BY 1;

#########################Tier Analysis########################

SELECT tier,COUNT(DISTINCT a.mobile) AS customer,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN a.mobile END) AS Repeater,
COUNT(DISTINCT txndate) AS Visit,
COUNT(DISTINCT a.mobile)/COUNT(DISTINCT txndate) AS Avg_Visit,
SUM(pointscollected) AS Point_Accrued,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END) AS Redeemers,
SUM(amount) AS Customer_Sales,
SUM(CASE WHEN frequencycount>1 THEN Amount END) AS Repeater_Sales,
COUNT(DISTINCT uniquebillno) AS Bills,
SUM(CASE WHEN a.pointsspent>1 THEN Amount END) AS Redeemed,
SUM(amount)/COUNT(DISTINCT uniquebillno) AS ABV,
SUM(amount)/COUNT(DISTINCT a.mobile) AS AMV
FROM txn_report_accrual_redemption a
JOIN member_report b
ON a.mobile=b.mobile
WHERE txndate<='2025-07-31'
GROUP BY 1;


#####################TIERWISE-1-MOM-DATA###############

SELECT tier,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END) AS Redeemers,
SUM(amount) AS Sales,
SUM(CASE WHEN frequencycount>1 THEN amount END) AS Repeater_Sales,
COUNT(DISTINCT uniquebillno) AS Bills,
SUM(pointscollected) AS Point_Collected,
SUM( CASE WHEN a.pointsspent>0 THEN amount END) AS Redeemed,
SUM(amount)/COUNT(DISTINCT uniquebillno) AS ABV,
SUM(amount)/COUNT(DISTINCT a.mobile) AS AMV
FROM txn_report_accrual_redemption a
JOIN member_report b
ON a.mobile=b.mobile
WHERE txndate BETWEEN '2025-07-01' AND '2025-07-31'
GROUP BY 1;

#####################TIERWISE-1-MOM-DATA###############

SELECT tier,CONCAT(LEFT(MONTHNAME(txndate),3),'-',RIGHT(YEAR(txndate),2)) AS Month_Name,
COUNT(DISTINCT a.mobile) AS Customer,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN a.mobile END) AS Repeater,
COUNT(DISTINCT txndate) AS Visit,
COUNT(DISTINCT a.mobile)/COUNT(DISTINCT txndate) AS Avg_Visits,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END) AS Redeemers,
SUM(amount) AS Sales,
SUM(CASE WHEN frequencycount>1 THEN amount END) AS Repeater_Sales,
COUNT(DISTINCT uniquebillno) AS Bills,
SUM(pointscollected) AS Point_Collected,
SUM( CASE WHEN a.pointsspent>0 THEN amount END) AS Redeemed,
SUM(amount)/COUNT(DISTINCT uniquebillno) AS ABV,
SUM(amount)/COUNT(DISTINCT a.mobile) AS AMV
FROM txn_report_accrual_redemption a
JOIN member_report b
ON a.mobile=b.mobile
WHERE txndate BETWEEN '2024-07-01' AND '2025-07-31'
GROUP BY 1,2;

#####################Tier vs Spend (Tier Analysis)#################

SELECT CASE 
WHEN sales>=0 AND sales<=1000 THEN '0-1000'
WHEN sales>1000 AND sales<=2500 THEN '1001-2500'
WHEN sales>2500 AND sales<=4000 THEN '2501-4000'
WHEN sales>4000 AND sales<=6000 THEN '4001-6000'
WHEN sales>6000 AND sales<=10000 THEN '6001-10000'
WHEN sales>10000 THEN '10000+'
END AS `Spend Bucket`,
Tier,
COUNT(DISTINCT mobile) AS Customer
FROM
(SELECT tier,a.mobile,SUM(amount) AS sales
-- count(distinct a.mobile) AS Customer
FROM txn_report_Accrual_redemption a
JOIN member_report b
ON a.mobile=b.mobile
WHERE txndate BETWEEN '2025-07-01' AND '2025-07-31' AND amount>0 
GROUP BY 1,2)a
GROUP BY 1,2;

########################Tierwise Visit###################


SELECT CASE 
WHEN visit=1 THEN '1'
WHEN visit=2 THEN '2'
WHEN visit=3 THEN '3'
WHEN visit=4 THEN '4'
WHEN visit=5 THEN '5'
WHEN visit>5 THEN '5+'
END AS `Visit Bucket`,
Tier,
COUNT(DISTINCT mobile) AS Customer
FROM
(SELECT tier,a.mobile,COUNT(DISTINCT txndate) AS Visit
FROM txn_report_Accrual_redemption a
JOIN member_report b
ON a.mobile=b.mobile
WHERE txndate BETWEEN '2025-07-01' AND '2025-07-31' AND amount>0 
GROUP BY 1,2)a
GROUP BY 1,2;

################Storewise Analysis DESC################

SELECT b.* FROM(
SELECT a.*, DENSE_RANK() OVER (PARTITION BY tier ORDER BY sales DESC)`rank` FROM
(SELECT b.tier,c.storecode,state,COUNT(DISTINCT a.mobile) AS Customer,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN a.mobile END) AS Repeaters,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END) AS Redeemers,
SUM(amount) AS Sales,
SUM(CASE WHEN frequencycount>1 THEN amount END) AS Repeater_Sales,
COUNT(DISTINCT uniquebillno) AS Bills
FROM txn_report_accrual_redemption a
JOIN member_report b ON a.mobile=b.mobile
JOIN store_master c 
ON a.storecode=c.storecode
WHERE txndate BETWEEN '2025-07-01' AND '2025-07-31'
GROUP BY 1,2
ORDER BY sales DESC)a)b
WHERE `rank`<=5
ORDER BY sales DESC;


################Storewise Analysis ASC################

SELECT b.* FROM(
SELECT a.*, DENSE_RANK() OVER (PARTITION BY tier ORDER BY sales DESC)`rank` FROM
(SELECT b.tier,c.storecode,state,COUNT(DISTINCT a.mobile) AS Customer,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN a.mobile END) AS Repeaters,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END) AS Redeemers,
SUM(amount) AS Sales,
SUM(CASE WHEN frequencycount>1 THEN amount END) AS Repeater_Sales,
COUNT(DISTINCT uniquebillno) AS Bills
FROM txn_report_accrual_redemption a
JOIN member_report b ON a.mobile=b.mobile
JOIN store_master c 
ON a.storecode=c.storecode
WHERE txndate BETWEEN '2025-07-01' AND '2025-07-31'
GROUP BY 1,2
ORDER BY sales DESC)a)b
WHERE `rank`<=5
ORDER BY sales ASC;

####################New Loyalty Sales Parameter#################

SELECT tier,
COUNT(DISTINCT CASE WHEN frequencycount=1 THEN a.mobile END) AS New_Customer,
COUNT(DISTINCT CASE WHEN frequencycount=1 THEN uniquebillno END) AS New_Bills,
SUM(CASE WHEN frequencycount=1 THEN amount END) AS New_Sales
FROM txn_report_accrual_redemption a
JOIN member_report b
ON a.mobile=b.mobile
WHERE txndate BETWEEN '2025-07-01' AND '2025-07-31'
GROUP BY 1; 

#####################MOM KPIs(1-Year)#################

SELECT 
CONCAT(LEFT(MONTHNAME(txndate),3),'-',(RIGHT(YEAR(txndate),2))) AS Periods,
SUM(amount) AS Sales,COUNT(DISTINCT uniquebillno) AS bills,
COUNT(DISTINCT mobile) AS Customers,
SUM(amount)/COUNT(DISTINCT uniquebillno) AS ABV,
SUM(pointscollected) AS Point_collected,
SUM(CASE WHEN pointsspent>0 THEN amount END) AS Point_Redemption,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END) AS Point_redeemers,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END) AS Redemption_Bills,
SUM(CASE WHEN pointsspent>0 THEN amount END) AS redemption_Sales,
COUNT(DISTINCT txndate,mobile) AS Visits,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN mobile END) AS Repeaters,
SUM(CASE WHEN frequencycount>1 THEN amount END) AS Repeaters_sales,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END) AS REpeaters_BIlls,
COUNT(DISTINCT CASE WHEN frequencycount=1 THEN mobile END) AS Onetimer,
SUM(CASE WHEN frequencycount=1 THEN amount END) AS OneTimer_sales,
COUNT(DISTINCT CASE WHEN frequencycount=1 THEN uniquebillno END) AS OneTimer_BIlls
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-08-01' AND '2025-07-31'
GROUP BY 1;


#####################TIERWISE-1-MOM-DATA###############

SELECT tier,CONCAT(LEFT(MONTHNAME(txndate),3),'-',RIGHT(YEAR(txndate),2)) AS Month_Name,
COUNT(DISTINCT a.mobile) AS Customer,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN a.mobile END) AS Repeater,
COUNT(DISTINCT txndate,a.mobile) AS Visit,
COUNT(DISTINCT txndate,a.mobile)/COUNT(DISTINCT a.mobile) AS Avg_Visits,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END) AS Redeemers,
SUM(amount) AS Sales,
SUM(CASE WHEN frequencycount>1 THEN amount END) AS Repeater_Sales,
COUNT(DISTINCT uniquebillno) AS Bills,
SUM(pointscollected) AS Point_Collected,
SUM( CASE WHEN a.pointsspent>0 THEN amount END) AS Redeemed,
SUM(amount)/COUNT(DISTINCT uniquebillno) AS ABV,
SUM(amount)/COUNT(DISTINCT a.mobile) AS AMV
FROM txn_report_accrual_redemption a
JOIN member_report b
ON a.mobile=b.mobile
WHERE txndate BETWEEN '2024-08-01' AND '2025-07-31'
GROUP BY 1,2;

########################Tier Migration#####################


## PREVIOUS MONTH



CREATE TABLE dummy.Umesh_migration_tier_Mango_2025_jun1_report
(mobile VARCHAR(20),max_tier_change_date VARCHAR(20),Tierno VARCHAR(10),tier VARCHAR(20));

INSERT INTO dummy.Umesh_migration_tier_Mango_2025_jun1_report(mobile,max_tier_change_date,tierno,tier)
SELECT mobile,MAX(DATE(tierchangedate))max_tier_change_date,
MAX(CASE
WHEN currenttier='Mango Classic' THEN 1
WHEN currenttier='Mango Club' THEN 2
WHEN currenttier='Mango Black' THEN 3
WHEN currenttier='Mango White' THEN 4
WHEN currenttier='Mango Platinum' THEN 5
ELSE NULL END) AS TierNo,
currenttier AS Tier
FROM mango.tier_report_log 
WHERE DATE(tierchangedate)<='2025-06-30'
GROUP BY 1;#547969 row(s) affected


ALTER TABLE dummy.Umesh_migration_tier_Mango_2025_jun1_report  ADD INDEX mobile(mobile),
ADD INDEX max_tier_change_date(max_tier_change_date),ADD currenttier VARCHAR(50);


UPDATE dummy.Umesh_migration_tier_Mango_2025_jun1_report a
LEFT JOIN mango.tier_report_log b 
ON a.mobile =b.mobile
AND a.max_tier_change_date =DATE(b.tierchangedate) 
SET a.currenttier=b.currenttier, 
Tier=
CASE
WHEN TierNo=1 THEN 'Mango Classic'
WHEN TierNo=2 THEN 'Mango club'
WHEN TierNo=3 THEN 'Mango black'
WHEN TierNo=4 THEN 'Mango white'
WHEN TierNo=5 THEN 'Mango platinum'
ELSE NULL END #547969 row(s) affected

ALTER TABLE dummy.Umesh_migration_tier_Mango_2025_jun1_report 
CONVERT TO CHARACTER SET latin1 COLLATE 'latin1_swedish_ci';



#### CURRENT MONTH

CREATE TABLE dummy.Umesh_migration_tier_Mango_2025_jul2_report
(mobile VARCHAR(20),max_tier_change_date VARCHAR(20),TierNo VARCHAR(10),Tier VARCHAR(20));

INSERT INTO dummy.Umesh_migration_tier_Mango_2025_jul2_report(mobile,max_tier_change_date,TierNo,Tier)
SELECT mobile,MAX(DATE(tierchangedate))max_tier_change_date,
MAX(CASE
WHEN currenttier='Mango Classic' THEN 1
WHEN currenttier='Mango Club' THEN 2
WHEN currenttier='Mango Black' THEN 3
WHEN currenttier='Mango White' THEN 4
WHEN currenttier='Mango Platinum' THEN 5
ELSE NULL END) AS TierNo,
CurrentTier AS Tier
FROM mango.tier_report_log WHERE DATE(tierchangedate)<='2025-07-31'
GROUP BY 1;#562761 row(s) affected


ALTER TABLE dummy.Umesh_migration_tier_Mango_2025_jul2_report  ADD INDEX mobile(mobile),
ADD INDEX max_tier_change_date(max_tier_change_date),ADD currenttier VARCHAR(50);

UPDATE dummy.Umesh_migration_tier_Mango_2025_jul2_report a
LEFT JOIN mango.tier_report_log b 
ON a.mobile=b.mobile   
AND a.max_tier_change_date=DATE(b.tierchangedate)  
SET a.currenttier=b.currenttier, 
Tier=
CASE
WHEN TierNo=1 THEN 'Mango Classic'
WHEN TierNo=2 THEN 'Mango club'
WHEN TierNo=3 THEN 'Mango black'
WHEN TierNo=4 THEN 'Mango white'
WHEN TierNo=5 THEN 'Mango platinum'
ELSE NULL END #562761 row(s) affected


ALTER TABLE dummy.Umesh_migration_tier_Mango_2025_jul2_report 
CONVERT TO CHARACTER SET latin1 COLLATE 'latin1_swedish_ci';


SELECT a.Tier AS Previous_Month_Tier,b.tier AS Current_Month_Tier,COUNT(DISTINCT a.mobile)customers 
FROM dummy.Umesh_migration_tier_Mango_2025_jun1_report a
LEFT JOIN dummy.Umesh_migration_tier_Mango_2025_jul2_report b ON a.mobile = b.mobile GROUP BY 1,2;
