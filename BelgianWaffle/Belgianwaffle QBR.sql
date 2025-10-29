

SELECT 
SUM(CASE WHEN deliverymode='offline' THEN itemnetamount END)AS 'Offline',
SUM(CASE WHEN deliverymode='online' THEN itemnetamount END )AS 'Online'
FROM sku_report_nonloyalty
WHERE modifiedtxndate BETWEEN '2025-04-01' AND '2025-07-31';


#############Overall Data#################

SELECT PERIOD,COUNT(DISTINCT modifiedStorecode) AS Store,
SUM(Er_Per_Store) AS Er_Per_Store,SUM(Txn_Per_store) AS Txn_Per_store,
SUM(One_Timer) AS One_Timer,SUM(Repeater) AS Repeater,
SUM(Loyalty_Sales) AS Loyalty_Sales,SUM(Repeater_Sales) AS Repeater_Sales,
SUM(Loyalty_Bills) AS Loyalty_Bills,SUM(OneTimer_Bills) AS OneTimer_Bills,
SUM(Repeater_Bills) AS Repeater_Bills,
SUM(Loyalty_Sales)/SUM(Txn_Per_store) AS AMV,
SUM(Loyalty_Sales)/SUM(Loyalty_Bills) AS AOV,
SUM(CASE WHEN frequencycount=1 THEN Loyalty_Sales END)/SUM(OneTimer_Bills) AS OneTimer_AOV,
SUM(Repeater_Sales)/SUM(Repeater_Bills) AS Repeater_AOV,
COUNT(DISTINCT modifiedtxndate,txnmappedmobile)/COUNT(txnmappedmobile) AS AVG_Frq
FROM(
SELECT modifiedStorecode,
CASE
WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-07-31' THEN 'Apr-Jul-25'
WHEN modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan-Mar-25'
WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2024-07-31' THEN 'Apr-Jul-24'
END AS `Period`,frequencycount,itemnetamount,modifiedtxndate,txnmappedmobile,
COUNT(DISTINCT mobile) AS Er_Per_Store,
COUNT(DISTINCT Txnmappedmobile) AS Txn_Per_store,
COUNT(DISTINCT CASE WHEN frequencycount=1 THEN txnmappedmobile END) AS 'One_Timer',
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS 'Repeater',
SUM(itemnetamount) AS Loyalty_Sales,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS 'Repeater_Sales',
COUNT(DISTINCT uniquebillno) AS Loyalty_Bills,
COUNT(DISTINCT CASE WHEN frequencycount=1 THEN Uniquebillno END) AS 'OneTimer_Bills',
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN Uniquebillno END) AS 'Repeater_Bills'
FROM sku_report_loyalty a
JOIN member_report b
ON a.txnmappedmobile=b.mobile
WHERE ((modifiedtxndate BETWEEN '2025-04-01' AND '2025-07-31')OR
(modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31')OR
(modifiedtxndate BETWEEN '2024-04-01' AND '2024-07-31'))
GROUP BY 1,2)a
GROUP BY 1;



SELECT PERIOD,
COUNT(DISTINCT modifiedstorecode) AS store,
SUM(nonloyalty_Sale) AS nonloyalty_Sale,
SUM(nonloyalty_bills) AS nonloyalty_bills
FROM(
SELECT modifiedstorecode,
CASE
WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-07-31' THEN 'Apr-Jul-25'
WHEN modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan-Mar-25'
WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2024-07-31' THEN 'Apr-Jul-24'
END AS `Period`,SUM(itemnetamount) AS nonloyalty_Sale,
COUNT(DISTINCT uniquebillno) AS nonloyalty_bills
FROM sku_report_nonloyalty
WHERE ((modifiedtxndate BETWEEN '2025-04-01' AND '2025-07-31')OR
(modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31')OR
(modifiedtxndate BETWEEN '2024-04-01' AND '2024-07-31'))
GROUP BY 1,2)a
GROUP BY 1;


###################Overall Offline ################

SELECT PERIOD,COUNT(DISTINCT modifiedStorecode) AS Store,
SUM(Er_Per_Store) AS Er_Per_Store,SUM(Txn_Per_store) AS Txn_Per_store,
SUM(One_Timer) AS One_Timer,SUM(Repeater) AS Repeater,
SUM(Loyalty_Sales) AS Loyalty_Sales,SUM(Repeater_Sales) AS Repeater_Sales,
SUM(Loyalty_Bills) AS Loyalty_Bills,SUM(OneTimer_Bills) AS OneTimer_Bills,
SUM(Repeater_Bills) AS Repeater_Bills,
SUM(Loyalty_Sales)/SUM(Txn_Per_store) AS AMV,
SUM(Loyalty_Sales)/SUM(Loyalty_Bills) AS AOV,
SUM(CASE WHEN frequencycount=1 THEN Loyalty_Sales END)/SUM(OneTimer_Bills) AS OneTimer_AOV,
SUM(Repeater_Sales)/SUM(Repeater_Bills) AS Repeater_AOV,
COUNT(DISTINCT modifiedtxndate,txnmappedmobile)/COUNT(txnmappedmobile) AS AVG_Frq
FROM(
SELECT modifiedStorecode,
CASE
WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-07-31' THEN 'Apr-Jul-25'
WHEN modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan-Mar-25'
WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2024-07-31' THEN 'Apr-Jul-24'
END AS `Period`,frequencycount,itemnetamount,modifiedtxndate,txnmappedmobile,
COUNT(DISTINCT mobile) AS Er_Per_Store,
COUNT(DISTINCT Txnmappedmobile) AS Txn_Per_store,
COUNT(DISTINCT CASE WHEN frequencycount=1 THEN txnmappedmobile END) AS 'One_Timer',
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS 'Repeater',
SUM(itemnetamount) AS Loyalty_Sales,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS 'Repeater_Sales',
COUNT(DISTINCT uniquebillno) AS Loyalty_Bills,
COUNT(DISTINCT CASE WHEN frequencycount=1 THEN Uniquebillno END) AS 'OneTimer_Bills',
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN Uniquebillno END) AS 'Repeater_Bills'
FROM sku_report_loyalty a
JOIN member_report b
ON a.txnmappedmobile=b.mobile
WHERE ((modifiedtxndate BETWEEN '2025-04-01' AND '2025-07-31')OR
(modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31')OR
(modifiedtxndate BETWEEN '2024-04-01' AND '2024-07-31'))
AND modifiedstorecode LIKE 'c%'
AND deliverymode='offline'
GROUP BY 1,2)a
GROUP BY 1;



SELECT PERIOD,
COUNT(DISTINCT modifiedstorecode) AS store,
SUM(nonloyalty_Sale) AS nonloyalty_Sale,
SUM(nonloyalty_bills) AS nonloyalty_bills
FROM(
SELECT modifiedstorecode,
CASE
WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-07-31' THEN 'Apr-Jul-25'
WHEN modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan-Mar-25'
WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2024-07-31' THEN 'Apr-Jul-24'
END AS `Period`,SUM(itemnetamount) AS nonloyalty_Sale,
COUNT(DISTINCT uniquebillno) AS nonloyalty_bills
FROM sku_report_nonloyalty
WHERE ((modifiedtxndate BETWEEN '2025-04-01' AND '2025-07-31')OR
(modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31')OR
(modifiedtxndate BETWEEN '2024-04-01' AND '2024-07-31'))
AND modifiedstorecode LIKE 'c%'
AND deliverymode='offline'
GROUP BY 1,2)a
GROUP BY 1;

######################CoCo Overall######################


SELECT PERIOD,COUNT(DISTINCT modifiedStorecode) AS Store,
SUM(Er_Per_Store) AS Er_Per_Store,SUM(Txn_Per_store) AS Txn_Per_store,
SUM(One_Timer) AS One_Timer,SUM(Repeater) AS Repeater,
SUM(Loyalty_Sales) AS Loyalty_Sales,SUM(Repeater_Sales) AS Repeater_Sales,
SUM(Loyalty_Bills) AS Loyalty_Bills,SUM(OneTimer_Bills) AS OneTimer_Bills,
SUM(Repeater_Bills) AS Repeater_Bills,
SUM(Loyalty_Sales)/SUM(Txn_Per_store) AS AMV,
SUM(Loyalty_Sales)/SUM(Loyalty_Bills) AS AOV,
SUM(CASE WHEN frequencycount=1 THEN Loyalty_Sales END)/SUM(OneTimer_Bills) AS OneTimer_AOV,
SUM(Repeater_Sales)/SUM(Repeater_Bills) AS Repeater_AOV,
COUNT(DISTINCT modifiedtxndate,txnmappedmobile)/COUNT(txnmappedmobile) AS AVG_Frq
FROM(
SELECT modifiedStorecode,
CASE
WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-07-31' THEN 'Apr-Jul-25'
WHEN modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan-Mar-25'
WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2024-07-31' THEN 'Apr-Jul-24'
END AS `Period`,frequencycount,itemnetamount,modifiedtxndate,txnmappedmobile,
COUNT(DISTINCT mobile) AS Er_Per_Store,
COUNT(DISTINCT Txnmappedmobile) AS Txn_Per_store,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS 'Repeater',
SUM(itemnetamount) AS Loyalty_Sales,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS 'Repeater_Sales',
COUNT(DISTINCT uniquebillno) AS Loyalty_Bills,
COUNT(DISTINCT CASE WHEN frequencycount=1 THEN Uniquebillno END) AS 'OneTimer_Bills',
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN Uniquebillno END) AS 'Repeater_Bills'
FROM sku_report_loyalty a
JOIN member_report b
ON a.txnmappedmobile=b.mobile
WHERE ((modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30')OR
(modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31')OR
(modifiedtxndate BETWEEN '2024-04-01' AND '2024-07-31'))
AND modifiedstorecode LIKE 'c%'
GROUP BY 1,2)a
GROUP BY 1;



SELECT PERIOD,
COUNT(DISTINCT modifiedstorecode) AS store,
SUM(nonloyalty_Sale) AS nonloyalty_Sale,
SUM(nonloyalty_bills) AS nonloyalty_bills
FROM(
SELECT modifiedstorecode,
CASE
WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-07-31' THEN 'Apr-Jul-25'
WHEN modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan-Mar-25'
WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2024-07-31' THEN 'Apr-Jul-24'
END AS `Period`,SUM(itemnetamount) AS nonloyalty_Sale,
COUNT(DISTINCT uniquebillno) AS nonloyalty_bills
FROM sku_report_nonloyalty
WHERE ((modifiedtxndate BETWEEN '2025-04-01' AND '2025-07-31')OR
(modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31')OR
(modifiedtxndate BETWEEN '2024-04-01' AND '2024-07-31'))
AND modifiedstorecode LIKE 'c%'
AND modifiedstorecode NOT LIKE '%demo%'
GROUP BY 1,2)a
GROUP BY 1;

####################Overal CoCo-Offline#################


SELECT PERIOD,COUNT(DISTINCT modifiedStorecode) AS Store,
SUM(Er_Per_Store) AS Er_Per_Store,SUM(Txn_Per_store) AS Txn_Per_store,
SUM(One_Timer) AS One_Timer,SUM(Repeater) AS Repeater,
SUM(Loyalty_Sales) AS Loyalty_Sales,SUM(Repeater_Sales) AS Repeater_Sales,
SUM(Loyalty_Bills) AS Loyalty_Bills,SUM(OneTimer_Bills) AS OneTimer_Bills,
SUM(Repeater_Bills) AS Repeater_Bills,
SUM(Loyalty_Sales)/SUM(Txn_Per_store) AS AMV,
SUM(Loyalty_Sales)/SUM(Loyalty_Bills) AS AOV,
SUM(CASE WHEN frequencycount=1 THEN Loyalty_Sales END)/SUM(OneTimer_Bills) AS OneTimer_AOV,
SUM(Repeater_Sales)/SUM(Repeater_Bills) AS Repeater_AOV,
COUNT(DISTINCT modifiedtxndate,txnmappedmobile)/COUNT(txnmappedmobile) AS AVG_Frq
FROM(
SELECT modifiedStorecode,
CASE
WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-07-31' THEN 'Apr-Jul-25'
WHEN modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan-Mar-25'
WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2024-07-31' THEN 'Apr-Jul-24'
END AS `Period`,frequencycount,itemnetamount,modifiedtxndate,txnmappedmobile,
COUNT(DISTINCT mobile) AS Er_Per_Store,
COUNT(DISTINCT Txnmappedmobile) AS Txn_Per_store,
COUNT(DISTINCT CASE WHEN frequencycount=1 THEN txnmappedmobile END) AS 'One_Timer',
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS 'Repeater',
SUM(itemnetamount) AS Loyalty_Sales,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS 'Repeater_Sales',
COUNT(DISTINCT uniquebillno) AS Loyalty_Bills,
COUNT(DISTINCT CASE WHEN frequencycount=1 THEN Uniquebillno END) AS 'OneTimer_Bills',
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN Uniquebillno END) AS 'Repeater_Bills'
FROM sku_report_loyalty a
JOIN member_report b
ON a.txnmappedmobile=b.mobile
WHERE ((modifiedtxndate BETWEEN '2025-04-01' AND '2025-07-31')OR
(modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31')OR
(modifiedtxndate BETWEEN '2024-04-01' AND '2024-07-31'))
AND modifiedstorecode LIKE 'c%'
AND deliverymode='offline'
GROUP BY 1,2)a
GROUP BY 1;


SELECT PERIOD,
COUNT(DISTINCT modifiedstorecode) AS store,
SUM(nonloyalty_Sale) AS nonloyalty_Sale,
SUM(nonloyalty_bills) AS nonloyalty_bills
FROM(
SELECT modifiedstorecode,
CASE
WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-07-31' THEN 'Apr-Jul-25'
WHEN modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan-Mar-25'
WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2024-07-31' THEN 'Apr-Jul-24'
END AS `Period`,SUM(itemnetamount) AS nonloyalty_Sale,
COUNT(DISTINCT uniquebillno) AS nonloyalty_bills
FROM sku_report_nonloyalty
WHERE ((modifiedtxndate BETWEEN '2025-04-01' AND '2025-07-31')OR
(modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31')OR
(modifiedtxndate BETWEEN '2024-04-01' AND '2024-07-31'))
AND modifiedstorecode LIKE 'c%'
AND deliverymode='offline'
GROUP BY 1,2)a
GROUP BY 1;


######################FoFo Overall Data###################


SELECT PERIOD,COUNT(DISTINCT modifiedStorecode) AS Store,
SUM(Er_Per_Store) AS Er_Per_Store,SUM(Txn_Per_store) AS Txn_Per_store,
SUM(One_Timer) AS One_Timer,SUM(Repeater) AS Repeater,
SUM(Loyalty_Sales) AS Loyalty_Sales,SUM(Repeater_Sales) AS Repeater_Sales,
SUM(Loyalty_Bills) AS Loyalty_Bills,SUM(OneTimer_Bills) AS OneTimer_Bills,
SUM(Repeater_Bills) AS Repeater_Bills,
SUM(Loyalty_Sales)/SUM(Txn_Per_store) AS AMV,
SUM(Loyalty_Sales)/SUM(Loyalty_Bills) AS AOV,
SUM(CASE WHEN frequencycount=1 THEN Loyalty_Sales END)/SUM(OneTimer_Bills) AS OneTimer_AOV,
SUM(Repeater_Sales)/SUM(Repeater_Bills) AS Repeater_AOV,
COUNT(DISTINCT modifiedtxndate,txnmappedmobile)/COUNT(txnmappedmobile) AS AVG_Frq
FROM(
SELECT modifiedStorecode,
CASE
WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-07-31' THEN 'Apr-Jul-25'
WHEN modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan-Mar-25'
WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2024-07-31' THEN 'Apr-Jul-24'
END AS `Period`,frequencycount,itemnetamount,modifiedtxndate,txnmappedmobile,
COUNT(DISTINCT mobile) AS Er_Per_Store,
COUNT(DISTINCT Txnmappedmobile) AS Txn_Per_store,
COUNT(DISTINCT CASE WHEN frequencycount=1 THEN txnmappedmobile END) AS 'One_Timer',
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS 'Repeater',
SUM(itemnetamount) AS Loyalty_Sales,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS 'Repeater_Sales',
COUNT(DISTINCT uniquebillno) AS Loyalty_Bills,
COUNT(DISTINCT CASE WHEN frequencycount=1 THEN Uniquebillno END) AS 'OneTimer_Bills',
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN Uniquebillno END) AS 'Repeater_Bills'
FROM sku_report_loyalty a
JOIN member_report b
ON a.txnmappedmobile=b.mobile
WHERE ((modifiedtxndate BETWEEN '2025-04-01' AND '2025-07-31')OR
(modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31')OR
(modifiedtxndate BETWEEN '2024-04-01' AND '2024-07-31'))
AND modifiedstorecode LIKE '%f%'
-- AND deliverymode='offline'
AND modifiedstorecode NOT LIKE '%demo%'
GROUP BY 1,2)a
GROUP BY 1;


SELECT PERIOD,
COUNT(DISTINCT modifiedstorecode) AS store,
SUM(nonloyalty_Sale) AS nonloyalty_Sale,
SUM(nonloyalty_bills) AS nonloyalty_bills
FROM(
SELECT modifiedstorecode,
CASE
WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-07-31' THEN 'Apr-Jul-25'
WHEN modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan-Mar-25'
WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2024-07-31' THEN 'Apr-Jul-24'
END AS `Period`,SUM(itemnetamount) AS nonloyalty_Sale,
COUNT(DISTINCT uniquebillno) AS nonloyalty_bills
FROM sku_report_nonloyalty
WHERE ((modifiedtxndate BETWEEN '2025-04-01' AND '2025-07-31')OR
(modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31')OR
(modifiedtxndate BETWEEN '2024-04-01' AND '2024-07-31'))
AND modifiedstorecode LIKE '%f%'
-- AND deliverymode='offline'
AND modifiedstorecode NOT LIKE '%demo%'
GROUP BY 1,2)a
GROUP BY 1;


######################FoFo Offline Data###################


SELECT PERIOD,COUNT(DISTINCT modifiedStorecode) AS Store,
SUM(Er_Per_Store) AS Er_Per_Store,SUM(Txn_Per_store) AS Txn_Per_store,
SUM(One_Timer) AS One_Timer,SUM(Repeater) AS Repeater,
SUM(Loyalty_Sales) AS Loyalty_Sales,SUM(Repeater_Sales) AS Repeater_Sales,
SUM(Loyalty_Bills) AS Loyalty_Bills,SUM(OneTimer_Bills) AS OneTimer_Bills,
SUM(Repeater_Bills) AS Repeater_Bills,
SUM(Loyalty_Sales)/SUM(Txn_Per_store) AS AMV,
SUM(Loyalty_Sales)/SUM(Loyalty_Bills) AS AOV,
SUM(CASE WHEN frequencycount=1 THEN Loyalty_Sales END)/SUM(OneTimer_Bills) AS OneTimer_AOV,
SUM(Repeater_Sales)/SUM(Repeater_Bills) AS Repeater_AOV,
COUNT(DISTINCT modifiedtxndate,txnmappedmobile)/COUNT(txnmappedmobile) AS AVG_Frq
FROM(
SELECT modifiedStorecode,
CASE
WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-07-31' THEN 'Apr-Jul-25'
WHEN modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan-Mar-25'
WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2024-07-31' THEN 'Apr-Jul-24'
END AS `Period`,frequencycount,itemnetamount,modifiedtxndate,txnmappedmobile,
COUNT(DISTINCT mobile) AS Er_Per_Store,
COUNT(DISTINCT Txnmappedmobile) AS Txn_Per_store,
COUNT(DISTINCT CASE WHEN frequencycount=1 THEN txnmappedmobile END) AS 'One_Timer',
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS 'Repeater',
SUM(itemnetamount) AS Loyalty_Sales,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS 'Repeater_Sales',
COUNT(DISTINCT uniquebillno) AS Loyalty_Bills,
COUNT(DISTINCT CASE WHEN frequencycount=1 THEN Uniquebillno END) AS 'OneTimer_Bills',
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN Uniquebillno END) AS 'Repeater_Bills'
FROM sku_report_loyalty a
JOIN member_report b
ON a.txnmappedmobile=b.mobile
WHERE ((modifiedtxndate BETWEEN '2025-04-01' AND '2025-07-31')OR
(modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31')OR
(modifiedtxndate BETWEEN '2024-04-01' AND '2024-07-31'))
AND modifiedstorecode LIKE '%f%'
AND deliverymode='offline'
AND modifiedstorecode NOT LIKE '%demo%'
GROUP BY 1,2)a
GROUP BY 1;


SELECT PERIOD,
COUNT(DISTINCT modifiedstorecode) AS store,
SUM(nonloyalty_Sale) AS nonloyalty_Sale,
SUM(nonloyalty_bills) AS nonloyalty_bills
FROM(
SELECT modifiedstorecode,
CASE
WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-07-31' THEN 'Apr-Jul-25'
WHEN modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan-Mar-25'
WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2024-07-31' THEN 'Apr-Jul-24'
END AS `Period`,SUM(itemnetamount) AS nonloyalty_Sale,
COUNT(DISTINCT uniquebillno) AS nonloyalty_bills
FROM sku_report_nonloyalty
WHERE ((modifiedtxndate BETWEEN '2025-04-01' AND '2025-07-31')OR
(modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31')OR
(modifiedtxndate BETWEEN '2024-04-01' AND '2024-07-31'))
AND modifiedstorecode LIKE '%f%'
AND deliverymode='offline'
AND modifiedstorecode NOT LIKE '%demo%'
GROUP BY 1,2)a
GROUP BY 1;


SELECT DISTINCT storecode,SUM(itemnetamount),COUNT(DISTINCT uniquebillno)FROM sku_report_nonloyalty
WHERE modifiedtxndate BETWEEN '2025-04-01' AND '2025-07-31'
AND modifiedstorecode LIKE '%c%';


SELECT CASE WHEN modifiedstorecode LIKE '%c%' THEN 'coco'
WHEN modifiedstorecode LIKE '%f%' THEN 'fofo' END storetype1,modifiedstorecode,COUNT(DISTINCT txnmappedmobile)mobile,
SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2025-07-01' AND '2025-07-31'
GROUP BY 1,2;

SELECT DISTINCT storecode FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2025-07-01' AND '2025-07-31'







