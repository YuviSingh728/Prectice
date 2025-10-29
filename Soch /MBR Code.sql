
-- ******************* Overall *************************
-- 1st sheet
--   using period       
        
 
SELECT 
CASE a.period
WHEN 'May-23' THEN 'curr_mn_prev_2nd_yr'
WHEN 'May-24' THEN 'curr_mn_prev_yr'
WHEN 'May-25' THEN 'curr_mn_curr_yr'
WHEN 'Apr-25' THEN 'prev_mn_curr_yr'
ELSE a.period
END AS PERIOD,
  COALESCE(a.Customer, 0) AS Customer,
  COALESCE(a.Repeaters, 0) AS Repeaters,
  COALESCE(a.`New Cust`, 0) AS `New Cust`,
  COALESCE(a.`Total Sales`, 0) AS `Total Sales`,
  COALESCE(a.`Repeat Sales`, 0) AS `Repeat Sales`,
  COALESCE(a.`New Sales`, 0) AS `New Sales`,
  COALESCE(a.`Total Bills`, 0) AS `Total Bills`,
  COALESCE(a.`Repeat Bills`, 0) AS `Repeat Bills`,
  COALESCE(a.`New Bills`, 0) AS `New Bills`,
  COALESCE(b.Quantity, 0) AS Quantity,
  COALESCE(a.`Total Visits`, 0) AS `Total Visits`,
  COALESCE(a.`Total Points Issued`, 0) AS `Total Points Issued`,
  COALESCE(a.`Points Redeemed`, 0) AS `Points Redeemed`,
  COALESCE(a.`Redemption Sales`, 0) AS `Redemption Sales`

FROM (
    SELECT 
        PERIOD,
        COUNT(DISTINCT CASE WHEN category = 'OneTimer' THEN mobile END) AS `New Cust`,
        COUNT(DISTINCT CASE WHEN category = 'OneTimer' THEN uniquebillno END) AS `New Bills`,
        SUM(CASE WHEN category = 'OneTimer' THEN amount ELSE 0 END) AS `New Sales`,

        COUNT(DISTINCT CASE WHEN category = 'Repeater' THEN mobile END) AS Repeaters,
        COUNT(DISTINCT CASE WHEN category = 'Repeater' THEN uniquebillno END) AS `Repeat Bills`,
        SUM(CASE WHEN category = 'Repeater' THEN amount ELSE 0 END) AS `Repeat Sales`,

        SUM(amount) AS `Total Sales`,  
        COUNT(DISTINCT mobile) AS Customer,
        COUNT(DISTINCT uniquebillno) AS `Total Bills`,
        SUM(pointsspent) AS `Points Redeemed`,
        SUM(pointscollected) AS `Total Points Issued`,
        SUM(CASE WHEN pointsspent >= 1 THEN amount ELSE 0 END) AS `Redemption Sales`,
        COUNT(DISTINCT mobile, txndate) AS `Total Visits`
    FROM (
        SELECT 
             CONCAT(LEFT(MONTHNAME(txndate),3), '-', RIGHT(YEAR(txndate),2)) AS PERIOD,
            t.mobile,
            t.uniquebillno,
            t.amount,
            t.pointsspent,
            t.pointscollected,
            t.txndate,
            CASE 
                WHEN (modifiedenrolledon = txndate AND TxnCount = 1) 
                     OR (txndate < modifiedenrolledon AND TxnCount = 1) 
                     OR (modifiedenrolledon IS NULL AND TxnCount = 1) 
                THEN 'OneTimer'
                ELSE 'Repeater'
            END AS category
        FROM txn_report_accrual_redemption t
        LEFT JOIN member_report m ON t.mobile = m.mobile
        WHERE 
            (txndate BETWEEN '2023-05-01' AND '2023-05-31' 
            OR txndate BETWEEN '2024-05-01' AND '2024-05-31' 
            OR txndate BETWEEN '2025-04-01' AND '2025-04-30' 
            OR txndate BETWEEN '2025-05-01' AND '2025-05-31')
            AND storecode NOT LIKE '%demo%' 
            AND storecode NOT LIKE '%Ecom%'
    ) AS categorized_data
    GROUP BY PERIOD
) a
LEFT JOIN (
    SELECT 
        CONCAT(LEFT(MONTHNAME(modifiedtxndate),3), '-', RIGHT(YEAR(modifiedtxndate),2)) AS PERIOD,
        SUM(itemqty) AS Quantity
    FROM Sku_report_Loyalty
    WHERE 
        (modifiedtxndate BETWEEN '2023-05-01' AND '2023-05-31' 
            OR modifiedtxndate BETWEEN '2024-05-01' AND '2024-05-31' 
            OR modifiedtxndate BETWEEN '2025-04-01' AND '2025-04-30' 
            OR modifiedtxndate BETWEEN '2025-05-01' AND '2025-05-31')
        AND storecode NOT LIKE '%Demo%'
        AND storecode NOT LIKE '%Ecom%'
    GROUP BY PERIOD
) b
ON a.PERIOD = b.PERIOD;


    
-- ****************** 2nd sheet (mom) **************


SELECT a.`Total Customers` , a.Repeaters, a.`New Customers`, a.`Total Bills`, a.`Repeat Bills`,a.`New Bills`, 
b.`Total Quantity`, b.`Repeat Quantity`, b.`New Quantity` ,a.`Total Visits`, a.`Points Issued`, a.`Points Redeemed`,
a.`Redemption Sales`,a.`new sales`+a.`Repeat sales` AS `Total sales`, a.`Repeat Sales`,a.`New Sales` FROM
(SELECT 'tag', COUNT(DISTINCT mobile) AS `Total Customers`,
COUNT(DISTINCT CASE WHEN category = 'Repeater' THEN mobile END) AS Repeaters,
COUNT(DISTINCT CASE WHEN category = 'OneTimer' THEN mobile END) AS `New Customers`,
COUNT(DISTINCT uniquebillno) AS `Total Bills`,
COUNT(DISTINCT CASE WHEN category = 'Repeater' THEN uniquebillno END) AS `Repeat Bills`,
COUNT(DISTINCT CASE WHEN category = 'OneTimer' THEN uniquebillno END) AS `New Bills`,
COUNT(DISTINCT mobile, txndate) AS `Total Visits`,
SUM(pointscollected) AS `Points Issued`,
SUM(pointsspent) AS `Points Redeemed`,
SUM(CASE WHEN pointsspent >= 1 THEN amount END) AS `Redemption Sales`,
SUM(amount) AS `Total Sales`, 
SUM(CASE WHEN category = 'Repeater' THEN amount ELSE 0 END) AS `Repeat Sales`,
SUM(CASE WHEN category = 'OneTimer' THEN amount ELSE 0 END) AS `New Sales`   
FROM (
SELECT t.mobile, t.uniquebillno, t.amount,
t.pointsspent, t.pointscollected, t.txndate,
CASE WHEN (modifiedenrolledon = txndate AND TxnCount = 1) 
OR (txndate < modifiedenrolledon AND TxnCount = 1) 
OR (modifiedenrolledon IS NULL AND TxnCount = 1) THEN 'OneTimer'
ELSE 'Repeater'
END AS category
FROM txn_report_accrual_redemption t
LEFT JOIN member_report m ON t.mobile = m.mobile
WHERE txndate BETWEEN '2025-05-01' AND '2025-05-31'
AND storecode NOT LIKE '%demo%' 
AND storecode NOT LIKE '%Ecom%'
) AS Transacting_Kpi) a JOIN

-- -- ***********Repeaters Onetimers Qty *******************
(SELECT 'Tag',
SUM(itemqty) AS `Total Quantity`,
SUM(CASE WHEN category = 'OneTimer' THEN itemqty ELSE 0 END) AS `New Quantity`,
SUM(CASE WHEN category = 'Repeater' THEN itemqty ELSE 0 END) AS `Repeat Quantity`    
FROM (
SELECT t.itemqty,
CASE WHEN (modifiedenrolledon = modifiedtxndate AND TxnCount = 1) 
OR (modifiedtxndate < modifiedenrolledon AND TxnCount = 1) 
OR (modifiedenrolledon IS NULL AND TxnCount = 1) THEN 'OneTimer'
ELSE 'Repeater'
END AS category
FROM sku_report_loyalty t
LEFT JOIN member_report m ON t.txnmappedmobile = m.mobile
WHERE txndate BETWEEN '2025-05-01' AND '2025-05-31'
AND storecode NOT LIKE '%demo%' 
AND storecode NOT LIKE '%Ecom%'
) AS categorized_data)b
USING(tag);


-- 3rd sheet 
-- *************** kpis_snapshot_regional_curr_yr *********************    
    
SELECT b.Region, a.`New Enrolment`, 
b.`Stores`, b.Customers, b.Sales, 
b.Repeaters, b.`Repeater Sales`, b.Bills 
FROM 
(
SELECT COALESCE(b.Region, 'Unmapped_Region') AS Region, 
COUNT(DISTINCT a.mobile) AS `New Enrolment`
FROM member_Report a 
JOIN store_master b ON a.enrolledstorecode = b.storecode
WHERE a.modifiedenrolledon BETWEEN '2025-05-01' AND '2025-05-31'
AND a.enrolledstorecode NOT LIKE '%demo%' 
AND a.enrolledstorecode NOT LIKE '%Ecom%'
GROUP BY COALESCE(b.Region, 'Unmapped_Region')
  ) a 
JOIN (
SELECT 
COALESCE(c.Region, 'Unmapped_Region') AS Region,
COUNT(DISTINCT t.storecode) AS `Stores`,
COUNT(DISTINCT t.mobile) AS Customers,
SUM(t.amount) AS Sales,
COUNT(DISTINCT CASE 
WHEN 
(t.txndate > m.modifiedenrolledon AND t.TxnCount = 1) OR
(t.txndate > m.modifiedenrolledon AND t.TxnCount > 1) OR
(m.modifiedenrolledon = t.txndate AND t.TxnCount > 1) OR
(t.txndate < m.modifiedenrolledon AND t.TxnCount > 1) OR
(m.modifiedenrolledon IS NULL AND t.TxnCount > 1)
THEN t.Mobile
END) AS Repeaters,
SUM(CASE 
WHEN 
(t.txndate > m.modifiedenrolledon AND t.TxnCount = 1) OR
(t.txndate > m.modifiedenrolledon AND t.TxnCount > 1) OR
(m.modifiedenrolledon = t.txndate AND t.TxnCount > 1) OR
(t.txndate < m.modifiedenrolledon AND t.TxnCount > 1) OR
(m.modifiedenrolledon IS NULL AND t.TxnCount > 1)
THEN t.amount
END) AS `Repeater Sales`,
COUNT(DISTINCT t.uniquebillno) AS Bills 
FROM txn_report_accrual_redemption t 
LEFT JOIN member_report m ON t.mobile = m.mobile
LEFT JOIN store_master c ON t.storecode = c.storecode
WHERE t.txndate BETWEEN '2025-05-01' AND '2025-05-31'
AND t.storecode NOT LIKE '%demo%'
AND t.storecode NOT LIKE '%Ecom%'
GROUP BY COALESCE(c.Region, 'Unmapped_Region')
) b 
USING (Region)
ORDER BY 
CASE 
WHEN Region = 'North' THEN 1
WHEN Region = 'South' THEN 2
WHEN Region = 'East' THEN 3
WHEN Region = 'West' THEN 4
WHEN Region = 'Unmapped_Region' THEN 5
ELSE 6
END;



-- 4th sheet 
-- *************** kpis_snapshot_regional_prev_yr *********************    
    
SELECT * FROM (
SELECT 
COALESCE(a.Region, b.Region, 'Unmapped_Region') AS Region,
COALESCE(a.`New Enrolment`, 0) AS `New Enrolment`,
COALESCE(b.`Stores`, 0) AS `Stores`,
COALESCE(b.Customers, 0) AS Customers,
COALESCE(b.Sales, 0) AS Sales,
COALESCE(b.Repeaters, 0) AS Repeaters,
COALESCE(b.`Repeater Sales`, 0) AS `Repeater Sales`,
COALESCE(b.Bills, 0) AS Bills
FROM (
SELECT 
COALESCE(b.Region, 'Unmapped_Region') AS Region,
COUNT(DISTINCT a.mobile) AS `New Enrolment`
FROM member_Report a
LEFT JOIN store_master b ON a.enrolledstorecode = b.storecode
WHERE a.modifiedenrolledon BETWEEN '2024-05-01' AND '2024-05-31'
GROUP BY COALESCE(b.Region, 'Unmapped_Region')
) a
LEFT JOIN (
SELECT 
COALESCE(c.Region, 'Unmapped_Region') AS Region,
COUNT(DISTINCT t.storecode) AS `Stores`,
COUNT(DISTINCT t.mobile) AS Customers,
SUM(t.amount) AS Sales,
COUNT(DISTINCT CASE 
          WHEN 
              (t.txndate > m.modifiedenrolledon AND t.TxnCount = 1) OR
              (t.txndate > m.modifiedenrolledon AND t.TxnCount > 1) OR
              (m.modifiedenrolledon = t.txndate AND t.TxnCount > 1) OR
              (t.txndate < m.modifiedenrolledon AND t.TxnCount > 1) OR
              (m.modifiedenrolledon IS NULL AND t.TxnCount > 1)
          THEN t.Mobile
        END) AS Repeaters,
        SUM(CASE 
          WHEN 
              (t.txndate > m.modifiedenrolledon AND t.TxnCount = 1) OR
              (t.txndate > m.modifiedenrolledon AND t.TxnCount > 1) OR
              (m.modifiedenrolledon = t.txndate AND t.TxnCount > 1) OR
              (t.txndate < m.modifiedenrolledon AND t.TxnCount > 1) OR
              (m.modifiedenrolledon IS NULL AND t.TxnCount > 1)
          THEN t.amount
        END) AS `Repeater Sales`,
        COUNT(DISTINCT t.uniquebillno) AS Bills
      FROM txn_report_accrual_redemption t
      LEFT JOIN member_report m ON t.mobile = m.mobile
      LEFT JOIN store_master c ON t.storecode = c.storecode
      WHERE t.txndate BETWEEN '2024-05-01' AND '2024-05-31'
        AND t.storecode NOT LIKE '%demo%'
        AND t.storecode NOT LIKE '%Ecom%'
      GROUP BY COALESCE(c.Region, 'Unmapped_Region')
  ) b ON a.Region = b.Region
UNION
SELECT 
    COALESCE(a.Region, b.Region, 'Unmapped_Region') AS Region,
    COALESCE(a.`New Enrolment`, 0) AS `New Enrolment`,
    COALESCE(b.`Stores`, 0) AS `Stores`,
    COALESCE(b.Customers, 0) AS Customers,
    COALESCE(b.Sales, 0) AS Sales,
    COALESCE(b.Repeaters, 0) AS Repeaters,
    COALESCE(b.`Repeater Sales`, 0) AS `Repeater Sales`,
    COALESCE(b.Bills, 0) AS Bills
FROM (
SELECT 
COALESCE(b.Region, 'Unmapped_Region') AS Region,
COUNT(DISTINCT a.mobile) AS `New Enrolment`
FROM member_Report a
LEFT JOIN store_master b ON a.enrolledstorecode = b.storecode
WHERE a.modifiedenrolledon BETWEEN '2024-05-01' AND '2024-05-31'
GROUP BY COALESCE(b.Region, 'Unmapped_Region')
  ) a
RIGHT JOIN (
      SELECT 
        COALESCE(c.Region, 'Unmapped_Region') AS Region,
        COUNT(DISTINCT t.storecode) AS `Stores`,
        COUNT(DISTINCT t.mobile) AS Customers,
        SUM(t.amount) AS Sales,
        COUNT(DISTINCT CASE 
          WHEN 
              (t.txndate > m.modifiedenrolledon AND t.TxnCount = 1) OR
              (t.txndate > m.modifiedenrolledon AND t.TxnCount > 1) OR
              (m.modifiedenrolledon = t.txndate AND t.TxnCount > 1) OR
              (t.txndate < m.modifiedenrolledon AND t.TxnCount > 1) OR
              (m.modifiedenrolledon IS NULL AND t.TxnCount > 1)
          THEN t.Mobile
        END) AS Repeaters,
        SUM(CASE 
          WHEN 
              (t.txndate > m.modifiedenrolledon AND t.TxnCount = 1) OR
              (t.txndate > m.modifiedenrolledon AND t.TxnCount > 1) OR
              (m.modifiedenrolledon = t.txndate AND t.TxnCount > 1) OR
              (t.txndate < m.modifiedenrolledon AND t.TxnCount > 1) OR
              (m.modifiedenrolledon IS NULL AND t.TxnCount > 1)
          THEN t.amount
        END) AS `Repeater Sales`,
        COUNT(DISTINCT t.uniquebillno) AS Bills
FROM txn_report_accrual_redemption t
LEFT JOIN member_report m ON t.mobile = m.mobile
LEFT JOIN store_master c ON t.storecode = c.storecode
WHERE t.txndate BETWEEN '2024-05-01' AND '2024-05-31'
AND t.storecode NOT LIKE '%demo%'
AND t.storecode NOT LIKE '%Ecom%'
GROUP BY COALESCE(c.Region, 'Unmapped_Region')
) b ON a.Region = b.Region
) final_result
ORDER BY 
CASE final_result.Region
WHEN 'North' THEN 1
WHEN 'South' THEN 2
WHEN 'East' THEN 3
WHEN 'West' THEN 4
WHEN 'Unmapped_Region' THEN 5
ELSE 6
END;

 
-- *************** 5 sheet(sales_trend) ********************

SELECT 
DATE_FORMAT(DATE_FORMAT(txndate, '%Y-%m-01'), '%d-%m-%Y') AS PERIOD,
SUM(CASE WHEN (modifiedenrolledon = txndate AND TxnCount = 1) 
OR(txndate < modifiedenrolledon AND TxnCount = 1) 
OR(modifiedenrolledon IS NULL AND TxnCount = 1) 
THEN t.amount END)AS `OneTimer sales`,
SUM(CASE WHEN 
(t.txndate > m.modifiedenrolledon AND t.TxnCount = 1) OR
(t.txndate > m.modifiedenrolledon AND t.TxnCount > 1) OR
(m.modifiedenrolledon = t.txndate AND t.TxnCount > 1) OR
(t.txndate < m.modifiedenrolledon AND t.TxnCount > 1) OR
(m.modifiedenrolledon IS NULL AND t.TxnCount > 1)
THEN t.amount
END) AS `Repeater Sales` FROM txn_report_accrual_redemption t  LEFT JOIN member_report m
ON t.mobile = m.mobile
WHERE txndate BETWEEN '2021-04-01' AND '2025-05-31' AND 
storecode NOT LIKE '%demo%' AND storecode NOT LIKE '%Ecom%'
GROUP BY DATE_FORMAT(txndate, '%Y-%m-01')
ORDER BY DATE_FORMAT(txndate, '%Y-%m-01');

-- 6.sheet
--  *************** monthly_overview ***************
#Transactors from each segment


SELECT PERIOD, Segments, Customers
FROM (
SELECT 
DATE_FORMAT(calendar.month, '%d-%m-%Y') AS PERIOD,
seg.segment AS Segments,
COALESCE(COUNT(DISTINCT t.mobile), 0) AS Customers,
1 AS sort_order,
seg.segment_order
FROM (
SELECT '2024-12-01' AS MONTH UNION ALL
SELECT '2025-01-01' UNION ALL
SELECT '2025-02-01' UNION ALL
SELECT '2025-03-01' UNION ALL
SELECT '2025-04-01' UNION ALL
SELECT '2025-05-01'
  ) AS calendar
  CROSS JOIN (
    SELECT 'Customer from active onetimer base' AS segment, 1 AS segment_order UNION ALL
    SELECT 'Customer from dormant onetimer base', 2 UNION ALL
    SELECT 'Customer from lapsed onetimer base', 3 UNION ALL
    SELECT 'Customers from active repeater base', 4 UNION ALL
    SELECT 'Customers from dormant repeater base', 5 UNION ALL
    SELECT 'Customers from lapsed repeater base', 6
  ) AS seg
  LEFT JOIN txn_report_accrual_redemption t
    ON DATE_FORMAT(t.txndate, '%Y-%m-01') = calendar.month
    AND t.TxnCount > 1
    AND t.storecode NOT LIKE '%demo%'
    AND t.storecode NOT LIKE '%Ecom%'
    AND (
      (seg.segment = 'Customer from active onetimer base' AND t.TxnCount = 2 AND t.Dayssincelastvisit <= 270) OR
      (seg.segment = 'Customer from dormant onetimer base' AND t.TxnCount = 2 AND t.Dayssincelastvisit BETWEEN 270 AND 440) OR
      (seg.segment = 'Customer from lapsed onetimer base' AND t.TxnCount = 2 AND t.Dayssincelastvisit > 440) OR
      (seg.segment = 'Customers from active repeater base' AND t.TxnCount > 2 AND t.Dayssincelastvisit <= 270) OR
      (seg.segment = 'Customers from dormant repeater base' AND t.TxnCount > 2 AND t.Dayssincelastvisit BETWEEN 270 AND 440) OR
      (seg.segment = 'Customers from lapsed repeater base' AND t.TxnCount > 2 AND t.Dayssincelastvisit > 440)
    )
  GROUP BY calendar.month, seg.segment, seg.segment_order
  UNION ALL
  SELECT 
    DATE_FORMAT(DATE_FORMAT(a.txndate, '%Y-%m-01'), '%d-%m-%Y') AS PERIOD,
    'Customers That come before Apr_21' AS Segments, 
    COUNT(DISTINCT a.mobile) AS Customers,
    2 AS sort_order,
    7 AS segment_order
FROM sochcircle.txn_report_accrual_redemption a 
LEFT JOIN member_Report b ON a.mobile = b.mobile
WHERE a.txndate BETWEEN '2024-12-01' AND '2025-05-31'
AND a.storecode NOT LIKE '%demo%'
AND a.storecode NOT LIKE '%Ecom%'
AND a.txndate > b.modifiedenrolledon
AND a.TxnCount = 1
GROUP BY 1
) AS final
ORDER BY sort_order, PERIOD, segment_order;


-- *********************** 7th sheet ******************
-- RFM_Banding

WITH rfm_values AS (
SELECT DISTINCT RFM_Bending FROM dummy.`finaltable_soch_singleview_enrolled_31_may_2025`
WHERE storecode NOT LIKE '%demo%' AND storecode NOT LIKE '%Ecom%'
),
segments AS (
SELECT 'Activeonetimer' AS PERIOD UNION ALL
SELECT 'Activerepeater' UNION ALL
SELECT 'Dormentonetimer' UNION ALL
SELECT 'DormentRepeater' UNION ALL
SELECT 'Lapsedonetimer' UNION ALL
SELECT 'LapsedRepeater'
),
base_combinations AS (
SELECT r.RFM_Bending, s.PERIOD
FROM rfm_values r
CROSS JOIN segments s
),
actual_data AS (
SELECT 
RFM_Bending,
CASE 
WHEN recency <= 270 AND Total_visits = 1 THEN 'Activeonetimer' 
WHEN recency <= 270 AND Total_Visits > 1 THEN 'Activerepeater'
WHEN recency > 270 AND recency <= 440 AND Total_visits = 1 THEN 'Dormentonetimer' 
WHEN recency > 270 AND recency <= 440 AND Total_visits > 1 THEN 'DormentRepeater' 
WHEN recency > 440 AND Total_Visits = 1 THEN 'Lapsedonetimer'
WHEN recency > 440 AND Total_Visits > 1 THEN 'LapsedRepeater'
END AS PERIOD,
COUNT(DISTINCT mobile) AS Customers
FROM dummy.`finaltable_soch_singleview_enrolled_31_may_2025`
WHERE storecode NOT LIKE '%demo%' AND storecode NOT LIKE '%Ecom%'
GROUP BY RFM_Bending, PERIOD
)
SELECT 
b.RFM_Bending AS `RFM score`,
b.PERIOD,
COALESCE(a.Customers, 0) AS Customers
FROM base_combinations b
LEFT JOIN actual_data a
ON b.RFM_Bending = a.RFM_Bending AND b.PERIOD = a.PERIOD
ORDER BY b.RFM_Bending, FIELD(b.PERIOD, 
'Activeonetimer', 'Activerepeater', 
'Dormentonetimer', 'DormentRepeater', 
'Lapsedonetimer', 'LapsedRepeater');


-- *********************** 8th sheet **********************
####Migration

WITH rfm_bins AS (
SELECT DISTINCT rfm_bending COLLATE utf8mb4_unicode_ci AS rfm_bending
FROM dummy.`finaltable_soch_singleview_enrolled_30_apr_2025a`
WHERE storecode NOT LIKE '%demo%' AND storecode NOT LIKE '%Ecom%'
UNION
SELECT DISTINCT rfm_bending COLLATE utf8mb4_unicode_ci AS rfm_bending
FROM dummy.`finaltable_soch_singleview_enrolled_31_may_2025`
WHERE storecode NOT LIKE '%demo%' AND storecode NOT LIKE '%Ecom%'
),
all_combinations AS (
SELECT old.rfm_bending AS Old_RFM,
new.rfm_bending AS New_RFM
FROM rfm_bins OLD
CROSS JOIN rfm_bins NEW
),
actual_data AS (
SELECT 
a.rfm_bending COLLATE utf8mb4_unicode_ci AS Old_RFM, 
b.rfm_bending COLLATE utf8mb4_unicode_ci AS New_RFM,
COUNT(DISTINCT a.Mobile COLLATE utf8mb4_unicode_ci) AS transactors
FROM dummy.`finaltable_soch_singleview_enrolled_30_apr_2025a` a
JOIN dummy.`finaltable_soch_singleview_enrolled_31_may_2025` b
ON a.Mobile COLLATE utf8mb4_unicode_ci = b.Mobile COLLATE utf8mb4_unicode_ci
WHERE a.storecode NOT LIKE '%demo%' AND a.storecode NOT LIKE '%Ecom%'
GROUP BY Old_RFM, New_RFM
)
SELECT 
ac.Old_RFM,
ac.New_RFM,
COALESCE(ad.transactors, 0) AS transactors
FROM all_combinations ac
LEFT JOIN actual_data ad
ON ac.Old_RFM = ad.Old_RFM AND ac.New_RFM = ad.New_RFM
ORDER BY ac.Old_RFM, ac.New_RFM;

-- ************* 9th sheet **********************
-- -- RFM_Score Base_Size *********************** 


SELECT 
  base.rfm_bending,
  COALESCE(base.Base_size, 0) AS Base_size,
  COALESCE(trans.Transactors, 0) AS Transactors
FROM (
    SELECT 
      rfm_bending, 
      COUNT(DISTINCT mobile) AS Base_size 
    FROM dummy.`finaltable_soch_singleview_enrolled_30_apr_2025a`
    WHERE storecode NOT LIKE '%demo%'
      AND storecode NOT LIKE '%Ecom%'
    GROUP BY rfm_bending
) base
LEFT JOIN (
    SELECT 
      a.rfm_bending COLLATE utf8mb4_unicode_ci AS rfm_bending,
      COUNT(DISTINCT b.mobile) AS Transactors
    FROM dummy.`finaltable_soch_singleview_enrolled_30_apr_2025a` a
    JOIN txn_report_accrual_redemption b 
      ON a.mobile COLLATE utf8mb4_unicode_ci = b.mobile COLLATE utf8mb4_unicode_ci
    WHERE b.txndate BETWEEN '2025-05-01' AND '2025-05-31'
      AND b.storecode NOT LIKE '%demo%'
      AND b.storecode NOT LIKE '%Ecom%'
    GROUP BY a.rfm_bending COLLATE utf8mb4_unicode_ci
) trans
ON base.rfm_bending = trans.rfm_bending;

-- ******************** 10 sheet *********************
-- ****************** Cohort Enrollment ******************

SELECT 
CASE WHEN modifiedenrolledon BETWEEN '2021-04-01' AND '2022-03-31' THEN 'last_4_fy'
WHEN modifiedenrolledon BETWEEN '2022-04-01' AND '2023-03-31' THEN 'last_3_fy'
WHEN modifiedenrolledon BETWEEN '2023-04-01' AND '2024-03-31' THEN 'last_2_fy'
WHEN modifiedenrolledon BETWEEN '2024-04-01' AND '2025-03-31' THEN 'last_fy'
WHEN modifiedenrolledon BETWEEN '2025-04-01' AND '2025-05-31' THEN 'curr_fy'
ELSE 'exclude' 
END AS cohort_year,
COUNT(DISTINCT mobile) AS Enrollements
FROM member_report
WHERE modifiedenrolledon <= '2025-05-31' 
AND enrolledstorecode NOT LIKE '%demo%'
AND enrolledstorecode NOT LIKE '%Ecom%'
GROUP BY cohort_year
HAVING cohort_year != 'exclude'
ORDER BY 
CASE cohort_year
WHEN 'last_4_fy' THEN 1
WHEN 'last_3_fy' THEN 2
WHEN 'last_2_fy' THEN 3
WHEN 'last_fy' THEN 4
WHEN 'curr_fy' THEN 5
END;

		
-- ***********Cohort **********

-- verify the enrolledments
SELECT COUNT(*) FROM member_report
WHERE enrolledstorecode NOT LIKE '%demo%' AND enrolledstorecode NOT LIKE '%Ecom%'
AND modifiedenrolledon<='2025-04-30'


-- Combined report for all cohorts (2021–2025) with blanks instead of NULLs
WITH member_2021 AS (
    SELECT DISTINCT mobile
    FROM member_Report
    WHERE modifiedenrolledon BETWEEN '2021-04-01' AND '2022-03-31'
    AND enrolledstorecode NOT LIKE '%demo%' AND enrolledstorecode NOT LIKE '%Ecom%'
),
member_2022 AS (
    SELECT DISTINCT mobile
    FROM member_Report
    WHERE modifiedenrolledon BETWEEN '2022-04-01' AND '2023-03-31'
    AND enrolledstorecode NOT LIKE '%demo%' AND enrolledstorecode NOT LIKE '%Ecom%'
),
member_2023 AS (
    SELECT DISTINCT mobile
    FROM member_Report
    WHERE modifiedenrolledon BETWEEN '2023-04-01' AND '2024-03-31'
    AND enrolledstorecode NOT LIKE '%demo%' AND enrolledstorecode NOT LIKE '%Ecom%'
),
member_2024 AS (
    SELECT DISTINCT mobile
    FROM member_Report
    WHERE modifiedenrolledon BETWEEN '2024-04-01' AND '2025-03-31'
    AND enrolledstorecode NOT LIKE '%demo%' AND enrolledstorecode NOT LIKE '%Ecom%'
),
member_2025 AS (
    SELECT DISTINCT mobile
    FROM member_Report
    WHERE modifiedenrolledon BETWEEN '2025-04-01' AND '2025-05-31'
    AND enrolledstorecode NOT LIKE '%demo%' AND enrolledstorecode NOT LIKE '%Ecom%'
)

-- Final unioned results with blanks
SELECT
    (SELECT COUNT(DISTINCT a.mobile) FROM txn_Report_Accrual_redemption a JOIN member_2021 b ON a.mobile = b.mobile WHERE a.txndate BETWEEN '2021-04-01' AND '2022-03-31' AND storecode NOT LIKE '%Demo%' AND storecode NOT LIKE '%Ecom%') AS last_4_fy,
    (SELECT COUNT(DISTINCT a.mobile) FROM txn_Report_accrual_redemption a JOIN member_2021 b ON a.mobile = b.mobile WHERE a.txndate BETWEEN '2022-04-01' AND '2023-03-31' AND storecode NOT LIKE '%Demo%' AND storecode NOT LIKE '%Ecom%') AS last_3_fy,
    (SELECT COUNT(DISTINCT a.mobile) FROM txn_Report_accrual_redemption a JOIN member_2021 b ON a.mobile = b.mobile WHERE a.txndate BETWEEN '2023-04-01' AND '2024-03-31' AND storecode NOT LIKE '%Demo%' AND storecode NOT LIKE '%Ecom%') AS last_2_fy,
    (SELECT COUNT(DISTINCT a.mobile) FROM txn_Report_accrual_redemption a JOIN member_2021 b ON a.mobile = b.mobile WHERE a.txndate BETWEEN '2024-04-01' AND '2025-03-31' AND storecode NOT LIKE '%Demo%' AND storecode NOT LIKE '%Ecom%') AS last_fy,
    (SELECT COUNT(DISTINCT a.mobile) FROM txn_Report_accrual_redemption a JOIN member_2021 b ON a.mobile = b.mobile WHERE a.txndate BETWEEN '2025-04-01' AND '2025-05-31' AND storecode NOT LIKE '%Demo%' AND storecode NOT LIKE '%Ecom%') AS curr_fy

UNION ALL

SELECT
    '' AS last_4_fy,
    (SELECT COUNT(DISTINCT a.mobile) FROM txn_Report_accrual_redemption a JOIN member_2022 b ON a.mobile = b.mobile WHERE a.txndate BETWEEN '2022-04-01' AND '2023-03-31' AND storecode NOT LIKE '%Demo%' AND storecode NOT LIKE '%Ecom%'),
    (SELECT COUNT(DISTINCT a.mobile) FROM txn_Report_accrual_redemption a JOIN member_2022 b ON a.mobile = b.mobile WHERE a.txndate BETWEEN '2023-04-01' AND '2024-03-31' AND storecode NOT LIKE '%Demo%' AND storecode NOT LIKE '%Ecom%'),
    (SELECT COUNT(DISTINCT a.mobile) FROM txn_Report_accrual_redemption a JOIN member_2022 b ON a.mobile = b.mobile WHERE a.txndate BETWEEN '2024-04-01' AND '2025-03-31' AND storecode NOT LIKE '%Demo%' AND storecode NOT LIKE '%Ecom%'),
    (SELECT COUNT(DISTINCT a.mobile) FROM txn_Report_accrual_redemption a JOIN member_2022 b ON a.mobile = b.mobile WHERE a.txndate BETWEEN '2025-04-01' AND '2025-05-31' AND storecode NOT LIKE '%Demo%' AND storecode NOT LIKE '%Ecom%')

UNION ALL

SELECT
    '', '', 
    (SELECT COUNT(DISTINCT a.mobile) FROM txn_Report_accrual_redemption a JOIN member_2023 b ON a.mobile = b.mobile WHERE a.txndate BETWEEN '2023-04-01' AND '2024-03-31' AND storecode NOT LIKE '%Demo%' AND storecode NOT LIKE '%Ecom%'),
    (SELECT COUNT(DISTINCT a.mobile) FROM txn_Report_accrual_redemption a JOIN member_2023 b ON a.mobile = b.mobile WHERE a.txndate BETWEEN '2024-04-01' AND '2025-03-31' AND storecode NOT LIKE '%Demo%' AND storecode NOT LIKE '%Ecom%'),
    (SELECT COUNT(DISTINCT a.mobile) FROM txn_Report_accrual_redemption a JOIN member_2023 b ON a.mobile = b.mobile WHERE a.txndate BETWEEN '2025-04-01' AND '2025-05-31' AND storecode NOT LIKE '%Demo%' AND storecode NOT LIKE '%Ecom%')

UNION ALL

SELECT
    '', '', '', 
    (SELECT COUNT(DISTINCT a.mobile) FROM txn_Report_accrual_redemption a JOIN member_2024 b ON a.mobile = b.mobile WHERE a.txndate BETWEEN '2024-04-01' AND '2025-03-31' AND storecode NOT LIKE '%Demo%' AND storecode NOT LIKE '%Ecom%'),
    (SELECT COUNT(DISTINCT a.mobile) FROM txn_Report_accrual_redemption a JOIN member_2024 b ON a.mobile = b.mobile WHERE a.txndate BETWEEN '2025-04-01' AND '2025-05-31' AND storecode NOT LIKE '%Demo%' AND storecode NOT LIKE '%Ecom%')

UNION ALL

SELECT
    '', '', '', '', 
    (SELECT COUNT(DISTINCT a.mobile) FROM txn_Report_accrual_redemption a JOIN member_2025 b ON a.mobile = b.mobile WHERE a.txndate BETWEEN '2025-04-01' AND '2025-05-31' AND storecode NOT LIKE '%Demo%' AND storecode NOT LIKE '%Ecom%')
    ;




-- ******************** Sheet 11 **************************

-- ************ State-Level-Data************

WITH overall_sales AS (
SELECT b.state AS state,
COUNT(DISTINCT a.storecode) AS `Store Count`,
SUM(a.amount) AS `Sales`,
COUNT(DISTINCT a.uniquebillno) AS `Total Bills`
FROM `sochcircle`.txn_report_accrual_redemption a
LEFT JOIN store_master b USING(storecode)
WHERE a.txndate BETWEEN '2025-05-01' AND '2025-05-31'
AND a.storecode NOT LIKE '%Demo%'
AND a.storecode NOT LIKE 'Ecom'
GROUP BY b.state
),
repeat_sales AS (
SELECT s.state AS state, 
SUM(t.amount) AS `Repeat Sales`
FROM txn_report_accrual_redemption t
LEFT JOIN member_report m ON t.mobile = m.mobile  
LEFT JOIN store_master s ON t.storecode = s.storecode  
WHERE 
(
(t.txndate > m.modifiedenrolledon AND t.TxnCount = 1) 
OR (t.txndate > m.modifiedenrolledon AND t.TxnCount > 1) 
OR (m.modifiedenrolledon = t.txndate AND t.TxnCount > 1) 
OR (t.txndate < m.modifiedenrolledon AND t.TxnCount > 1) 
OR (m.modifiedenrolledon IS NULL AND t.TxnCount > 1)
)
AND t.txndate BETWEEN '2025-05-01' AND '2025-05-31'
AND t.storecode NOT LIKE '%Demo%'
AND t.storecode NOT LIKE 'Ecom'
GROUP BY s.state
)
SELECT 
os.state AS `State`,
os.`Store Count`,
os.`Sales`,
os.`Total Bills`,
COALESCE(rs.`Repeat Sales`, 0) AS `Repeat Sales`
FROM overall_sales os
LEFT JOIN repeat_sales rs ON os.state = rs.state
UNION
SELECT 
rs.state AS `State`,
COALESCE(os.`Store Count`, 0) AS `Store Count`,
COALESCE(os.`Sales`, 0) AS `Sales`,
COALESCE(os.`Total Bills`, 0) AS `Total Bills`,
rs.`Repeat Sales`
FROM repeat_sales rs
LEFT JOIN overall_sales os ON rs.state = os.state
WHERE os.state IS NULL
ORDER BY `State`;
 
 
 -- ******************  13th Sheet Spend Band Analysis  ****************

SELECT spend_band,
SUM(Bills) AS `Total Bills`,
SUM(Sales) AS `Total Sales`
FROM (
SELECT mobile,
COUNT(DISTINCT uniquebillno) AS Bills,
SUM(amount) AS sales,
CASE WHEN SUM(amount) >= 0 AND SUM(amount) <= 2500 THEN '0-2500'
WHEN SUM(amount) > 2500 AND SUM(amount) <= 5000 THEN '2500-5000'
WHEN SUM(amount) > 5000 AND SUM(amount) <= 7500 THEN '5000-7500'
WHEN SUM(amount) > 7500 AND SUM(amount) <= 10000 THEN '7500-10000'
WHEN SUM(amount) > 10000 AND SUM(amount) <= 12500 THEN '10000-12500'
WHEN SUM(amount) > 12500 AND SUM(amount) <= 15000 THEN '12500-15000'
WHEN SUM(amount) > 15000 AND SUM(amount) <= 17500 THEN '15000-17500'
WHEN SUM(amount) > 17500 AND SUM(amount) <= 20000 THEN '17500-20000'
WHEN SUM(amount) > 20000 AND SUM(amount) <= 25000 THEN '20000-25000'
WHEN SUM(amount) > 25000 AND SUM(amount) <= 30000 THEN '25000-30000'
WHEN SUM(amount) > 30000 THEN '30000+'
END AS spend_band
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2025-05-01' AND '2025-05-31'
AND storecode NOT LIKE '%demo%' 
AND storecode NOT LIKE '%Ecom%' 
GROUP BY mobile
) a
WHERE spend_band IS NOT NULL
GROUP BY spend_band
ORDER BY 
CASE spend_band
WHEN '0-2500' THEN 1
WHEN '2500-5000' THEN 2
WHEN '5000-7500' THEN 3
WHEN '7500-10000' THEN 4
WHEN '10000-12500' THEN 5
WHEN '12500-15000' THEN 6
WHEN '15000-17500' THEN 7
WHEN '17500-20000' THEN 8
WHEN '20000-25000' THEN 9
WHEN '25000-30000' THEN 10
WHEN '30000+' THEN 11
END;
 
 

--  ******************** 14th Sheet **********************
-- ************************Region-Level-Data *****************

 WITH regions AS (
  SELECT DISTINCT COALESCE(region, 'Unmapped') AS region
  FROM store_master
  WHERE storecode NOT LIKE '%Demo%' AND storecode NOT LIKE '%Ecom%'
),
ages AS (
  SELECT 'New Store' AS Store_Age
  UNION ALL
  SELECT 'Semi Old Store'
  UNION ALL
  SELECT 'Old Store'
),
region_age_dim AS (
  SELECT r.region, a.Store_Age
  FROM regions r
  CROSS JOIN ages a
),
store_age_mapping AS (
  SELECT 
    a.storecode, 
    COALESCE(b.region, 'Unmapped') AS region,
    CASE 
      WHEN DATEDIFF(CURDATE(), MIN(a.txndate)) <= 365 THEN 'New Store'
      WHEN DATEDIFF(CURDATE(), MIN(a.txndate)) > 365 AND DATEDIFF(CURDATE(), MIN(a.txndate)) <= 730 THEN 'Semi Old Store'
      WHEN DATEDIFF(CURDATE(), MIN(a.txndate)) > 730 THEN 'Old Store'
    END AS Store_Age
  FROM txn_report_accrual_redemption a
  LEFT JOIN store_master b ON a.storecode = b.storecode
  WHERE a.storecode NOT LIKE '%Demo%' AND a.storecode NOT LIKE '%Ecom%' AND txndate <= '2025-05-31'
  GROUP BY 1, 2
),
store_kpis AS (
  SELECT 
    t.storecode, 
    COALESCE(b.region, 'Unmapped') AS region,
    COUNT(DISTINCT t.mobile) AS customers,
    SUM(amount) AS sales,
    COUNT(DISTINCT uniquebillno) AS bills,
    COUNT(DISTINCT CASE 
      WHEN (t.txndate > m.modifiedenrolledon AND t.TxnCount = 1) 
        OR (t.txndate > m.modifiedenrolledon AND t.TxnCount > 1) 
        OR (m.modifiedenrolledon = t.txndate AND t.TxnCount > 1) 
        OR (t.txndate < m.modifiedenrolledon AND t.TxnCount > 1) 
        OR (m.modifiedenrolledon IS NULL AND t.TxnCount > 1) 
      THEN t.mobile END) AS Repeaters,
    SUM(CASE 
      WHEN (t.txndate > m.modifiedenrolledon AND t.TxnCount = 1) 
        OR (t.txndate > m.modifiedenrolledon AND t.TxnCount > 1) 
        OR (m.modifiedenrolledon = t.txndate AND t.TxnCount > 1) 
        OR (t.txndate < m.modifiedenrolledon AND t.TxnCount > 1) 
        OR (m.modifiedenrolledon IS NULL AND t.TxnCount > 1) 
      THEN amount END) AS Repeaters_sales
  FROM txn_report_accrual_redemption t
  LEFT JOIN store_master b ON t.storecode = b.storecode
  LEFT JOIN member_Report m ON t.mobile = m.mobile
  WHERE t.storecode NOT LIKE '%Demo%' AND t.storecode NOT LIKE '%Ecom%' 
    AND t.txndate BETWEEN '2025-05-01' AND '2025-05-31'
  GROUP BY 1, 2
),
combined AS (
  SELECT 
    s.region, 
    s.Store_Age, 
    k.storecode, 
    k.customers, 
    k.sales, 
    k.bills, 
    k.Repeaters_sales
  FROM store_age_mapping s
  LEFT JOIN store_kpis k ON s.storecode = k.storecode
)
SELECT 
  d.region,
  d.Store_Age,
  COUNT(c.storecode) AS `Store Count`,
  COALESCE(SUM(c.Repeaters_sales), 0) AS `Repeat Sales`,
  COALESCE(SUM(c.customers), 0) AS `Total Customers`,
  COALESCE(SUM(c.sales), 0) AS `Total Sales`,
  COALESCE(SUM(c.bills), 0) AS `Total Bills`
FROM region_age_dim d
LEFT JOIN combined c ON d.region = c.region AND d.Store_Age = c.Store_Age
GROUP BY d.region, d.Store_Age
ORDER BY d.region, 
  CASE 
    WHEN d.Store_Age = 'New Store' THEN 1
    WHEN d.Store_Age = 'Semi Old Store' THEN 2
    WHEN d.Store_Age = 'Old Store' THEN 3
    ELSE 4
  END;



-- *************************** 15TH Sheet *******************
-- **************************Store-level-data *************

WITH overall_kpis AS (
SELECT b.storecode,
SUM(amount) AS sale,
COUNT(DISTINCT uniquebillno) AS bills
FROM txn_report_accrual_redemption a
LEFT JOIN store_master b USING(storecode)
WHERE txndate BETWEEN '2025-05-01' AND '2025-05-31' 
AND a.storecode NOT LIKE '%Demo%'
AND a.storecode NOT LIKE '%Ecom%' 
GROUP BY b.storecode
),
repeaters_kpis AS (
SELECT t.storecode, 
SUM(t.amount) AS Repeat_sales
FROM txn_report_accrual_redemption t
LEFT JOIN member_report m ON t.mobile = m.mobile  
LEFT JOIN store_master s ON t.storecode = s.storecode  
WHERE (
(t.txndate > m.modifiedenrolledon AND t.TxnCount = 1) 
OR (t.txndate > m.modifiedenrolledon AND t.TxnCount > 1) 
OR (m.modifiedenrolledon = t.txndate AND t.TxnCount > 1) 
OR (t.txndate < m.modifiedenrolledon AND t.TxnCount > 1) 
OR (m.modifiedenrolledon IS NULL AND t.TxnCount > 1)
    )
AND t.txndate BETWEEN '2025-05-01' AND '2025-05-31' 
AND t.storecode NOT LIKE '%Demo%' 
AND t.storecode NOT LIKE '%Ecom%' 
GROUP BY t.storecode
)
SELECT o.storecode,
o.sale, o.bills,
COALESCE(r.Repeat_sales, 0) AS Repeat_sales
FROM overall_kpis o
LEFT JOIN repeaters_kpis r ON o.storecode = r.storecode;

     
  
-- ******************* Sheet_16 product_combos_purchased ****************   
-- category level data 

SELECT category ,category_count,SUM(bills)AS Bills FROM(
SELECT txnmappedmobile,GROUP_CONCAT(categoryname)AS category,COUNT(categoryname)AS category_count,COUNT(DISTINCT uniquebillno)AS bills FROM sku_report_loyalty a 
LEFT JOIN item_master b USING(uniqueitemcode)
WHERE a.modifiedstorecode NOT LIKE '%Demo%' 
AND a.modifiedstorecode NOT LIKE '%Ecom%' AND a.modifiedtxndate BETWEEN '2025-05-01' AND '2025-05-31'
GROUP BY 1)a
GROUP BY 1;
  
     
-- ****************** Sheet_17  Online-Offline-Purchase-YTD **********************    


SELECT `KPIs`,
COUNT(DISTINCT mobile) AS Customers,
SUM(sales) AS `Sales`, SUM(Bills) AS `Bills`,
SUM(visits) AS `Visits`
FROM (
SELECT mobile, SUM(amount) AS sales,
COUNT(DISTINCT uniquebillno) AS Bills,
COUNT(DISTINCT mobile, txndate) AS visits,
CASE WHEN GROUP_CONCAT(DISTINCT CASE WHEN storecode = 'Ecom' THEN 'Online' ELSE 'Offline' END) LIKE 'Online,Offline'
OR GROUP_CONCAT(DISTINCT CASE WHEN storecode = 'Ecom' THEN 'Online' ELSE 'Offline' END) LIKE 'Offline,Online' THEN 'Overlap'
ELSE GROUP_CONCAT(DISTINCT CASE WHEN storecode = 'Ecom' THEN 'Online' ELSE 'Offline' END) END AS `KPIs`
FROM txn_report_accrual_redemption
WHERE storecode NOT LIKE '%Demo%' 
AND txndate BETWEEN '2025-04-01' AND '2025-05-31'
GROUP BY mobile
) a
GROUP BY `KPIs`;



-- *************** Sheet_18_city_online_offline_proportion-YTD ****************


SELECT 
COALESCE(b.city, 'unmapped') AS city,
COUNT(DISTINCT a.mobile) AS Customers,
COALESCE(SUM(sales), 0) AS sales
FROM (
SELECT mobile,
SUM(amount) AS sales,
GROUP_CONCAT(DISTINCT CASE WHEN storecode = 'Ecom' THEN 'online' ELSE 'Offline' END) AS online_mobile
FROM txn_report_accrual_redemption
WHERE storecode NOT LIKE '%Demo%' 
AND txndate BETWEEN '2025-04-01' AND '2025-05-31'
GROUP BY mobile
HAVING online_mobile = 'offline,online'
) a
LEFT JOIN txn_report_accrual_redemption c ON a.mobile = c.mobile
LEFT JOIN store_master b ON c.storecode = b.storecode
WHERE c.storecode NOT LIKE '%Ecom%'
GROUP BY COALESCE(b.city, 'unmapped');


