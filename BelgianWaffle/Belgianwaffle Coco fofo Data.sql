################################################## thebelgianwaffles ######################################################################

## \\  MMR
-- coco
WITH customer_min_freq AS (
    SELECT MONTH(modifiedtxndate) AS `Date`,
    txnmappedmobile,MIN(frequencycount) AS min_freq
    FROM thebelgianwaffles.sku_report_Loyalty
    WHERE  modifiedTxndate BETWEEN '2025-05-20' AND '2025-09-09'
    AND modifiedstorecode LIKE 'C%' AND deliverymode='offline'
    GROUP BY MONTH(modifiedtxndate),txnmappedmobile
 )
SELECT 
    `Date` AS period_label,
    COUNT(DISTINCT txnmappedmobile) AS `Transacting Customers`,
    COUNT(DISTINCT CASE WHEN min_freq > 1 THEN txnmappedmobile END) AS `Repeat Customers`,
    COUNT(DISTINCT CASE WHEN min_freq = 1 THEN txnmappedmobile END) AS `New Customers` 
FROM customer_min_freq
GROUP BY `Date`
ORDER BY `Date`;

-- WITH customer_min_freq AS (
--     SELECT txnmappedmobile,MIN(frequencycount) AS min_freq
--     FROM thebelgianwaffles.sku_report_Loyalty
--     WHERE  modifiedTxndate BETWEEN '2025-04-01' AND '2025-09-09'
--     AND modifiedstorecode LIKE 'C%' AND deliverymode='offline'
--     GROUP BY txnmappedmobile
-- )
-- SELECT 
--     'COCO_Apr_25 to till date' AS period_label,
--     COUNT(DISTINCT txnmappedmobile) AS `Transacting Customers`,
--     COUNT(DISTINCT CASE WHEN min_freq = 1 THEN txnmappedmobile END) AS `New Customers`,
--     COUNT(DISTINCT CASE WHEN min_freq > 1 THEN txnmappedmobile END) AS `Repeat Customers`
-- FROM customer_min_freq;
-- 

-- fofo
WITH customer_min_freq AS (
    SELECT MONTH(modifiedtxndate) AS `Date`,
    txnmappedmobile,MIN(frequencycount) AS min_freq
    FROM thebelgianwaffles.sku_report_Loyalty
    WHERE modifiedTxndate BETWEEN '2025-05-20' AND '2025-09-09'
    AND (modifiedstorecode  LIKE 'P/%' OR modifiedstorecode LIKE 'F/%') AND deliverymode='offline'
    GROUP BY MONTH(modifiedtxndate),txnmappedmobile
)
SELECT 
    `Date` AS period_label,
    COUNT(DISTINCT txnmappedmobile) AS `Transacting Customers`,
    COUNT(DISTINCT CASE WHEN min_freq > 1 THEN txnmappedmobile END) AS `Repeat Customers`,
    COUNT(DISTINCT CASE WHEN min_freq = 1 THEN txnmappedmobile END) AS `New Customers`    
FROM customer_min_freq
GROUP BY `Date`
ORDER BY `Date`;#


#################################################### belgianwaffles ######################################################################

## \\  NON-MMR  
-- coco
WITH customer_min_freq AS (
    SELECT MONTH(modifiedtxndate) AS `Date`,
    txnmappedmobile,MIN(frequencycount) AS min_freq
    FROM belgianwaffles.sku_report_Loyalty
    WHERE modifiedTxndate BETWEEN '2024-04-01' AND '2025-04-30'
    AND modifiedstorecode LIKE 'C%' AND deliverymode='offline'
    GROUP BY MONTH(modifiedtxndate),txnmappedmobile
)
SELECT 
    `Date` AS period_label,
    COUNT(DISTINCT txnmappedmobile) AS `Transacting Customers`,
    COUNT(DISTINCT CASE WHEN min_freq > 1 THEN txnmappedmobile END) AS `Repeat Customers`,
    COUNT(DISTINCT CASE WHEN min_freq = 1 THEN txnmappedmobile END) AS `New Customers`    
FROM customer_min_freq
GROUP BY `Date`
ORDER BY `Date`;


-- fofo
WITH customer_min_freq AS (
    SELECT MONTH(modifiedtxndate) AS `Date`,
    txnmappedmobile,MIN(frequencycount) AS min_freq
    FROM belgianwaffles.sku_report_Loyalty
    WHERE modifiedTxndate BETWEEN '2024-04-01' AND '2025-04-30'
    AND (modifiedstorecode  LIKE 'P/%' OR modifiedstorecode LIKE 'F/%') AND deliverymode='offline'
    GROUP BY MONTH(modifiedtxndate),txnmappedmobile
)
SELECT 
    `Date` AS period_label,
    COUNT(DISTINCT txnmappedmobile) AS `Transacting Customers`,
    COUNT(DISTINCT CASE WHEN min_freq > 1 THEN txnmappedmobile END) AS `Repeat Customers`,
    COUNT(DISTINCT CASE WHEN min_freq = 1 THEN txnmappedmobile END) AS `New Customers`
FROM customer_min_freq
GROUP BY `Date`
ORDER BY `Date`;#32m

##########################May_25 to Sep_25 Data

WITH customer_min_freq AS (
    SELECT MONTH(modifiedtxndate) AS `Date`,
    txnmappedmobile,MIN(frequencycount) AS min_freq
    FROM belgianwaffles.sku_report_Loyalty
    WHERE modifiedTxndate BETWEEN '2025-05-01' AND '2025-09-09'
    AND modifiedstorecode LIKE 'C%' AND deliverymode='offline'
    AND uniquebillno NOT IN (SELECT uniquebillno FROM thebelgianwaffles.sku_report_loyalty)
    GROUP BY MONTH(modifiedtxndate),txnmappedmobile
)
SELECT 
    `Date` AS period_label,
    COUNT(DISTINCT txnmappedmobile) AS `Transacting Customers`,
    COUNT(DISTINCT CASE WHEN min_freq > 1 THEN txnmappedmobile END) AS `Repeat Customers`,
    COUNT(DISTINCT CASE WHEN min_freq = 1 THEN txnmappedmobile END) AS `New Customers`    
FROM customer_min_freq
GROUP BY `Date`
ORDER BY `Date`;


-- fofo
WITH customer_min_freq AS (
    SELECT MONTH(modifiedtxndate) AS `Date`,
    txnmappedmobile,MIN(frequencycount) AS min_freq
    FROM belgianwaffles.sku_report_Loyalty
    WHERE modifiedTxndate BETWEEN '2025-05-01' AND '2025-09-09'
    AND (modifiedstorecode  LIKE 'P/%' OR modifiedstorecode LIKE 'F/%') AND deliverymode='offline'
    AND uniquebillno NOT IN (SELECT uniquebillno FROM thebelgianwaffles.sku_report_loyalty)
    GROUP BY MONTH(modifiedtxndate),txnmappedmobile
)
SELECT 
    `Date` AS period_label,
    COUNT(DISTINCT txnmappedmobile) AS `Transacting Customers`,
    COUNT(DISTINCT CASE WHEN min_freq > 1 THEN txnmappedmobile END) AS `Repeat Customers`,
    COUNT(DISTINCT CASE WHEN min_freq = 1 THEN txnmappedmobile END) AS `New Customers`
FROM customer_min_freq
GROUP BY `Date`
ORDER BY `Date`;#32m