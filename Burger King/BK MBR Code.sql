#USer Data--------------
 
#YOY All Users--
SELECT `FY_year`AS YEAR,delivery_modes,
`count(distinct Txnmappedmobile)`AS Users,
`sum(sales)`AS Revenue,`sum(bills)`AS Orders,`avg(visits)`AS Freq
FROM  burgerking.`fact_all_users_yoy`
  WHERE `FY_year` = '2025-2026';
  
  
 #HOH All Users--
SELECT `Year_Part`AS `Year`,delivery_modes,`count(distinct txnmappedmobile)`Users,`sum(bills)`Orders,
`sum(sales)`Revenue,ROUND(`sum(sales)`/`sum(bills)`,0)APC,ROUND(`avg(visits)`,2)Freq
 FROM Burgerking.`fact_all_users_hoh` WHERE `Year_Part` = '2025-H1';
 
 SELECT * FROM burgerking.`fact_all_users_hoh`;
 
 #QoQ All Users--
SELECT `Calender_Quarter`AS `Qtr`,delivery_modes,`count(distinct txnmappedmobile)`Users,`sum(bills)`Orders,
`sum(sales)`Revenue,ROUND(`sum(sales)`/`sum(bills)`,0)APC,ROUND(`avg(visits)`,2)Freq
 FROM Burgerking.`fact_all_users_qoq` WHERE `Calender_Quarter` = '2025-Q2'; ##Data not Fetch
 
 #MOM All Users--
SELECT `calender_month`AS MONTH,delivery_modes,`count(distinct txnmappedmobile)`Users,`sum(bills)`Orders,
`sum(sales)`Revenue,ROUND(`sum(sales)`/`sum(bills)`,0)APC,ROUND(`avg(visits)`,2)Freq
FROM Burgerking.fact_all_users_mom WHERE calender_month = 'Sep-2025'; 

SELECT 'Non Loyalty'AS SOURCE,
 COUNT(DISTINCT uniquebillno)Bills,SUM(itemnetamount)sales FROM burgerking.sku_report_nonloyalty
  WHERE SOURCE IN ('BKAPP','BKMob_Del','BKMob_Dinein','BKMobile_TA') 
  AND modifiedtxndate BETWEEN '2025-09-01' AND '2025-09-30';
  
  #MOm RFM--
   SELECT * FROM burgerking.bk_mom_rfm_segment WHERE `month` = 'Sep-2025';##Data not Fetch
   
SELECT * FROM burgerking.fact_acquistion_repeat_QoQ   
   
   #Mom Acq vs Repeat--
SELECT `year`,`Month`,Tag,Users,Bills AS Orders,Sales AS Revenue,ROUND(sales/Bills,0)APC,ROUND(Avgvisits,2) AS Freq
FROM burgerking.fact_acquistion_repeat_mom WHERE YEAR='2025' AND MONTH ='Sep'; ##Data not Fetch

#QoQ Acq vs Repeat
SELECT `Quarter`,Tag,Users,Bills AS Orders,Sales AS Revenue,ROUND(sales/Bills,0)APC,ROUND(Avgvisits,2) AS Freq
FROM burgerking.fact_acquistion_repeat_QoQ WHERE `Quarter` = '2025-Q2';


#HOH Acq vs Repeat--
SELECT `Year_part`AS FY_Year,Tag,Users,Bills AS Orders,Sales AS Revenue,ROUND(sales/Bills,0)APC,ROUND(Avgvisits,2) AS Freq
FROM burgerking.`fact_acquistion_repeat_hoh` WHERE year_part = '2025-H1';

#YoY Acq vs Repeat--
SELECT `Year`AS FY_Year,Tag,Users,Bills AS Orders,Sales AS Revenue,ROUND(sales/Bills,0)APC,ROUND(Avgvisits,2) AS Freq
FROM burgerking.fact_acquistion_repeat_YoY WHERE YEAR = 2025;

#SLMH YOY--
SELECT * FROM burgerking.bk_yoy_segm_lite_med_heavy WHERE `FY_Year` = '2025-2026';

#SLMH HoH--
SELECT * FROM burgerking.`bk_hoh_segm_lite_med_heavy` WHERE hoh = '2025-04-01||2025-09-30';

#SLMH QoQ--
SELECT `Quarter`,segment, USers,Revenue,orders,Freq FROM burgerking.bk_qoq_segm_lite_med_heavy 
WHERE `Quarter` = '2025-Q2';

#SLMH MOm--
SELECT `Month`,segment, USers,Revenue,orders,Freq FROM burgerking.bk_mom_segm_lite_med_heavy WHERE `Month` = 'Sep-2025';


#MOM Customer Type Segmentation--
SELECT * FROM burgerking.fact_cust_type_segmnt_mom WHERE yearmonth = '2025_September' ORDER BY classification ASC;#Data not Fetch

#QoQ Customer Type Segmentation--
SELECT * FROM burgerking.fact_cust_type_segmnt_Qoq WHERE `quarter` = '2025-Q2' ORDER BY classification ASC;

#YoY Customer Type Segmentation--
SELECT * FROM burgerking.fact_cust_type_segmnt_yoy WHERE `Year` = '2025' ORDER BY classification ASC;

#HOH Customer Type Segmentation--
SELECT * FROM burgerking.fact_cust_type_segmnt_hoh WHERE `Year_part` = '2025-H1' ORDER BY classification ASC;

#MOM Veg & Nonveg--
SELECT * FROM burgerking.bk_mom_veg_nonveg_seg WHERE `month` = 'Sep-2025' AND segment IS NOT NULL ORDER BY Users DESC;

#QoQ Veg & Nonveg--
SELECT * FROM burgerking.bk_qoq_veg_nonveg_seg WHERE `quarter` = '2025-Q2' AND segment IS NOT NULL ORDER BY users DESC;

#YoY Veg & Nonveg--
SELECT * FROM burgerking.bk_yoy_veg_nonveg_seg WHERE `Fy_Year` = '2025-2026' AND segment IS NOT NULL ORDER BY users DESC;

#HOH Veg & Nonveg--
SELECT * FROM burgerking.bk_hoh_veg_nonveg_seg WHERE segment IS NOT NULL AND hoh = '2025-04-01||2025-09-30' ORDER BY users DESC;

#Crown Redemption--

#YoY Crown Redemption--
SELECT FY,transactors,distinct_coupon_issued,redeemers,APC,Freq
FROM burgerking.bk_yoy_coupon_redemers WHERE Fy = '2025-2026';

#HOH Crown Redemption--
SELECT halfyear_range AS HOH,transactors,distinct_coupon_issued,redeemers,APC,Freq 
FROM burgerking.`bk_hoh_coupon_redemers_` WHERE `halfyear_range` = '2025-04-01||2025-09-30' ;

#QoQ Crown Redemption--
SELECT `QUARTER`,transactors,distinct_coupon_issued,redeemers,APC,Freq 
FROM burgerking.bk_qoq_coupon_redemers WHERE `QUARTER` = '2025-Q2';

#MOm Crown Redemption--
SELECT `Month`,transactors,distinct_coupon_issued,redeemers,APC,Freq 
FROM burgerking.bk_mom_coupon_redemers WHERE `month` = 'Sep-2025' ;

#MOM Acq Performance--

-- SELECT enrolment_FY,Repeat_FY,COUNT(DISTINCT b.txnmappedmobile)Repeat_Customers 
-- FROM 
-- (SELECT txnmappedmobile,FY AS enrolment_FY FROM burgerking.`bk_mom_customer_deliverymode_data_bkapponly`
--    WHERE min_freq = 1 AND FY IN ('2023-09-01||2023-09-30','2023-10-01||2023-10-31','2023-11-01||2023-11-30','2023-12-01||2023-12-31','2024-01-01||2024-01-31','2024-02-01||2024-02-29','2024-03-01||2024-03-31','2024-04-01||2024-04-30','2024-05-01||2024-05-31','2024-06-01||2024-06-30','2024-07-01||2024-07-31','2024-08-01||2024-08-31','2024-09-01||2024-09-30','2024-10-01||2024-10-31','2024-11-01||2024-11-30','2024-12-01||2024-12-31','2025-01-01||2025-01-31','2025-02-01||2025-02-28','2025-03-01||2025-03-31',
-- '2025-04-01||2025-04-30','2025-05-01||2025-05-31','2025-06-01||2025-06-30','2025-07-01||2025-07-31',
-- '2025-08-01||2025-08-31','2025-09-01||2025-09-30')
--    GROUP BY 1,2) a
--  JOIN
--     (SELECT txnmappedmobile,FY AS Repeat_FY FROM burgerking.`bk_mom_customer_deliverymode_data_bkapponly`
--         WHERE  FY IN ('2023-09-01||2023-09-30','2023-10-01||2023-10-31','2023-11-01||2023-11-30','2023-12-01||2023-12-31','2024-01-01||2024-01-31','2024-02-01||2024-02-29','2024-03-01||2024-03-31','2024-04-01||2024-04-30','2024-05-01||2024-05-31','2024-06-01||2024-06-30','2024-07-01||2024-07-31','2024-08-01||2024-08-31','2024-09-01||2024-09-30','2024-10-01||2024-10-31','2024-11-01||2024-11-30','2024-12-01||2024-12-31','2025-01-01||2025-01-31','2025-02-01||2025-02-28','2025-03-01||2025-03-31',
-- '2025-04-01||2025-04-30','2025-05-01||2025-05-31','2025-06-01||2025-06-30','2025-07-01||2025-07-31','2025-08-01||2025-08-31','2025-09-01||2025-09-30') 
--  GROUP BY 1,2)b 
--      ON a.txnmappedmobile = b.txnmappedmobile
--      GROUP BY 1,2;


WITH CTE1 AS
(SELECT txnmappedmobile,FY AS enrolment_FY FROM burgerking.`bk_mom_customer_deliverymode_data_bkapponly`
   WHERE min_freq = 1 AND FY IN ('2024-10-01||2024-10-31','2024-11-01||2024-11-30',
                      '2024-12-01||2024-12-31','2025-01-01||2025-01-31','2025-02-01||2025-02-28','2025-03-01||2025-03-31',
                      '2025-04-01||2025-04-30','2025-05-01||2025-05-31','2025-06-01||2025-06-30',
                      '2025-07-01||2025-07-31','2025-08-01||2025-08-31','2025-09-01||2025-09-30')
   GROUP BY 1,2),
CTE2 AS
    (SELECT txnmappedmobile,FY AS Repeat_FY FROM burgerking.`bk_mom_customer_deliverymode_data_bkapponly`
        WHERE  FY IN ('2024-10-01||2024-10-31','2024-11-01||2024-11-30',
                      '2024-12-01||2024-12-31','2025-01-01||2025-01-31','2025-02-01||2025-02-28','2025-03-01||2025-03-31',
                      '2025-04-01||2025-04-30','2025-05-01||2025-05-31','2025-06-01||2025-06-30','2025-07-01||2025-07-31',
                      '2025-08-01||2025-08-31','2025-09-01||2025-09-30') 
                      GROUP BY 1,2) 
      SELECT a.enrolment_FY,b.Repeat_FY,COUNT(a.txnmappedmobile)Repeaters FROM CTE1 a
        JOIN CTE2 b ON a.txnmappedmobile = b.txnmappedmobile
        GROUP BY 1,2;


     
#QoQ Acq Performance--     
-- 
-- SELECT enrolment_FY,Repeat_FY,COUNT(DISTINCT a.txnmappedmobile)Repeat_Customers 
-- FROM 
WITH QUT1 AS
(SELECT txnmappedmobile,FY AS enrolment_FY FROM burgerking.`bk_qoq_customer_deliverymode_data_bkapponly`
   WHERE min_freq = 1 AND FY <> '2024-07-01||2024-08-31' 
   AND FY>='2023-04-01'  
   GROUP BY 1,2),
 QUT2 AS
    (SELECT txnmappedmobile,FY AS Repeat_FY FROM burgerking.`bk_qoq_customer_deliverymode_data_bkapponly`
        WHERE  FY <> '2024-07-01||2024-08-31' 
        AND FY>='2023-04-01'
        GROUP BY 1,2)
 SELECT a.enrolment_FY,b.Repeat_FY,COUNT(a.txnmappedmobile)Repeaters FROM QUT1 a 
 JOIN QUT2 b ON a.txnmappedmobile = b.txnmappedmobile
 GROUP BY 1,2;
  
  ##############################################################################################################################################


#Burgerking Phase2 requirement---

SELECT 'Total Transacting BAse',COUNT(DISTINCT txnmappedmobile)Customers FROM burgerking.bk_yoy_customer_deliverymode_data;

SELECT 'Loyalty'AS SOURCE,COUNT(DISTINCT uniquebillno)Bills,SUM(itemnetamount)sales FROM burgerking.sku_report_loyalty
  WHERE modifiedtxndate BETWEEN '2025-09-01' AND '2025-09-30';

SELECT 'Non Loyalty'AS SOURCE,COUNT(DISTINCT uniquebillno)Bills,SUM(itemnetamount)sales FROM burgerking.sku_report_nonloyalty
  WHERE modifiedtxndate BETWEEN '2025-09-01' AND '2025-09-30';

SELECT fy,delivery_modes,COUNT(DISTINCT txnmappedmobile)users,SUM(bills)orders,SUM(sales)revenue,SUM(visits)visits,AVG(visits)freq
FROM burgerking.bk_yoy_customer_deliverymode_data 
WHERE FY = '2025-04-01||2025-09-30'
 GROUP BY 1,2;
 
 #FY21-22 to Fy25-26--
 SELECT 'FY21-22',COUNT(b.txnmappedmobile)users,SUM(b.bills)orders,ROUND(SUM(b.sales),0)Revenue,ROUND(SUM(b.sales)/SUM(b.bills),0)APC,
 ROUND(AVG(b.visits),2)Freq 
 FROM 
 (SELECT * FROM burgerking.bk_yoy_customer_deliverymode_data
  WHERE fy= '2021-04-01||2022-03-31')a 
  JOIN 
  (SELECT * FROM burgerking.bk_yoy_customer_deliverymode_data
  WHERE fy = '2025-04-01||2025-09-30')b 
  ON a.txnmappedmobile = b.txnmappedmobile;
  
  #FY22-23 to Fy25-26--
  SELECT 'FY22-23',COUNT(b.txnmappedmobile)users,SUM(b.bills)orders,ROUND(SUM(b.sales),0)Revenue,ROUND(SUM(b.sales)/SUM(b.bills),0)APC,
 ROUND(AVG(b.visits),2)Freq 
 FROM 
 (SELECT * FROM burgerking.bk_yoy_customer_deliverymode_data
  WHERE fy= '2022-04-01||2023-03-31')a 
  JOIN 
  (SELECT * FROM burgerking.bk_yoy_customer_deliverymode_data
  WHERE fy= '2025-04-01||2025-09-30')b 
  ON a.txnmappedmobile = b.txnmappedmobile;
  
  #FY23-24 to FY25-26--
  SELECT 'FY23-24',COUNT(b.txnmappedmobile)users,SUM(b.bills)orders,ROUND(SUM(b.sales),0)Revenue,ROUND(SUM(b.sales)/SUM(b.bills),0)APC,
 ROUND(AVG(b.visits),2)Freq 
 FROM 
 (SELECT * FROM burgerking.bk_yoy_customer_deliverymode_data
  WHERE fy= '2023-04-01||2024-03-31')a 
  JOIN 
  (SELECT * FROM burgerking.bk_yoy_customer_deliverymode_data
  WHERE fy= '2025-04-01||2025-09-30')b 
  ON a.txnmappedmobile = b.txnmappedmobile;
  
  #FY24-25 to FY25-26--
  SELECT 'FY24-25',COUNT(b.txnmappedmobile)users,SUM(b.bills)orders,ROUND(SUM(b.sales),0)Revenue,ROUND(SUM(b.sales)/SUM(b.bills),0)APC,
 ROUND(AVG(b.visits),2)Freq 
 FROM 
 (SELECT * FROM burgerking.bk_yoy_customer_deliverymode_data
  WHERE fy= '2024-04-01||2025-03-31')a 
  JOIN 
  (SELECT * FROM burgerking.bk_yoy_customer_deliverymode_data
  WHERE fy= '2025-04-01||2025-09-30')b 
  ON a.txnmappedmobile = b.txnmappedmobile;
  
  #SLMH---
  SELECT CASE WHEN segment_slmh = 'Heavy' THEN '1 Heavy' WHEN segment_slmh = 'Medium' THEN '2 Medium'
              WHEN segment_slmh = 'Lite' THEN '3 Lite'  
              WHEN segment_slmh = 'Single' THEN '4 Single' END AS 'SLMH',
  
 CASE WHEN region = 'East' THEN '1 East' WHEN region = 'West 1' THEN '2 West 1' WHEN region = 'West 2' THEN '3 West 2'
      WHEN region = 'North 1' THEN '4 North 1' WHEN region = 'North 2' THEN '5 North 2' 
      WHEN region = 'South' THEN '6 South' END AS 'Region',
 city,
 COUNT(txnmappedmobile)Users,SUM(bills)Orders,ROUND(SUM(sales),0)Revenue,
  ROUND(SUM(sales)/SUM(bills),0)apc,SUM(visits)visits
 FROM burgerking.bk_yoy_customer_deliverymode_data 
  WHERE fy = '2025-04-01||2025-09-30' 
  GROUP BY 1,2,3;
  
  #SLMH MIgration----
  
#FY21-22 to FY25-26  
  SELECT a.segment_slmh,b.segment_slmh,COUNT(a.txnmappedmobile)users
  FROM 
  (SELECT segment_slmh,txnmappedmobile FROM burgerking.bk_yoy_customer_deliverymode_data 
    WHERE fy = '2021-04-01||2022-03-31')a
   LEFT JOIN 
           (SELECT segment_slmh,txnmappedmobile FROM burgerking.bk_yoy_customer_deliverymode_data 
                 WHERE fy = '2025-04-01||2025-09-30')b 
    ON a.txnmappedmobile = b.txnmappedmobile 
    GROUP BY 1,2;
  
  #FY22-23 to FY25-26
  SELECT a.segment_slmh,b.segment_slmh,COUNT(a.txnmappedmobile)users
  FROM 
  (SELECT segment_slmh,txnmappedmobile FROM burgerking.bk_yoy_customer_deliverymode_data 
    WHERE fy = '2022-04-01||2023-03-31')a
   LEFT JOIN 
           (SELECT segment_slmh,txnmappedmobile FROM burgerking.bk_yoy_customer_deliverymode_data 
                 WHERE fy = '2025-04-01||2025-09-30')b 
    ON a.txnmappedmobile = b.txnmappedmobile 
    GROUP BY 1,2;
    
   #FY23-24 to FY25-26
  SELECT a.segment_slmh,b.segment_slmh,COUNT(a.txnmappedmobile)users
  FROM 
  (SELECT segment_slmh,txnmappedmobile FROM burgerking.bk_yoy_customer_deliverymode_data 
    WHERE fy = '2023-04-01||2024-03-31')a
   LEFT JOIN 
           (SELECT segment_slmh,txnmappedmobile FROM burgerking.bk_yoy_customer_deliverymode_data 
                 WHERE fy = '2025-04-01||2025-09-30')b 
    ON a.txnmappedmobile = b.txnmappedmobile 
    GROUP BY 1,2;
    
   #FY24-25 to FY25-26
    SELECT a.segment_slmh,b.segment_slmh,COUNT(a.txnmappedmobile)users
  FROM 
  (SELECT segment_slmh,txnmappedmobile FROM burgerking.bk_yoy_customer_deliverymode_data 
    WHERE fy = '2024-04-01||2025-03-31')a
   LEFT JOIN 
           (SELECT segment_slmh,txnmappedmobile FROM burgerking.bk_yoy_customer_deliverymode_data 
                 WHERE fy = '2025-04-01||2025-09-30')b 
    ON a.txnmappedmobile = b.txnmappedmobile 
    GROUP BY 1,2;
   
   #SLMH MIgartion Story Telling-- 
   
    SELECT segment_slmh,fy,COUNT(DISTINCT txnmappedmobile)users,SUM(bills)orders,SUM(sales)Revenue,ROUND(SUM(sales)/SUM(bills),0)APC,SUM(visits),
     AVG(visits)Freq FROM burgerking.bk_yoy_customer_deliverymode_data WHERE fy = '2025-04-01||2025-09-30'
     GROUP BY 1;
  
  
  SELECT 'FY25-26'AS FY,segment_slmh,CASE WHEN apc BETWEEN 1 AND 100 THEN '1-100'
                          WHEN apc BETWEEN 101 AND 200 THEN '101-200'
                          WHEN apc BETWEEN 201 AND 300 THEN '201-300'
                          WHEN apc BETWEEN 301 AND 400 THEN '301-400'
                          WHEN apc BETWEEN 401 AND 500 THEN '401-500'
                          WHEN apc >500 THEN '500+' END AS APC_Bucket,
  COUNT(Txnmappedmobile)Users FROM 
 (SELECT txnmappedmobile,segment_slmh,ROUND(SUM(sales)/SUM(bills),0)APC FROM burgerking.bk_yoy_customer_deliverymode_data 
   WHERE fy = '2025-04-01||2025-09-30' GROUP BY 1,2)a 
   GROUP BY 2,3;
   
SELECT CASE WHEN segment_slmh = 'Heavy' THEN '1 Heavy' WHEN segment_slmh = 'Medium' THEN '2 Medium'
              WHEN segment_slmh = 'Lite' THEN '3 Lite'  
              WHEN segment_slmh = 'Single' THEN '4 Single' END AS 'SLMH1',segment_slmh,
  
 CASE WHEN region = 'East' THEN '1 East' WHEN region = 'West 1' THEN '2 West 1' WHEN region = 'West 2' THEN '3 West 2'
      WHEN region = 'North 1' THEN '4 North 1' WHEN region = 'North 2' THEN '5 North 2' 
      WHEN region = 'South' THEN '6 South' END AS 'Region1',region,
 city,
 COUNT(txnmappedmobile)Users,SUM(bills)Orders,ROUND(SUM(sales),0)Revenue,
  ROUND(SUM(sales)/SUM(bills),0)apc,SUM(visits)visits
 FROM burgerking.bk_yoy_customer_deliverymode_data_bkapponly 
  WHERE fy = '2025-04-01||2025-09-30' 
  GROUP BY 1,2,3,4,5; 
   
   #BKAPP SLMH MIgration FY21-22 to FY25-26
   
  SELECT a.segment_slmh,b.segment_slmh,COUNT(a.txnmappedmobile)users
  FROM 
  (SELECT segment_slmh,txnmappedmobile FROM burgerking.bk_yoy_customer_deliverymode_data_bkapponly 
    WHERE fy = '2021-04-01||2022-03-31')a
   LEFT JOIN 
           (SELECT segment_slmh,txnmappedmobile FROM burgerking.bk_yoy_customer_deliverymode_data_bkapponly 
                 WHERE fy = '2025-04-01||2025-09-30')b 
    ON a.txnmappedmobile = b.txnmappedmobile 
    GROUP BY 1,2;
    
    SELECT a.segment_slmh,b.segment_slmh,COUNT(a.txnmappedmobile)users
  FROM 
  (SELECT segment_slmh,txnmappedmobile FROM burgerking.bk_yoy_customer_deliverymode_data_bkapponly 
    WHERE fy = '2022-04-01||2023-03-31')a
   LEFT JOIN 
           (SELECT segment_slmh,txnmappedmobile FROM burgerking.bk_yoy_customer_deliverymode_data_bkapponly 
                 WHERE fy = '2025-04-01||2025-09-30')b 
    ON a.txnmappedmobile = b.txnmappedmobile 
    GROUP BY 1,2;
    
    
    SELECT a.segment_slmh,b.segment_slmh,COUNT(a.txnmappedmobile)users
  FROM 
  (SELECT segment_slmh,txnmappedmobile FROM burgerking.bk_yoy_customer_deliverymode_data_bkapponly 
    WHERE fy = '2023-04-01||2024-03-31')a
   LEFT JOIN 
           (SELECT segment_slmh,txnmappedmobile FROM burgerking.bk_yoy_customer_deliverymode_data_bkapponly 
                 WHERE fy = '2025-04-01||2025-09-30')b 
    ON a.txnmappedmobile = b.txnmappedmobile 
    GROUP BY 1,2;
    
    
    SELECT a.segment_slmh,b.segment_slmh,COUNT(a.txnmappedmobile)users
  FROM 
  (SELECT segment_slmh,txnmappedmobile FROM burgerking.bk_yoy_customer_deliverymode_data_bkapponly 
    WHERE fy = '2024-04-01||2025-03-31')a
   LEFT JOIN 
           (SELECT segment_slmh,txnmappedmobile FROM burgerking.bk_yoy_customer_deliverymode_data_bkapponly 
                 WHERE fy = '2025-04-01||2025-09-30')b 
    ON a.txnmappedmobile = b.txnmappedmobile 
    GROUP BY 1,2;
    
    
    
    SELECT segment_slmh,fy,COUNT(DISTINCT txnmappedmobile)users,SUM(bills)orders,SUM(sales)Revenue,ROUND(SUM(sales)/SUM(bills),0)APC,SUM(visits),
     AVG(visits)Freq FROM burgerking.bk_yoy_customer_deliverymode_data_bkapponly WHERE fy = '2025-04-01||2025-09-30'
     GROUP BY 1 ORDER BY users DESC;
   
   ############################################################################################################################
 
 #BK User data SUMMARY---
 
INSERT IGNORE INTO dummy.`bk_sandeep_first_txn_store`(txnmappedmobile,first_txn_store,first_txndate)
SELECT a.txnmappedmobile,modifiedstorecode,modifiedtxndate FROM burgerking.sku_report_loyalty a
  JOIN
   (SELECT txnmappedmobile,MIN(modifiedtxndate)min_date FROM burgerking.sku_report_loyalty
       WHERE modifiedtxndate BETWEEN '2024-09-01' AND '2024-09-30' 
       GROUP BY 1)b ON a.txnmappedmobile = b.txnmappedmobile AND a.modifiedtxndate = b.min_date
     WHERE a.modifiedtxndate BETWEEN '2024-09-01' AND '2024-09-30'
     GROUP BY 1,2,3;#484299

-- select*from dummy.`bk_sandeep_first_txn_store`     
     
     UPDATE dummy.`bk_sandeep_first_txn_store` a 
     JOIN burgerking.store_master b ON a.first_txn_store = b.storecode
    SET a.sub_region = b.region,a.sub_region = b.sub_region,a.city = b.city
    WHERE a.city IS NULL OR a.city = '';#481631
    
--     select*from store_master
    
    INSERT IGNORE INTO dummy.`bk_sandeep_first_txn_store`(txnmappedmobile,first_txn_store,first_txndate)
SELECT a.txnmappedmobile,modifiedstorecode,modifiedtxndate FROM burgerking.sku_report_loyalty a
  JOIN
   (SELECT txnmappedmobile,MIN(modifiedtxndate)max_date FROM burgerking.sku_report_loyalty
       WHERE modifiedtxndate BETWEEN '2025-09-01' AND '2025-09-30' 
       GROUP BY 1)b ON a.txnmappedmobile = b.txnmappedmobile AND a.modifiedtxndate = b.max_date
     WHERE a.modifiedtxndate BETWEEN '2025-09-01' AND '2025-09-30' 
     GROUP BY 1,2,3;#1010894
     
--      SELECT * FROM dummy.`bk_sandeep_first_txn_store` WHERE min_txndate>= '2025-06-01'
     
     UPDATE dummy.`bk_sandeep_first_txn_store` a 
     JOIN burgerking.store_master b ON a.first_txn_store = b.storecode
    SET a.sub_region = b.region,a.sub_region = b.sub_region,a.city = b.city
    WHERE a.city IS NULL OR a.city = '';#990590
     

     
#Region Wise YOY--
SELECT CASE WHEN sub_region  = 'East' THEN '1' WHEN sub_region = 'West 1' THEN '2'
                           WHEN sub_region = 'West 2' THEN '3' WHEN sub_region = 'North 1' THEN '4'
                           WHEN sub_region = 'North 2' THEN '5' WHEN sub_region = 'South' THEN '6' 
                           WHEN sub_region IS NULL THEN '7' END AS 'Seq',
b.sub_region,COUNT(DISTINCT a.txnmappedmobile)Customers,SUM(Bills)Orders,SUM(Sales)Sales,
ROUND(SUM(Sales)/SUM(bills),0)APC,AVG(visits)Freq 
FROM burgerking.`bk_yoy_customer_deliverymode_data_bkapponly` a LEFT JOIN dummy.bk_sandeep_first_txn_store b 
ON a.txnmappedmobile COLLATE utf8mb4_general_ci = b.txnmappedmobile
  WHERE FY = '2025-04-01||2025-09-30' 
  GROUP BY 1,2 ORDER BY seq ASC;
  
--   select * from dummy.bk_sandeep_first_txn_store
--   select*from burgerking.`bk_yoy_customer_deliverymode_data_bkapponly`

#Region Wise MOM  
  SELECT CASE WHEN sub_region  = 'East' THEN '1' WHEN sub_region = 'West 1' THEN '2'
                           WHEN sub_region = 'West 2' THEN '3' WHEN sub_region = 'North 1' THEN '4'
                           WHEN sub_region = 'North 2' THEN '5' WHEN sub_region = 'South' THEN '6' 
                           WHEN sub_region IS NULL THEN '7' END AS 'Seq', 
  b.sub_region,COUNT(DISTINCT a.txnmappedmobile)Customers,SUM(Bills)Orders,ROUND(SUM(Sales),0)Sales,
ROUND(SUM(Sales)/SUM(bills),0)APC,ROUND(AVG(visits),1)Freq 
FROM burgerking.`bk_mom_customer_deliverymode_data_bkapponly` a LEFT JOIN dummy.bk_sandeep_first_txn_store b 
ON a.txnmappedmobile COLLATE utf8mb4_general_ci = b.txnmappedmobile
  WHERE FY = '2025-09-01||2025-09-30'
  GROUP BY 1,2 ORDER BY seq ASC;
  
  #Region Wise QoQ  
  SELECT CASE WHEN sub_region  = 'East' THEN '1' WHEN sub_region = 'West 1' THEN '2'
                           WHEN sub_region = 'West 2' THEN '3' WHEN sub_region = 'North 1' THEN '4'
                           WHEN sub_region = 'North 2' THEN '5' WHEN sub_region = 'South' THEN '6' 
                           WHEN sub_region IS NULL THEN '7' END AS 'Seq', 
  b.sub_region,COUNT(DISTINCT a.txnmappedmobile)Customers,SUM(Bills)Orders,SUM(Sales)Sales,
ROUND(SUM(Sales)/SUM(bills),0)APC,AVG(visits)Freq 
FROM burgerking.`bk_qoq_customer_deliverymode_data_bkapponly` a LEFT JOIN dummy.bk_sandeep_first_txn_store b 
ON a.txnmappedmobile COLLATE utf8mb4_general_ci = b.txnmappedmobile
  WHERE FY = '2025-04-01||2025-09-30' 
  GROUP BY 1,2 ORDER BY seq ASC;## Table does not exist
  
  #Region Wise SLMH--
  
  SELECT `FY_Year`,segment,delivery_modes,Users,Orders,Revenue,ROUND(Revenue/Orders,0)APC,Freq
   FROM burgerking.`bk_yoy_segm_lite_med_heavy_channelwise` WHERE FY_Year = '2025-2026';
  
  SELECT `quarter`,segment,delivery_modes,Users,Orders,Revenue,ROUND(Revenue/Orders,0)APC,Freq
   FROM burgerking.`bk_qoq_segm_lite_med_heavy_channelwise` WHERE `quarter` = '2025-Q2';
  
  SELECT `month`,segment,delivery_modes,Users,Orders,Revenue,ROUND(Revenue/Orders,0)APC,Freq 
  FROM burgerking.bk_mom_segm_lite_med_heavy_channelwise WHERE `month` = 'sep-2025';
  

#YOY New Vs Repeater Witout BK App Filter--

SELECT FY,
COUNT(DISTINCT CASE WHEN min_freq = 1 THEN txnmappedmobile END)New_Users,
SUM(CASE WHEN min_freq = 1 THEN bills END)New_Orders,
SUM(CASE WHEN min_freq = 1 THEN sales END)New_Revenue,
ROUND(SUM(CASE WHEN min_freq = 1 THEN sales END)/SUM(CASE WHEN min_freq = 1 THEN bills END),0)APC,
AVG(CASE WHEN min_freq = 1 THEN visits END)New_avgFreq,
COUNT(DISTINCT CASE WHEN min_freq > 1 THEN txnmappedmobile END)Repeat_Users,
SUM(CASE WHEN min_freq > 1 THEN bills END)Repeat_Orders,
SUM(CASE WHEN min_freq > 1 THEN sales END)Repeat_Revenue,
ROUND(SUM(CASE WHEN min_freq > 1 THEN sales END)/SUM(CASE WHEN min_freq > 1 THEN bills END),0)APC,
AVG(CASE WHEN min_freq >1 THEN visits END)Repeat_avgFreq
FROM burgerking.bk_yoy_customer_deliverymode_data 
WHERE FY = '2025-04-01||2025-09-30'
 GROUP BY 1;


#QoQ New Vs Repeater Witout BK App Filter--

SELECT FY,COUNT(DISTINCT CASE WHEN min_freq = 1 THEN txnmappedmobile END)New_Users,
SUM(CASE WHEN min_freq = 1 THEN bills END)New_Orders,
SUM(CASE WHEN min_freq = 1 THEN sales END)New_Revenue,
ROUND(SUM(CASE WHEN min_freq = 1 THEN sales END)/SUM(CASE WHEN min_freq = 1 THEN bills END),0)APC,
AVG(CASE WHEN min_freq = 1 THEN visits END)New_avgFreq,
COUNT(DISTINCT CASE WHEN min_freq > 1 THEN txnmappedmobile END)Repeat_Users,
SUM(CASE WHEN min_freq > 1 THEN bills END)Repeat_Orders,
SUM(CASE WHEN min_freq > 1 THEN sales END)Repeat_Revenue,
ROUND(SUM(CASE WHEN min_freq > 1 THEN sales END)/SUM(CASE WHEN min_freq > 1 THEN bills END),0)APC,
AVG(CASE WHEN min_freq >1 THEN visits END)Repeat_avgFreq
FROM burgerking.bk_qoq_customer_deliverymode_data 
WHERE FY = '2025-04-01||2025-09-30' GROUP BY 1;## Data Not Fatch


#MOM New Vs Repeater Witout BK App Filter--

SELECT FY,COUNT(DISTINCT CASE WHEN min_freq = 1 THEN txnmappedmobile END)New_Users,
SUM(CASE WHEN min_freq = 1 THEN bills END)New_Orders,
SUM(CASE WHEN min_freq = 1 THEN sales END)New_Revenue,
ROUND(SUM(CASE WHEN min_freq = 1 THEN sales END)/SUM(CASE WHEN min_freq = 1 THEN bills END),0)APC,
AVG(CASE WHEN min_freq = 1 THEN visits END)New_avgFreq,
COUNT(DISTINCT CASE WHEN min_freq > 1 THEN txnmappedmobile END)Repeat_Users,
SUM(CASE WHEN min_freq > 1 THEN bills END)Repeat_Orders,
SUM(CASE WHEN min_freq > 1 THEN sales END)Repeat_Revenue,
ROUND(SUM(CASE WHEN min_freq > 1 THEN sales END)/SUM(CASE WHEN min_freq > 1 THEN bills END),0)APC,
AVG(CASE WHEN min_freq >1 THEN visits END)Repeat_avgFreq
FROM burgerking.bk_mom_customer_deliverymode_data 
WHERE FY = '2025-09-01||2025-09-30' GROUP BY 1;

-- --------------------------------------------------------------------------------------------------------------------------

#YOY Region wise New Vs Repeater Witout BK App Filter--

SELECT CASE WHEN sub_region  = 'East' THEN '1' WHEN sub_region = 'West 1' THEN '2'
                           WHEN sub_region = 'West 2' THEN '3' WHEN sub_region = 'North 1' THEN '4'
                           WHEN sub_region = 'North 2' THEN '5' WHEN sub_region = 'South' THEN '6' 
                           WHEN sub_region IS NULL THEN '7' END AS 'Seq',
Sub_region,
COUNT(DISTINCT CASE WHEN min_freq = 1 THEN a.txnmappedmobile END)New_Users,
SUM(CASE WHEN min_freq = 1 THEN bills END)New_Orders,
SUM(CASE WHEN min_freq = 1 THEN sales END)New_Revenue,
ROUND(SUM(CASE WHEN min_freq = 1 THEN sales END)/SUM(CASE WHEN min_freq = 1 THEN bills END),0)APC,
AVG(CASE WHEN min_freq = 1 THEN visits END)New_avgFreq,
COUNT(DISTINCT CASE WHEN min_freq > 1 THEN a.txnmappedmobile END)Repeat_Users,
SUM(CASE WHEN min_freq > 1 THEN bills END)Repeat_Orders,
SUM(CASE WHEN min_freq > 1 THEN sales END)Repeat_Revenue,
ROUND(SUM(CASE WHEN min_freq > 1 THEN sales END)/SUM(CASE WHEN min_freq > 1 THEN bills END),0)APC,
AVG(CASE WHEN min_freq >1 THEN visits END)Repeat_avgFreq
FROM burgerking.bk_yoy_customer_deliverymode_data a LEFT JOIN dummy.bk_sandeep_first_txn_store b
 ON a.txnmappedmobile COLLATE utf8mb4_general_ci = b.txnmappedmobile
WHERE FY = '2025-04-01||2025-09-30' 
GROUP BY 1,2 ORDER BY seq ASC;## Table does not exist

#QoQ New Vs Repeater Witout BK App Filter--

SELECT CASE WHEN sub_region  = 'East' THEN '1' WHEN sub_region = 'West 1' THEN '2'
                           WHEN sub_region = 'West 2' THEN '3' WHEN sub_region = 'North 1' THEN '4'
                           WHEN sub_region = 'North 2' THEN '5' WHEN sub_region = 'South' THEN '6' 
                           WHEN sub_region IS NULL THEN '7' END AS 'Seq',
Sub_region,
COUNT(DISTINCT CASE WHEN min_freq = 1 THEN a.txnmappedmobile END)New_Users,
SUM(CASE WHEN min_freq = 1 THEN bills END)New_Orders,
SUM(CASE WHEN min_freq = 1 THEN sales END)New_Revenue,
ROUND(SUM(CASE WHEN min_freq = 1 THEN sales END)/SUM(CASE WHEN min_freq = 1 THEN bills END),0)APC,
AVG(CASE WHEN min_freq = 1 THEN visits END)New_avgFreq,
COUNT(DISTINCT CASE WHEN min_freq > 1 THEN a.txnmappedmobile END)Repeat_Users,
SUM(CASE WHEN min_freq > 1 THEN bills END)Repeat_Orders,
SUM(CASE WHEN min_freq > 1 THEN sales END)Repeat_Revenue,
ROUND(SUM(CASE WHEN min_freq > 1 THEN sales END)/SUM(CASE WHEN min_freq > 1 THEN bills END),0)APC,
AVG(CASE WHEN min_freq >1 THEN visits END)Repeat_avgFreq
FROM burgerking.bk_qoq_customer_deliverymode_data a LEFT JOIN dummy.bk_sandeep_first_txn_store b
 ON a.txnmappedmobile COLLATE utf8mb4_general_ci = b.txnmappedmobile
WHERE FY = '2025-04-01||2025-09-30' GROUP BY 1,2 ORDER BY seq ASC; ##Data not fetch

#MOM New Vs Repeater Witout BK App Filter--

SELECT CASE WHEN sub_region  = 'East' THEN '1' WHEN sub_region = 'West 1' THEN '2'
                           WHEN sub_region = 'West 2' THEN '3' WHEN sub_region = 'North 1' THEN '4'
                           WHEN sub_region = 'North 2' THEN '5' WHEN sub_region = 'South' THEN '6' 
                           WHEN sub_region IS NULL THEN '7' END AS 'Seq',
Sub_region,
COUNT(DISTINCT CASE WHEN min_freq = 1 THEN a.txnmappedmobile END)New_Users,
SUM(CASE WHEN min_freq = 1 THEN bills END)New_Orders,
SUM(CASE WHEN min_freq = 1 THEN sales END)New_Revenue,
ROUND(SUM(CASE WHEN min_freq = 1 THEN sales END)/SUM(CASE WHEN min_freq = 1 THEN bills END),0)APC,
AVG(CASE WHEN min_freq = 1 THEN visits END)New_avgFreq,
COUNT(DISTINCT CASE WHEN min_freq > 1 THEN a.txnmappedmobile END)Repeat_Users,
SUM(CASE WHEN min_freq > 1 THEN bills END)Repeat_Orders,
SUM(CASE WHEN min_freq > 1 THEN sales END)Repeat_Revenue,
ROUND(SUM(CASE WHEN min_freq > 1 THEN sales END)/SUM(CASE WHEN min_freq > 1 THEN bills END),0)APC,
AVG(CASE WHEN min_freq >1 THEN visits END)Repeat_avgFreq
FROM burgerking.bk_mom_customer_deliverymode_data a LEFT JOIN dummy.bk_sandeep_first_txn_store b
 ON a.txnmappedmobile COLLATE utf8mb4_general_ci = b.txnmappedmobile
WHERE FY = '2025-09-01||2025-09-30' 
 GROUP BY 1,2 ORDER BY seq ASC;
 

SELECT `month`,region,CASE WHEN region = 'East' THEN '1'
       WHEN region = 'West 1' THEN '2'
       WHEN region = 'West 2' THEN '3'
       WHEN region = 'North 1' THEN '4'
       WHEN region = 'North 2' THEN '5'
       WHEN region = 'South' THEN '6'
       WHEN region IS NULL THEN '7' END AS 'regionseq',churncount
   FROM burgerking.bk_mom_churn_regionwise WHERE `month` = '2025-09-30'
    ORDER BY regionseq ASC;#data not fetch
    
  
  SELECT `month`,region,CASE WHEN region = 'East' THEN '1'
       WHEN region = 'West 1' THEN '2'
       WHEN region = 'West 2' THEN '3'
       WHEN region = 'North 1' THEN '4'
       WHEN region = 'North 2' THEN '5'
       WHEN region = 'South' THEN '6'
       WHEN region IS NULL THEN '7' END AS 'regionseq',winbackcount
        FROM burgerking.bk_mom_winback_regionwise WHERE `Month` = 'Sep-2025' 
        ORDER BY regionseq ASC ;
  
  SELECT `Quarter`,region,CASE WHEN region = 'East' THEN '1'
       WHEN region = 'West 1' THEN '2'
       WHEN region = 'West 2' THEN '3'
       WHEN region = 'North 1' THEN '4'
       WHEN region = 'North 2' THEN '5'
       WHEN region = 'South' THEN '6'
       WHEN region IS NULL THEN '7' END AS 'regionseq',winbackcount
       FROM burgerking.bk_qoq_winback_regionwise 
  WHERE QUARTER = '2025-Q2' ORDER BY regionseq ASC ;
  
  SELECT `FY`,region,CASE WHEN region = 'East' THEN '1'
       WHEN region = 'West 1' THEN '2'
       WHEN region = 'West 2' THEN '3'
       WHEN region = 'North 1' THEN '4'
       WHEN region = 'North 2' THEN '5'
       WHEN region = 'South' THEN '6'
       WHEN region IS NULL THEN '7' END AS 'regionseq',winbackcount 
       FROM burgerking.bk_yoy_winback_regionwise WHERE FY = '2025-2026'
        ORDER BY regionseq ASC;
       
   ############################################################################################################################################

# BkApp Repeaters Report Queries---

SELECT COUNT(txnmappedmobile) FROM burgerking.bk_yoy_customer_deliverymode_data_bkapponly
  WHERE fy = '2021-04-01||2022-03-31';
  
  SELECT COUNT(txnmappedmobile) FROM burgerking.bk_yoy_customer_deliverymode_data_bkapponly
  WHERE fy = '2022-04-01||2023-03-31';
  
  -- ----------------------------------------------------------------------------------------------------------------------------------------
 
 #Yearly Repeat #FY22-FY25---
 
  SELECT 
  CASE WHEN a.visits>50 THEN '50+' ELSE a.visits END AS 'FY22 Visits', 
  CASE WHEN b.visits>50 THEN '50+' ELSE b.visits END AS 'FY25 Visits', b.delivery_modes AS 'FY25 Order Mode', 
  COUNT(b.txnmappedmobile)'FY25 Reepaters',
  SUM(b.sales)'FY25 Revenue',
  SUM(b.bills)'FY25 Orders', ROUND(SUM(b.sales)/SUM(b.bills),0)'FY25 APC',
   SUM(b.visits)'FY25 Visits' 
   FROM (SELECT * FROM burgerking.`bk_yoy_customer_deliverymode_data_bkapponly` WHERE fy = '2021-04-01||2022-03-31')a 
   JOIN
    (SELECT * FROM burgerking.`bk_yoy_customer_deliverymode_data_bkapponly` WHERE fy = '2025-04-01||2025-09-30')b
     ON a.txnmappedmobile = b.txnmappedmobile 
   GROUP BY 1,2,3;
   
   #FY22-23-FY25-26---
   SELECT 
  CASE WHEN a.visits>50 THEN '50+' ELSE a.visits END AS 'FY23 Visits', 
  CASE WHEN b.visits>50 THEN '50+' ELSE b.visits END AS 'FY25 Visits', b.delivery_modes AS 'FY25 Order Mode', 
  COUNT(b.txnmappedmobile)'FY25 Reepaters',
  SUM(b.sales)'FY25 Revenue',
  SUM(b.bills)'FY25 Orders', ROUND(SUM(b.sales)/SUM(b.bills),0)'FY25 APC',
   SUM(b.visits)'FY25 Visits' 
   FROM (SELECT * FROM burgerking.`bk_yoy_customer_deliverymode_data_bkapponly` WHERE fy = '2022-04-01||2023-03-31')a 
   JOIN
    (SELECT * FROM burgerking.`bk_yoy_customer_deliverymode_data_bkapponly` WHERE fy = '2025-04-01||2025-09-30')b
     ON a.txnmappedmobile = b.txnmappedmobile 
   GROUP BY 1,2,3;
   
   #FY23-24-FY25-26---
   SELECT 
  CASE WHEN a.visits>50 THEN '50+' ELSE a.visits END AS 'FY24 Visits', 
  CASE WHEN b.visits>50 THEN '50+' ELSE b.visits END AS 'FY25 Visits', b.delivery_modes AS 'FY25 Order Mode', 
  COUNT(b.txnmappedmobile)'FY25 Reepaters',
  SUM(b.sales)'FY25 Revenue',
  SUM(b.bills)'FY25 Orders', ROUND(SUM(b.sales)/SUM(b.bills),0)'FY25 APC',
   SUM(b.visits)'FY25 Visits' 
   FROM (SELECT * FROM burgerking.`bk_yoy_customer_deliverymode_data_bkapponly` WHERE fy = '2023-04-01||2024-03-31')a 
   JOIN
    (SELECT * FROM burgerking.`bk_yoy_customer_deliverymode_data_bkapponly` WHERE fy = '2025-04-01||2025-09-30')b
     ON a.txnmappedmobile = b.txnmappedmobile 
   GROUP BY 1,2,3;
   
    #FY24-25-FY25-26---
    
   SELECT 
  CASE WHEN a.visits>50 THEN '50+' ELSE a.visits END AS 'FY24 Visits', 
  CASE WHEN b.visits>50 THEN '50+' ELSE b.visits END AS 'FY25 Visits', b.delivery_modes AS 'FY25 Order Mode', 
  COUNT(b.txnmappedmobile)'FY25 Reepaters',
  SUM(b.sales)'FY25 Revenue',
  SUM(b.bills)'FY25 Orders', ROUND(SUM(b.sales)/SUM(b.bills),0)'FY25 APC',
   SUM(b.visits)'FY25 Visits' 
   FROM (SELECT * FROM burgerking.`bk_yoy_customer_deliverymode_data_bkapponly` WHERE fy = '2024-04-01||2025-03-31')a 
   JOIN
    (SELECT * FROM burgerking.`bk_yoy_customer_deliverymode_data_bkapponly` WHERE fy = '2025-04-01||2025-09-30')b
     ON a.txnmappedmobile = b.txnmappedmobile 
   GROUP BY 1,2,3;
 
  
  #Repeaters MOnthly Level---
  
   
  #FY21-22 to FY25-26 Repeat customers--
  
  SELECT CASE 
   WHEN b.fy = '2025-04-01||2025-04-30' THEN 'Apr-25'
   WHEN b.fy = '2025-05-01||2025-05-31' THEN 'May-25' 
   WHEN b.fy = '2025-06-01||2025-06-30' THEN 'June-25'
   WHEN b.fy = '2025-07-01||2025-07-31' THEN 'July-25'
   WHEN b.fy = '2025-08-01||2025-08-31' THEN 'Aug-25'
   WHEN b.fy = '2025-09-01||2025-09-30' THEN 'Sep-25'
   END AS 'FY25 Month',
  b.delivery_modes AS 'FY25 Order Mode',
CASE WHEN b.visits>8 THEN '8+' ELSE b.visits END AS 'FY25 Visits Bucket',
COUNT(b.txnmappedmobile)'FY25 Repeaters',SUM(b.sales)'FY25 Revenue',SUM(b.bills)'FY25 Orders',
ROUND(SUM(b.sales)/SUM(b.bills),0)'FY25 APC',SUM(b.visits)'FY25 Visits'
FROM 
(SELECT txnmappedmobile FROM burgerking.`bk_yoy_customer_deliverymode_data_bkapponly` WHERE fy = '2021-04-01||2022-03-31')a
JOIN
(SELECT * FROM burgerking.`bk_mom_customer_deliverymode_data_bkapponly` 
   WHERE fy IN ('2025-04-01||2025-04-30','2025-05-01||2025-05-31','2025-06-01||2025-06-30','2025-07-01||2025-07-31',
   '2025-08-01||2025-08-31','2025-09-01||2025-09-30'))b   
   ON a.txnmappedmobile = b.txnmappedmobile
  GROUP BY 1,2,3;
  
  #FY22-23 to FY25-26 Repeat customers--
  
   SELECT CASE 
   WHEN b.fy = '2025-04-01||2025-04-30' THEN 'Apr-25'
   WHEN b.fy = '2025-05-01||2025-05-31' THEN 'May-25' 
   WHEN b.fy = '2025-06-01||2025-06-30' THEN 'June-25'
   WHEN b.fy = '2025-07-01||2025-07-31' THEN 'July-25'
   WHEN b.fy = '2025-08-01||2025-08-31' THEN 'Aug-25'
   WHEN b.fy = '2025-09-01||2025-09-30' THEN 'Sep-25'
   END AS 'FY25 Month',
  b.delivery_modes AS 'FY25 Order Mode',
CASE WHEN b.visits>8 THEN '8+' ELSE b.visits END AS 'FY25 Visits Bucket',
COUNT(b.txnmappedmobile)'FY25 Repeaters',SUM(b.sales)'FY25 Revenue',SUM(b.bills)'FY25 Orders',
ROUND(SUM(b.sales)/SUM(b.bills),0)'FY25 APC',SUM(b.visits)'FY25 Visits'
FROM 
(SELECT txnmappedmobile FROM burgerking.`bk_yoy_customer_deliverymode_data_bkapponly` WHERE fy = '2022-04-01||2023-03-31')a
JOIN
(SELECT * FROM burgerking.`bk_mom_customer_deliverymode_data_bkapponly` 
   WHERE fy IN ('2025-04-01||2025-04-30','2025-05-01||2025-05-31','2025-06-01||2025-06-30',
   '2025-07-01||2025-07-31','2025-08-01||2025-08-31','2025-09-01||2025-09-30'))b   
   ON a.txnmappedmobile = b.txnmappedmobile
  GROUP BY 1,2,3;
  
   #FY23-24 to FY2526 Repeat customers--
  
   SELECT CASE 
   WHEN b.fy = '2025-04-01||2025-04-30' THEN 'Apr-25'
   WHEN b.fy = '2025-05-01||2025-05-31' THEN 'May-25'
   WHEN b.fy = '2025-06-01||2025-06-30' THEN 'June-25'
   WHEN b.fy = '2025-07-01||2025-07-31' THEN 'July-25'
   WHEN b.fy = '2025-08-01||2025-08-31' THEN 'Aug-25'
   WHEN b.fy = '2025-09-01||2025-09-30' THEN 'Sep-25'
   END AS 'FY25 Month',
  b.delivery_modes AS 'FY25 Order Mode',
CASE WHEN b.visits>8 THEN '8+' ELSE b.visits END AS 'FY25 Visits Bucket',
COUNT(b.txnmappedmobile)'FY25 Repeaters',SUM(b.sales)'FY25 Revenue',SUM(b.bills)'FY25 Orders',
ROUND(SUM(b.sales)/SUM(b.bills),0)'FY25 APC',SUM(b.visits)'FY25 Visits'
FROM 
(SELECT txnmappedmobile FROM burgerking.`bk_yoy_customer_deliverymode_data_bkapponly` WHERE fy = '2023-04-01||2024-03-31')a
JOIN
(SELECT * FROM burgerking.`bk_mom_customer_deliverymode_data_bkapponly` 
   WHERE fy IN ('2025-04-01||2025-04-30','2025-05-01||2025-05-31','2025-06-01||2025-06-30','2025-07-01||2025-07-31',
   '2025-08-01||2025-08-31','2025-09-01||2025-09-30'))b   
   ON a.txnmappedmobile = b.txnmappedmobile
  GROUP BY 1,2,3;
  
  #FY24-25 to FY2526 Repeat customers--
  
    SELECT CASE 
   WHEN b.fy = '2025-04-01||2025-04-30' THEN 'Apr-25'
   WHEN b.fy = '2025-05-01||2025-05-31' THEN 'May-25'
   WHEN b.fy = '2025-06-01||2025-06-30' THEN 'Jun-25'
    WHEN b.fy = '2025-07-01||2025-07-31' THEN 'July-25'
    WHEN b.fy = '2025-08-01||2025-08-31' THEN 'Aug-25'
    WHEN b.fy = '2025-09-01||2025-09-30' THEN 'Sep-25'
   END AS 'FY25 Month',
  b.delivery_modes AS 'FY25 Order Mode',
CASE WHEN b.visits>8 THEN '8+' ELSE b.visits END AS 'FY25 Visits Bucket',
COUNT(b.txnmappedmobile)'FY25 Repeaters',SUM(b.sales)'FY25 Revenue',SUM(b.bills)'FY25 Orders',
ROUND(SUM(b.sales)/SUM(b.bills),0)'FY25 APC',SUM(b.visits)'FY25 Visits'
FROM 
(SELECT txnmappedmobile FROM burgerking.`bk_yoy_customer_deliverymode_data_bkapponly` WHERE fy = '2024-04-01||2025-03-31')a
JOIN
(SELECT * FROM burgerking.`bk_mom_customer_deliverymode_data_bkapponly` 
   WHERE fy IN ('2025-04-01||2025-04-30','2025-05-01||2025-05-31','2025-06-01||2025-06-30',
   '2025-07-01||2025-07-31','2025-08-01||2025-08-31','2025-09-01||2025-09-30'))b   
   ON a.txnmappedmobile = b.txnmappedmobile
  GROUP BY 1,2,3;
  
  #FY21-22 to FY25-26---
  
  SELECT a.segment_slmh AS 'Segment SLMH FY22',
  b.segment_slmh AS 'Segment SLMH FY25',
  b.delivery_modes AS 'Order Mode FY25',
  COUNT(b.txnmappedmobile)'FY25 Repeaters',
SUM(b.sales)'FY25 Revenue',
SUM(b.bills)'FY25 Orders',
ROUND(SUM(b.sales)/SUM(b.bills),0)'FY25 APC',
SUM(b.visits)'FY25 Visits'
FROM 
(SELECT txnmappedmobile,segment_slmh FROM burgerking.bk_yoy_customer_deliverymode_data_bkapponly 
   WHERE fy = '2021-04-01||2022-03-31')a
JOIN
(SELECT * FROM burgerking.bk_yoy_customer_deliverymode_data_bkapponly
   WHERE fy  = '2025-04-01||2025-09-30')b
   ON a.txnmappedmobile = b.txnmappedmobile
  GROUP BY 1,2,3; 


#FY22-23-FY25-26
 SELECT a.segment_slmh AS 'Segment_slmh FY2223',
  b.segment_slmh AS 'Segment_slmh FY2425',
  b.delivery_modes AS 'Order Mode',
  COUNT(b.txnmappedmobile)'FY23-24 Repeaters',
SUM(b.sales)'FY23-24 Revenue',
SUM(b.bills)'FY23-24 Orders',
ROUND(SUM(b.sales)/SUM(b.bills),0)'FY23-24 APC',
SUM(b.visits)'FY23-24 Visits'
FROM 
(SELECT txnmappedmobile,segment_slmh FROM burgerking.bk_yoy_customer_deliverymode_data_bkapponly 
   WHERE fy = '2022-04-01||2023-03-31')a
JOIN
(SELECT * FROM burgerking.bk_yoy_customer_deliverymode_data_bkapponly
   WHERE fy  = '2025-04-01||2025-09-30')b
   ON a.txnmappedmobile = b.txnmappedmobile
  GROUP BY 1,2,3;  
  
  
   #FY23-24-FY25-26--
  SELECT a.segment_slmh AS 'Segment_slmh FY2324',
  b.segment_slmh AS 'Segment_slmh FY2425',
  b.delivery_modes AS 'Order Mode',
  COUNT(b.txnmappedmobile)'FY24-25 Repeaters',
SUM(b.sales)'FY24-25 Revenue',
SUM(b.bills)'FY24-25 Orders',
ROUND(SUM(b.sales)/SUM(b.bills),0)'FY24-25 APC',
SUM(b.visits)'FY24-25 Visits'
FROM 
(SELECT txnmappedmobile,segment_slmh FROM burgerking.bk_yoy_customer_deliverymode_data_bkapponly 
   WHERE fy = '2023-04-01||2024-03-31')a
JOIN
(SELECT * FROM burgerking.bk_yoy_customer_deliverymode_data_bkapponly
   WHERE fy  = '2025-04-01||2025-09-30')b
   ON a.txnmappedmobile = b.txnmappedmobile
  GROUP BY 1,2,3;
  
  #FY24-25-FY25-26--
  
    SELECT a.segment_slmh AS 'Segment_slmh FY2425',
  b.segment_slmh AS 'Segment_slmh FY2526',
  b.delivery_modes AS 'Order Mode',
  COUNT(b.txnmappedmobile)'FY25-26 Repeaters',
SUM(b.sales)'FY25-26 Revenue',
SUM(b.bills)'FY25-26 Orders',
ROUND(SUM(b.sales)/SUM(b.bills),0)'FY25-26 APC',
SUM(b.visits)'FY25-26 Visits'
FROM 
(SELECT txnmappedmobile,segment_slmh FROM burgerking.bk_yoy_customer_deliverymode_data_bkapponly 
   WHERE fy = '2024-04-01||2025-03-31')a
JOIN
(SELECT * FROM burgerking.bk_yoy_customer_deliverymode_data_bkapponly
   WHERE fy  = '2025-04-01||2025-09-30')b
   ON a.txnmappedmobile = b.txnmappedmobile
  GROUP BY 1,2,3;
  
  SHOW FULL PROCESSLIST;
  
  
  SELECT CASE WHEN delivery_modes = 'Dine In' THEN 'Dine IN'
              WHEN delivery_modes = 'Delivery' THEN 'Delivery'
              WHEN delivery_modes IN ('Delivery,Dine In','Delivery,Dine In,Dine In',
              'Delivery,Delivery,Dine In,Dine In',',Delivery,Delivery,Dine In') THEN 'Omni' END AS Tag,
     COUNT(DISTINCT txnmappedmobile)Customers,
     SUM(bills)Orders,
     SUM(sales)Revenue,
     ROUND(SUM(visits)/COUNT(DISTINCT txnmappedmobile),2)Freq
                FROM 
  (SELECT txnmappedmobile,GROUP_CONCAT(DISTINCT delivery_modes)delivery_modes,
    SUM(sales)Sales,SUM(bills)bills,SUM(visits)visits  
   FROM burgerking.bk_mom_customer_deliverymode_data_bkapponly
    WHERE FY IN ('2023-07-01||2023-07-31','2023-08-01||2023-08-31','2023-09-01||2023-09-30','2023-10-01||2023-10-31'
                 '2023-11-01||2023-11-30','2023-12-01||2023-12-31','2024-01-01||2024-01-31','2024-02-01||2024-02-28',
                 '2024-03-01||2024-03-31','2024-04-01||2024-04-30','2024-05-01||2024-05-31','2024-06-01||2024-06-30',
                 '2024-07-01||2024-07-31','2024-08-01||2024-08-31','2024-09-01||2024-09-30')
         GROUP BY 1)a
    GROUP BY 1;
    
    SELECT CASE 
    WHEN bills = 1 THEN '4 Single' 
    WHEN bills BETWEEN 2 AND 4 THEN '3 Lite' 
    WHEN bills BETWEEN 5 AND 8 THEN '2 Meduim' WHEN bills >8 THEN '1 High' END AS SLMH,
     COUNT(DISTINCT txnmappedmobile)Customers,
     SUM(bills)Orders,
     SUM(sales)Revenue,
     ROUND(SUM(visits)/COUNT(DISTINCT txnmappedmobile),2)Freq
                FROM 
  (SELECT txnmappedmobile,
    SUM(sales)Sales,SUM(bills)bills,SUM(visits)visits  
   FROM burgerking.bk_mom_customer_deliverymode_data_bkapponly
    WHERE FY IN ('2023-07-01||2023-07-31','2023-08-01||2023-08-31','2023-09-01||2023-09-30','2023-10-01||2023-10-31'
                 '2023-11-01||2023-11-30','2023-12-01||2023-12-31','2024-01-01||2024-01-31','2024-02-01||2024-02-28',
                 '2024-03-01||2024-03-31','2024-04-01||2024-04-30','2024-05-01||2024-05-31','2024-06-01||2024-06-30',
                 '2024-07-01||2024-07-31','2024-08-01||2024-08-31','2024-09-01||2024-09-30')
         GROUP BY 1)a
    GROUP BY 1 ORDER BY SLMH ASC;
    
    SELECT CASE 
    WHEN visits = 1 THEN '3 Junior' 
    WHEN visits BETWEEN 2 AND 3 THEN '2 Whopper' 
    WHEN visits >=4 THEN '1 King' END AS Customertype,
     COUNT(DISTINCT txnmappedmobile)Customers,
     SUM(bills)Orders,
     SUM(sales)Revenue,
     ROUND(SUM(visits)/COUNT(DISTINCT txnmappedmobile),2)Freq
                FROM 
  (SELECT txnmappedmobile,
    SUM(sales)Sales,SUM(bills)bills,SUM(visits)visits  
   FROM burgerking.bk_mom_customer_deliverymode_data_bkapponly
    WHERE FY IN ('2023-07-01||2023-07-31','2023-08-01||2023-08-31','2023-09-01||2023-09-30','2023-10-01||2023-10-31'
                 '2023-11-01||2023-11-30','2023-12-01||2023-12-31','2024-01-01||2024-01-31','2024-02-01||2024-02-28',
		 '2024-03-01||2024-03-31','2024-04-01||2024-04-30','2024-05-01||2024-05-31','2024-06-01||2024-06-30',
		 '2024-07-01||2024-07-31','2024-08-01||2024-08-31','2024-09-01||2024-09-30')
         GROUP BY 1)a
    GROUP BY 1 ORDER BY Customertype ASC;
    
    
     SELECT CASE WHEN min_freq =1 THEN 'New' ELSE 'Repeater' END AS Tag,
     COUNT(DISTINCT txnmappedmobile)Customers,
     SUM(bills)Orders,
     SUM(sales)Revenue,
     ROUND(SUM(visits)/COUNT(DISTINCT txnmappedmobile),2)Freq
                FROM 
  (SELECT txnmappedmobile,
    SUM(sales)Sales,SUM(bills)bills,SUM(visits)visits,MIN(min_freq)min_freq
   FROM burgerking.bk_mom_customer_deliverymode_data_bkapponly
    WHERE FY IN ('2023-07-01||2023-07-31','2023-08-01||2023-08-31','2023-09-01||2023-09-30','2023-10-01||2023-10-31'
                 '2023-11-01||2023-11-30','2023-12-01||2023-12-31','2024-01-01||2024-01-31','2024-02-01||2024-02-28',
                 '2024-03-01||2024-03-31','2024-04-01||2024-04-30','2024-05-01||2024-05-31','2024-06-01||2024-06-30',
                 '2024-07-01||2024-07-31','2024-08-01||2024-08-31','2024-09-01||2024-09-30')
         GROUP BY 1)a
    GROUP BY 1;
    
      
    SHOW FULL PROCESSLIST;
    
    
    
  
  
  
  
  
  
  
  
  
  
  
 
 
  
### Rolling 12M Queries--

SELECT MAX(modifiedtxndate) FROM dummy.bkapp_raw_data #2025-05-31

/*CREATE TABLE dummy.bkapp_rolling_12m_jul23_jun24(Txnmappedmobile VARCHAR(10),delivery_modes VARCHAR(30),
sales VARCHAR(10),bills INT,visits INT, qty INT,min_freq INT);

ALTER TABLE dummy.bkapp_rolling_12m_jul23_jun24 ADD INDEX mob(txnmappedmobile);

INSERT INTO dummy.bkapp_rolling_12m_jul23_jun24(Txnmappedmobile,delivery_modes,
sales,bills,visits, qty,min_freq)
SELECT txnmappedmobile,GROUP_CONCAT(DISTINCT CASE WHEN deliverymode IN ('Dine In','Take Away','BKMobile_TA','BKMob_Dinein',
'Cafe Take Away','Cafe Dine In','Dessert Kiosk','Kiosk','Drive Thru','Kiosk TA')  THEN 'Dinein'  
WHEN deliverymode IN('Delivery','BKMob_Del') THEN 'Delivery' END)AS Delivery_modes,
ROUND(SUM(itemnetamount),0)Sales,
COUNT(DISTINCT uniquebillno)Bills,
COUNT(DISTINCT modifiedtxndate)Visits,
SUM(itemqty)Qty,
MIN(frequencycount)min_freq
FROM dummy.bkapp_raw_data 
WHERE modifiedtxndate BETWEEN '2023-07-01' AND '2024-06-30' 
AND source IN ('BKAPP','BKMob_Del','BKMob_Dinein','BKMobile_TA') 
GROUP BY 1;*/

ALTER TABLE dummy.bkapp_rolling_12m_jul23_jun24 ADD COLUMN segment VARCHAR(30);
ALTER TABLE dummy.bkapp_rolling_12m_jul23_jun24 ADD COLUMN veg_nonveg VARCHAR(50);
ALTER TABLE dummy.bkapp_rolling_12m_jul23_jun24 ADD COLUMN cust_type VARCHAR(30);
ALTER TABLE dummy.bkapp_rolling_12m_jul23_jun24 ADD COLUMN coupon_issued INT;
ALTER TABLE dummy.bkapp_rolling_12m_jul23_jun24 ADD COLUMN coupon_redeemed INT;
ALTER TABLE dummy.bkapp_rolling_12m_jul23_jun24 ADD COLUMN is_redeemer INT;

UPDATE dummy.bkapp_rolling_12m_jul23_jun24
   SET segment = CASE WHEN bills =1 THEN 'Single'
WHEN bills BETWEEN 2 AND 4 THEN 'Lite'
WHEN bills BETWEEN 5 AND 8 THEN 'Medium'
WHEN bills >=9 THEN 'Heavy' END;

UPDATE dummy.bkapp_rolling_12m_jul23_jun24
SET cust_type = CASE WHEN visits =1 THEN "3.Junior"
                     WHEN visits BETWEEN 2 AND 3 THEN "2.Whopper"
                     WHEN visits >=4 THEN "1.King" END;
                     
   SELECT * FROM dummy.rolling_Jul23_jun24_vegnoveg
                     
  CREATE TABLE dummy.rolling_Jul23_jun24_vegnoveg(txnmappedmobile VARCHAR(10),veg_nonveg VARCHAR(30));
  ALTER TABLE dummy.rolling_Jul23_jun24_vegnoveg ADD INDEX mob(txnmappedmobile);
   ALTER TABLE dummy.rolling_Jul23_jun24_vegnoveg ADD INDEX tag(veg_nonveg);
   
INSERT INTO dummy.rolling_Jul23_jun24_vegnoveg()   
  SELECT txnmappedmobile,
 GROUP_CONCAT(DISTINCT CASE WHEN b.gender IN ('Non Veg','NON-VEG','NonVeg') THEN 'Non Veg' 
  WHEN b.gender = 'Veg' THEN 'Veg' ELSE '' END) AS veg_nonveg
 FROM dummy.bkapp_raw_data a 
 JOIN dummy.temp_bk_item_master b ON a.uniqueitemcode COLLATE utf8mb4_general_ci  = b.uniqueitemcode
 WHERE a.modifiedtxndate >= '2023-07-01' AND a.modifiedtxndate<= '2024-05-31' 
 AND SOURCE IN ('BKAPP','BKMob_Del','BKMob_Dinein','BKMobile_TA') AND b.gender IN ('Non Veg','NON-VEG','NonVeg','Veg')
 GROUP BY 1;
 
CREATE TABLE dummy.rolling_Jul23_jun24_couponIssued(Txnmappedmobile VARCHAR(10),coupon_Issued INT);
ALTER TABLE dummy.rolling_Jul23_jun24_couponIssued ADD INDEX mobile(Txnmappedmobile);

CREATE TABLE dummy.rolling_Jul2_jun24_couponredeemed(Txnmappedmobile VARCHAR(10),coupon_redeemed INT);
ALTER TABLE dummy.rolling_Jul2_jun24_couponredeemed ADD INDEX mobile(Txnmappedmobile);

INSERT INTO dummy.rolling_Jul23_jun24_couponIssued()
SELECT issuedmobile,COUNT(DISTINCT couponcode)coupon_issued 
               FROM burgerking.coupon_offer_report 
               WHERE Issueddate>= '2023-07-01' AND Issueddate<= '2024-06-30'
               AND couponoffercode IN ('JCA8PMR0C0','5RJ87BJSXI','2A8TBLE7CR','4ZIO7YB34F','VJMPSB157E',
                                          'A8K7PRD2MA','352DW5RYWZ','ZWNNFSZU8C','3WWSNLDQSP','OGSZ4FZKRZ',
                                           '5PWDWYU0A7','GDORRO8RA3','0E2T54F3V1','3UQ1AHKZIQ','C4RC5NRU7Z',
                                             '8CN4HWX2RC','USSU735ULN','XN4W4XD4KW','1NL2B9GCNO','S7IOD1QRQS','KQQUG8AQE8','E1AV64SCBG','GBMY47Z6KK','OK1RZYP5RX',
                                                'TXZIE657IO','AUW5DPYARU')
              GROUP BY 1;
              
              
              
  INSERT INTO dummy.rolling_Jul2_jun24_couponredeemed()            
  SELECT redeemedmobile,COUNT(DISTINCT couponcode)coupon_redeemed 
               FROM burgerking.coupon_offer_report 
               WHERE useddate>= '2023-07-01' AND useddate<= '2024-06-30' AND couponstatus = 'Used'
               AND couponoffercode IN ('JCA8PMR0C0','5RJ87BJSXI','2A8TBLE7CR','4ZIO7YB34F','VJMPSB157E',
                                          'A8K7PRD2MA','352DW5RYWZ','ZWNNFSZU8C','3WWSNLDQSP','OGSZ4FZKRZ',
                                           '5PWDWYU0A7','GDORRO8RA3','0E2T54F3V1','3UQ1AHKZIQ','C4RC5NRU7Z',
                                             '8CN4HWX2RC','USSU735ULN','XN4W4XD4KW','1NL2B9GCNO','S7IOD1QRQS','KQQUG8AQE8','E1AV64SCBG','GBMY47Z6KK','OK1RZYP5RX',
                                                'TXZIE657IO','AUW5DPYARU')
              GROUP BY 1;
 
 UPDATE dummy.bkapp_rolling_12m_jul23_jun24
 SET veg_nonveg = NULL;
  
 UPDATE dummy.bkapp_rolling_12m_jul23_jun24 a
   JOIN dummy.rolling_Jul23_jun24_vegnoveg b ON a.txnmappedmobile = b.txnmappedmobile
  SET a.veg_nonveg = b.veg_nonveg;
    
  UPDATE dummy.bkapp_rolling_12m_jul23_jun24 a
    JOIN (SELECT * FROM dummy.rolling_Jul23_jun24_couponIssued)b ON a.txnmappedmobile = b.txnmappedmobile
         SET a.coupon_issued = b.coupon_issued;

UPDATE dummy.bkapp_rolling_12m_jul23_jun24 a
    JOIN (SELECT * FROM dummy.rolling_Jul2_jun24_couponredeemed)b ON a.txnmappedmobile = b.txnmappedmobile
         SET a.coupon_redeemed = b.coupon_redeemed;
         
UPDATE dummy.bkapp_rolling_12m_jul23_jun24 SET is_redeemer = CASE WHEN coupon_redeemed>=1 THEN '1' ELSE '0' END;

ALTER TABLE dummy.bkapp_rolling_12m_jul23_jun24 ADD COLUMN sub_region VARCHAR(20);
ALTER TABLE dummy.bkapp_rolling_12m_jul23_jun24 ADD COLUMN City VARCHAR(30);

UPDATE dummy.bkapp_rolling_12m_jul23_jun24  a
  JOIN dummy.`bk_sandeep_first_txn_store` b ON a.txnmappedmobile = b.txnmappedmobile
 SET a.sub_region = b.sub_region,
     a.city = b.city;
     


CREATE TABLE dummy.bkapp_rolling_12m_Jul24_Jun25_v2(Txnmappedmobile VARCHAR(10),delivery_modes VARCHAR(20),
sales VARCHAR(10),bills INT,visits INT, qty INT,min_freq INT);

ALTER TABLE dummy.bkapp_rolling_12m_Jul24_Jun25_v2 ADD INDEX mob(txnmappedmobile);

INSERT INTO dummy.bkapp_rolling_12m_Jul24_Jun25_v2(Txnmappedmobile,delivery_modes,
sales,bills,visits, qty,min_freq)
SELECT txnmappedmobile,GROUP_CONCAT(DISTINCT CASE WHEN deliverymode IN ('Dine In','Take Away','BKMobile_TA','BKMob_Dinein',
'Cafe Take Away','Cafe Dine In','Dessert Kiosk','Kiosk','Drive Thru','Kiosk TA')  THEN 'Dinein'  
WHEN deliverymode IN('Delivery','BKMob_Del') THEN 'Delivery' END)AS Delivery_modes,
ROUND(SUM(itemnetamount),0)Sales,
COUNT(DISTINCT uniquebillno)Bills,
COUNT(DISTINCT modifiedtxndate)Visits,
SUM(itemqty)Qty,
MIN(frequencycount)min_freq
FROM dummy.bkapp_raw_data 
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2025-05-31' 
AND SOURCE IN ('BKAPP','BKMob_Del','BKMob_Dinein','BKMobile_TA') 
GROUP BY 1;

ALTER TABLE dummy.bkapp_rolling_12m_Jul24_Jun25_v2 ADD COLUMN segment VARCHAR(30);
ALTER TABLE dummy.bkapp_rolling_12m_Jul24_Jun25_v2 ADD COLUMN veg_nonveg VARCHAR(50);
ALTER TABLE dummy.bkapp_rolling_12m_Jul24_Jun25_v2 ADD COLUMN cust_type VARCHAR(30);
ALTER TABLE dummy.bkapp_rolling_12m_Jul24_Jun25_v2 ADD COLUMN coupon_issued INT;
ALTER TABLE dummy.bkapp_rolling_12m_Jul24_Jun25_v2 ADD COLUMN coupon_redeemed INT;
ALTER TABLE dummy.bkapp_rolling_12m_Jul24_Jun25_v2 ADD COLUMN is_redeemer INT;

UPDATE dummy.bkapp_rolling_12m_Jul24_Jun25_v2
   SET segment = CASE WHEN bills =1 THEN 'Single'
WHEN bills BETWEEN 2 AND 4 THEN 'Lite'
WHEN bills BETWEEN 5 AND 8 THEN 'Medium'
WHEN bills >=9 THEN 'Heavy' END;

UPDATE dummy.bkapp_rolling_12m_Jul24_Jun25_v2
SET cust_type = CASE WHEN visits =1 THEN "3.Junior"
                     WHEN visits BETWEEN 2 AND 3 THEN "2.Whopper"
                     WHEN visits >=4 THEN "1.King" END;
                     
  CREATE TABLE dummy.rolling_Jun24_May25_vegnoveg(txnmappedmobile VARCHAR(10),veg_nonveg VARCHAR(30));
  ALTER TABLE dummy.rolling_Jun24_May25_vegnoveg ADD INDEX mob(txnmappedmobile);
   ALTER TABLE dummy.rolling_Jun24_May25_vegnoveg ADD INDEX tag(veg_nonveg);
   
INSERT INTO dummy.rolling_Jun24_May25_vegnoveg()   
  SELECT txnmappedmobile,
 GROUP_CONCAT(DISTINCT CASE WHEN b.gender IN ('Non Veg','NON-VEG','NonVeg') THEN 'Non Veg' 
  WHEN b.gender = 'Veg' THEN 'Veg' ELSE '' END) AS veg_nonveg
 FROM dummy.bkapp_raw_data a 
 JOIN dummy.temp_bk_item_master b ON a.uniqueitemcode COLLATE utf8mb4_general_ci  = b.uniqueitemcode
 WHERE a.modifiedtxndate BETWEEN '2024-06-01' AND '2025-05-31' 
 AND SOURCE IN ('BKAPP','BKMob_Del','BKMob_Dinein','BKMobile_TA') AND b.gender IN ('Non Veg','NON-VEG','NonVeg','Veg')
 GROUP BY 1;
 
CREATE TABLE dummy.rolling_Jun24_May25_couponIssued(Txnmappedmobile VARCHAR(10),coupon_Issued INT);
ALTER TABLE dummy.rolling_Jun24_May25_couponIssued ADD INDEX mobile(Txnmappedmobile);

CREATE TABLE dummy.rolling_Jun24_May25_couponredeemed(Txnmappedmobile VARCHAR(10),coupon_redeemed INT);
ALTER TABLE dummy.rolling_Jun24_May25_couponredeemed ADD INDEX mobile(Txnmappedmobile);

INSERT INTO dummy.rolling_Jun24_May25_couponIssued()
SELECT issuedmobile,COUNT(DISTINCT couponcode)coupon_issued 
               FROM burgerking.coupon_offer_report 
               WHERE Issueddate BETWEEN '2024-06-01' AND '2025-05-31'
               AND couponoffercode IN ('JCA8PMR0C0','5RJ87BJSXI','2A8TBLE7CR','4ZIO7YB34F','VJMPSB157E',
                                          'A8K7PRD2MA','352DW5RYWZ','ZWNNFSZU8C','3WWSNLDQSP','OGSZ4FZKRZ',
                                           '5PWDWYU0A7','GDORRO8RA3','0E2T54F3V1','3UQ1AHKZIQ','C4RC5NRU7Z',
                                             '8CN4HWX2RC','USSU735ULN','XN4W4XD4KW','1NL2B9GCNO','S7IOD1QRQS','KQQUG8AQE8','E1AV64SCBG','GBMY47Z6KK','OK1RZYP5RX',
                                                'TXZIE657IO','AUW5DPYARU')
              GROUP BY 1;
              
              
              
  INSERT INTO dummy.rolling_Jun24_May25_couponredeemed()            
  SELECT redeemedmobile,COUNT(DISTINCT couponcode)coupon_redeemed 
               FROM burgerking.coupon_offer_report 
               WHERE useddate BETWEEN '2024-06-01' AND '2025-05-31' AND couponstatus = 'Used'
               AND couponoffercode IN ('JCA8PMR0C0','5RJ87BJSXI','2A8TBLE7CR','4ZIO7YB34F','VJMPSB157E',
                                          'A8K7PRD2MA','352DW5RYWZ','ZWNNFSZU8C','3WWSNLDQSP','OGSZ4FZKRZ',
                                           '5PWDWYU0A7','GDORRO8RA3','0E2T54F3V1','3UQ1AHKZIQ','C4RC5NRU7Z',
                                             '8CN4HWX2RC','USSU735ULN','XN4W4XD4KW','1NL2B9GCNO','S7IOD1QRQS','KQQUG8AQE8','E1AV64SCBG','GBMY47Z6KK','OK1RZYP5RX',
                                                'TXZIE657IO','AUW5DPYARU')
              GROUP BY 1;
 
 UPDATE dummy.bkapp_rolling_12m_Jul24_Jun25_v2
 SET veg_nonveg = NULL;
  
 UPDATE dummy.bkapp_rolling_12m_Jul24_Jun25_v2 a
   JOIN dummy.rolling_Jun24_May25_vegnoveg b ON a.txnmappedmobile = b.txnmappedmobile
  SET a.veg_nonveg = b.veg_nonveg;
    
  UPDATE dummy.bkapp_rolling_12m_Jul24_Jun25_v2 a
    JOIN (SELECT * FROM dummy.rolling_Jun24_May25_couponIssued)b ON a.txnmappedmobile = b.txnmappedmobile
         SET a.coupon_issued = b.coupon_issued;

UPDATE dummy.bkapp_rolling_12m_Jul24_Jun25_v2 a
    JOIN (SELECT * FROM dummy.rolling_Jun24_May25_couponredeemed)b ON a.txnmappedmobile = b.txnmappedmobile
         SET a.coupon_redeemed = b.coupon_redeemed;
         
UPDATE dummy.bkapp_rolling_12m_Jul24_Jun25_v2 SET is_redeemer = CASE WHEN coupon_redeemed>=1 THEN '1' ELSE '0' END;

ALTER TABLE dummy.bkapp_rolling_12m_Jul24_Jun25_v2 ADD COLUMN sub_region VARCHAR(20);
ALTER TABLE dummy.bkapp_rolling_12m_Jul24_Jun25_v2 ADD COLUMN City VARCHAR(30);

UPDATE dummy.bkapp_rolling_12m_Jul24_Jun25_v2  a
  JOIN dummy.`bk_sandeep_first_txn_store` b ON a.txnmappedmobile = b.txnmappedmobile
 SET a.sub_region = b.sub_region,
     a.city = b.city;
     
 SHOW FULL PROCESSLIST;
     
   #####################################################################################################################################
 
  SELECT 'Jun24-May25' AS PERIOD, delivery_modes,COUNT(DISTINCT txnmappedmobile)USER,SUM(bills)Orders,
SUM(sales)Revenue,ROUND(SUM(sales)/SUM(bills),0)APC,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_Jul24_Jun25_v2  GROUP BY 2
UNION ALL     
SELECT 'Jun23-May24' AS PERIOD,delivery_modes,COUNT(DISTINCT txnmappedmobile)USER,SUM(bills)Orders,
SUM(sales)Revenue,ROUND(SUM(sales)/SUM(bills),0)APC,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_Jul23_jun24 
 GROUP BY 2;

SELECT  'May24-Apr25'AS PERIOD,AVG(visits)Freq FROM dummy.bkapp_rolling_12m_Jul24_Jun25_v2
UNION ALL
SELECT 'May23-Apr24'AS PERIOD,AVG(visits)Freq FROM dummy.bkapp_rolling_12m_Jul23_jun24;



SELECT 'Jun24-May25'AS PERIOD,segment,COUNT(DISTINCT txnmappedmobile)Users,SUM(bills)Orders,
SUM(sales)revenue,ROUND(SUM(sales)/SUM(bills),0)APC,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_Jul24_Jun25_v2 GROUP BY 2
UNION ALL
SELECT 'Jun23-May24'AS PERIOD, segment,COUNT(DISTINCT txnmappedmobile)Users,SUM(bills)Orders,
SUM(sales)revenue,ROUND(SUM(sales)/SUM(bills),0)APC,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_Jul23_jun24 
GROUP BY 2;




SELECT 'Jul24-Jun25'AS PERIOD, cust_type,COUNT(DISTINCT txnmappedmobile)Users,SUM(bills)Orders,
SUM(sales)Revenue,ROUND(SUM(sales)/SUM(bills),0)APC,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_Jul24_Jun25_v2
GROUP BY 2
UNION ALL
SELECT 'Jul23-Jun24'AS PERIOD, cust_type,COUNT(DISTINCT txnmappedmobile)Users,SUM(bills)Orders,
SUM(sales)Revenue,ROUND(SUM(sales)/SUM(bills),0)APC,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_Jul23_jun24
  GROUP BY 2;



SELECT 'Jul24-Jun25'AS PERIOD,CASE WHEN min_freq = 1 THEN 'New' ELSE 'Repeat' END AS Tag,
COUNT(DISTINCT txnmappedmobile)Users,SUM(bills)Orders,
SUM(sales)Revenue,ROUND(SUM(sales)/SUM(bills),0)APC,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_Jul24_Jun25_v2  GROUP BY 2
UNION ALL
SELECT 'Jul23-Jun24'AS PERIOD, CASE WHEN min_freq = 1 THEN 'New' ELSE 'Repeat' END AS Tag,
COUNT(DISTINCT txnmappedmobile)Users,SUM(bills)Orders,
SUM(sales)Revenue,ROUND(SUM(sales)/SUM(bills),0)APC,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_Jul23_jun24
  GROUP BY 2;


SELECT 'Jul24-Jun25'AS PERIOD, veg_nonveg,COUNT(DISTINCT txnmappedmobile)USERs,SUM(bills)Orders,
SUM(sales)Revenue,ROUND(SUM(sales)/SUM(bills),0)APC,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_Jul24_Jun25_v2 
GROUP BY 2
UNION ALL
SELECT 'Jul23-Jun24'AS PERIOD, veg_nonveg,COUNT(DISTINCT txnmappedmobile)USERs,SUM(bills)Orders,
SUM(sales)Revenue,ROUND(SUM(sales)/SUM(bills),0)APC,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_Jul23_jun24
 GROUP BY 2;

SELECT 'Jul24-Jun25'AS PERIOD,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_Jul24_Jun25_v2 
WHERE veg_nonveg IS NOT NULL
UNION ALL
SELECT 'Jul23-Jun24'AS PERIOD,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_Jul23_jun24 
WHERE veg_nonveg IS NOT NULL;

SELECT 'Jul24-Jun25'AS PERIOD, COUNT(txnmappedmobile)Users,SUM(coupon_Issued)Crown_Coupon_Issued,SUM(coupon_redeemed)Crown_Coupon_Redeemed,
COUNT(CASE WHEN is_redeemer = 1 THEN txnmappedmobile END)Redeemers,ROUND(SUM(Sales)/SUM(Bills),0)APC,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_Jul24_Jun25_v2
UNION ALL
SELECT'Jul23-Jun24'AS PERIOD, COUNT(txnmappedmobile)Users,SUM(coupon_Issued)Crown_Coupon_Issued,SUM(coupon_redeemed)Crown_Coupon_Redeemed,
COUNT(CASE WHEN is_redeemer = 1 THEN txnmappedmobile END)Redeemers,ROUND(SUM(Sales)/SUM(Bills),0)APC,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_Jul23_jun24;





SELECT MAX(modifiedtxndate) FROM dummy.bkapp_raw_data 

CREATE TABLE dummy.bkapp_rolling_12m_jul24_jun25_v2(Txnmappedmobile VARCHAR(10),delivery_modes VARCHAR(20),
sales VARCHAR(10),bills INT,visits INT, qty INT,min_freq INT);

ALTER TABLE dummy.bkapp_rolling_12m_jul24_jun25_v2 ADD INDEX mob(txnmappedmobile);

INSERT INTO dummy.bkapp_rolling_12m_jul24_jun25_v2(Txnmappedmobile,delivery_modes,
sales,bills,visits, qty,min_freq)
SELECT txnmappedmobile,GROUP_CONCAT(DISTINCT CASE WHEN deliverymode IN ('Dine In','Take Away','BKMobile_TA','BKMob_Dinein',
'Cafe Take Away','Cafe Dine In','Dessert Kiosk','Kiosk','Drive Thru','Kiosk TA','BKMob_DnPAC','BKMob_TAPAC')  THEN 'Dinein'  
WHEN deliverymode IN('Delivery','BKMob_Del') THEN 'Delivery' END)AS Delivery_modes,
ROUND(SUM(itemnetamount),0)Sales,
COUNT(DISTINCT uniquebillno)Bills,
COUNT(DISTINCT modifiedtxndate)Visits,
SUM(itemqty)Qty,
MIN(frequencycount)min_freq
FROM dummy.bkapp_raw_data 
WHERE modifiedtxndate >= '2024-07-01' AND modifiedtxndate<= '2025-07-31' 
AND SOURCE IN ('BKAPP','BKMob_Del','BKMob_Dinein','BKMobile_TA','BKMob_DnPAC','BKMob_TAPAC') 
GROUP BY 1;


CREATE TABLE dummy.bkapp_rolling_12m_jul24_jun25_v2 AS
SELECT a2.* 
FROM
(SELECT *,ROW_NUMBER()OVER (PARTITION BY txnmappedmobile ORDER BY txnmappedmobile ASC)seq2 
  FROM dummy.bkapp_rolling_12m_jul24_jun25 ) a2
  WHERE seq2 = 1;
  


ALTER TABLE dummy.bkapp_rolling_12m_jul24_jun25_v2 ADD COLUMN segment VARCHAR(30);
ALTER TABLE dummy.bkapp_rolling_12m_jul24_jun25_v2 ADD COLUMN veg_nonveg VARCHAR(50);
ALTER TABLE dummy.bkapp_rolling_12m_jul24_jun25_v2 ADD COLUMN cust_type VARCHAR(30);
ALTER TABLE dummy.bkapp_rolling_12m_jul24_jun25_v2 ADD COLUMN coupon_issued INT;
ALTER TABLE dummy.bkapp_rolling_12m_jul24_jun25_v2 ADD COLUMN coupon_redeemed INT;
ALTER TABLE dummy.bkapp_rolling_12m_jul24_jun25_v2 ADD COLUMN is_redeemer INT;

UPDATE dummy.bkapp_rolling_12m_jul24_jun25_v2
   SET segment = CASE WHEN bills =1 THEN 'Single'
WHEN bills BETWEEN 2 AND 4 THEN 'Lite'
WHEN bills BETWEEN 5 AND 8 THEN 'Medium'
WHEN bills >=9 THEN 'Heavy' END;

UPDATE dummy.bkapp_rolling_12m_jul24_jun25_v2
SET cust_type = CASE WHEN visits =1 THEN "3.Junior"
                     WHEN visits BETWEEN 2 AND 3 THEN "2.Whopper"
                     WHEN visits >=4 THEN "1.King" END;
                     
  CREATE TABLE dummy.rolling_jul24_jun25_vegnoveg(txnmappedmobile VARCHAR(10),veg_nonveg VARCHAR(30));
  ALTER TABLE dummy.rolling_jul24_jun25_vegnoveg ADD INDEX mob(txnmappedmobile);
   ALTER TABLE dummy.rolling_jul24_jun25_vegnoveg ADD INDEX tag(veg_nonveg);
   
INSERT INTO dummy.rolling_jul24_jun25_vegnoveg()   
  SELECT txnmappedmobile,
 GROUP_CONCAT(DISTINCT CASE WHEN b.gender IN ('Non Veg','NON-VEG','NonVeg') THEN 'Non Veg' 
  WHEN b.gender = 'Veg' THEN 'Veg' ELSE '' END) AS veg_nonveg
 FROM dummy.bkapp_raw_data a 
 JOIN dummy.temp_bk_item_master b ON a.uniqueitemcode COLLATE utf8mb4_general_ci  = b.uniqueitemcode
 WHERE a.modifiedtxndate >= '2024-07-01' AND modifiedtxndate<= '2025-07-31' 
 AND SOURCE IN ('BKAPP','BKMob_Del','BKMob_Dinein','BKMobile_TA') AND b.gender IN ('Non Veg','NON-VEG','NonVeg','Veg')
 GROUP BY 1;
 
CREATE TABLE dummy.rolling_jul24_jun25_couponIssued(Txnmappedmobile VARCHAR(10),coupon_Issued INT);
ALTER TABLE dummy.rolling_jul24_jun25_couponIssued ADD INDEX mobile(Txnmappedmobile);

CREATE TABLE dummy.rolling_jul24_jun25_couponredeemed(Txnmappedmobile VARCHAR(10),coupon_redeemed INT);
ALTER TABLE dummy.rolling_jul24_jun25_couponredeemed ADD INDEX mobile(Txnmappedmobile);

INSERT INTO dummy.rolling_jul24_jun25_couponIssued()
SELECT issuedmobile,COUNT(DISTINCT couponcode)coupon_issued 
               FROM burgerking.coupon_offer_report 
               WHERE Issueddate >= '2024-07-01' AND Issueddate<='2025-07-31'
               AND couponoffercode IN ('JCA8PMR0C0','5RJ87BJSXI','2A8TBLE7CR','4ZIO7YB34F','VJMPSB157E',
                                          'A8K7PRD2MA','352DW5RYWZ','ZWNNFSZU8C','3WWSNLDQSP','OGSZ4FZKRZ',
                                           '5PWDWYU0A7','GDORRO8RA3','0E2T54F3V1','3UQ1AHKZIQ','C4RC5NRU7Z',
                                             '8CN4HWX2RC','USSU735ULN','XN4W4XD4KW','1NL2B9GCNO','S7IOD1QRQS','KQQUG8AQE8','E1AV64SCBG','GBMY47Z6KK','OK1RZYP5RX',
                                                'TXZIE657IO','AUW5DPYARU')
              GROUP BY 1;
              
              
              
  INSERT INTO dummy.rolling_jul24_jun25_couponredeemed()            
  SELECT redeemedmobile,COUNT(DISTINCT couponcode)coupon_redeemed 
               FROM burgerking.coupon_offer_report 
               WHERE useddate >= '2024-07-01' AND useddate<= '2025-07-31' AND couponstatus = 'Used'
               AND couponoffercode IN ('JCA8PMR0C0','5RJ87BJSXI','2A8TBLE7CR','4ZIO7YB34F','VJMPSB157E',
                                          'A8K7PRD2MA','352DW5RYWZ','ZWNNFSZU8C','3WWSNLDQSP','OGSZ4FZKRZ',
                                           '5PWDWYU0A7','GDORRO8RA3','0E2T54F3V1','3UQ1AHKZIQ','C4RC5NRU7Z',
                                             '8CN4HWX2RC','USSU735ULN','XN4W4XD4KW','1NL2B9GCNO','S7IOD1QRQS','KQQUG8AQE8','E1AV64SCBG','GBMY47Z6KK','OK1RZYP5RX',
                                                'TXZIE657IO','AUW5DPYARU')
              GROUP BY 1;
 
 UPDATE dummy.bkapp_rolling_12m_jul24_jun25_v2
 SET veg_nonveg = NULL;
  
 UPDATE dummy.bkapp_rolling_12m_jul24_jun25_v2 a
   JOIN dummy.rolling_jul24_jun25_vegnoveg b ON a.txnmappedmobile = b.txnmappedmobile
  SET a.veg_nonveg = b.veg_nonveg;
    
  UPDATE dummy.bkapp_rolling_12m_jul24_jun25_v2 a
    JOIN (SELECT * FROM dummy.rolling_jul24_jun25_couponIssued)b ON a.txnmappedmobile = b.txnmappedmobile
         SET a.coupon_issued = b.coupon_issued;

UPDATE dummy.bkapp_rolling_12m_jul24_jun25_v2 a
    JOIN (SELECT * FROM dummy.rolling_jul24_jun25_couponredeemed)b ON a.txnmappedmobile = b.txnmappedmobile
         SET a.coupon_redeemed = b.coupon_redeemed;
         
UPDATE dummy.bkapp_rolling_12m_jul24_jun25_v2 SET is_redeemer = CASE WHEN coupon_redeemed>=1 THEN '1' ELSE '0' END;

ALTER TABLE dummy.bkapp_rolling_12m_jul24_jun25_v2 ADD COLUMN sub_region VARCHAR(20);
ALTER TABLE dummy.bkapp_rolling_12m_jul24_jun25_v2 ADD COLUMN City VARCHAR(30);

CREATE TABLE dummy.bk_min_txndate(txnmappedmobile VARCHAR(10),min_txndate DATE);

ALTER TABLE dummy.bk_min_txndate ADD INDEX mob(txnmappedmobile);
ALTER TABLE dummy.bk_min_txndate ADD INDEX DATE(min_txndate);

INSERT INTO dummy.bk_min_txndate(txnmappedmobile,min_txndate)
SELECT txnmappedmobile,MIN(modifiedtxndate)min_date FROM burgerking.sku_report_loyalty
       WHERE modifiedtxndate >= '2025-06-01' AND modifiedtxndate<='2025-07-31' 
       GROUP BY 1;
       
 SELECT * FROM dummy.bk_min_txndate;
 
 CREATE TABLE dummy.bk_junedata(txnmappedmobile VARCHAR(10),modifiedstorecode VARCHAR(30),modifiedtxndate DATE);
 
 ALTER TABLE dummy.bk_junedata ADD INDEX mob(txnmappedmobile);
 ALTER TABLE dummy.bk_junedata ADD INDEX storecode(modifiedstorecode);
 ALTER TABLE dummy.bk_junedata ADD INDEX txndate(modifiedtxndate);
 
 INSERT INTO dummy.bk_junedata(txnmappedmobile,modifiedstorecode,modifiedtxndate)
  SELECT txnmappedmobile,modifiedstorecode,modifiedtxndate FROM burgerking.sku_report_loyalty
   WHERE modifiedtxndate >= '2025-06-01' AND modifiedtxndate <='2025-07-31';
   
  SHOW FULL PROCESSLIST;  KILL 5203847

INSERT IGNORE INTO dummy.`bk_sandeep_first_txn_store`(txnmappedmobile,first_txn_store,Min_txndate)
SELECT a.txnmappedmobile,a.modifiedstorecode,a.modifiedtxndate FROM dummy.bk_junedata a
  JOIN dummy.bk_min_txndate b
  ON a.txnmappedmobile = b.txnmappedmobile  AND a.modifiedtxndate = b.min_txndate
  GROUP BY 1,2,3;
     
     UPDATE dummy.`bk_sandeep_first_txn_store` a 
     JOIN burgerking.store_master b ON a.first_txn_store = b.storecode
    SET a.region = b.region,a.sub_region = b.sub_region,a.city = b.city
    WHERE a.city IS NULL OR a.city = '';

UPDATE dummy.bkapp_rolling_12m_jul24_jun25_v2  a
  JOIN dummy.`bk_sandeep_first_txn_store` b ON a.txnmappedmobile = b.txnmappedmobile
 SET a.sub_region = b.sub_region,
     a.city = b.city;
     
     
     SELECT * FROM dummy.`bk_sandeep_first_txn_store` WHERE min_txndate>= '2025-06-01';
     
     SHOW FULL PROCESSLIST;
     
    
        
   #####################################################################################################################################
 
 
  SELECT 'Jun24-May25' AS PERIOD, delivery_modes,COUNT(DISTINCT txnmappedmobile)USER,SUM(bills)Orders,
SUM(sales)Revenue,ROUND(SUM(sales)/SUM(bills),0)APC,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_jul24_jun25_v2  GROUP BY 2
UNION ALL     
SELECT 'Jun23-May24' AS PERIOD,delivery_modes,COUNT(DISTINCT txnmappedmobile)USER,SUM(bills)Orders,
SUM(sales)Revenue,ROUND(SUM(sales)/SUM(bills),0)APC,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_kpis_Jun23_May24_v2 
 GROUP BY 2;

SELECT  'May24-Apr25'AS PERIOD,AVG(visits)Freq FROM dummy.bkapp_rolling_12m_jul24_jun25_v2
UNION ALL
SELECT 'May23-Apr24'AS PERIOD,AVG(visits)Freq FROM dummy.bkapp_rolling_12m_kpis_Jun23_May24_v2;



SELECT 'Jun24-May25'AS PERIOD,segment,COUNT(DISTINCT txnmappedmobile)Users,SUM(bills)Orders,
SUM(sales)revenue,ROUND(SUM(sales)/SUM(bills),0)APC,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_jul24_jun25_v2 GROUP BY 2
UNION ALL
SELECT 'Jun23-May24'AS PERIOD, segment,COUNT(DISTINCT txnmappedmobile)Users,SUM(bills)Orders,
SUM(sales)revenue,ROUND(SUM(sales)/SUM(bills),0)APC,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_kpis_Jun23_May24_v2 
GROUP BY 2;




SELECT 'Jun24-May25'AS PERIOD, cust_type,COUNT(DISTINCT txnmappedmobile)Users,SUM(bills)Orders,
SUM(sales)Revenue,ROUND(SUM(sales)/SUM(bills),0)APC,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_jul24_jun25_v2
GROUP BY 2
UNION ALL
SELECT 'Jun23-May24'AS PERIOD, cust_type,COUNT(DISTINCT txnmappedmobile)Users,SUM(bills)Orders,
SUM(sales)Revenue,ROUND(SUM(sales)/SUM(bills),0)APC,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_kpis_Jun23_May24_v2
  GROUP BY 2;



SELECT 'Jun24-May25'AS PERIOD,CASE WHEN min_freq = 1 THEN 'New' ELSE 'Repeat' END AS Tag,
COUNT(DISTINCT txnmappedmobile)Users,SUM(bills)Orders,
SUM(sales)Revenue,ROUND(SUM(sales)/SUM(bills),0)APC,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_jul24_jun25_v2  GROUP BY 2
UNION ALL
SELECT 'Jun23-May24'AS PERIOD, CASE WHEN min_freq = 1 THEN 'New' ELSE 'Repeat' END AS Tag,
COUNT(DISTINCT txnmappedmobile)Users,SUM(bills)Orders,
SUM(sales)Revenue,ROUND(SUM(sales)/SUM(bills),0)APC,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_kpis_Jun23_May24_v2
  GROUP BY 2;


SELECT 'Jun24-May25'AS PERIOD, veg_nonveg,COUNT(DISTINCT txnmappedmobile)USERs,SUM(bills)Orders,
SUM(sales)Revenue,ROUND(SUM(sales)/SUM(bills),0)APC,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_jul24_jun25_v2 
GROUP BY 2
UNION ALL
SELECT 'Jun23-May24'AS PERIOD, veg_nonveg,COUNT(DISTINCT txnmappedmobile)USERs,SUM(bills)Orders,
SUM(sales)Revenue,ROUND(SUM(sales)/SUM(bills),0)APC,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_kpis_Jun23_May24_v2
 GROUP BY 2;

SELECT 'Jun24-May25'AS PERIOD,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_jul24_jun25_v2 
WHERE veg_nonveg IS NOT NULL
UNION ALL
SELECT 'Jun23-May24'AS PERIOD,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_kpis_Jun23_May24_v2 
WHERE veg_nonveg IS NOT NULL;

SELECT 'Jun24-May25'AS PERIOD, COUNT(txnmappedmobile)Users,SUM(coupon_Issued)Crown_Coupon_Issued,SUM(coupon_redeemed)Crown_Coupon_Redeemed,
COUNT(CASE WHEN is_redeemer = 1 THEN txnmappedmobile END)Redeemers,ROUND(SUM(Sales)/SUM(Bills),0)APC,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_jul24_jun25_v2
UNION ALL
SELECT'Jun23-May24'AS PERIOD, COUNT(txnmappedmobile)Users,SUM(coupon_Issued)Crown_Coupon_Issued,SUM(coupon_redeemed)Crown_Coupon_Redeemed,
COUNT(CASE WHEN is_redeemer = 1 THEN txnmappedmobile END)Redeemers,ROUND(SUM(Sales)/SUM(Bills),0)APC,
AVG(visits)Freq FROM dummy.bkapp_rolling_12m_kpis_Jun23_May24_v2;







     
     

















