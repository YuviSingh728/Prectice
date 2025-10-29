############### Create Table#################
CREATE TABLE dummy.Umesh_CustomerSingleView(
User_id VARCHAR(20),Total_spend DECIMAL(12,2),Total_Bills INT,Total_Visits INT,First_Transaction_Date VARCHAR(50),
Last_Transaction_Date VARCHAR(50),First_Visit_ABV DECIMAL(12,2),Second_Visit_ABV DECIMAL(12,2),Recency INT,
Latency INT,First_Transaction_Store VARCHAR(100),Last_Transaction_Store VARCHAR(100),Favourite_Store VARCHAR(100),
Total_Qty_Purchased INT,ABV DECIMAL(12,2),ABS INT,Favourite_Category VARCHAR(100),Last_Store DECIMAL(12,2),
First_Store DECIMAL(12,2))

#################Upload Data ######################

LOAD DATA LOCAL INFILE "C:\\Users\\intern_dataanalyst2\\Downloads\\AA\\Naturebasket_mobile_level_data.csv"
INTO TABLE dummy.Umesh_natures1
CHARACTER SET 'latin1'
FIELDS TERMINATED BY '\t'
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

######### Customer SIngle view #######  
  
SELECT * FROM  dummy.Umesh_CustomerSingleView;
SHOW COLUMNS FROM dummy.Umesh_CustomerSingleView

#############Insert mobile#########

CREATE TABLE dummy.Umesh_sku_Dump_Apr_may_June
SELECT * FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30'  

SELECT * FROM dummy.Umesh_sku_Dump_Apr_may_June;

#####Total Spend,Bill,Visits,LastTxnDAte,FirstTxnDate,Recency#####
UPDATE dummy.Umesh_CustomerSingleView a JOIN
(SELECT txnmappedmobile,
SUM(itemnetamount) AS Sales,
COUNT(DISTINCT uniquebillno) AS bill, 
COUNT(DISTINCT modifiedtxndate) AS visits,
MAX(modifiedtxndate) AS lastTxnDate,
MIN(modifiedtxndate) AS FirstTxnDate,
DATEDIFF('2025-06-30',MAX(modifiedtxndate)) AS Recency
FROM dummy.Umesh_sku_Dump_Apr_may_June
GROUP BY 1)b
ON a.mobile=b.txnmappedmobile
SET a.total_spend=b.Sales,
    a.total_bills=b.bill,
    a.total_visits=b.visits,
    a.Last_Transaction_Date=b.lasttxndate,
    a.First_Transaction_Date=b.firsttxndate,
    a.Recency=b.recency;
#####Total Spend,Bill,Visits,LastTxnDAte,FirstTxnDate,Recency#####
    
      
      
      
#################First and Second Visit ABV#################### 
 
 UPDATE dummy.Umesh_CustomerSingleView b JOIN
 (SELECT txnmappedmobile,
SUM(CASE WHEN frequencyCount=1 THEN itemnetamount END)/
COUNT(DISTINCT CASE WHEN frequencyCount=1 THEN uniquebillno END) AS First_visit_ABV,
SUM(CASE WHEN frequencyCount=2 THEN itemnetamount END)/
COUNT(DISTINCT CASE WHEN frequencyCount=2 THEN uniquebillno END) AS Second_visit_ABV
FROM dummy.Umesh_sku_Dump_Apr_may_June
WHERE txnmappedmobile IN(SELECT DISTINCT txnmappedmobile FROM 
(SELECT txnmappedmobile,MIN(frequencycount) AS Min_feq FROM dummy.Umesh_sku_Dump_Apr_may_June
GROUP BY 1
HAVING Min_feq=1)a)
GROUP BY 1)a
ON b.mobile=a.txnmappedmobile
SET b.First_Visit_ABV=a.First_visit_ABV,
b.Second_Visit_ABV=a.Second_visit_ABV ##18317 row(s) affected, 395 warning(s)

#################First and Second Visit ABV#################### 



#################Latency##############

UPDATE dummy.Umesh_CustomerSingleView a JOIN
(SELECT txnmappedmobile,ROUND(DATEDIFF(MAX(modifiedtxndate),
MIN(modifiedtxndate))/NULLIF((COUNT(DISTINCT modifiedtxndate)-1),0))AS Latency
FROM dummy.Umesh_sku_Dump_Apr_may_June
GROUP BY 1) b
ON a.mobile = b.txnmappedmobile
SET a.Latency = b.Latency; #50327 row(s) affected

#################Latency##############


########ABV and ABS############

UPDATE dummy.Umesh_CustomerSingleView a JOIN
(SELECT txnmappedmobile,
COUNT(itemqty) AS TotalQty,SUM(itemnetamount)/COUNT(DISTINCT uniquebillno) AS ABV,
SUM(itemqty)/COUNT(DISTINCT uniquebillno) AS ABS FROM dummy.Umesh_sku_Dump_Apr_may_June a
GROUP BY 1)b
ON a.mobile=b.txnmappedmobile
SET a.Total_Qty_Purchased=b.TotalQty,
a.ABV=b.ABV,
a.ABS=b.ABS; #519086 row(s) affected, 18135 warning(s)

########ABV and ABS############


  
#############First_Transaction_Store##########

  UPDATE dummy.Umesh_CustomerSingleView a JOIN(
  SELECT txnmappedmobile,modifiedstore,modifiedtxndate FROM sku_report_loyalty
  WHERE txndate BETWEEN '2025-04-01' AND '2025-06-30')b
  ON a.mobile=b.txnmappedmobile AND a.First_Transaction_Date=b.modifiedtxndate
  SET a.First_Transaction_Store=b.modifiedstore;
  
#############First_Transaction_Store##########


##################Last_Transaction_Store#############

UPDATE dummy.Umesh_CustomerSingleView a JOIN(
SELECT txnmappedmobile,modifiedstore,modifiedtxndate FROM sku_report_loyalty
WHERE txndate BETWEEN '2025-04-01' AND '2025-06-30')b
ON a.mobile=b.txnmappedmobile AND a.Last_Transaction_Date =b.modifiedtxndate
SET a.Last_Transaction_Store=b.modifiedstore;
  
##################Last_Transaction_Store#############   


##################Favourite_Category###########

 UPDATE dummy.Umesh_CustomerSingleView a JOIN 
 (SELECT txnmappedmobile,categoryname,Qty,
 DENSE_RANK() OVER(PARTITION BY txnmappedmobile ORDER BY Qty DESC)DQty FROM
 (SELECT txnmappedmobile,categoryname,SUM(itemqty)Qty FROM 
 sku_report_loyalty a JOIN item_master  b ON a.uniqueitemcode=b.uniqueitemcode
 WHERE modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30'
 GROUP BY 1,2)a)b
 ON a.mobile=b.txnmappedmobile
 SET a.Favourite_Category=b.categoryname
 WHERE DQty=1; #514458 row(s) affected
 
##################Favourite_Category########### 


######################Favourite_Store############

UPDATE dummy.Umesh_CustomerSingleView p
JOIN(SELECT txnmappedmobile,modifiedstorecode,
ROW_NUMBER() OVER (PARTITION BY txnmappedMobile ORDER BY visit DESC) AS ranks,visit 
FROM(SELECT txnmappedmobile,modifiedstorecode,
COUNT(DISTINCT modifiedtxndate)visit
FROM sku_report_loyalty
WHERE  modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30' 
GROUP BY txnmappedmobile,modifiedstorecode ORDER BY 1
)b)q
ON p.mobile=q.txnmappedmobile 
SET p.Favourite_Store=q.modifiedstorecode
WHERE ranks=1;

######################Favourite_Store############


##########Last and First Store###########

ALTER TABLE dummy.Umesh_CustomerSingleView
MODIFY COLUMN first_store VARCHAR(50);


ALTER TABLE dummy.Umesh_CustomerSingleView
MODIFY COLUMN Last_store VARCHAR(50);

UPDATE dummy.Umesh_CustomerSingleView c JOIN
(SELECT mobile,modifiedstorecode,modifiedstore 
FROM dummy.Umesh_CustomerSingleView a JOIN dummy.Umesh_sku_Dump_Apr_may_June b 
ON a.mobile=b.txnmappedmobile AND a.First_Transaction_Date=b.modifiedtxndate)a
ON c.mobile=a.mobile 
SET c.First_Store=a.modifiedstorecode


UPDATE dummy.Umesh_CustomerSingleView c JOIN
(SELECT mobile,modifiedstorecode,modifiedstore 
FROM dummy.Umesh_CustomerSingleView a JOIN dummy.Umesh_sku_Dump_Apr_may_June b 
ON a.mobile=b.txnmappedmobile AND a.Last_Transaction_Date=b.modifiedtxndate)a
ON c.mobile=a.mobile 
SET c.Last_Store=a.modifiedstorecode ##18863 row(s) affected
 
##########Last and First Store########### 
 
 
#####################Drop Rate###############

SELECT CASE 
	WHEN Total_Visits=1 THEN '1'
	WHEN Total_Visits=2 THEN '2'
	WHEN Total_Visits=3 THEN '3'
	WHEN Total_Visits=4 THEN '4'
	WHEN Total_Visits=5 THEN '5'
	WHEN Total_Visits=6 THEN '6'
	WHEN Total_Visits>6 THEN '6+'
END AS `Total Visit`,COUNT(DISTINCT mobile) AS Customer,COUNT(total_bills) AS Bills,SUM(total_spend) AS Total_spend
FROM dummy.Umesh_CustomerSingleView
GROUP BY 1;
	
		
######################Drop Rate in Second Way########################

SELECT 
CASE WHEN Total_Visits<=6 THEN Total_Visits ELSE '6+' END tag,
COUNT(DISTINCT mobile) FROM dummy.Umesh_CustomerSingleView
GROUP BY 1;
	
#####################Drop Rate###############	
	
	
####################1st to 2nd Visit ABV Migration######################

SELECT CASE
	WHEN First_visit_ABV BETWEEN 0 AND 100  THEN '0-100'
	WHEN First_visit_ABV BETWEEN 101 AND 250 THEN '101-250'
	WHEN First_visit_ABV BETWEEN 251 AND 500 THEN '251-500'
	WHEN First_visit_ABV BETWEEN 501 AND 750 THEN '501-750'
	WHEN First_visit_ABV BETWEEN 751 AND 1000 THEN '751-1000'
	WHEN First_visit_ABV BETWEEN 1001 AND 1500 THEN '1001-1500'
	WHEN First_visit_ABV >1500 THEN '1500+' 
	END AS `First Visit ABV`,
	CASE
	WHEN Second_visit_ABV BETWEEN 0 AND 100  THEN '0-100'
	WHEN Second_visit_ABV BETWEEN 101 AND 250 THEN '101-250'
	WHEN Second_visit_ABV BETWEEN 251 AND 500 THEN '251-500'
	WHEN Second_visit_ABV BETWEEN 501 AND 750 THEN '501-750'
	WHEN Second_visit_ABV BETWEEN 751 AND 1000 THEN '751-1000'
	WHEN Second_visit_ABV BETWEEN 1001 AND 1500 THEN '1001-1500'
	WHEN Second_visit_ABV>1500 THEN '1500+' 
	END AS `Second Visit ABV`,COUNT(DISTINCT txnmappedmobile) AS mobile FROM 
(SELECT txnmappedmobile,
SUM(CASE WHEN frequencyCount=1 THEN itemnetamount END)/
COUNT(DISTINCT CASE WHEN frequencyCount=1 THEN uniquebillno END) AS First_visit_ABV,
SUM(CASE WHEN frequencyCount=2 THEN itemnetamount END)/
COUNT(DISTINCT CASE WHEN frequencyCount=2 THEN uniquebillno END) AS Second_visit_ABV
FROM dummy.Umesh_sku_Dump_Apr_may_June
WHERE txnmappedmobile IN(SELECT DISTINCT txnmappedmobile FROM 
(SELECT txnmappedmobile,MIN(frequencycount) AS Min_feq FROM dummy.Umesh_sku_Dump_Apr_may_June
GROUP BY 1
HAVING Min_feq=1)a)
GROUP BY 1)b
GROUP BY 1,2;

####################1st to 2nd Visit ABV Migration######################



##########################Brand Lapsation######################

CREATE TABLE dummy.Umesh_sku_Dump_Apr_may_June
SELECT * FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30';

INSERT INTO dummy.distinctmobile
SELECT DISTINCT txnmappedmobile AS mobile FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2025-06-30' AND frequencycount>1;


SELECT 
	CASE 
	WHEN DaysSinceLastVisit BETWEEN 0 AND 30 THEN '0-30'
	WHEN DaysSinceLastVisit BETWEEN 31 AND 60 THEN '31-60'
	WHEN DaysSinceLastVisit BETWEEN 61 AND 90 THEN '61-90'
	WHEN DaysSinceLastVisit BETWEEN 91 AND 120 THEN '91-120'	
	WHEN DaysSinceLastVisit BETWEEN 121 AND 150 THEN '121-150'
	WHEN DaysSinceLastVisit BETWEEN 151 AND 180 THEN '151-180'
	WHEN DaysSinceLastVisit BETWEEN 181 AND 210 THEN '181-210'
	WHEN DaysSinceLastVisit BETWEEN 211 AND 240 THEN '211-240'
	WHEN DaysSinceLastVisit BETWEEN 241 AND 270 THEN '241-270'
	WHEN DaysSinceLastVisit BETWEEN 271 AND 300 THEN '271-300'
	WHEN DaysSinceLastVisit BETWEEN 301 AND 330 THEN '301-330'
	WHEN DaysSinceLastVisit BETWEEN 331 AND 360 THEN '331-360'
	WHEN DaysSinceLastVisit >360 THEN '360+'
	END AS DaysSinceLastVisit,COUNT(DISTINCT UNIQUEBILLNO) AS No_Of_Bills
	FROM sku_report_loyalty a JOIN dummy.distinctmobile b ON a.txnmappedmobile=b.mobile
	WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2025-06-30'
	GROUP BY 1
	ORDER BY DaysSinceLastVisit;
	

##########################Brand Lapsation######################
	


#########################Cohort######################

SELECT MONTHNAME(a.FirsttxnDate) AS firstmonth,MONTHNAME(b.modifiedtxndate) AS Txn_month,
COUNT(DISTINCT a.txnmappedmobile) AS Total_customer FROM 
(SELECT txnmappedmobile,MIN(modifiedtxndate) AS FirsttxnDate FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-01-01' AND '2024-12-31' 
GROUP BY 1)a JOIN 
(SELECT txnmappedmobile,modifiedtxndate FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-01-01' AND '2024-12-31' 
GROUP BY 1,2)b ON a.txnmappedmobile=b.txnmappedmobile
GROUP BY 1,2

#########################Cohort######################



###########Category Penetration############

SELECT CategoryName,COUNT(DISTINCT uniquebillno) AS Bills,COUNT(DISTINCT txnmappedmobile) AS Total_Customer,
SUM(itemnetamount) AS Total_Sales,SUM(DISTINCT itemqty) AS QtySold FROM item_master a
JOIN sku_report_loyalty b ON a.uniqueitemcode=b.uniqueitemcode
WHERE modifiedtxndate BETWEEN '2025-06-15' AND '2025-06-20'
GROUP BY 1;

###########Category Penetration############



##################Market Basket Analysis###############

CREATE TABLE dummy.CategoryNew
SELECT DISTINCT categoryName,uniquebillno FROM sku_report_loyalty a
JOIN item_master b ON a.uniqueitemcode=b.uniqueitemcode
WHERE modifiedtxndate BETWEEN '2025-01-01' AND '2025-06-30' AND categoryName IN('SHOE','SLIPPER','SANDAL',
'SOCKS','PANTS','T-SHIRTS','SHORTS','TOPS','JACKETS','LEGGINGS');
		
SELECT a.categoryName,b.categoryName,COUNT(DISTINCT a.uniquebillno)bills 
FROM dummy.Categorynew a JOIN dummy.Categorynew b ON a.uniquebillno=b.uniquebillno
GROUP BY 1,2;

##################Market Basket Analysis###############

################KPIs code for One Timer###################


SELECT COUNT(DISTINCT txnmappedmobile) AS membe,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS `repeater`,
COUNT(DISTINCT uniquebillno) AS bill,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END) AS `Repeaters bills`,
SUM(itemnetamount) AS Total_Sale,SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS `Repeater Sale`,
SUM(itemnetamount)/COUNT(DISTINCT txnmappedmobile) AS Avg_member_value,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END)/
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END)AS `Repeaters AMV`,
SUM(itemnetamount)/COUNT(DISTINCT uniquebillno) AS ABV,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END)/
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END) AS `Repeater ATV`,
AVG(frequencycount) AS Avg_Feq
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2025-05-01' AND '2025-05-31';

################KPIs code for One Timer###################

################KPIs code for Repeater###################

SELECT COUNT(DISTINCT txnmappedmobile) AS membe,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS `repeater`,
COUNT(DISTINCT uniquebillno) AS bill,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END) AS `Repeaters bills`,
SUM(itemnetamount) AS Total_Sale,SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS `Repeater Sale`,
SUM(itemnetamount)/COUNT(DISTINCT txnmappedmobile) AS Avg_member_value,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END)/
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END)AS `Repeaters AMV`,
SUM(itemnetamount)/COUNT(DISTINCT uniquebillno) AS ABV,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END)/
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END) AS `Repeater ATV`,
AVG(frequencycount) AS Avg_Feq
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2025-06-01' AND '2025-06-30';

################KPIs code for Repeater###################

###############Days Since Last Visit##########


SELECT 
    mobile,
    txndate,
    LAG(txndate) OVER(PARTITION BY mobile ORDER BY txndate) AS visit,
    DATEDIFF(txndate, LAG(txndate) OVER(PARTITION BY mobile ORDER BY txndate)) AS dslv
FROM txn_report_accrual_redemption
-- WHERE txndate>'2025-01-01'
ORDER BY mobile, txndate;

	
