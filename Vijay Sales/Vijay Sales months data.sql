
################################Repeat Cohort

SELECT enrolled_period,repeat_period,COUNT(DISTINCT a.txnmappedmobile)Repeat_Customers 
FROM 
(SELECT txnmappedmobile,CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),"-",RIGHT(YEAR(modifiedtxndate),2))enrolled_period,
MIN(frequencycount)min_freq
  FROM myvs.sku_report_loyalty
   WHERE modifiedtxndate>= '2024-09-01' AND modifiedtxndate<= '2025-09-30'
   AND itemnetamount>0
   GROUP BY 1,2 HAVING min_freq = 1) a
JOIN
    (SELECT txnmappedmobile,CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),"-",RIGHT(YEAR(modifiedtxndate),2))
      repeat_period FROM myvs.sku_report_loyalty
        WHERE  modifiedtxndate>= '2024-09-01' AND modifiedtxndate<= '2025-09-30' AND itemnetamount>0
                      GROUP BY 1,2)b 
     ON a.txnmappedmobile = b.txnmappedmobile
     GROUP BY 1,2;
          
     
###########################Top 10 Store     

SELECT modifiedstorecode,modifiedstore,COUNT(DISTINCT txnmappedmobile) AS Txn_Customer,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS Repeaters,
SUM(itemnetamount) AS Total_sales,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END)AS Repeaters_Sales,
COUNT(DISTINCT uniquebillno) AS Total_Bills,
SUM(itemnetamount)/COUNT(DISTINCT uniquebillno) AS ABV
FROM sku_report_loyalty
WHERE modifiedtxndate>='2025-09-01' AND modifiedtxndate>='2025-09-30' 
GROUP BY 1
ORDER BY Total_sales DESC
LIMIT 10;

SELECT storecode,COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END) AS Redeemers
FROM txn_report_accrual_redemption
WHERE txndate>='2025-09-01' AND txndate>='2025-09-30'
AND storecode IN ('HGG','UND','GDB','BR','DJK','PBH','PCH','PNV','MR','OH')
GROUP BY 1;


#######################Bottom 10 Store

SELECT modifiedstorecode,modifiedstore,COUNT(DISTINCT txnmappedmobile) AS Txn_Customer,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS Repeaters,
SUM(itemnetamount) AS Total_sales,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END)AS Repeaters_Sales,
COUNT(DISTINCT uniquebillno) AS Total_Bills,
SUM(itemnetamount)/COUNT(DISTINCT uniquebillno) AS ABV
FROM sku_report_loyalty
WHERE modifiedtxndate>='2025-09-01' AND modifiedtxndate>='2025-09-30'
AND modifiedstore NOT LIKE '%REGIONAL OFF%' 
GROUP BY 1
HAVING Total_sales>0
ORDER BY Total_sales 
LIMIT 10;


SELECT storecode,COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END) AS Redeemers
FROM txn_report_accrual_redemption
WHERE txndate>='2025-09-01' AND txndate>='2025-09-30'
AND storecode IN ('KNZ','VSO','DRS','CRP','CRD','TKU','TCG','TMH','PDC','TNM')
GROUP BY 1;

##################Loyalty Redeemers Data

SELECT 
CASE 
WHEN txndate>='2024-09-01' AND txndate<='2024-09-30' THEN 'Sep_24'
WHEN txndate>='2025-08-01' AND txndate<='2025-08-31' THEN 'Aug_25'
WHEN txndate>='2025-09-01' AND txndate<='2025-09-30' THEN 'Sep_25'
END AS `Months`,
SUM(pointscollected) AS Point_Earn,
SUM(pointsspent) AS Point_Redeemed,
SUM(CASE WHEN pointsspent>0 THEN amount END) AS Point_Redemption_Sales,
SUM(CASE WHEN pointsspent>0 THEN amount END)/COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END) AS Points_Redeemers_ATV,
SUM(CASE WHEN pointsspent>0 THEN amount END)/SUM(pointsspent) AS Sales_Per_Point_Spent
FROM txn_report_accrual_redemption
WHERE ((txndate>='2024-09-01' AND txndate<='2024-09-30')OR
(txndate>='2025-08-01' AND txndate<='2025-08-31')OR
(txndate>='2025-09-01' AND txndate<='2025-09-30'))
AND pointsspent>0
GROUP BY 1
ORDER BY txndate;


SELECT 
CASE 
WHEN txndate>='2024-09-01' AND txndate<='2024-09-30' THEN 'Sep_24'
WHEN txndate>='2025-08-01' AND txndate<='2025-08-31' THEN 'Aug_25'
WHEN txndate>='2025-09-01' AND txndate<='2025-09-30' THEN 'Sep_25'
END AS `Months`,
SUM(pointscollected) AS Flat_Accrual
FROM txn_Report_flat_accrual
WHERE ((txndate>='2024-09-01' AND txndate<='2024-09-30')OR
(txndate>='2025-08-01' AND txndate<='2025-08-31')OR
(txndate>='2025-09-01' AND txndate<='2025-09-30'))
GROUP BY 1
ORDER BY txndate;

###################Product Landscape

SELECT subcategoryname,COUNT(DISTINCT txnmappedmobile) Customer,SUM(itemnetamount) AS Sales,COUNT(DISTINCT uniquebillno) AS Bills
-- sum(itemqty) as Qty,sum(itemnetamount)/sum(itemqty) as APP
FROM sku_report_loyalty a
JOIN item_master b USING (uniqueitemcode)
WHERE modifiedtxndate BETWEEN '2025-09-01' AND '2025-09-30'
AND itemnetamount>0
AND subcategoryname NOT LIKE ''
GROUP BY 1
ORDER BY sales DESC;

######################Product Combo

SELECT 
  Product,SUM(Customer)AS Customer,SUM(Bills) AS Bills,SUM(Sales) AS Sales,SUM(qty) AS Qty
FROM (
  SELECT 
    txnmappedmobile,
    GROUP_CONCAT(DISTINCT b.subcategoryname ORDER BY b.subcategoryname) AS Product,
    COUNT(DISTINCT txnmappedmobile) AS Customer,
    COUNT(DISTINCT uniquebillno) AS Bills,
    SUM(itemnetamount) AS Sales,
    SUM(itemqty) AS Qty
  FROM sku_report_loyalty a
  JOIN item_master b USING(uniqueitemcode)
  WHERE a.modifiedtxndate BETWEEN '2025-09-01' AND '2025-09-30'
    AND b.subcategoryname IS NOT NULL
    AND b.subcategoryname != ''
    AND itemnetamount>0
  GROUP BY txnmappedmobile
) c
GROUP BY Product
ORDER BY Sales DESC;

-- select GROUP_CONCAT(DISTINCT b.subcategoryname ORDER BY b.subcategoryname) as Product,count(distinct txnmappedmobile) as Customer,
-- count(distinct uniquebillno) as Bills,sum(itemnetamount) as Sales,sum(itemqty) as Qty
-- from sku_report_loyalty a
-- join item_master b using(uniqueitemcode)
-- WHERE a.modifiedtxndate BETWEEN '2025-09-01' AND '2025-09-30'
-- AND subcategoryname IS NOT NULL
-- AND subcategoryname != ''
-- and itemnetamount>0
-- -- group by Product
-- order by sales desc;


############Subcategory Seasonality Monthwise##############

SELECT subcategoryname,CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),'-',RIGHT(YEAR(modifiedtxndate),2)) AS Months,
SUM(itemnetamount) AS Sales
FROM sku_report_loyalty a
JOIN item_master b USING(uniqueitemcode)
WHERE modifiedtxndate BETWEEN '2024-10-01' AND '2025-09-30'
AND subcategoryname NOT LIKE ''
AND itemnetamount>0
GROUP BY 1,2
ORDER BY Sales DESC;


############Brand Seasonality Monthwise##############

SELECT Brandname,CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),'-',RIGHT(YEAR(modifiedtxndate),2)) AS Months,
SUM(itemnetamount) AS Sales
FROM sku_report_loyalty a
JOIN item_master b USING(uniqueitemcode)
WHERE modifiedtxndate BETWEEN '2024-10-01' AND '2025-09-30'
AND Brandname NOT LIKE ''
AND itemnetamount>0
GROUP BY 1,2
ORDER BY Sales DESC;











































