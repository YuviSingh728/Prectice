

#|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
-- Brand snapshot

# Report Month July 25
SELECT '2025-07-01' startdate,'2025-07-31' enddate , 
			COUNT(DISTINCT storecode) AS StoreCount,
			COUNT(DISTINCT mobile) TransactedMembers,		
			COUNT(DISTINCT (CASE WHEN frequencycount>1 THEN mobile  END)) AS Repeaters,
			COUNT(DISTINCT UniqueBillno) Loyaltybills,
			COUNT(DISTINCT (CASE WHEN FrequencyCount>1 THEN uniquebillno END)) Repeat_bills,
			SUM(amount) LoyaltySales, 
			SUM(CASE WHEN frequencycount>1 THEN amount END) Repeat_Sales,
			COUNT(DISTINCT (CASE WHEN pointsspent>0 THEN mobile END)) AS Redeemers,
			ROUND(IFNULL(SUM(Pointscollected)/NULLIF(SUM(PointsSpent),0),0),2) AS `EARN BURN RATIO`
			FROM dummy.Regalshoes_temp_txn
			WHERE storecode NOT LIKE '%demo%' AND tag_='L'
			   AND modifiedbillno NOT LIKE '%test%'
			   AND modifiedbillno NOT LIKE '%roll%'
			   AND txndate>='2025-07-01' AND txndate<='2025-07-31';
			   
SELECT COUNT(mobile)enrolments FROM regalshoes.member_report
				WHERE modifiedenrolledon>='2025-07-01' 
				AND modifiedenrolledon<='2025-07-31'
				AND enrolledstore NOT LIKE '%demo%';

	# Report Month Last Year 
SELECT '2024-07-01' startdate,'2024-07-31' enddate , 
			COUNT(DISTINCT storecode) AS StoreCount,
			COUNT(DISTINCT mobile) TransactedMembers,		
			COUNT(DISTINCT (CASE WHEN frequencycount>1 THEN mobile  END)) AS Repeaters,
			COUNT(DISTINCT UniqueBillno) Loyaltybills,
			COUNT(DISTINCT (CASE WHEN FrequencyCount>1 THEN uniquebillno END)) Repeat_bills,
			SUM(amount) LoyaltySales, 
			SUM(CASE WHEN frequencycount>1 THEN amount END) Repeat_Sales,
			COUNT(DISTINCT (CASE WHEN pointsspent>0 THEN mobile END)) AS Redeemers,
			ROUND(IFNULL(SUM(Pointscollected)/NULLIF(SUM(PointsSpent),0),0),2) AS `EARN BURN RATIO`
			FROM dummy.Regalshoes_temp_txn
			WHERE modifiedbillno NOT LIKE '%test%' AND storecode NOT LIKE '%demo%' AND tag_='L'
			   AND modifiedbillno NOT LIKE '%roll%'
			   AND txndate>='2024-07-01' AND txndate<='2024-07-31' ;
			   
SELECT COUNT(mobile)enrolments FROM regalshoes.member_report
				WHERE modifiedenrolledon>='2024-07-01' 
				AND modifiedenrolledon<='2024-07-31'
				AND enrolledstore NOT LIKE '%demo%';
				
-- KPIs Overview 1 yr				
CALL dummy.P1_P2_automation_KPI_overview_regal('2024-08-01','2025-07-31','','dummy');

-- Lapsation 2 yrs from feb25 report
CALL dummy.P1_P2_automation_Lapsation_Regal('2023-08-01','2025-07-31','','','','dummy',10,120,10);
CALL dummy.P1_P2_automation_Lapsation_Regal('2023-08-01','2025-07-31','','','','dummy',50,550,50);

-- drop rate 2 yrs
CALL dummy.P1_P2_automation_DropRateAndVisitMigration_regal('2023-08-01','2025-07-31','','',10,'dummy');

-- ATV Spend Bucket
CALL dummy.P1_P2_automation_ATV_movement_Regal('2024-08-01','2025-07-31',2500,12500,2500,'dummy');

-- Repeat cohort
CALL dummy.P1_P2_automation_repeat_cohort_regal('2024-08-01','2025-07-31','dummy');

-- Bill Banding
CALL dummy.P1_P2_automation_Bill_Banding_regal('2025-07-01','2025-07-31','','365','2500','12500','2500','dummy'); 

-- rolling 3Y
CALL dummy.P1_P2_automation_customer_overview_regal ('2023-04-01','2025-07-31','365','dummy');

-- Redemption snapshot
CALL dummy.P1_P2_automation_redemption_snapshot_regal('2025-01-01','2025-07-31','2024-08-01','2025-07-31','2025-01-01','2025-07-31','2024-01-01','2024-12-31','1','1','','dummy');


#|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

#Category wise – top and bottom selling
/*
-- Category level data for report month
-- Top
WITH category_sales AS (
    SELECT CASE WHEN b.Categoryname IS NULL THEN 'NA' ELSE b.Categoryname END AS Categoryname,
        SUM(itemnetamount) AS Sales,SUM(itemqty) AS Qty
    FROM `regalshoes`.`sku_report_loyalty` a
    LEFT JOIN regalshoes.item_master b
    USING(uniqueitemcode)
    WHERE modifiedtxndate BETWEEN '2025-05-01' AND '2025-05-31'
    GROUP BY Categoryname
),
top_10_categories AS (
    SELECT * FROM category_sales ORDER BY Sales DESC LIMIT 10
),
rest_of_base AS (
    SELECT 'Rest of Base' AS Categoryname,SUM(Sales) AS Sales,SUM(Qty) AS Qty FROM category_sales
    WHERE Categoryname NOT IN (SELECT Categoryname FROM top_10_categories)
)
SELECT * FROM top_10_categories
UNION ALL
SELECT * FROM rest_of_base
ORDER BY Sales DESC;

-- Bottom

WITH category_sales AS (
    SELECT CASE WHEN b.Categoryname IS NULL THEN 'NA' ELSE b.Categoryname END AS Categoryname,
        SUM(itemnetamount) AS Sales,SUM(itemqty) AS Qty
    FROM `regalshoes`.`sku_report_loyalty` a
    LEFT JOIN regalshoes.item_master b
    USING(uniqueitemcode)
    WHERE modifiedtxndate BETWEEN '2025-05-01' AND '2025-05-31'
    GROUP BY Categoryname
),
bottom_10_categories AS (
    SELECT * FROM category_sales ORDER BY Sales ASC 
    LIMIT 10
),
rest_of_base AS (
    SELECT 'Rest of Base' AS Categoryname,SUM(Sales) AS Sales,SUM(Qty) AS Qty
    FROM category_sales WHERE Categoryname NOT IN (SELECT Categoryname FROM bottom_10_categories)
)
SELECT * FROM bottom_10_categories
UNION ALL
SELECT * FROM rest_of_base
ORDER BY Sales ASC;
*/
WITH category_sales AS (
    SELECT 
        CASE 
            WHEN b.SubCategoryname IS NULL THEN 'No Mapping' 
            ELSE b.SubCategoryname 
        END AS SubCategoryname,
        SUM(itemnetamount) AS Sales,
        SUM(itemqty) AS Qty
    FROM regalshoes.sku_report_loyalty a
    LEFT JOIN regalshoes.item_master b USING (uniqueitemcode)
    WHERE modifiedtxndate BETWEEN '2025-07-01' AND '2025-07-31'
    GROUP BY 1
),
ranked_sales AS (
    SELECT 
        SubCategoryname,
        Sales,
        Qty,
        RANK() OVER (ORDER BY Sales DESC) AS rank_desc,
        RANK() OVER (ORDER BY Sales ASC) AS rank_asc
    FROM category_sales
),

-- Top 10 + Rest of Top
top_categories AS (
    SELECT SubCategoryname, Sales, Qty, 'Top 10' AS CategoryGroup
    FROM ranked_sales 
    WHERE rank_desc <= 10

    UNION ALL

    SELECT 
        'Rest of Top' AS SubCategoryname,
        SUM(Sales) AS Sales,
        SUM(Qty) AS Qty,
        'Rest of Top' AS CategoryGroup
    FROM ranked_sales
    WHERE rank_desc > 10
),

-- Bottom 10 + Rest of Bottom
bottom_categories AS (
    SELECT SubCategoryname, Sales, Qty, 'Bottom 10' AS CategoryGroup
    FROM ranked_sales 
    WHERE rank_asc <= 10

    UNION ALL

    SELECT 
        'Rest of Bottom' AS SubCategoryname,
        SUM(Sales) AS Sales,
        SUM(Qty) AS Qty,
        'Rest of Bottom' AS CategoryGroup
    FROM ranked_sales
    WHERE rank_asc > 10
)

-- Final combined output
SELECT * FROM top_categories
UNION ALL
SELECT * FROM bottom_categories;

#|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
-- Storewise redemption for report month
-- `Points redeemed`

SELECT 'Top-10' AS Tag,a.Storecode,b.Lpaasstore AS `Store Name`,
SUM(Pointsspent)`Points Redeemed`
FROM dummy.`Regalshoes_temp_txn` a
LEFT JOIN regalshoes.store_master b
ON a.storecode=b.storecode
WHERE txndate>='2025-07-01' AND txndate<='2025-07-31'   AND tag_='L'
GROUP BY 2
ORDER BY 4 DESC
LIMIT 10;

SELECT 'Bottom -10' AS Tag,a.Storecode,b.Lpaasstore AS `Store Name`,
SUM(Pointsspent)`Points Redeemed`
FROM dummy.`Regalshoes_temp_txn` a
LEFT JOIN regalshoes.store_master b
ON a.storecode=b.storecode
WHERE  txndate>='2025-07-01' AND txndate<='2025-07-31'  AND a.storecode NOT LIKE '%demo%'  AND tag_='L'
GROUP BY 2
HAVING `Points Redeemed`>0
ORDER BY 4 ASC
LIMIT 10;

#|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
# New enrolled customer in the year (), Jan – Dec 2024 and are Onetime / Repeat – counts / bills / sales
-- for June- May 25

SET @date1 = '2024-08-01'; 
SET @date2 = '2025-07-31'; 


WITH RegalData_Report_Month AS 
(SELECT mobile,'Aug-July25' AS PERIOD, 
SUM(amount)sales,COUNT(DISTINCT uniquebillno)Bills,COUNT(DISTINCT txndate)visits, 
MIN(frequencycount)min_freq,MAX(frequencycount)max_freq 
FROM dummy.Regalshoes_temp_txn 
WHERE (txndate BETWEEN @date1 AND @date2) 
 AND mobile IN(SELECT DISTINCT mobile FROM regalshoes.member_report WHERE modifiedenrolledon BETWEEN '2024-08-01' AND '2025-07-31')
 AND modifiedbillno NOT LIKE '%Test%'  AND tag_='L'
 AND storecode NOT LIKE '%Demo%' 
 AND modifiedbillno NOT LIKE '%Roll%' 
 GROUP BY 1),
 
RegalData_Report_Month_V2 AS (SELECT * FROM RegalData_Report_Month)
 SELECT PERIOD, 
 COUNT(Mobile)'Transacting Customers',
 COUNT(DISTINCT CASE WHEN  visits = 1 THEN Mobile END)'Onetimer',
 COUNT(DISTINCT CASE WHEN  visits > 1 THEN Mobile END)'Repeater',
 ROUND(SUM(sales),0)'Total Sales',
 SUM(CASE WHEN  visits = 1 THEN sales END)'Onetimer Sales',
 SUM(CASE WHEN  visits > 1 THEN sales END)'Repeater Sales',
 SUM(bills)'Total Bills', 
 SUM(CASE WHEN  visits = 1 THEN bills END)'Onetimer Bills', 
 SUM(CASE WHEN  visits > 1 THEN bills END)'Repeater Bills'
 FROM RegalData_Report_Month_V2;

