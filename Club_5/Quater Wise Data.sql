#############Quater Wise ABV and Avg_Frq##########
SELECT SUM(Sales)/SUM(bill) AS AOV,
SUM(visit)/COUNT(DISTINCT txnmappedmobile) AS Avg_Visit
FROM
(SELECT txnmappedmobile,SUM(itemnetamount) AS Sales,COUNT(DISTINCT uniquebillno) bill,
COUNT(DISTINCT txnmappedmobile,modifiedtxndate) AS visit
FROM sku_report_loyalty
WHERE  modifiedtxndate BETWEEN DATE_SUB('2025-08-15', INTERVAL 24 MONTH) AND '2025-08-15'
AND itemnetamount>0
GROUP BY 1) a;


############Fevourite Category 

CREATE TABLE dummy.Item_Output_Umesh
SELECT storecode,COUNT(DISTINCT mobile)fav_product FROM (
SELECT * ,ROW_NUMBER() OVER (PARTITION BY mobile ORDER BY qty DESC) AS `ranks`
FROM(
SELECT txnmappedmobile mobile,modifiedstorecode storecode,b.categoryname,SUM(itemqty)qty,inhouse_branded
FROM sku_report_loyalty a JOIN item_master b USING(uniqueitemcode)
JOIN dummy.item_master_details_umesh c ON b.categoryname=c.CATEGORY1 AND b.categorycode=c.DIVISION
WHERE modifiedtxndate BETWEEN '2024-09-15' AND '2025-08-15'
AND itemnetamount>0
AND inhouse_branded= 'inhouse'
GROUP BY 1,2,3)c)b 
WHERE ranks=1
GROUP BY 1;##94 row(s) affected

############ Last Purchase Product
CREATE TABLE dummy.last_shopped_date
    SELECT 
        txnmappedmobile,
        MAX(modifiedtxndate)last_txndate
    FROM sku_report_loyalty
    WHERE modifiedtxndate BETWEEN '2024-09-15' AND '2025-08-15'
    AND itemnetamount>0
    GROUP BY 1 ;#389314
    
    
    ALTER TABLE dummy.last_shopped_date ADD INDEX mobile(txnmappedmobile), ADD COLUMN lasttxnstorecode VARCHAR(100);
    ALTER TABLE dummy.last_shopped_date ADD COLUMN product VARCHAR(100);

SELECT * FROM dummy.table


SELECT * FROM dummy.last_date

UPDATE  dummy.last_shopped_date a
JOIN 
( SELECT txnmappedmobile,modifiedtxndate,modifiedstorecode 
FROM club5.sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-09-15' AND '2025-08-15' 
AND itemnetamount>0   
)b
ON a.txnmappedmobile=b.txnmappedmobile AND a.last_txndate=b.modifiedtxndate
SET a.lasttxnstorecode=b.modifiedstorecode;##389345


UPDATE  dummy.last_shopped_date a JOIN (
SELECT DISTINCT txnmappedmobile,modifiedtxndate,modifiedstorecode,categoryname 
FROM club5.sku_report_loyalty a JOIN item_master b USING(uniqueitemcode)
JOIN dummy.item_master_details_umesh c
ON b.categoryname=c.CATEGORY1 AND b.categorycode=c.DIVISION
WHERE modifiedtxndate BETWEEN '2024-09-15' AND '2025-08-15' 
AND inhouse_branded = 'inhouse'
AND itemnetamount>0)b  
ON a.txnmappedmobile=b.txnmappedmobile AND a.last_txndate=b.modifiedtxndate
AND a.lasttxnstorecode=b.modifiedstorecode
SET a.product=b.categoryname;##260077

ALTER TABLE dummy.last_shopped_date ADD COLUMN points_spents FLOAT

UPDATE dummy.last_shopped_date a JOIN (
SELECT mobile,storecode,SUM(pointsspent)points_spents FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-09-15' AND '2025-08-15'
AND amount>0
GROUP BY 1)b ON a.txnmappedmobile=b.mobile AND a.lasttxnstorecode=b.storecode
SET a.points_spents=b.points_spents##377217


SELECT lasttxnstorecode,product,COUNT(DISTINCT txnmappedmobile) FROM dummy.last_shopped_date
GROUP BY 1
SELECT Lasttxnstorecode,COUNT(DISTINCT txnmappedmobile) Last_product,
SUM(points_spents) AS Points_Redeemed FROM dummy.last_shopped_date
GROUP BY 1;



