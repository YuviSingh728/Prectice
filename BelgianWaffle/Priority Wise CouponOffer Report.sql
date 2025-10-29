SELECT*FROM dummy.BW_New_loyalty_program_coupn_data_26_09_2025;


-- CREATE TABLE dummy.BW_New_loyalty_program_coupn_data_26_09_2025
--  SELECT mobile FROM member_report
--  WHERE modifiedenrolledon <='2025-09-25';#1406823
 
 
ALTER TABLE dummy.BW_New_loyalty_program_coupn_data_26_09_2025 ADD COLUMN Coupon_issued VARCHAR(200),ADD COLUMN Priority_couponoffercode VARCHAR(200);


UPDATE dummy.BW_New_loyalty_program_coupn_data_26_09_2025 SET Coupon_issued=NULL;
UPDATE dummy.BW_New_loyalty_program_coupn_data_26_09_2025 a JOIN (
SELECT issuedmobile,COUNT(couponoffercode)issued,GROUP_CONCAT(couponoffercode) AS couponoffercode FROM coupon_offer_report
WHERE issueddate>='2025-05-20' #AND '2025-09-25'
AND couponstatus='issued'
GROUP BY 1) b
ON a.mobile=b.issuedmobile
SET a.Coupon_issued=b.issued,
a.Priority_couponoffercode=b.couponoffercode;#56523

SELECT*FROM coupon_offer_report;

ALTER TABLE dummy.BW_New_loyalty_program_coupn_data_26_09_2025 ADD COLUMN Priority VARCHAR(50);

SELECT*FROM dummy.BW_New_loyalty_program_coupn_data_26_09_2025;

UPDATE dummy.BW_New_loyalty_program_coupn_data_26_09_2025  
SET Priority= CASE 
WHEN couponoffercode='NLPCUM' THEN '1'
WHEN couponoffercode='NLPUM' THEN '2'
WHEN couponoffercode='NLPUP' THEN '3'
WHEN couponoffercode='NLPWN' THEN '4'
WHEN couponoffercode='NLPMB' THEN '5'
WHEN couponoffercode='NLPFC' THEN '6'
ELSE 'other'
END;#1406823


SELECT * FROM dummy.BW_New_loyalty_program_coupn_data_26_09_2025 
GROUP BY 1
ORDER BY Priority;










SELECT * FROM dummy.Umesh_member_report


-- CREATE TEMPORARY TABLE numbers (n INT);
 
WITH  numbers AS (
SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9);
 
 
UPDATE dummy.Umesh_member_report AS t
JOIN (
    SELECT 
        extracted.mobile,
        MIN(cp.priority) AS highest_priority
    FROM (
        SELECT 
            t.mobile,
            SUBSTRING_INDEX(SUBSTRING_INDEX(t.Priority_couponoffercode, ',', n.n + 1), ',', -1) AS coupon_code
        FROM dummy.Umesh_member_report t
        JOIN numbers n 
          ON CHAR_LENGTH(t.Priority_couponoffercode) - CHAR_LENGTH(REPLACE(t.Priority_couponoffercode, ',', '')) >= n.n
    ) AS extracted
    JOIN coupon_priority cp 
      ON extracted.coupon_code = cp.couponoffercode
    GROUP BY extracted.mobile
) AS final_priority
  ON t.mobile = final_priority.mobile
SET t.Priority = final_priority.highest_priority;
 
 
ALTER TABLE dummy.Umesh_member_report
ADD COLUMN Priority_coupon VARCHAR(10);
 
 
UPDATE dummy.Umesh_member_report AS lp
JOIN dummy.coupon_priority cp ON lp.Priority = cp.priority
SET lp.Priority_coupon = cp.couponoffercode;
 
 
ALTER TABLE dummy.Umesh_member_report
ADD COLUMN priority_coupon_expiry DATE;
 
SELECT * FROM dummy.Umesh_member_report;#2025-05-20
 
 
UPDATE dummy.Umesh_member_report AS lp
JOIN (
    SELECT 
        issuedmobile AS mobile,
        couponoffercode,
         MAX(expirydate) AS latest_expiry
    FROM thebelgianwaffles.coupon_offer_report
    WHERE couponstatus = 'Issued' 
    GROUP BY issuedmobile, couponoffercode
) AS ci
ON lp.mobile = ci.mobile AND lp.Priority_coupon = ci.couponoffercode
SET lp.priority_coupon_expiry = ci.latest_expiry;




ALTER TABLE dummy.Umesh_member_report ADD COLUMN Coupon_issued VARCHAR(200),
ADD COLUMN Priority_couponoffercode VARCHAR(200);

SELECT*FROM dummy.Umesh_member_report

ALTER TABLE dummy.Umesh_member_report DROP Modifiedenrolledon,DROP couponoffercode;

INSERT INTO dummy.Umesh_member_report (mobile,enrolledstorecode)
SELECT DISTINCT mobile,enrolledstorecode
FROM member_report 
-- join coupon_offer_report b
-- on a.mobile=b.issuedmobile
WHERE Modifiedenrolledon<='2025-09-28'
AND enrolledstorecode <> 'demo'
-- AND couponstatus='issued'
;#1410516


SELECT*FROM dummy.Umesh_member_report;

DESC dummy.Umesh_member_report;







CREATE TABLE dummy.coupon_offer_1 
SELECT mobile,modifiedenrolledon,GROUP_CONCAT(couponoffercode)Active_Couponoffercode
FROM member_report a
LEFT JOIN coupon_offer_report b
ON a.mobile=b.issuedmobile
WHERE modifiedenrolledon<='2025-09-28'
AND enrolledstorecode <> 'demo'
GROUP BY 1;#1410516



ALTER TABLE dummy.coupon_offer_1 ADD COLUMN Priority INT;


ALTER TABLE dummy.coupon_offer_1 MODIFY COLUMN Priority VARCHAR(20);

UPDATE dummy.coupon_offer_1  
SET Priority= CASE 
WHEN Active_Couponoffercode='NLPCUM' THEN '1'
WHEN Active_Couponoffercode='NLPUM' THEN '2'
WHEN Active_Couponoffercode='NLPUP' THEN '3'
WHEN Active_Couponoffercode='NLPWN' THEN '4'
WHEN Active_Couponoffercode='NLPMB' THEN '5'
WHEN Active_Couponoffercode='NLPFC' THEN '6'
ELSE 'other'
END;#1410516

SELECT Active_Couponoffercode, Priority,COUNT(DISTINCT mobile) FROM dummy.coupon_offer_1 
GROUP BY 1,2

SELECT * FROM coupon_offer_report

UPDATE dummy.coupon_offer_1 
SET priority ='2'
WHERE Active_Couponoffercode LIKE '%NLPUM%' AND priority IS NULL; #9805 row(s) affected

UPDATE dummy.coupon_offer_1 
SET priority ='3'
WHERE Active_Couponoffercode LIKE '%NLPUP%' AND priority IS NULL; #60161 row(s) affected


UPDATE dummy.coupon_offer_1 
SET priority ='4'
WHERE Active_Couponoffercode LIKE '%NLPWN%' AND priority IS NULL; #104016 row(s) affected


UPDATE dummy.coupon_offer_1 
SET priority ='5'
WHERE Active_Couponoffercode LIKE '%NLPMB%' AND priority IS NULL; #14355 row(s) affected


UPDATE dummy.coupon_offer_1 
SET priority ='6'
WHERE Active_Couponoffercode LIKE '%NLPFC%' AND priority IS NULL; #726 row(s) affected

SELECT * FROM dummy.coupon_offer_1 

ALTER TABLE dummy.coupon_offer_1 
ADD COLUMN Coupon_Code VARCHAR(50);

UPDATE dummy.coupon_offer_1 
SET coupon_code = CASE WHEN  priority ='1' THEN 'NLPCUM'
                       WHEN  priority ='2' THEN 'NLPUM'
                        WHEN  priority ='3' THEN 'NLPUP'
                         WHEN  priority ='4' THEN 'NLPWN'
                          WHEN  priority ='5' THEN 'NLPMB'
                           WHEN  priority ='6' THEN 'NLPFC' END ; #238325 row(s) affected



SELECT * FROM dummy.coupon_offer_1 
-- select Active_Couponoffercode,count(Distinct Active_Couponoffercode)  from coupon_offer_report
-- group by 1
-- 
-- 9767643092 9898473524


-- select * from coupon_offer_report
-- where issuedmobile in('9767643092','9898473524')

ALTER TABLE dummy.coupon_offer_1 ADD INDEX mobile(mobile);


ALTER TABLE dummy.coupon_offer_1 ADD COLUMN Expiry_Date DATE;


UPDATE dummy.coupon_offer_1 a JOIN
(SELECT issuedmobile,couponoffercode,MAX(expirydate)AS Expire_Date FROM coupon_offer_report
WHERE issueddate<='2025-09-28' 
GROUP BY 1,2)b
ON a.mobile = b.issuedmobile AND a.coupon_code = b.couponoffercode
SET a.Expiry_Date = b.Expire_Date #238299 row(s) affected


UPDATE dummy.coupon_offer_1
SET priority = 1
WHERE mobile IN(SELECT DISTINCT issuedmobile FROM coupon_offer_report
WHERE couponoffercode = 'NLPCUM');#4748

UPDATE dummy.coupon_offer_1
SET Priority = NULL
WHERE Priority = 'other' #1366002 row(s) affected

SELECT COUNT(DISTINCT mobile),COUNT(mobile) FROM dummy.coupon_offer_1
WHERE Priority ='other' #

SELECT*FROM dummy.coupon_offer_1

SELECT DISTINCT Active_Couponoffercode FROM dummy.coupon_offer_1
WHERE mobile IN(SELECT DISTINCT issuedmobile FROM coupon_offer_report
WHERE couponoffercode = 'NLPCUM');


SELECT * FROM 





-- Create temp numbers table (0-9) for splitting
CREATE TABLE dummy.numbers (n INT);
INSERT INTO dummy.numbers (n)
SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9;

-- Step 1: Extract individual coupon codes and calculate their priorities
UPDATE dummy.coupon_offer_1 AS t
JOIN (
    SELECT 
        extracted.mobile,
        MIN(cp.priority) AS highest_priority
    FROM (
        SELECT 
            t.mobile,
            TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(t.Active_Couponoffercode, ',', n.n + 1), ',', -1)) AS coupon_code
        FROM dummy.coupon_offer_1 t
        JOIN dummy.numbers n 
          ON n.n <= CHAR_LENGTH(t.Active_Couponoffercode) - CHAR_LENGTH(REPLACE(t.Active_Couponoffercode, ',', ''))
    ) AS extracted
    JOIN priority cp ON extracted.coupon_code = cp.couponoffercode
    GROUP BY extracted.mobile
) AS final_priority
ON t.mobile = final_priority.mobile
SET t.Priority = final_priority.highest_priority;







