################## Overall Data##################


SELECT 
	CASE 
		WHEN modifiedtxndate BETWEEN '2022-04-01' AND '2023-03-31' THEN 'Apr-Mar-22_23'
		WHEN modifiedtxndate BETWEEN '2023-04-01' AND '2024-03-31' THEN 'Apr-Mar-23_24'
		WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' THEN 'Apr-Mar-24_25'
		END AS `Period`,
COUNT(DISTINCT modifiedstorecode) AS Txn_Store,COUNT(DISTINCT txnmappedmobile) AS txncustomer,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS Repeater,
SUM(itemnetamount) AS Loyalty_Sales,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS Repeater_Sales,
COUNT(DISTINCT uniquebillno) AS Loyalty_BIlls,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END) AS Repeater_Bills,
SUM(itemnetamount)/COUNT(DISTINCT txnmappedmobile) AS AMV,
SUM(itemnetamount)/COUNT(DISTINCT uniquebillno) AS AOV,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END)/
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END) AS Repeater_AOV,
COUNT(DISTINCT txnmappedmobile, modifiedtxndate) AS Visit
FROM sku_report_loyalty
WHERE ((modifiedtxndate BETWEEN '2022-04-01' AND '2023-03-31')OR
(modifiedtxndate BETWEEN '2023-04-01' AND '2024-03-31')OR
(modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'))
GROUP BY 1;


SELECT
	CASE 
		WHEN modifiedtxndate BETWEEN '2022-04-01' AND '2023-03-31' THEN 'Apr-Mar-22_23'
		WHEN modifiedtxndate BETWEEN '2023-04-01' AND '2024-03-31' THEN 'Apr-Mar-23_24'
		WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' THEN 'Apr-Mar-24_25'
		END AS `Period`,
COUNT(DISTINCT enrolledstorecode) AS Enroll_Store,
COUNT(DISTINCT mobile) AS enrolled_Cust
FROM member_report
WHERE ((modifiedtxndate BETWEEN '2022-04-01' AND '2023-03-31')OR
(modifiedtxndate BETWEEN '2023-04-01' AND '2024-03-31')OR
(modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'))
GROUP BY 1;


SELECT
	CASE 
		WHEN modifiedtxndate BETWEEN '2022-04-01' AND '2023-03-31' THEN 'Apr-Mar-22_23'
		WHEN modifiedtxndate BETWEEN '2023-04-01' AND '2024-03-31' THEN 'Apr-Mar-23_24'
		WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' THEN 'Apr-Mar-24_25'
		END AS `Period`,SUM(itemnetamount) AS Nonloyalty_sale,
COUNT(DISTINCT uniquebillno) AS nonloyalty_Bills
FROM sku_report_nonloyalty
WHERE ((modifiedtxndate BETWEEN '2022-04-01' AND '2023-03-31')OR
(modifiedtxndate BETWEEN '2023-04-01' AND '2024-03-31')OR
(modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'))
GROUP BY 1;

###One Timer

SELECT PERIOD,
COUNT(DISTINCT CASE WHEN max_f=1 THEN txnmappedmobile END) AS One_Timer,
SUM(CASE WHEN max_f=1 THEN loyalty_sale END)/
SUM( CASE WHEN max_f=1 THEN loyalty_Bills END) AS One_Timer_AOV
FROM
(SELECT
	CASE 
		WHEN modifiedtxndate BETWEEN '2022-04-01' AND '2023-03-31' THEN 'Apr-Mar-22_23'
		WHEN modifiedtxndate BETWEEN '2023-04-01' AND '2024-03-31' THEN 'Apr-Mar-23_24'
		WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' THEN 'Apr-Mar-24_25'
		END AS `Period`,SUM(itemnetamount) AS loyalty_sale,txnmappedmobile,
COUNT(DISTINCT uniquebillno) AS loyalty_Bills,
MIN(modifiedtxndate) AS min_F,MAX(modifiedtxndate) AS Max_f
FROM sku_report_loyalty
WHERE ((modifiedtxndate BETWEEN '2022-04-01' AND '2023-03-31')OR
(modifiedtxndate BETWEEN '2023-04-01' AND '2024-03-31')OR
(modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'))
GROUP BY 1)a
GROUP BY 1;

################### MoM Data#############

SELECT  CONCAT(LEFT(MONTHNAME(modifiedtxndate),3), '-', RIGHT(YEAR(modifiedtxndate),2)) AS PERIOD, 
COUNT(DISTINCT modifiedstorecode) AS Txn_Store,COUNT(DISTINCT txnmappedmobile) AS txncustomer,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS Repeater,
SUM(itemnetamount) AS Loyalty_Sales,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS Repeater_Sales,
COUNT(DISTINCT uniquebillno) AS Loyalty_BIlls,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END) AS Repeater_Bills,
SUM(itemnetamount)/COUNT(DISTINCT txnmappedmobile) AS AMV,
SUM(itemnetamount)/COUNT(DISTINCT uniquebillno) AS AOV,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END)/
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END) AS Repeater_AOV,
COUNT(DISTINCT txnmappedmobile, modifiedtxndate) AS Visit
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2022-04-01' AND '2025-03-31'
GROUP BY 1;


SELECT
CONCAT(LEFT(MONTHNAME(enrolledon),3), '-', RIGHT(YEAR(enrolledon),2)) AS PERIOD
COUNT(DISTINCT mobile) AS enrolled_Cust
FROM member_report
WHERE enrolledon BETWEEN '2022-04-01' AND '2025-03-31'
GROUP BY 1;


SELECT
CONCAT(LEFT(MONTHNAME(modifiedtxndate),3), '-', RIGHT(YEAR(modifiedtxndate),2)) AS PERIOD,
SUM(itemnetamount) AS Nonloyalty_sale,
COUNT(DISTINCT uniquebillno) AS nonloyalty_Bills
FROM sku_report_nonloyalty
WHERE modifiedtxndate BETWEEN '2022-04-01' AND '2025-03-31'
GROUP BY 1;


###################### Drop Rate######################

SELECT 	
	CASE
		WHEN dayssincelastvisit BETWEEN 0 AND 60 THEN '0-60'
		WHEN dayssincelastvisit BETWEEN 61 AND 120 THEN '61-120'
		WHEN dayssincelastvisit BETWEEN 121 AND 240 THEN '121-240'
		WHEN dayssincelastvisit BETWEEN 241 AND 360 THEN '241-360'
		WHEN dayssincelastvisit BETWEEN 361 AND 480 THEN '361-480'
		WHEN dayssincelastvisit BETWEEN 481 AND 600 THEN '481-600'
		WHEN dayssincelastvisit BETWEEN 601 AND 720 THEN '601-720'
		WHEN dayssincelastvisit BETWEEN 721 AND 840 THEN '721-840'
		WHEN dayssincelastvisit BETWEEN 841 AND 960 THEN '841-960'
		WHEN dayssincelastvisit BETWEEN 961 AND 1080 THEN '961-1080'
		WHEN dayssincelastvisit>1080 THEN '1080+'
		END AS `DSLV Band`,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END) AS `Repeat Bills`
FROM sku_report_loyalty
  
 
############### OneTimer and Repeater##############

SELECT 
	CASE 
		WHEN visit=1 THEN '1'
		WHEN visit=2 THEN '2'
		WHEN visit=3 THEN '3'
		WHEN visit=4 THEN '4'
		WHEN visit=5 THEN '5'
		WHEN visit=6 THEN '6'
		WHEN visit=7 THEN '7'
		WHEN visit=8 THEN '8'
		WHEN visit=9 THEN '9'
		WHEN visit=10 THEN '10'
		WHEN visit>10+ THEN '10+'
		END AS `Visits`,
COUNT(DISTINCT txnmappedmobile) AS Txn_Customer
FROM		
(SELECT txnmappedmobile,
COUNT(DISTINCT modifiedtxndate,txnmappedmobile) AS Visit
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'
GROUP BY 1) a
GROUP BY 1;

##Overall data

SELECT 
	CASE 
		WHEN visit=1 THEN '1'
		WHEN visit=2 THEN '2'
		WHEN visit=3 THEN '3'
		WHEN visit=4 THEN '4'
		WHEN visit=5 THEN '5'
		WHEN visit=6 THEN '6'
		WHEN visit=7 THEN '7'
		WHEN visit=8 THEN '8'
		WHEN visit=9 THEN '9'
		WHEN visit=10 THEN '10'
		WHEN visit>10+ THEN '10+'
		END AS `Visits`,
COUNT(DISTINCT txnmappedmobile) AS Txn_Customer
FROM		
(SELECT txnmappedmobile,
COUNT(DISTINCT modifiedtxndate,txnmappedmobile) AS Visit
FROM sku_report_loyalty
WHERE modifiedtxndate<='2025-08-31'
GROUP BY 1) a
GROUP BY 1;

###############Store Data Overall ###################

SELECT storecode,lpaasstore,SUM(itemnetamount) AS Loyalty_Sales,
COUNT(DISTINCT uniquebillno) AS Loyalty_Bills,
SUM(itemnetamount)/COUNT(DISTINCT uniquebillno) AS ATV,
COUNT(DISTINCT txnmappedmobile) AS Txn_Customer
FROM sku_report_loyalty a
JOIN store_master b
ON a.modifiedstorecode=b.storecode
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'
GROUP BY 1,2;

SELECT storecode,lpaasstore,COUNT(DISTINCT mobile) AS Enrollement 
FROM member_report a
JOIN store_master b
ON a.enrolledstorecode=b.storecode
WHERE enrolledon BETWEEN '2024-04-01' AND '2025-03-31'
GROUP BY 1,2;

SELECT storecode,lpaasstore,COUNT(DISTINCT uniquebillno) AS nonloyalty_bills,
SUM(itemnetamount) AS nonloyalty_sales 
FROM sku_report_nonloyalty a
JOIN store_master b
ON a.enrolledstorecode=b.storecode
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'
GROUP BY 1,2;

SELECT b.storecode,lpaasstore,SUM(pointscollected) AS point_issued,
SUM(pointsspent) AS point_redeemed 
FROM txn_report_accrual_redemption a
JOIN store_master b
ON a.storecode=b.storecode
WHERE txndate BETWEEN '2024-04-01' AND '2025-03-31'
GROUP BY 1,2;



##############StateWise Data ####################


SELECT state,COUNT(DISTINCT modifiedstorecode) AS `Store Count`,
SUM(itemnetamount) AS Loyalty_Sales,COUNT(DISTINCT uniquebillno) AS Loyalty_Bills,
SUM(itemnetamount)/COUNT(DISTINCT uniquebillno) AS ATV,
COUNT(DISTINCT txnmappedmobile) AS Txn_Customer
FROM sku_report_loyalty a
JOIN store_master b
ON a.modifiedstorecode=b.storecode
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'
GROUP BY 1;

SELECT state,COUNT(DISTINCT mobile) AS Enrollement 
FROM member_report a
JOIN store_master b
ON a.enrolledstorecode=b.storecode
WHERE enrolledon BETWEEN '2024-04-01' AND '2025-03-31'
GROUP BY 1,2;

SELECT state,COUNT(DISTINCT uniquebillno) AS nonloyalty_bills,
SUM(itemnetamount) AS nonloyalty_sales 
FROM sku_report_nonloyalty a
JOIN store_master b
ON a.enrolledstorecode=b.storecode
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'
GROUP BY 1,2;

SELECT state,SUM(pointscollected) AS point_issued,
SUM(pointsspent) AS point_redeemed 
FROM txn_report_accrual_redemption a
JOIN store_master b
ON a.storecode=b.storecode
WHERE txndate BETWEEN '2024-04-01' AND '2025-03-31'
GROUP BY 1,2;



###################Region Wise Data #####################
############Overall Data Regio Wise

SELECT 
	region,
COUNT(DISTINCT txnmappedmobile) AS txncustomer,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS Repeater,
SUM(itemnetamount) AS Loyalty_Sales,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS Repeater_Sales,
COUNT(DISTINCT uniquebillno) AS Loyalty_BIlls,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END) AS Repeater_Bills,
SUM(itemnetamount)/COUNT(DISTINCT txnmappedmobile) AS AMV,
SUM(itemnetamount)/COUNT(DISTINCT uniquebillno) AS AOV,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END)/
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END) AS Repeater_AOV,
COUNT(DISTINCT txnmappedmobile, modifiedtxndate) AS Visit
FROM sku_report_loyalty a
JOIN store_master b
ON a.modifiedstorecode=b.storecode
WHERE modifiedtxndate<='2025-08-31'
GROUP BY 1;


SELECT
	COUNT(DISTINCT mobile) AS enrolled_Cust
FROM member_report
GROUP BY 1;


SELECT
	SUM(itemnetamount) AS Nonloyalty_sale,
COUNT(DISTINCT uniquebillno) AS nonloyalty_Bills
FROM sku_report_nonloyalty
GROUP BY 1;

###One Timer

SELECT 
COUNT(DISTINCT CASE WHEN max_f=1 THEN txnmappedmobile END) AS One_Timer,
SUM(CASE WHEN max_f=1 THEN loyalty_sale END)/
SUM( CASE WHEN max_f=1 THEN loyalty_Bills END) AS One_Timer_AOV
FROM
(SELECT SUM(itemnetamount) AS loyalty_sale,txnmappedmobile,
COUNT(DISTINCT uniquebillno) AS loyalty_Bills,
MIN(modifiedtxndate) AS min_F,MAX(modifiedtxndate) AS Max_f
FROM sku_report_loyalty
GROUP BY 1)a
GROUP BY 1;


############ FY Data Region wise
SELECT 
	CASE 
		WHEN modifiedtxndate BETWEEN '2022-04-01' AND '2023-03-31' THEN 'Apr-Mar-22_23'
		WHEN modifiedtxndate BETWEEN '2023-04-01' AND '2024-03-31' THEN 'Apr-Mar-23_24'
		WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' THEN 'Apr-Mar-24_25'
		END AS `Period`,region,
COUNT(DISTINCT modifiedstorecode) AS Txn_Store,COUNT(DISTINCT txnmappedmobile) AS txncustomer,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS Repeater,
SUM(itemnetamount) AS Loyalty_Sales,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS Repeater_Sales,
COUNT(DISTINCT uniquebillno) AS Loyalty_BIlls,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END) AS Repeater_Bills,
SUM(itemnetamount)/COUNT(DISTINCT txnmappedmobile) AS AMV,
SUM(itemnetamount)/COUNT(DISTINCT uniquebillno) AS AOV,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END)/
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END) AS Repeater_AOV,
COUNT(DISTINCT txnmappedmobile, modifiedtxndate) AS Visit
FROM sku_report_loyalty a
JOIN store_master b
ON a.modifiedstorecode=b.storecode
WHERE ((modifiedtxndate BETWEEN '2022-04-01' AND '2023-03-31')OR
(modifiedtxndate BETWEEN '2023-04-01' AND '2024-03-31')OR
(modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'))
GROUP BY 1,2;


SELECT
	CASE 
		WHEN modifiedtxndate BETWEEN '2022-04-01' AND '2023-03-31' THEN 'Apr-Mar-22_23'
		WHEN modifiedtxndate BETWEEN '2023-04-01' AND '2024-03-31' THEN 'Apr-Mar-23_24'
		WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' THEN 'Apr-Mar-24_25'
		END AS `Period`,
COUNT(DISTINCT enrolledstorecode) AS Enroll_Store,
COUNT(DISTINCT mobile) AS enrolled_Cust
FROM member_report
WHERE ((modifiedtxndate BETWEEN '2022-04-01' AND '2023-03-31')OR
(modifiedtxndate BETWEEN '2023-04-01' AND '2024-03-31')OR
(modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'))
GROUP BY 1;


SELECT
	CASE 
		WHEN modifiedtxndate BETWEEN '2022-04-01' AND '2023-03-31' THEN 'Apr-Mar-22_23'
		WHEN modifiedtxndate BETWEEN '2023-04-01' AND '2024-03-31' THEN 'Apr-Mar-23_24'
		WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' THEN 'Apr-Mar-24_25'
		END AS `Period`,SUM(itemnetamount) AS Nonloyalty_sale,
COUNT(DISTINCT uniquebillno) AS nonloyalty_Bills
FROM sku_report_nonloyalty
WHERE ((modifiedtxndate BETWEEN '2022-04-01' AND '2023-03-31')OR
(modifiedtxndate BETWEEN '2023-04-01' AND '2024-03-31')OR
(modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'))
GROUP BY 1;

###One Timer

SELECT PERIOD,
COUNT(DISTINCT CASE WHEN max_f=1 THEN txnmappedmobile END) AS One_Timer,
SUM(CASE WHEN max_f=1 THEN loyalty_sale END)/
SUM( CASE WHEN max_f=1 THEN loyalty_Bills END) AS One_Timer_AOV
FROM
(SELECT
	CASE 
		WHEN modifiedtxndate BETWEEN '2022-04-01' AND '2023-03-31' THEN 'Apr-Mar-22_23'
		WHEN modifiedtxndate BETWEEN '2023-04-01' AND '2024-03-31' THEN 'Apr-Mar-23_24'
		WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' THEN 'Apr-Mar-24_25'
		END AS `Period`,SUM(itemnetamount) AS loyalty_sale,txnmappedmobile,
COUNT(DISTINCT uniquebillno) AS loyalty_Bills,
MIN(modifiedtxndate) AS min_F,MAX(modifiedtxndate) AS Max_f
FROM sku_report_loyalty
WHERE ((modifiedtxndate BETWEEN '2022-04-01' AND '2023-03-31')OR
(modifiedtxndate BETWEEN '2023-04-01' AND '2024-03-31')OR
(modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'))
GROUP BY 1)a
GROUP BY 1;



#################Product Behaviour###########

SELECT CategoryName,subcategoryName,b.uniqueitemname,SUM(itemnetamount) AS Sale,
COUNT(DISTINCT txnmappedmobile) AS Customer,COUNT(DISTINCT uniquebillno) AS Bills,
SUM(itemqty) AS Qty
FROM sku_report_loyalty a
JOIN item_master b
ON a.uniqueitemcode=b.uniqueitemcode
WHERE modifiedtxndate<='2025-08-31'
AND itemnetamount>0
GROUP BY 1,2,3;


############Product Seasonality##############

SELECT CONCAT(LEFT(MONTHNAME(modifiedtxndate),3), '-', RIGHT(YEAR(modifiedtxndate),2)) AS Month_Year,
DepartmentName,CategoryName,SubCategoryName,b.UniqueItemName,SUM(itemnetamount) AS Sales,
COUNT(DISTINCT uniquebillno) AS Bills,COUNT(DISTINCT txnmappedmobile) AS Customer,
SUM(itemqty) AS Qty
FROM sku_report_loyalty a
JOIN item_master b
ON a.uniqueitemcode=b.uniqueitemcode
GROUP BY 1,2;

##################MBA#############

######Category Wise

CREATE TABLE dummy.Celio_MBA_Data_Umesh_1_1 AS
SELECT DISTINCT Txnmappedmobile,uniquebillno,CategoryName,subcategoryname,b.UniqueItemName,a.uniqueitemcode FROM sku_report_loyalty a
JOIN item_master b ON a.uniqueitemcode = b.uniqueitemcode;#736447 row(s) affected

ALTER TABLE dummy.Celio_MBA_Data_Umesh_1_1 ADD INDEX Billno(uniquebillno);
ALTER TABLE dummy.Celio_MBA_Data_Umesh_1_1 ADD INDEX Sub_Cat(subcategoryname);

SELECT a.Categoryname AS Category1,b.Categoryname AS Category2,COUNT(DISTINCT a.uniquebillno) AS Bills,
COUNT(DISTINCT a.Txnmappedmobile) AS Customer FROM dummy.Celio_MBA_Data_Umesh_1_1 a
JOIN dummy.Celio_MBA_Data_Umesh_1_1 b ON a.uniquebillno = b.uniquebillno 
GROUP BY 1,2;


#######Sub Category Wise

SELECT a.SubCategoryname AS Sub_Category1,b.SubCategoryname AS Sub_Category2,COUNT(DISTINCT a.uniquebillno) AS Bills,
COUNT(DISTINCT a.Txnmappedmobile) AS Customer FROM dummy.Celio_MBA_Data_Umesh_1_1 a
JOIN dummy.Celio_MBA_Data_Umesh_1_1 b ON a.uniquebillno = b.uniquebillno 
GROUP BY 1,2;

#######UniqueItem Name Wise

SELECT a.UniqueItemName AS Unique_Item1,b.UniqueItemName AS Unique_Item2,COUNT(DISTINCT a.uniquebillno)bills,
COUNT(DISTINCT a.Txnmappedmobile) AS Customer
FROM dummy.Celio_MBA_Data_Umesh_1_1 a JOIN dummy.Celio_MBA_Data_Umesh_1_1 b ON a.uniquebillno=b.uniquebillno
AND a.uniqueitemcode=b.uniqueitemcode
GROUP BY 1,2;


#####################Combo And Visit Analysis#################
 
WITH Sub AS(SELECT Txnmappedmobile,MAX(frequencycount) AS Max_f,
GROUP_CONCAT(DISTINCT CASE WHEN frequencycount=1 THEN b.subcategoryname END) AS f1_subcat,
GROUP_CONCAT(DISTINCT CASE WHEN frequencycount=2 THEN b.subcategoryname END) AS f2_subcat,
SUM(CASE WHEN frequencycount=1 THEN itemnetamount END) AS f1_Sales,
SUM(CASE WHEN frequencycount=2 THEN itemnetamount END) AS f2_Sales
FROM sku_report_loyalty a
JOIN item_master b
ON a.uniqueitemcode=b.uniqueitemcode
GROUP BY Txnmappedmobile)
SELECT f1_subcat,f2_subcat,SUM(f1_Sales) AS f1_Sales,SUM(f2_Sales) AS f2_Sales,
COUNT(DISTINCT txnmappedmobile) AS Customer
FROM sub 
WHERE f1_subcat IS NOT NULL 
AND f2_subcat IS NOT NULL
GROUP BY f1_subcat,f2_subcat;


WITH Sub AS(SELECT Txnmappedmobile,
GROUP_CONCAT(DISTINCT CASE WHEN frequencycount=1 THEN b.subcategoryname END) AS f1_subcat,
GROUP_CONCAT(DISTINCT CASE WHEN frequencycount=3 THEN b.subcategoryname END) AS f3_subcat,
SUM(CASE WHEN frequencycount=1 THEN itemnetamount END) AS f1_Sales,
SUM(CASE WHEN frequencycount=3 THEN itemnetamount END) AS f3_Sales
FROM sku_report_loyalty a
JOIN item_master b
ON a.uniqueitemcode=b.uniqueitemcode
GROUP BY Txnmappedmobile)
SELECT f1_subcat,f3_subcat,SUM(f1_Sales) AS f1_Sales,SUM(f3_Sales) AS f3_Sales,
COUNT(DISTINCT txnmappedmobile) AS Customer
FROM sub 
WHERE f1_subcat IS NOT NULL 
AND f3_subcat IS NOT NULL
GROUP BY f1_subcat,f3_subcat;


############Recency Cohort###################

SELECT 
CONCAT(LEFT(MONTHNAME(modifiedtxndate),3), '-', RIGHT(YEAR(modifiedtxndate),2)) AS Month_Year,
CASE 
WHEN recency BETWEEN 31 AND 60 THEN '30-60'
WHEN recency BETWEEN 31 AND 60 THEN '30-60'
WHEN recency BETWEEN 61 AND 90 THEN '60-90'
WHEN recency>91 THEN '90+'
END AS `Recency Cohort`,
COUNT(DISTINCT txnmappedmobile) AS Customer
FROM
(SELECT 
txnmappedmobile,modifiedtxndate,
DATEDIFF('2025-08-31',MAX(modifiedtxndate)) AS Recency
FROM sku_report_loyalty
GROUP BY 1) a
GROUP BY 1,2;


SELECT 
DATE_FORMAT(modifiedtxndate,'%b-%y') AS Month_Year,
CASE 
WHEN dayssincelastvisit <=30 THEN '0-30'
WHEN dayssincelastvisit <=60 THEN '30-60'
WHEN dayssincelastvisit <=90 THEN '60-90'
WHEN dayssincelastvisit <=180 THEN '90-180'
WHEN dayssincelastvisit <=365 THEN '181-365'
WHEN dayssincelastvisit <=730 THEN '366-730'
WHEN dayssincelastvisit>730 THEN '730+'
END AS `Recency Cohort`,
COUNT(DISTINCT txnmappedmobile) AS Customer
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2023-07-01' AND '2025-06-30'
AND frequencycount='2'
GROUP BY 1,2
ORDER BY 2;







