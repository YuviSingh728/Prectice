###############SingleView For ThomasCook##############

CREATE TABLE dummy.Thomascook_SingleView
SELECT txnmappedmobile,SUM(itemnetamount) AS sales,COUNT(DISTINCT uniquebillno) AS Bills,
COUNT(DISTINCT txnmappedmobile,modifiedtxndate) AS Visit,SUM(itemqty) AS Qty,
TIMESTAMPDIFF(YEAR, dateofbirth, CURDATE()) AS Age,enrolledstorecode,City,State,
MAX(modifiedtxndate)Last_Txn_Date FROM sku_report_loyalty a
LEFT JOIN member_report b
ON a.txnmappedmobile=b.mobile
JOIN Store_master c
ON a.modifiedstorecode=c.storecode
GROUP BY 1;#20263

ALTER TABLE dummy.Thomascook_SingleView ADD INDEX mobile(txnmappedmobile);

ALTER TABLE dummy.Thomascook_SingleView ADD COLUMN Is_Repeater INT;

############Is Repeater Tag##########
ALTER TABLE dummy.Thomascook_SingleView ADD COLUMN Is_Repeater_1 VARCHAR(100);

UPDATE dummy.Thomascook_SingleView a JOIN (
SELECT DISTINCT txnmappedmobile FROM sku_report_loyalty
WHERE frequencycount>1 
AND insertiondate <='2025-09-24'
) b USING(txnmappedmobile)
SET Is_Repeater_1='repeater'; #repeater;#2897,4062

UPDATE dummy.Thomascook_SingleView a JOIN sku_report_loyalty b USING(txnmappedmobile)
SET Is_Repeater_1='onetimer' #mean onetimer 
WHERE Is_Repeater_1 IS NULL;#17366,28806

################ Last_Txn_Date

ALTER TABLE dummy.Thomascook_SingleView ADD COLUMN Last_Txn_Date VARCHAR(50);

UPDATE dummy.Thomascook_SingleView a JOIN(
SELECT txnmappedmobile,MAX(modifiedtxndate)last_txn_date FROM sku_report_loyalty
GROUP BY 1) b 
 ON a.txnmappedmobile=b.txnmappedmobile 
SET a.last_txn_date=b.last_txn_date;

################# Last_Txn_Store

ALTER TABLE dummy.Thomascook_SingleView ADD COLUMN Last_Txn_Store VARCHAR(200);

UPDATE dummy.Thomascook_SingleView a JOIN sku_report_loyalty b 
ON a.txnmappedmobile=b.txnmappedmobile 
AND a.last_txn_date=b.modifiedtxndate 
SET a.Last_Txn_Store=b.modifiedstorecode;##32868

################### Last_Txn City and State

ALTER TABLE dummy.Thomascook_SingleView ADD COLUMN Last_Txn_City VARCHAR(200),ADD COLUMN Last_Txn_State VARCHAR(200);

UPDATE dummy.Thomascook_SingleView a JOIN Store_master b 
ON a.Last_Txn_Store=b.storecode 
SET a.Last_Txn_City=b.city,
 a.Last_Txn_State=b.State;##19885
 
############## First_Visit_Product_Purchase
 
ALTER TABLE dummy.Thomascook_SingleView ADD COLUMN First_Visit_Product_Purchase VARCHAR(200);

UPDATE dummy.Thomascook_SingleView a JOIN (
SELECT txnmappedmobile,uniqueitemcode FROM sku_report_loyalty
WHERE frequencycount=1
AND uniqueitemcode<>''
GROUP BY 1) b
ON a.txnmappedmobile=b.txnmappedmobile
SET a.First_Visit_Product_Purchase=b.uniqueitemcode;##32467

###################### Second_Visit_Product_Purchase

ALTER TABLE dummy.Thomascook_SingleView ADD COLUMN Second_Visit_Product_Purchase VARCHAR(200);
 
UPDATE dummy.Thomascook_SingleView a JOIN (
SELECT txnmappedmobile,uniqueitemcode FROM sku_report_loyalty
WHERE frequencycount=2
AND uniqueitemcode<>''
GROUP BY 1) b
ON a.txnmappedmobile=b.txnmappedmobile
SET a.Second_Visit_Product_Purchase=b.uniqueitemcode;##4011

###################### Third_Visit_Product_Purchase

ALTER TABLE dummy.Thomascook_SingleView ADD COLUMN Third_Visit_Product_Purchase VARCHAR(200);

UPDATE dummy.Thomascook_SingleView a JOIN (
SELECT txnmappedmobile,uniqueitemcode FROM sku_report_loyalty
WHERE frequencycount=3
AND uniqueitemcode<>''
GROUP BY 1) b
ON a.txnmappedmobile=b.txnmappedmobile
SET a.Third_Visit_Product_Purchase=b.uniqueitemcode;##1528

################ Overall ATV

ALTER TABLE dummy.Thomascook_SingleView ADD COLUMN ATV FLOAT;

UPDATE dummy.Thomascook_SingleView a JOIN (
SELECT txnmappedmobile,SUM(itemnetamount)/COUNT(DISTINCT uniquebillno) AS ATV FROM sku_report_loyalty
GROUP BY 1) b
ON a.txnmappedmobile=b.txnmappedmobile
SET a.ATV=b.ATV;##32868

###############Repeater ATV

ALTER TABLE dummy.Thomascook_SingleView ADD COLUMN Repeat_ATV FLOAT;

UPDATE dummy.Thomascook_SingleView a JOIN (
SELECT txnmappedmobile,
SUM(itemnetamount)/COUNT(DISTINCT uniquebillno) AS ATV FROM sku_report_loyalty
WHERE Frequencycount>1
GROUP BY 1) b
ON a.txnmappedmobile=b.txnmappedmobile
SET a.Repeat_ATV=b.ATV;##4062

##################Is FIT Buyer
UPDATE dummy.Thomascook_SingleView
SET Is_FIT_Buyer = NULL;


ALTER TABLE dummy.Thomascook_SingleView ADD COLUMN Is_FIT_Buyer VARCHAR(100);

UPDATE dummy.Thomascook_SingleView a JOIN (
SELECT txnmappedmobile,uniqueitemcode 
FROM sku_report_loyalty 
WHERE uniqueitemcode LIKE '%FIT%'
OR uniqueitemcode LIKE '%Customised Tour%' 
GROUP BY 1) b
ON a.txnmappedmobile=b.txnmappedmobile
SET a.Is_FIT_Buyer=b.uniqueitemcode;#11501


SELECT * FROM dummy.Thomascook_SingleView;


##################Is GIT Buyer

-- UPDATE dummy.Thomascook_SingleView
-- SET Is_FIT_Buyer = NULL;


ALTER TABLE dummy.Thomascook_SingleView ADD COLUMN Is_GIT_Buyer VARCHAR(200);

UPDATE dummy.Thomascook_SingleView a JOIN (
SELECT txnmappedmobile,uniqueitemcode 
FROM sku_report_loyalty 
WHERE uniqueitemcode NOT LIKE '%FIT%'
AND uniqueitemcode NOT LIKE '%Customised Tour%' 
GROUP BY 1) b
ON a.txnmappedmobile=b.txnmappedmobile
SET a.Is_GIT_Buyer=b.uniqueitemcode;#22871

##################Visit Vise Data

SELECT First_Visit_Product_Purchase,
COUNT(DISTINCT txnmappedmobile) Customer FROM dummy.Thomascook_SingleView
WHERE First_Visit_Product_Purchase IS NOT NULL
GROUP BY 1;

SELECT Second_Visit_Product_Purchase,
COUNT(DISTINCT txnmappedmobile) Customer FROM dummy.Thomascook_SingleView
WHERE Second_Visit_Product_Purchase IS NOT NULL
GROUP BY 1;

SELECT Third_Visit_Product_Purchase,
COUNT(DISTINCT txnmappedmobile) Customer FROM dummy.Thomascook_SingleView
WHERE Third_Visit_Product_Purchase IS NOT NULL
GROUP BY 1;

###################Age Bucketing 

SELECT
    CASE
        WHEN age>0 AND age<=18 THEN '0-18'
        WHEN age>=19 AND age<=30 THEN '19-30'
        WHEN age>30 AND age <=50 THEN '31-50'
        WHEN age>50 AND age<=70 THEN '51-70'
        WHEN age>70 THEN '70+'
        END AS `Age_Group`,COUNT(DISTINCT txnmappedmobile) AS Customer
FROM dummy.Thomascook_Singleview 
WHERE bills>2 
GROUP BY 1;

##################Avg People Book Travelling

SELECT SUM(Qty)/SUM(bills) AVG_People FROM dummy.Thomascook_Singleview
WHERE bills>1;


SELECT Txnmappedmobile Mobile,SUM(Qty)/SUM(bills) AVG_People FROM dummy.Thomascook_Singleview
WHERE bills>1
GROUP BY 1;

##################City Wise Customer Count

SELECT City,COUNT(DISTINCT txnmappedmobile) AS Customer
FROM dummy.Thomascook_Singleview
WHERE bills>1
AND enrolledstorecode NOT LIKE '%demo%'
GROUP BY 1;


SELECT enrolledstorecode Store_Code,COUNT(DISTINCT txnmappedmobile) AS Customer
FROM dummy.Thomascook_Singleview
WHERE bills>1
AND city IS NULL
AND enrolledstorecode NOT LIKE '%demo%'
GROUP BY 1;

#################Is FIT Buyer Data

SELECT COUNT(DISTINCT txnmappedmobile) AS Customer,
SUM(sales)/SUM(bills) AS ATV,
SUM(bills)/COUNT(DISTINCT txnmappedmobile) AS AVG 
FROM dummy.Thomascook_Singleview
WHERE bills>1
AND is_fit_buyer IS NOT NULL
AND is_fit_buyer LIKE 'fit%';

#################Is GIT Buyer Data

SELECT COUNT(DISTINCT txnmappedmobile) AS Customer,
SUM(sales)/SUM(bills) AS ATV,
SUM(Bills)/COUNT(DISTINCT txnmappedmobile) AS AVG 
FROM dummy.Thomascook_Singleview
WHERE bills>1
AND is_git_buyer IS NOT NULL;


SELECT COUNT(DISTINCT txnmappedmobile) AS Customer,
SUM(sales)/SUM(bills) AS ATV,
SUM(Bills)/COUNT(DISTINCT txnmappedmobile) AS AVG 
FROM dummy.Thomascook_Singleview
WHERE bills>1 
AND is_git_buyer IS NOT NULL AND is_fit_buyer IS NOT NULL 

SELECT DISTINCT Is_Fit_Buyer , Is_Git_buyer FROM dummy.Thomascook_Singleview

########################Repeater ATV

SELECT SUM(repeater_sales)/SUM(repeater_bills) AS ATV FROM dummy.Thomascook_Singleview;


SELECT SUM(sales),SUM(bills) FROM dummy.Thomascook_Singleview
WHERE is_repeater='1';

ALTER TABLE dummy.Thomascook_Singleview ADD COLUMN repeater_sales FLOAT,ADD COLUMN repeater_bills FLOAT

UPDATE dummy.Thomascook_Singleview a JOIN (
SELECT txnmappedmobile,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM sku_report_loyalty
WHERE frequencycount>1
AND insertiondate<='2025-09-24'
GROUP BY 1)b USING(txnmappedmobile)
SET a.repeater_sales=b.sales,a.repeater_bills=b.bills;#4062

SELECT *FROM dummy.Thomascook_Singleview;

SELECT COUNT(DISTINCT mobile) FROM
(SELECT txnmappedmobile mobile,COUNT(DISTINCT uniqueitemcode)codes,COUNT(DISTINCT uniquebillno)bills FROM sku_report_loyalty
WHERE modifiedstorecode NOT LIKE 'demo%' 
AND uniqueitemcode <> 'fit%'
AND uniqueitemcode LIKE 'fit%'
GROUP BY 1)a
WHERE bills>1


SELECT COUNT(DISTINCT txnmappedmobile) AS Customer
FROM sku_report_loyalty
WHERE uniqueitemcode LIKE 'FIT%';






SELECT*FROM sku_report_loyalty;




SELECT Txnmappedmobile Mobile,Modifiedbillno,Modifiedstorecode,modifiedtxndate FROM sku_report_loyalty
WHERE modifiedtxndate<='2025-09-29'
AND frequencycount>1
GROUP BY 1,2,3,4;



SELECT Txnmappedmobile Mobile,Modifiedstorecode,Modifiedtxndate,Uniquebillno,Uniqueitemcode,itemqty,
itemnetamount FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-01-01' AND '2025-10-13';




