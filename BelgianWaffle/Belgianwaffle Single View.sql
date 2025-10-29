
###################BelgianWaffles SingleView

-- CREATE TABLE dummy.belgianwaffle_SingleView_till_25thSept
INSERT INTO dummy.belgianwaffle_SingleView_till_25thSept(mobile)
SELECT DISTINCT mobile FROM member_report
WHERE modifiedenrolledon<='2025-09-25'
UNION
SELECT DISTINCT mobile FROM txn_report_accrual_redemption
WHERE txndate<='2025-09-25'
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%';#6523839
      
      
ALTER TABLE dummy.belgianwaffle_SingleView_till_25thSept ADD INDEX mobile(mobile);

-- ALTER TABLE dummy.belgianwaffle_SingleView_till_25thSept ADD COLUMN FirstName VARCHAR(100),ADD COLUMN LastName VARCHAR(100),
-- ADD COLUMN DateOfBirth VARCHAR(50),ADD COLUMN Gender VARCHAR(20),ADD COLUMN Email VARCHAR(100),
-- ADD COLUMN Modifiedenrolledon VARCHAR(100),ADD COLUMN EnrolledStorecode VARCHAR(100),
-- ADD COLUMN AvailablePoints FLOAT,ADD COLUMN anniversaryDate VARCHAR(50);  
   
-- ALTER TABLE dummy.belgianwaffle_SingleView_till_25thSept MODIFY COLUMN FirstName VARCHAR(200);

UPDATE dummy.belgianwaffle_SingleView_till_25thSept a JOIN (
SELECT DISTINCT mobile,FirstName,
LastName,
DateOfBirth,
Gender,
a.Email,
Modifiedenrolledon,
a.EnrolledStorecode,
a.AvailablePoints,
a.anniversarydate
FROM member_report a 
WHERE modifiedenrolledon<='2025-09-25'
)b USING(mobile)
SET a.FirstName=b.FirstName,a.LastName=b.LastName,
a.DateOfBirth=b.DateOfBirth,a.Gender=b.Gender,
a.Email=b.Email,a.Modifiedenrolledon=b.Modifiedenrolledon,
a.EnrolledStorecode=b.EnrolledStorecode,a.AvailablePoints=b.AvailablePoints,
a.anniversaryDate=b.anniversaryDate;#6519184
-- WHERE customertype IS NULL;



-- ALTER TABLE dummy.belgianwaffle_SingleView_till_25thSept ADD COLUMN Sales FLOAT,ADD COLUMN Bills VARCHAR(200),ADD COLUMN Visit VARCHAR(200),
-- ADD COLUMN pointscollected FLOAT,ADD COLUMN Point_Spent FLOAT,ADD COLUMN First_Txn_Date VARCHAR(200),
-- ADD COLUMN Last_Txn_date VARCHAR(200);


UPDATE dummy.belgianwaffle_SingleView_till_25thSept a JOIN (
SELECT mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,COUNT(DISTINCT mobile,txndate)visit,
SUM(pointscollected)pointscollected,SUM(pointsspent)pts_spent,MIN(txndate)first_txn_date,MAX(txndate)last_txn_date
FROM txn_report_accrual_redemption
WHERE txndate<='2025-09-25'
AND storecode <> 'demo'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
GROUP BY 1)b USING(mobile)
SET a.sales=b.sales,
a.Sales=b.Sales,a.Bills=b.Bills,
a.Visit=b.Visit,a.pointscollected=b.pointscollected,
a.Point_Spent=b.pts_spent,a.First_Txn_Date=b.First_Txn_Date,
a.Last_Txn_date=b.Last_Txn_date;#5797719
-- WHERE customertype IS NULL;

ALTER TABLE dummy.belgianwaffle_SingleView_till_25thSept ADD COLUMN CustomerType VARCHAR(50);

UPDATE dummy.belgianwaffle_SingleView_till_25thSept a JOIN(
SELECT mobile,modifiedenrolledon,First_Txn_Date, 
	CASE 
		WHEN (modifiedenrolledon IS NOT NULL AND First_Txn_Date IS NOT NULL) THEN 'Enroll & Txn'
		WHEN (modifiedenrolledon IS NOT NULL AND First_Txn_Date IS NULL) THEN 'Only Enrolled'
		WHEN (modifiedenrolledon IS NULL AND First_Txn_Date IS NOT NULL) THEN 'Only Transacted'
		END AS `Tag`
FROM dummy.belgianwaffle_SingleView_till_25thSept)b USING(mobile)
SET a.CustomerType=b.Tag;#6523839
-- WHERE customertype IS NULL;

SELECT DISTINCT customertype,mobile FROM dummy.belgianwaffle_SingleView_till_25thSept
GROUP BY 1;

SELECT mobile,COUNT(mobile) FROM dummy.belgianwaffle_SingleView_till_25thSept
GROUP BY 1;

SELECT COUNT(*) FROM  dummy.belgianwaffle_SingleView_till_25thSept;


SELECT * FROM txn_report_accrual_redemption
WHERE mobile ='6000030073';

SELECT * FROM member_report
WHERE mobile ='6000030073';

###################TheBelgianWaffles SingleView


INSERT INTO dummy.thebelgianwaffle_SingleView_till_25thSept(mobile)
SELECT DISTINCT mobile FROM member_report
WHERE modifiedenrolledon<='2025-09-25'
UNION
SELECT DISTINCT mobile FROM txn_report_accrual_redemption
WHERE txndate<='2025-09-25'
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%';#1406852
      
      
ALTER TABLE dummy.thebelgianwaffle_SingleView_till_25thSept ADD INDEX mobile(mobile);


-- ALTER TABLE dummy.thebelgianwaffle_SingleView_till_25thSept ADD COLUMN FirstName VARCHAR(100),ADD COLUMN LastName VARCHAR(100),
-- ADD COLUMN DateOfBirth VARCHAR(50),ADD COLUMN Gender VARCHAR(20),ADD COLUMN Email VARCHAR(100),
-- ADD COLUMN Modifiedenrolledon VARCHAR(100),ADD COLUMN EnrolledStorecode VARCHAR(100),
-- ADD COLUMN AvailablePoints FLOAT,ADD COLUMN anniversaryDate VARCHAR(50);  
  
  ALTER TABLE dummy.thebelgianwaffle_SingleView_till_25thSept MODIFY COLUMN FirstName VARCHAR(200);
  

UPDATE dummy.thebelgianwaffle_SingleView_till_25thSept a JOIN (
SELECT DISTINCT mobile,FirstName,
LastName,
DateOfBirth,
Gender,
a.Email,
Modifiedenrolledon,
a.EnrolledStorecode,
a.AvailablePoints,
a.anniversarydate
FROM member_report a 
WHERE modifiedenrolledon<='2025-09-25'
)b USING(mobile)
SET a.FirstName=b.FirstName,a.LastName=b.LastName,
a.DateOfBirth=b.DateOfBirth,a.Gender=b.Gender,
a.Email=b.Email,a.Modifiedenrolledon=b.Modifiedenrolledon,
a.EnrolledStorecode=b.EnrolledStorecode,a.AvailablePoints=b.AvailablePoints,
a.anniversaryDate=b.anniversaryDate;#1406823
-- WHERE customertype IS NULL;


-- ALTER TABLE dummy.thebelgianwaffle_SingleView_till_25thSept ADD COLUMN Sales FLOAT,ADD COLUMN Bills VARCHAR(200),ADD COLUMN Visit VARCHAR(200),
-- ADD COLUMN pointscollected FLOAT,ADD COLUMN Point_Spent FLOAT,ADD COLUMN First_Txn_Date VARCHAR(200),
-- ADD COLUMN Last_Txn_date VARCHAR(200);


UPDATE dummy.thebelgianwaffle_SingleView_till_25thSept a JOIN (
SELECT mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,COUNT(DISTINCT mobile,txndate)visit,
SUM(pointscollected)pointscollected,SUM(pointsspent)pts_spent,MIN(txndate)first_txn_date,MAX(txndate)last_txn_date
FROM txn_report_accrual_redemption
WHERE txndate<='2025-09-25'
AND storecode <> 'demo'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
GROUP BY 1)b USING(mobile)
SET a.sales=b.sales,
a.Sales=b.Sales,a.Bills=b.Bills,
a.Visit=b.Visit,a.pointscollected=b.pointscollected,
a.Point_Spent=b.pts_spent,a.First_Txn_Date=b.First_Txn_Date,
a.Last_Txn_date=b.Last_Txn_date;#332877
-- WHERE customertype IS NULL;

-- ALTER TABLE dummy.thebelgianwaffle_SingleView_till_25thSept ADD COLUMN CustomerType VARCHAR(50);

UPDATE dummy.thebelgianwaffle_SingleView_till_25thSept a JOIN(
SELECT mobile,modifiedenrolledon,First_Txn_Date, 
	CASE 
		WHEN (modifiedenrolledon IS NOT NULL AND First_Txn_Date IS NOT NULL) THEN 'Enrolled & Transacted'
		WHEN (modifiedenrolledon IS NOT NULL AND First_Txn_Date IS NULL) THEN 'Enrolled Only'
		WHEN (modifiedenrolledon IS NULL AND First_Txn_Date IS NOT NULL) THEN 'Transacted Only'
		END AS `Tag`
FROM dummy.thebelgianwaffle_SingleView_till_25thSept)b USING(mobile)
SET a.CustomerType=b.Tag;#1406852
-- WHERE customertype IS NULL;

SELECT customertype,COUNT(DISTINCT mobile) FROM dummy.thebelgianwaffle_SingleView_till_25thSept
GROUP BY 1;

SELECT mobile,COUNT(mobile) FROM dummy.thebelgianwaffle_SingleView_till_25thSept
GROUP BY 1;

SELECT*FROM  dummy.thebelgianwaffle_SingleView_till_25thSept