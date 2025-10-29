SET @cycm1 = '2025-07-01'; 
SET @cycm2 = '2025-07-31'; 
SET @cypm1 = '2025-06-01'; 
SET @cypm2 = '2025-06-30'; 
SET @pycm1 = '2024-07-01'; 
SET @pycm2 = '2024-07-31'; 

WITH plumgoodnes_mbr_May25 AS 
(SELECT a.mobile,b.tier, 
CASE 
WHEN txndate BETWEEN @cycm1 AND @cycm2 THEN '1CYCM' 
WHEN txndate BETWEEN @cypm1 AND @cypm2 THEN '3CYPM' 
WHEN txndate BETWEEN @pycm1 AND @pycm2 THEN '2PYCM' END AS Period, SUM(amount)sales,COUNT(DISTINCT uniquebillno)Bills,
COUNT(DISTINCT txndate)visits, SUM(a.pointscollected)pointscollected,SUM(a.pointsspent)pointsspent,
MIN(frequencycount)min_freq,MAX(frequencycount)max_freq FROM plumgoodness.txn_report_accrual_redemption a 
JOIN plumgoodness.member_report b ON a.mobile = b.mobile WHERE a.insertiondate < CURDATE() AND
 ((txndate BETWEEN @cycm1 AND @cycm2) OR (txndate BETWEEN @cypm1 AND @cypm2)OR (txndate BETWEEN @pycm1 AND @pycm2))
 AND modifiedbillno NOT LIKE '%Test%' AND storecode NOT LIKE '%Demo%' AND modifiedbillno NOT LIKE '%Roll%' GROUP BY 1,3),
 
 plumgoodnes_mbr_May25_v2 AS (SELECT *,CASE WHEN pointsspent>=1 THEN '1' ELSE '0' END AS 'is_redeemer' FROM plumgoodnes_mbr_May25)
 
 SELECT period, 
 COUNT(Mobile)'Transacting Customers',
 COUNT(DISTINCT CASE WHEN min_freq = 1 AND max_freq = 1 THEN Mobile END)'New Onetimer',
 COUNT(DISTINCT CASE WHEN min_freq = 1 AND max_freq > 1 THEN Mobile END)'New Repeater',
 COUNT(DISTINCT CASE WHEN min_freq > 1 AND max_freq > 1 THEN Mobile END)'Old Repeater', 
 ROUND(SUM(sales),0)'Total Sales',
 SUM(CASE WHEN min_freq = 1 AND max_freq = 1 THEN sales END)'New Onetimer Sales',
 SUM(CASE WHEN min_freq = 1 AND max_freq > 1 THEN sales END)'New Repeater Sales',
 SUM(CASE WHEN min_freq > 1 AND max_freq > 1 THEN sales END)'Old Repeater Sales',
 SUM(bills)'Total Bills', SUM(CASE WHEN min_freq = 1 AND max_freq = 1 THEN bills END)'New Onetimer Bills', 
 SUM(CASE WHEN min_freq = 1 AND max_freq > 1 THEN bills END)'New Repeater Bills',
 SUM(CASE WHEN min_freq > 1 AND max_freq > 1 THEN bills END)'Old Repeater Bills',
 ROUND(SUM(sales)/SUM(Bills),0)'ABV',
 ROUND(SUM(CASE WHEN min_freq = 1 AND max_freq = 1 THEN sales END)/SUM(CASE WHEN min_freq = 1 AND max_freq = 1 THEN bills END),0)'New Onetimer ABV',
 ROUND(SUM(CASE WHEN min_freq = 1 AND max_freq > 1 THEN sales END)/SUM(CASE WHEN min_freq = 1 AND max_freq > 1 THEN bills END),0)'New Repeater ABV',
 ROUND(SUM(CASE WHEN min_freq > 1 AND max_freq > 1 THEN sales END)/SUM(CASE WHEN min_freq > 1 AND max_freq > 1 THEN bills END),0)'Old Repeater ABV',
 ROUND(SUM(sales)/COUNT(DISTINCT Mobile),0)'AMV',
 ROUND(SUM(CASE WHEN min_freq = 1 AND max_freq = 1 THEN sales END)/COUNT(DISTINCT CASE WHEN min_freq = 1 AND max_freq = 1 THEN Mobile END),0)'New Onetimer AMV',
 ROUND(SUM(CASE WHEN min_freq = 1 AND max_freq > 1 THEN sales END)/COUNT(DISTINCT CASE WHEN min_freq = 1 AND max_freq > 1 THEN Mobile END),0)'New Repeater AMV',
 ROUND(SUM(CASE WHEN min_freq > 1 AND max_freq > 1 THEN sales END)/COUNT(DISTINCT CASE WHEN min_freq > 1 AND max_freq > 1 THEN Mobile END),0)'Old Repeater AMV', 
 ROUND(SUM(pointscollected),0)'Points Issued',
 ROUND(SUM(Pointsspent),0)'Points Redeemed' 
 FROM plumgoodnes_mbr_May25_v2 GROUP BY 1 ORDER BY period;
 
SET @cycm1 = '2025-06-01'; 
SET @cycm2 = '2025-06-30'; 
SET @cypm1 = '2025-05-01'; 
SET @cypm2 = '2025-05-31'; 
SET @pycm1 = '2024-06-01'; 
SET @pycm2 = '2024-06-30';

SELECT CASE 
  WHEN modifiedenrolledon BETWEEN @cycm1 AND @CYCM2 THEN '1CYCM'
  WHEN modifiedenrolledon BETWEEN @CYPM1 AND @CYPM2 THEN '3CYPM' 
  WHEN modifiedenrolledon BETWEEN @PYCM1 AND @PYCM2 THEN '2PYCM' END AS period,
  COUNT(mobile)customers FROM plumgoodness.member_report 
  WHERE insertiondate < CURDATE() AND enrolledstorecode NOT LIKE '%Demo%' 
  AND ((Modifiedenrolledon BETWEEN @CYCM1 AND @CYCM2)OR(Modifiedenrolledon BETWEEN @CYPM1 AND @CYPM2)
   OR(Modifiedenrolledon BETWEEN @PYCM1 AND @PYCM2)) GROUP BY 1 ORDER BY period;
   
 
SET @cycm1 = '2025-06-01'; 
SET @cycm2 = '2025-06-30'; 
SET @cypm1 = '2025-05-01'; 
SET @cypm2 = '2025-05-31'; 
SET @pycm1 = '2024-06-01'; 
SET @pycm2 = '2024-06-30';

WITH plumgoodness_modewise_kpis AS
 (SELECT a.Mobile,CASE WHEN txndate BETWEEN @CYCM1 AND @CYCM2 THEN '1CYCM'
  WHEN txndate BETWEEN @CYPM1 AND @CYPM2 THEN '3CYPM' 
  WHEN txndate BETWEEN @PYCM1 AND @PYCM2 THEN '2PYCM' END AS period,
  CASE
  WHEN storecode = 'MobileAPP' THEN 'Mobile APP' WHEN storecode = 'Website' THEN 'Website' 
  WHEN storecode NOT IN ('MobileAPP','Website') THEN 'Offline' END AS Tag,
  IFNULL(SUM(amount),0)sales,
  COUNT(DISTINCT uniquebillno)Bills,
  COUNT(DISTINCT txndate)visits, MIN(frequencycount)min_freq,
  MAX(frequencycount)max_freq,
  SUM(a.pointscollected)pointscollected,
  SUM(a.pointsspent)pointsspent FROM plumgoodness.txn_report_accrual_redemption a
  JOIN plumgoodness.member_report b ON a.Mobile = b.mobile 
  WHERE a.insertiondate < CURDATE() AND ((txndate BETWEEN @CYCM1 AND @CYCM2)OR
  (txndate BETWEEN @CYPM1 AND @CYPM2)OR(txndate BETWEEN @PYCM1 AND @PYCM2)) 
  AND modifiedbillno NOT LIKE '%Test%' AND storecode NOT LIKE '%Demo%'AND modifiedbillno NOT LIKE '%Roll%'
  GROUP BY 1,2,3)
  
  SELECT tag,period, COUNT(Mobile)'Transacting Customers',
  COUNT(DISTINCT CASE WHEN min_freq = 1 AND max_freq = 1 THEN Mobile END)'New Onetimer',
  COUNT(DISTINCT CASE WHEN min_freq = 1 AND max_freq > 1 THEN Mobile END)'New Repeater',
  COUNT(DISTINCT CASE WHEN min_freq > 1 AND max_freq > 1 THEN Mobile END)'Old Repeater',
  ROUND(SUM(sales),0)'Total Sales',
  SUM(CASE WHEN min_freq = 1 AND max_freq = 1 THEN sales END)'New Onetimer Sales',
  SUM(CASE WHEN min_freq = 1 AND max_freq > 1 THEN sales END)'New Repeater Sales',
  SUM(CASE WHEN min_freq > 1 AND max_freq > 1 THEN sales END)'Old Repeater Sales',
  SUM(bills)'Total Bills',
  SUM(CASE WHEN min_freq = 1 AND max_freq = 1 THEN bills END)'New Onetimer Bills',
  SUM(CASE WHEN min_freq = 1 AND max_freq > 1 THEN bills END)'New Repeater Bills',
  SUM(CASE WHEN min_freq > 1 AND max_freq > 1 THEN bills END)'Old Repeater Bills',
  ROUND(SUM(sales)/SUM(Bills),0)'ABV',
  ROUND(SUM(CASE WHEN min_freq = 1 AND max_freq = 1 THEN sales END)/SUM(CASE WHEN min_freq = 1 AND max_freq = 1 THEN bills END),0)'New Onetimer ABV',
  ROUND(SUM(CASE WHEN min_freq = 1 AND max_freq > 1 THEN sales END)/SUM(CASE WHEN min_freq = 1 AND max_freq > 1 THEN bills END),0)'New Repeater ABV',
  ROUND(SUM(CASE WHEN min_freq > 1 AND max_freq > 1 THEN sales END)/SUM(CASE WHEN min_freq > 1 AND max_freq > 1 THEN bills END),0)'Old Repeater ABV',
  ROUND(SUM(sales)/COUNT(DISTINCT Mobile),0)'AMV',
  ROUND(SUM(CASE WHEN min_freq = 1 AND max_freq = 1 THEN sales END)/COUNT(DISTINCT CASE WHEN min_freq = 1 AND max_freq = 1 THEN Mobile END),0)'New Onetimer AMV',
  ROUND(SUM(CASE WHEN min_freq = 1 AND max_freq > 1 THEN sales END)/COUNT(DISTINCT CASE WHEN min_freq = 1 AND max_freq > 1 THEN Mobile END),0)'New Repeater AMV',
  ROUND(SUM(CASE WHEN min_freq > 1 AND max_freq > 1 THEN sales END)/COUNT(DISTINCT CASE WHEN min_freq > 1 AND max_freq > 1 THEN Mobile END),0)'Old Repeater AMV',
  ROUND(SUM(pointscollected),0)'Points Issued',
  ROUND(SUM(Pointsspent),0)'Points Redeemed'
  FROM plumgoodness_modewise_kpis GROUP BY 1,2; 
  
  
SET @cycm1 = '2025-06-01'; 
SET @cycm2 = '2025-06-30'; 
SET @cypm1 = '2025-05-01'; 
SET @cypm2 = '2025-05-31'; 
SET @pycm1 = '2024-06-01'; 
SET @pycm2 = '2024-06-30';
 
SELECT 
CASE 
 WHEN enrolledstorecode = 'MobileAPP' THEN 'Mobile APP'
 WHEN enrolledstorecode = 'Website' THEN 'Website' 
 WHEN enrolledstorecode NOT IN ('MobileAPP','Website') THEN 'Offline' END AS Tag,
 CASE WHEN modifiedenrolledon BETWEEN @CYCM1 AND @CYCM2 THEN '1CYCM'
 WHEN modifiedenrolledon BETWEEN @CYPM1 AND @CYPM2 THEN '3CYPM'
 WHEN modifiedenrolledon BETWEEN @PYCM1 AND @PYCM2 THEN '2PYCM' END AS period,
 COUNT(mobile)customers FROM plumgoodness.member_report WHERE insertiondate < CURDATE()
 AND enrolledstorecode NOT LIKE '%Demo%' AND ((Modifiedenrolledon BETWEEN @CYCM1 AND @CYCM2)OR
 (Modifiedenrolledon BETWEEN @CYPM1 AND @CYPM2) OR(Modifiedenrolledon BETWEEN @PYCM1 AND @PYCM2))
 GROUP BY 1,2 ORDER BY period ;
 
 --  Redeemers & Non redeemers
 
SET @cycm1 = '2025-06-01'; 
SET @cycm2 = '2025-06-30'; 
SET @cypm1 = '2025-05-01'; 
SET @cypm2 = '2025-05-31'; 
SET @pycm1 = '2024-06-01'; 
SET @pycm2 = '2024-06-30';
 
     
WITH plumgoodnes_redeemers_nonredeemers_May25 AS 
(SELECT a.mobile,b.tier,
CASE WHEN txndate BETWEEN @CYCM1 AND @CYCM2 THEN 'CYCM'
WHEN txndate BETWEEN @CYPM1 AND @CYPM2 THEN 'CYPM'
WHEN txndate BETWEEN @PYCM1 AND @PYCM2 THEN 'PYCM' END AS Period,
SUM(amount)sales,COUNT(DISTINCT uniquebillno)Bills,COUNT(DISTINCT txndate)visits,
SUM(a.pointscollected)pointscollected,SUM(a.pointsspent)pointsspent,
MIN(frequencycount)min_freq,MAX(frequencycount)max_freq
FROM plumgoodness.txn_report_accrual_redemption a
JOIN plumgoodness.member_report b ON a.mobile = b.mobile
WHERE a.insertiondate < CURDATE() AND ((txndate BETWEEN @CYCM1 AND @CYCM2) OR (txndate BETWEEN @CYPM1 AND @CYPM2) OR(txndate BETWEEN @PYCM1 AND @PYCM2)) 
 AND modifiedbillno NOT LIKE '%Test%' AND storecode NOT LIKE '%Demo%'AND modifiedbillno NOT LIKE '%Roll%'
 GROUP BY 1,3),
 
plumgoodnes_redeemers_nonredeemers_May25_v2 AS
 (SELECT *,CASE WHEN pointsspent>=1 THEN '1' ELSE '0' END AS 'is_redeemer' FROM plumgoodnes_redeemers_nonredeemers_May25)
    
   SELECT 'Redeemers'AS Tag,period,
   COUNT(DISTINCT Mobile)'Transactors',
   COUNT(DISTINCT CASE WHEN is_redeemer = 1 THEN Mobile END)'Redeemers',
   IFNULL(SUM(CASE WHEN is_redeemer = 1 THEN sales END),0)'Redeemers Sales',
   IFNULL(SUM(CASE WHEN is_redeemer = 1 THEN bills END),0)'Redeemers Bills',
   #ifnull(SUM(CASE WHEN is_redeemer = 1 THEN Qty END),0)'Redeemers Qty',
   IFNULL(SUM(CASE WHEN is_redeemer = 1 THEN pointsspent END),0)'Redeemers Points Redeemed',
   IFNULL(ROUND(SUM(CASE WHEN is_redeemer = 1 THEN sales END)/SUM(CASE WHEN is_redeemer = 1 THEN bills END),0),0)'Redeemers ABV',
   IFNULL(ROUND(SUM(CASE WHEN is_redeemer = 1 THEN sales END)/COUNT(DISTINCT CASE WHEN is_redeemer = 1 THEN Mobile END),0),0)'Redeemers AMV'
   #ifnull(ROUND(SUM(CASE WHEN is_redeemer = 1 THEN qty END)/SUM(CASE WHEN is_redeemer = 1 THEN bills END),2),0)'Redeemers ABS'
   FROM plumgoodnes_redeemers_nonredeemers_May25_v2 
   GROUP BY 2 ORDER BY period;
  
   -- non redeemers---
   
SET @cycm1 = '2025-06-01'; 
SET @cycm2 = '2025-06-30'; 
SET @cypm1 = '2025-05-01'; 
SET @cypm2 = '2025-05-31'; 
SET @pycm1 = '2024-06-01'; 
SET @pycm2 = '2024-06-30';
     
WITH plumgoodnes_redeemers_nonredeemers_Aug24 AS 
(SELECT a.mobile,b.tier,
CASE WHEN txndate BETWEEN @CYCM1 AND @CYCM2 THEN 'CYCM'
WHEN txndate BETWEEN @CYPM1 AND @CYPM2 THEN 'CYPM'
WHEN txndate BETWEEN @PYCM1 AND @PYCM2 THEN 'PYCM' END AS Period,
SUM(amount)sales,COUNT(DISTINCT uniquebillno)Bills,COUNT(DISTINCT txndate)visits,
SUM(a.pointscollected)pointscollected,SUM(a.pointsspent)pointsspent,
MIN(frequencycount)min_freq,MAX(frequencycount)max_freq
FROM plumgoodness.txn_report_accrual_redemption a
JOIN plumgoodness.member_report b ON a.mobile = b.mobile
WHERE a.insertiondate < CURDATE() AND ((txndate BETWEEN @CYCM1 AND @CYCM2) OR (txndate BETWEEN @CYPM1 AND @CYPM2) OR(txndate BETWEEN @PYCM1 AND @PYCM2)) 
 AND modifiedbillno NOT LIKE '%Test%' AND storecode NOT LIKE '%Demo%'AND modifiedbillno NOT LIKE '%Roll%'
 GROUP BY 1,3),
 
plumgoodnes_redeemers_nonredeemers_Aug24_v2 AS
 (SELECT *,CASE WHEN pointsspent>=1 THEN '1' ELSE '0' END AS 'is_redeemer' FROM plumgoodnes_redeemers_nonredeemers_Aug24)
   
SELECT 'Non Redeemers'AS Tag,period,
   COUNT(DISTINCT Mobile)'Transactors',
   COUNT(DISTINCT CASE WHEN is_redeemer <> 1 THEN Mobile END)'NonRedeemers',
   IFNULL(SUM(CASE WHEN is_redeemer <> 1 THEN sales END),0)'NonRedeemers Sales',
   IFNULL(SUM(CASE WHEN is_redeemer <> 1 THEN bills END),0)'NonRedeemers Bills',
   #ifnull(SUM(CASE WHEN is_redeemer = 1 THEN Qty END),0)'Redeemers Qty',
   IFNULL(SUM(CASE WHEN is_redeemer <> 1 THEN pointsspent END),0)'Non Redeemers Points Redeemed',
   IFNULL(ROUND(SUM(CASE WHEN is_redeemer <> 1 THEN sales END)/SUM(CASE WHEN is_redeemer <> 1 THEN bills END),0),0)'Non Redeemers ABV',
   IFNULL(ROUND(SUM(CASE WHEN is_redeemer <> 1 THEN sales END)/COUNT(DISTINCT CASE WHEN is_redeemer <> 1 THEN Mobile END),0),0)'Non Redeemers AMV'
   #ifnull(ROUND(SUM(CASE WHEN is_redeemer = 1 THEN qty END)/SUM(CASE WHEN is_redeemer = 1 THEN bills END),2),0)'Redeemers ABS'
   FROM plumgoodnes_redeemers_nonredeemers_Aug24_v2 
   GROUP BY 2;
   
   
SET @cycm1 = '2025-06-01'; SET @cycm2 = '2025-06-30';
 WITH plumgoodnes_Tierwise_KPIs_Aug24 AS 
(SELECT a.mobile,b.tier, SUM(amount)sales,COUNT(DISTINCT uniquebillno)Bills,
COUNT(DISTINCT txndate)visits, SUM(a.pointscollected)pointscollected,SUM(a.pointsspent)pointsspent,
MIN(frequencycount)min_freq,MAX(frequencycount)max_freq FROM plumgoodness.txn_report_accrual_redemption a 
JOIN plumgoodness.member_report b ON a.mobile = b.mobile 
WHERE a.insertiondate < CURDATE() AND txndate BETWEEN @cycm1 AND @cycm2 AND modifiedbillno NOT LIKE '%Test%' AND storecode NOT LIKE '%Demo%'
 AND modifiedbillno NOT LIKE '%Roll%' GROUP BY 1,2)
 
 SELECT CASE WHEN Tier = 'Welcome Tier' THEN '1 Welcome Tier'
             WHEN Tier = 'Insider' THEN '2 Insider'
             WHEN Tier = 'Influencer' THEN '3 Influencer'
             WHEN Tier = 'Icon' THEN '4 Icon' END AS Tier,
 COUNT(Mobile)'Transacting Customers',
 COUNT(DISTINCT CASE WHEN min_freq = 1 AND max_freq = 1 THEN Mobile END)'New Onetimer',
 COUNT(DISTINCT CASE WHEN min_freq = 1 AND max_freq > 1 THEN Mobile END)'New Repeater',
 COUNT(DISTINCT CASE WHEN min_freq > 1 AND max_freq > 1 THEN Mobile END)'Old Repeater', 
 ROUND(SUM(sales),0)'Total Sales',
 SUM(CASE WHEN min_freq = 1 AND max_freq = 1 THEN sales END)'New Onetimer Sales',
 SUM(CASE WHEN min_freq = 1 AND max_freq > 1 THEN sales END)'New Repeater Sales',
 SUM(CASE WHEN min_freq > 1 AND max_freq > 1 THEN sales END)'Old Repeater Sales',
 SUM(bills)'Total Bills', SUM(CASE WHEN min_freq = 1 AND max_freq = 1 THEN bills END)'New Onetimer Bills', 
 SUM(CASE WHEN min_freq = 1 AND max_freq > 1 THEN bills END)'New Repeater Bills',
 SUM(CASE WHEN min_freq > 1 AND max_freq > 1 THEN bills END)'Old Repeater Bills',
 ROUND(SUM(sales)/SUM(Bills),0)'ABV',
 ROUND(SUM(CASE WHEN min_freq = 1 AND max_freq = 1 THEN sales END)/SUM(CASE WHEN min_freq = 1 AND max_freq = 1 THEN bills END),0)'New Onetimer ABV',
 ROUND(SUM(CASE WHEN min_freq = 1 AND max_freq > 1 THEN sales END)/SUM(CASE WHEN min_freq = 1 AND max_freq > 1 THEN bills END),0)'New Repeater ABV',
 ROUND(SUM(CASE WHEN min_freq > 1 AND max_freq > 1 THEN sales END)/SUM(CASE WHEN min_freq > 1 AND max_freq > 1 THEN bills END),0)'Old Repeater ABV',
 ROUND(SUM(sales)/COUNT(DISTINCT Mobile),0)'AMV',
 ROUND(SUM(CASE WHEN min_freq = 1 AND max_freq = 1 THEN sales END)/COUNT(DISTINCT CASE WHEN min_freq = 1 AND max_freq = 1 THEN Mobile END),0)'New Onetimer AMV',
 ROUND(SUM(CASE WHEN min_freq = 1 AND max_freq > 1 THEN sales END)/COUNT(DISTINCT CASE WHEN min_freq = 1 AND max_freq > 1 THEN Mobile END),0)'New Repeater AMV',
 ROUND(SUM(CASE WHEN min_freq > 1 AND max_freq > 1 THEN sales END)/COUNT(DISTINCT CASE WHEN min_freq > 1 AND max_freq > 1 THEN Mobile END),0)'Old Repeater AMV', 
 ROUND(SUM(pointscollected),0)'Points Issued',
 ROUND(SUM(Pointsspent),0)'Points Redeemed' 
 FROM plumgoodnes_Tierwise_KPIs_Aug24 GROUP BY 1;

  
  #Overall ATV--- 
  
SET @cycm1 = '2025-06-01';SET @cycm2 = '2025-06-30';
WITH plumgoodness_ATV AS
       (SELECT a.Mobile,
         SUM(amount)Sales,COUNT(DISTINCT uniquebillno)Bills,
         ROUND(SUM(amount)/COUNT(DISTINCT uniquebillno),0)ATV
   FROM plumgoodness.txn_report_accrual_redemption a JOIN plumgoodness.member_report b ON a.mobile = b.mobile
      WHERE a.insertiondate < CURDATE() AND (txndate BETWEEN @cycm1 AND @cycm2) 
       AND modifiedbillno NOT LIKE '%Test%' AND storecode NOT LIKE '%Demo%'
       AND modifiedbillno NOT LIKE '%Roll%' GROUP BY 1)

SELECT CASE WHEN atv <=500 THEN 'Upto 500'
                 WHEN atv >500 AND atv<=1000 THEN '501-1000'
                 WHEN atv >1000 AND atv<=1500 THEN '1001-1500'
                 WHEN atv >1500 AND atv<=2000 THEN '1501-2000'
                 WHEN atv >2000 AND atv<=2500 THEN '2001-2500'
                WHEN atv >2500 THEN '2500+' END AS 'ATV Bucket',
     COUNT(Mobile)'Customers',SUM(bills)'Bills',SUM(sales)'Sales' FROM plumgoodness_ATV GROUP BY 1;
   
   
   
   #Overall Visit & recency---
     
SET @cycm1 = '2025-06-01';
SET @cycm2 = '2025-06-30'; 
	  
      WITH plumg_recency_visits_Aug24 AS
    (SELECT mobile,
    DATEDIFF(@CYCM2,MAX(txndate))recency,COUNT(DISTINCT txndate)visits,SUM(amount)sales,
    COUNT(DISTINCT uniquebillno)bills
    FROM plumgoodness.txn_report_accrual_redemption WHERE txndate<= @CYCM2
     AND modifiedbillno NOT LIKE '%Test%' AND storecode NOT LIKE '%Demo%'
     AND modifiedbillno NOT LIKE '%Roll%' AND insertiondate< CURDATE()
     GROUP BY 1)
      SELECT CASE WHEN recency <=180 THEN 'Active'
                  WHEN recency>180 AND recency<= 270 THEN 'Dormant'
                  WHEN recency >270 THEN 'Lapsed' END AS 'Tag',CASE WHEN visits>8 THEN '8+' ELSE visits END AS 'Visits Band',
                  COUNT(Mobile)Customers,SUM(sales)Sales
               FROM plumg_recency_visits_Aug24 GROUP BY 1,2;
               
               
               
  ######################################################################################################################################
      
      
      #Plum Goodness Additional --

SET @CYCM1 = '2025-06-01';SET @CYCM2 = '2025-06-30';
SET @CYPM1 = '2025-05-01';SET @CYPM2 = '2025-05-31';
SET @PYCM1 = '2024-06-01';SET @PYCM2 = '2024-06-30';

WITH redeemers_table AS
(SELECT a.mobile,CASE 
WHEN txndate BETWEEN @CYCM1 AND @CYCM2  THEN '1CYCM'
WHEN txndate BETWEEN @CYPM1 AND @CYPM2 THEN '3CYPM'
WHEN txndate BETWEEN @PYCM1 AND @PYCM2 THEN '2PYCM'END AS Period,
CASE WHEN storecode NOT IN ('MobileAPP','Website') THEN 'Offline' ELSE storecode END AS Tag,
SUM(amount)sales,
COUNT(DISTINCT uniquebillno)Bills,
SUM(a.PointsSpent)'Points Redeemed',
SUM(a.pointscollected)'Points Issued'
FROM plumgoodness.txn_report_accrual_redemption a
  JOIN plumgoodness.member_report b ON a.mobile = b.mobile
WHERE storecode NOT LIKE '%Demo%' AND modifiedbillno NOT LIKE '%Test%' AND a.insertiondate < CURDATE()
AND ((txndate BETWEEN  @CYCM1 AND @CYCM2) OR (txndate BETWEEN @CYPM1 AND @CYPM2) OR(txndate BETWEEN @PYCM1 AND @PYCM2))
    GROUP BY 1,2,3)
    
 SELECT period,Tag,
        COUNT(DISTINCT mobile)Transacting_Customers,SUM(sales)Sales,SUM(bills)BIlls,
        SUM(`Points Redeemed`)'Points Redeemed',
        ROUND(SUM(sales)/SUM(bills),0)ABV,
        ROUND(SUM(sales)/COUNT(DISTINCT Mobile),0)AMV,
        COUNT(DISTINCT CASE WHEN `Points Redeemed`>=1 THEN mobile END)'Redeemers',
        SUM(CASE WHEN `Points Redeemed`>=1 THEN sales END)'Redeemers Sales',
        SUM(CASE WHEN `Points Redeemed`>=1 THEN Bills END)'Redeemers Bills',
        ROUND(SUM(CASE WHEN `Points Redeemed`>=1 THEN sales END)/SUM(CASE WHEN `Points Redeemed`>=1 THEN Bills END),0)'Redeemers ABV',
        ROUND(SUM(CASE WHEN `Points Redeemed`>=1 THEN sales END)/COUNT(DISTINCT CASE WHEN `Points Redeemed`>=1 THEN mobile END),0)'Redeemers AMV',
        COUNT(DISTINCT CASE WHEN `Points Redeemed`<1 OR `Points Redeemed` IS NULL THEN mobile END)'Non Redeemers',
        SUM(CASE WHEN `Points Redeemed`<1 OR `Points Redeemed` IS NULL THEN sales END)'Non Redeemers Sales',
        SUM(CASE WHEN `Points Redeemed`<1 OR `Points Redeemed` IS NULL THEN Bills END)'Non Redeemers Bills',
        ROUND(SUM(CASE WHEN `Points Redeemed`<1 OR `Points Redeemed` IS NULL  THEN sales END)/SUM(CASE WHEN `Points Redeemed`<1 OR `Points Redeemed` IS NULL THEN Bills END),0)'Non Redeemers ABV',
        ROUND(SUM(CASE WHEN `Points Redeemed`<1 OR `Points Redeemed` IS NULL THEN sales END)/COUNT(DISTINCT CASE WHEN `Points Redeemed`<1 OR `Points Redeemed` IS NULL THEN Mobile END),0)'Non Redeemers AMV'
        FROM redeemers_table GROUP BY 1,2;
        
        
SET @cycm1 = '2025-06-01'; SET @cycm2 = '2025-06-30';
WITH plumgoodnes_tier_and_modewise_KPIs AS 
(SELECT a.mobile,b.tier,
 CASE WHEN storecode = 'MobileAPP' THEN 'Mobile APP' 
  WHEN storecode = 'Website' THEN 'Website' 
  WHEN storecode NOT IN ('MobileAPP','Website') THEN 'Offline' END AS Tag,
 SUM(amount)sales,COUNT(DISTINCT uniquebillno)Bills,
COUNT(DISTINCT txndate)visits, SUM(a.pointscollected)pointscollected,SUM(a.pointsspent)pointsspent,
MIN(frequencycount)min_freq,MAX(frequencycount)max_freq FROM plumgoodness.txn_report_accrual_redemption a 
JOIN plumgoodness.member_report b ON a.mobile = b.mobile WHERE a.insertiondate < CURDATE() AND
 txndate BETWEEN @cycm1 AND @cycm2 AND modifiedbillno NOT LIKE '%Test%' AND storecode NOT LIKE '%Demo%' 
 AND modifiedbillno NOT LIKE '%Roll%' 
 GROUP BY 1,2,3),
 
 plumgoodnes_tier_and_modewise_KPIs_v2 AS (SELECT *,CASE WHEN pointsspent>=1 THEN '1' ELSE '0' END AS 'is_redeemer' 
                                   FROM plumgoodnes_tier_and_modewise_KPIs)
 
 SELECT Tier,Tag, 
 COUNT(Mobile)'Transacting Customers',
 COUNT(DISTINCT CASE WHEN min_freq = 1 AND max_freq = 1 THEN Mobile END)'New Onetimer',
 COUNT(DISTINCT CASE WHEN min_freq = 1 AND max_freq > 1 THEN Mobile END)'New Repeater',
 COUNT(DISTINCT CASE WHEN min_freq > 1 AND max_freq > 1 THEN Mobile END)'Old Repeater', 
 ROUND(SUM(sales),0)'Total Sales',
 SUM(CASE WHEN min_freq = 1 AND max_freq = 1 THEN sales END)'New Onetimer Sales',
 SUM(CASE WHEN min_freq = 1 AND max_freq > 1 THEN sales END)'New Repeater Sales',
 SUM(CASE WHEN min_freq > 1 AND max_freq > 1 THEN sales END)'Old Repeater Sales',
 SUM(bills)'Total Bills', SUM(CASE WHEN min_freq = 1 AND max_freq = 1 THEN bills END)'New Onetimer Bills', 
 SUM(CASE WHEN min_freq = 1 AND max_freq > 1 THEN bills END)'New Repeater Bills',
 SUM(CASE WHEN min_freq > 1 AND max_freq > 1 THEN bills END)'Old Repeater Bills',
 ROUND(SUM(sales)/SUM(Bills),0)'ABV',
 ROUND(SUM(CASE WHEN min_freq = 1 AND max_freq = 1 THEN sales END)/SUM(CASE WHEN min_freq = 1 AND max_freq = 1 THEN bills END),0)'New Onetimer ABV',
 ROUND(SUM(CASE WHEN min_freq = 1 AND max_freq > 1 THEN sales END)/SUM(CASE WHEN min_freq = 1 AND max_freq > 1 THEN bills END),0)'New Repeater ABV',
 ROUND(SUM(CASE WHEN min_freq > 1 AND max_freq > 1 THEN sales END)/SUM(CASE WHEN min_freq > 1 AND max_freq > 1 THEN bills END),0)'Old Repeater ABV',
 ROUND(SUM(sales)/COUNT(DISTINCT Mobile),0)'AMV',
 ROUND(SUM(CASE WHEN min_freq = 1 AND max_freq = 1 THEN sales END)/COUNT(DISTINCT CASE WHEN min_freq = 1 AND max_freq = 1 THEN Mobile END),0)'New Onetimer AMV',
 ROUND(SUM(CASE WHEN min_freq = 1 AND max_freq > 1 THEN sales END)/COUNT(DISTINCT CASE WHEN min_freq = 1 AND max_freq > 1 THEN Mobile END),0)'New Repeater AMV',
 ROUND(SUM(CASE WHEN min_freq > 1 AND max_freq > 1 THEN sales END)/COUNT(DISTINCT CASE WHEN min_freq > 1 AND max_freq > 1 THEN Mobile END),0)'Old Repeater AMV', 
 ROUND(SUM(pointscollected),0)'Points Issued',
 ROUND(SUM(Pointsspent),0)'Points Redeemed' 
 FROM plumgoodnes_tier_and_modewise_KPIs_v2 GROUP BY 1,2;
 
 #Mode Wise ATV----
 
SET @cycm1 = '2025-06-01';SET @cycm2 = '2025-06-30';
WITH plumgoodness_modewise_ATV AS
       (SELECT a.Mobile,CASE WHEN storecode = 'MobileAPP' THEN 'Mobile APP' 
                             WHEN storecode = 'Website' THEN 'Website' 
                             WHEN storecode NOT IN ('MobileAPP','Website') THEN 'Offline' END AS Tag,
         SUM(amount)Sales,COUNT(DISTINCT uniquebillno)Bills,
         ROUND(SUM(amount)/COUNT(DISTINCT uniquebillno),0)ATV
   FROM plumgoodness.txn_report_accrual_redemption a JOIN plumgoodness.member_report b ON a.mobile = b.mobile
      WHERE a.insertiondate < CURDATE() AND txndate BETWEEN @cycm1 AND @cycm2
       AND modifiedbillno NOT LIKE '%Test%' AND storecode NOT LIKE '%Demo%'
       AND modifiedbillno NOT LIKE '%Roll%' GROUP BY 1,2)

SELECT Tag,CASE WHEN atv <=500 THEN 'Upto 500'
                 WHEN atv >500 AND atv<=1000 THEN '501-1000'
                 WHEN atv >1000 AND atv<=1500 THEN '1001-1500'
                 WHEN atv >1500 AND atv<=2000 THEN '1501-2000'
                 WHEN atv >2000 AND atv<=2500 THEN '2001-2500'
                WHEN atv >2500 THEN '2500+' END AS 'ATV Bucket',
     COUNT(Mobile)'Customers',SUM(bills)'Bills',SUM(sales)'Sales'
      FROM plumgoodness_modewise_ATV GROUP BY 1,2;
      
      
      #MOde wise Visit & recency---
     
SET @cycm1 = '2025-06-01';SET @cycm2 = '2025-06-30'; 
	  
    WITH plumg_modewise_recency_visits_Aug24 AS
    (SELECT mobile,CASE WHEN storecode = 'MobileAPP' THEN 'Mobile APP' 
                        WHEN storecode = 'Website' THEN 'Website' 
                        WHEN storecode NOT IN ('MobileAPP','Website') THEN 'Offline' END AS Tag,
    DATEDIFF(@CYCM2,MAX(txndate))recency,                        
    SUM(amount)Sales,COUNT(DISTINCT txndate)visits FROM plumgoodness.txn_report_accrual_redemption WHERE txndate<= @CYCM2
     AND modifiedbillno NOT LIKE '%Test%' AND storecode NOT LIKE '%Demo%'
     AND modifiedbillno NOT LIKE '%Roll%' AND insertiondate< CURDATE()
     GROUP BY 1,2)
     
      SELECT Tag,CASE WHEN recency <=180 THEN 'Active'
                  WHEN recency>180 AND recency<= 270 THEN 'Dormant'
                  WHEN recency >270 THEN 'Lapsed' END AS 'Tag',CASE WHEN visits>8 THEN '8+' ELSE visits END AS 'Visits Band',
                  COUNT(Mobile)Customers,SUM(sales)Sales
               FROM plumg_modewise_recency_visits_Aug24 
             GROUP BY 1,2,3;
             
  SELECT tier,
  COUNT(mobile)customers FROM plumgoodness.member_report 
  WHERE insertiondate < CURDATE() AND enrolledstorecode NOT LIKE '%Demo%' 
  AND modifiedenrolledon BETWEEN '2025-06-01' AND '2025-06-30' GROUP BY 1;
  

CREATE TABLE dummy.tier_ason_Jun25_end(mobile VARCHAR(20),tierno INT,tier VARCHAR(30));
INSERT INTO dummy.tier_ason_Jun25_end
SELECT mobile,
MAX(CASE 
WHEN currenttier='Welcome Tier' THEN 1
WHEN currenttier='Insider' THEN 2
WHEN currenttier='Influencer' THEN 3
WHEN currenttier='Icon' THEN 4
ELSE NULL END) AS TierNo,
CurrentTier AS Tier
FROM Plumgoodness.tier_report_log WHERE DATE(tierchangedate)<='2025-06-30'
GROUP BY 1;

ALTER TABLE dummy.tier_ason_Jun25_end ADD INDEX mob(Mobile);
ALTER TABLE dummy.tier_ason_Jun25_end ADD INDEX Tier(Tier);

DELETE a.* FROM dummy.tier_ason_Jun25_end a
JOIN Plumgoodness.member_report_registered b ON a.mobile COLLATE utf8mb4_general_ci = b.mobile;


UPDATE dummy.tier_ason_Jun25_end
SET Tier=
CASE 
WHEN TierNo=1 THEN 'Welcome Tier'
WHEN TierNo=2 THEN 'Insider'
WHEN TierNo=3 THEN 'Influencer'
WHEN TierNo=4 THEN 'Icon' ELSE NULL END;

UPDATE dummy.tier_ason_Jun25_end a
    JOIN dummy.plum_sandeep_tier_change b ON a.mobile = b.mobile
   SET a.tier = b.newtier WHERE a.tier IS NULL;
   
   UPDATE dummy.tier_ason_Jun25_end a
   SET a.tier = 'Welcome Tier' WHERE a.tier IS NULL;
 
 SELECT tier, COUNT(*) FROM dummy.tier_ason_Jun25_end
    GROUP BY 1; 
    
    SELECT a.tier AS tier_ason_30th_Apr,b.tier AS tier_ason_1st_Apr,COUNT(a.mobile)customers 
      FROM dummy.tier_ason_Jun25_end a
        LEFT JOIN dummy.tier_ason_may25_end b ON a.mobile = b.mobile
        GROUP BY 1,2;






#Overall Users--
    SELECT 'Start of the Month' AS Period, tier,COUNT(*)cnt FROM dummy.tier_ason_may25_end 
    GROUP BY 2 
    UNION ALL
    SELECT 'End of the Month' AS Period, tier,COUNT(*)cnt FROM dummy.tier_ason_Jun25_end 
    GROUP BY 2  ; 
    
   
    #Overall Users--
    
SET @cycm1 = '2025-06-01';
SET @cycm2 = '2025-06-30';

    SELECT tier,COUNT(DISTINCT b.mobile)transacted,
    SUM(amount)Sales,
    COUNT(DISTINCT uniquebillno)Bills,SUM(pointsspent)pointsspent
     FROM dummy.tier_ason_Jun25_end a
      RIGHT JOIN plumgoodness.txn_report_accrual_redemption b ON a.mobile = b.mobile
       WHERE txndate BETWEEN @CYCM1 AND @CYCM2 GROUP BY 1
        ORDER BY transacted DESC ; 
 
SET @cycm1 = '2025-06-01';
SET @cycm2 = '2025-06-30';  
   
     #Website-- 
   SELECT tier,
   COUNT(DISTINCT b.mobile)transacted,
    SUM(amount)Sales,
    COUNT(DISTINCT uniquebillno)Bills,SUM(pointsspent)pointsspent
     FROM dummy.tier_ason_Jun25_end a JOIN plumgoodness.txn_report_accrual_redemption b ON a.mobile COLLATE utf8mb4_general_ci = b.mobile
       WHERE txndate BETWEEN @CYCM1 AND @CYCM2 AND storecode = 'Website' 
       AND modifiedbillno NOT LIKE '%Test%' AND modifiedbillno NOT LIKE '%Roll%' AND Storecode NOT LIKE '%Demo%'
         AND b.insertiondate < CURDATE()
          GROUP BY 1 ORDER BY transacted DESC ; 
     
     #Mobile App---
SET @cycm1 = '2025-06-01';
SET @cycm2 = '2025-06-30'; 
   SELECT tier,
   COUNT(DISTINCT b.mobile)transacted,
    SUM(amount)Sales,
    COUNT(DISTINCT uniquebillno)Bills,SUM(pointsspent)pointsspent
     FROM dummy.tier_ason_Jun25_end a JOIN plumgoodness.txn_report_accrual_redemption b ON a.mobile COLLATE utf8mb4_general_ci = b.mobile
       WHERE txndate BETWEEN @CYCM1 AND @CYCM2 AND storecode = 'MobileAPP' 
       AND modifiedbillno NOT LIKE '%Test%' AND modifiedbillno NOT LIKE '%Roll%' AND Storecode NOT LIKE '%Demo%'
         AND b.insertiondate < CURDATE()
          GROUP BY 1 ORDER BY transacted DESC ; 
      
      #EBW/Offline Users--
      
SET @cycm1 = '2025-06-01';
SET @cycm2 = '2025-06-30'; 
    SELECT tier,COUNT(DISTINCT b.mobile)transacted,
    SUM(amount)Sales,
    COUNT(DISTINCT uniquebillno)Bills,SUM(pointsspent)pointsspent
     FROM dummy.tier_ason_Jun25_end a
      RIGHT JOIN plumgoodness.txn_report_accrual_redemption b ON a.mobile COLLATE utf8mb4_general_ci = b.mobile
       WHERE txndate BETWEEN @CYCM1 AND @CYCM2 AND storecode NOT IN ('MobileAPP','Website')
       AND modifiedbillno NOT LIKE '%Test%' AND modifiedbillno NOT LIKE '%Roll%' AND Storecode NOT LIKE '%Demo%'
      AND b.insertiondate < CURDATE()
      GROUP BY 1 ORDER BY transacted DESC ; 
      
      
      SELECT Tier,COUNT(DISTINCT mobile)cnt FROM plumgoodness.member_report
        WHERE modifiedenrolledon BETWEEN '2025-06-01' AND '2025-06-30' AND enrolledstorecode NOT LIKE '%Demo%'
         GROUP BY 1 ORDER BY cnt DESC ;