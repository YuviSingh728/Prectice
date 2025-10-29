SELECT a.mobile,FirstName,LastName,DateOfBirth,Gender,a.Email,Modifiedenrolledon,a.EnrolledStorecode,
a.AvailablePoints,anniversaryDate,SUM(amount) AS Sales,COUNT(DISTINCT uniquebillno) AS Bills,
COUNT(DISTINCT txndate,b.mobile) AS Visit,SUM(pointscollected) AS pointscollected,
SUM(b.pointsspent) AS Point_Spent,MIN(txndate) AS First_Txn_Date,MAX(txndate) AS Last_Txn_date
FROM member_report a
JOIN txn_report_accrual_redemption b
ON a.mobile=b.mobile
WHERE txndate>='2025-09-15'
GROUP BY 1
LIMIT 10;

SELECT*FROM member_report
LIMIT 10;


SELECT DISTINCT mobile FROM member_report 
WHERE modifiedenrolledon<=




############Customer SingleView

CREATE TABLE dummy.mobile_1(
mobile INT PRIMARY KEY)


SELECT * FROM dummy.mobile_1;

ALTER TABLE dummy.mobile_1
MODIFY COLUMN mobile BIGINT;

INSERT INTO dummy.mobile_1
SELECT DISTINCT mobile FROM member_report 
WHERE modifiedenrolledon<='2025-09-18'
AND enrolledstorecode NOT LIKE 'demo';##1619177

INSERT INTO dummy.mobile_1(mobile)
SELECT DISTINCT mobile FROM txn_report_accrual_redemption 
WHERE txndate<='2025-09-18'
AND storecode NOT LIKE 'demo'
AND mobile NOT IN (SELECT DISTINCT mobile FROM dummy.mobile_1);##726


SELECT mobile, COUNT(mobile) FROM dummy.mobile_1
GROUP BY 1

ALTER TABLE dummy.Mobile_1 ADD INDEX mobile(mobile),ADD COLUMN Tag VARCHAR(50);


UPDATE dummy.Mobile_1 a JOIN (
SELECT DISTINCT mobile FROM member_report a JOIN txn_report_accrual_redemption b USING(mobile)
WHERE txndate <='2025-09-18'
AND storecode <> 'demo')b USING(mobile)
SET a.tag='Both_table';#1224612


SELECT COUNT(DISTINCT mobile) FROM dummy.Mobile_1
WHERE tag IS NULL;#395291

UPDATE dummy.Mobile_1 a JOIN (
SELECT DISTINCT mobile FROM member_report a 
WHERE modifiedenrolledon <='2025-09-18'
AND mobile NOT IN (SELECT DISTINCT mobile FROM txn_report_accrual_redemption
WHERE txndate <='2025-09-18'
AND storecode <> 'demo')
AND enrolledstorecode <> 'demo')b USING(mobile)
SET a.tag='ENT'
WHERE tag IS NULL;#394566

UPDATE dummy.Mobile_1 a JOIN (
SELECT DISTINCT mobile FROM txn_report_accrual_redemption
WHERE txndate <='2025-09-18'
AND storecode <> 'demo'
AND mobile NOT IN (SELECT DISTINCT mobile FROM member_report a 
WHERE modifiedenrolledon <='2025-09-18'
AND enrolledstorecode <> 'demo'))b USING(mobile)
SET a.tag='txn'
WHERE tag IS NULL;

SELECT tag,COUNT(DISTINCT mobile) FROM dummy.Mobile_1
GROUP BY 1;


ALTER TABLE dummy.Mobile_1 ADD COLUMN FirstName VARCHAR(100),ADD COLUMN LastName VARCHAR(100),
ADD COLUMN DateOfBirth VARCHAR(20),ADD COLUMN Gender VARCHAR(20),ADD COLUMN Email VARCHAR(100),
ADD COLUMN Modifiedenrolledon VARCHAR(50),ADD COLUMN EnrolledStorecode VARCHAR(20),
ADD COLUMN AvailablePoints FLOAT,ADD COLUMN anniversaryDate VARCHAR(50);



UPDATE dummy.Mobile_1 a JOIN (
SELECT DISTINCT mobile,FirstName,LastName,DateOfBirth,Gender,Email,Modifiedenrolledon,EnrolledStorecode,
AvailablePoints,anniversaryDate
FROM member_report 
WHERE modifiedenrolledon<='2025-09-18'
AND enrolledstorecode NOT LIKE '%demo%'
)b USING(mobile)
SET a.FirstName=b.FirstName,a.LastName=b.LastName,
a.DateOfBirth=b.DateOfBirth,a.Gender=b.Gender,
a.Email=b.Email,a.Modifiedenrolledon=b.Modifiedenrolledon,
a.EnrolledStorecode=b.EnrolledStorecode,a.AvailablePoints=b.AvailablePoints,
a.anniversaryDate=b.anniversaryDate
WHERE tag ='ENT';#394566



UPDATE dummy.Mobile_1 a JOIN (
SELECT DISTINCT mobile,FirstName,LastName,DateOfBirth,Gender,Email,Modifiedenrolledon,EnrolledStorecode,
AvailablePoints,anniversaryDate
FROM member_report 
WHERE modifiedenrolledon<='2025-09-18'
AND enrolledstorecode NOT LIKE '%demo%'
)b USING(mobile)
SET a.FirstName=b.FirstName,a.LastName=b.LastName,
a.DateOfBirth=b.DateOfBirth,a.Gender=b.Gender,
a.Email=b.Email,a.Modifiedenrolledon=b.Modifiedenrolledon,
a.EnrolledStorecode=b.EnrolledStorecode,a.AvailablePoints=b.AvailablePoints,
a.anniversaryDate=b.anniversaryDate
WHERE tag ='txn';#0

-- alter table dummy.Mobile_1 modify
-- column anniversaryDate varchar(50);


ALTER TABLE dummy.Mobile_1 ADD COLUMN Sales FLOAT,ADD COLUMN Bills INT,ADD COLUMN Visit INT,
ADD COLUMN pointscollected FLOAT,ADD COLUMN Point_Spent FLOAT,ADD COLUMN First_Txn_Date VARCHAR(50),
ADD COLUMN Last_Txn_date VARCHAR(50);

UPDATE dummy.Mobile_1 a JOIN(
SELECT 
mobile,
SUM(amount) AS Sales,COUNT(DISTINCT uniquebillno) AS Bills,
COUNT(DISTINCT txndate,b.mobile) AS Visit,SUM(pointscollected) AS pointscollected,
SUM(b.pointsspent) AS Point_Spent,MIN(txndate) AS First_Txn_Date,MAX(txndate) AS Last_Txn_date
FROM txn_report_accrual_redemption b
WHERE txndate>='2025-09-15'
AND storecode <> 'demo'
GROUP BY 1)b USING(mobile)
SET a.sales=b.sales,
a.Sales=b.Sales,a.Bills=b.Bills,
a.Visit=b.Visit,a.pointscollected=b.pointscollected,
a.Point_Spent=b.Point_Spent,a.First_Txn_Date=b.First_Txn_Date,
a.Last_Txn_date=b.Last_Txn_date
WHERE tag ='Both_table';##4102


UPDATE dummy.Mobile_1 a JOIN(
SELECT 
mobile,
SUM(amount) AS Sales,COUNT(DISTINCT uniquebillno) AS Bills,
COUNT(DISTINCT txndate,b.mobile) AS Visit,SUM(pointscollected) AS pointscollected,
SUM(b.pointsspent) AS Point_Spent,MIN(txndate) AS First_Txn_Date,MAX(txndate) AS Last_Txn_date
FROM txn_report_accrual_redemption b
WHERE txndate>='2025-09-15'
AND storecode <> 'demo'
GROUP BY 1)b USING(mobile)
SET a.sales=b.sales,
a.Sales=b.Sales,a.Bills=b.Bills,
a.Visit=b.Visit,a.pointscollected=b.pointscollected,
a.Point_Spent=b.Point_Spent,a.First_Txn_Date=b.First_Txn_Date,
a.Last_Txn_date=b.Last_Txn_date
WHERE tag ='ENT';##1

UPDATE dummy.Mobile_1 a JOIN(
SELECT 
mobile,
SUM(amount) AS Sales,COUNT(DISTINCT uniquebillno) AS Bills,
COUNT(DISTINCT txndate,b.mobile) AS Visit,SUM(pointscollected) AS pointscollected,
SUM(b.pointsspent) AS Point_Spent,MIN(txndate) AS First_Txn_Date,MAX(txndate) AS Last_Txn_date
FROM txn_report_accrual_redemption b
WHERE txndate>='2025-09-15'
AND storecode <> 'demo'
GROUP BY 1)b USING(mobile)
SET a.sales=b.sales,
a.Sales=b.Sales,a.Bills=b.Bills,
a.Visit=b.Visit,a.pointscollected=b.pointscollected,
a.Point_Spent=b.Point_Spent,a.First_Txn_Date=b.First_Txn_Date,
a.Last_Txn_date=b.Last_Txn_date
WHERE tag ='Txn';##O



CREATE TABLE dummy.thebelgianwaffle_SingleView(
Mobile VARCHAR(50),FirstName VARCHAR(100),LastName VARCHAR(100),DateOfBirth VARCHAR(100),Gender VARCHAR(20),
Email VARCHAR(100),Modifiedenrolledon VARCHAR(50),EnrolledStorecode VARCHAR(50),AvailablePoints FLOAT,
AvailablePoints FLOAT
)




INSERT INTO dummy.thebelgianwaffle_SingleView
SELECT DISTINCT mobile FROM member_report
WHERE modifiedenrolledon<='2025-09-18' 
UNION
SELECT DISTINCT mobile FROM txn_report_accrual_redemption
WHERE txndate<='2025-09-18'
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%';#1398235



ALTER TABLE dummy.thebelgianwaffle_SingleView ADD COLUMN FirstName VARCHAR(100),ADD COLUMN LastName VARCHAR(100),
ADD COLUMN DateOfBirth VARCHAR(50),ADD COLUMN Gender VARCHAR(20),ADD COLUMN Email VARCHAR(100),
ADD COLUMN Modifiedenrolledon VARCHAR(100),ADD COLUMN EnrolledStorecode VARCHAR(100),
ADD COLUMN AvailablePoints FLOAT,ADD COLUMN anniversaryDate VARCHAR(50);

ALTER TABLE dummy.thebelgianwaffle_SingleView ADD COLUMN CustomerType VARCHAR(50);

ALTER TABLE dummy.thebelgianwaffle_SingleView MODIFY
COLUMN FirstName VARCHAR(200)


UPDATE dummy.thebelgianwaffle_SingleView a JOIN (
SELECT DISTINCT mobile,FirstName,
LastName,
DateOfBirth,
Gender,
a.Email,
Modifiedenrolledon,
a.EnrolledStorecode,
a.AvailablePoints,
a.anniversarydate
-- SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,COUNT(DISTINCT b.mobile,txndate)visits,
-- SUM(pointscollected)pointscollected,SUM(b.pointsspent)pts_spent,MIN(txndate)first_txn_date,MAX(txndate)last_txn_date
 FROM member_report a 
-- JOIN txn_report_accrual_redemption b on c.mobile=b.mobile
WHERE modifiedenrolledon <='2025-09-18'
-- AND storecode <> 'demo'
-- AND billno NOT LIKE '%roll%'
-- AND billno NOT LIKE '%test%'
)b USING(mobile)
SET a.FirstName=b.FirstName,a.LastName=b.LastName,
a.DateOfBirth=b.DateOfBirth,a.Gender=b.Gender,
a.Email=b.Email,a.Modifiedenrolledon=b.Modifiedenrolledon,
a.EnrolledStorecode=b.EnrolledStorecode,a.AvailablePoints=b.AvailablePoints,
a.anniversaryDate=b.anniversaryDate;##1398206



ALTER TABLE dummy.thebelgianwaffle_SingleView ADD COLUMN Sales FLOAT,ADD COLUMN Bills VARCHAR(200),ADD COLUMN Visit VARCHAR(200),
ADD COLUMN pointscollected FLOAT,ADD COLUMN Point_Spent FLOAT,ADD COLUMN First_Txn_Date VARCHAR(200),
ADD COLUMN Last_Txn_date VARCHAR(200);



UPDATE dummy.thebelgianwaffle_SingleView a JOIN (
SELECT mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,COUNT(DISTINCT mobile,txndate)visit,
SUM(pointscollected)pointscollected,SUM(pointsspent)pts_spent,MIN(txndate)first_txn_date,MAX(txndate)last_txn_date
 FROM txn_report_accrual_redemption b
--  on c.mobile=b.mobile
WHERE txndate <='2025-09-18'
AND storecode <> 'demo'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
GROUP BY 1)b USING(mobile)
SET a.sales=b.sales,
a.Sales=b.Sales,a.Bills=b.Bills,
a.Visit=b.Visit,a.pointscollected=b.pointscollected,
a.Point_Spent=b.pts_spent,a.First_Txn_Date=b.First_Txn_Date,
a.Last_Txn_date=b.Last_Txn_date;#318908

ALTER TABLE dummy.thebelgianwaffle_SingleView DROP customertype;
ALTER TABLE dummy.thebelgianwaffle_SingleView ADD COLUMN CustomerType VARCHAR(50);

UPDATE dummy.thebelgianwaffle_SingleView a JOIN (
SELECT DISTINCT mobile
FROM member_report 
WHERE modifiedenrolledon<='2025-09-18'
AND mobile NOT IN(SELECT mobile FROM txn_report_accrual_redemption)
)b USING(mobile)
SET a.CustomerType='Only Enrolled'
WHERE CustomerType IS NULL;#1076183



UPDATE dummy.thebelgianwaffle_SingleView a JOIN (
SELECT DISTINCT mobile
FROM txn_report_accrual_redemption 
WHERE txndate<='2025-09-18'
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND mobile NOT IN(SELECT mobile FROM member_report)
)b USING(mobile)
SET a.CustomerType='Only Transacted'
WHERE CustomerType IS NULL;##1



UPDATE dummy.thebelgianwaffle_SingleView a JOIN (
SELECT DISTINCT a.mobile FROM member_report a
JOIN txn_report_accrual_redemption b
ON a.mobile=b.mobile
WHERE modifiedenrolledon<='2025-09-18'
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
)b USING(mobile)
SET a.CustomerType='Enroll & Txn'
WHERE CustomerType IS NULL;##321977



SELECT * FROM dummy.thebelgianwaffle_SingleView
LIMIT 1000;
WHERE mobile='6302117558'

6205311305,6235096851,6299011958,6302117558,6306224072,6304249718,6360080554

SELECT*FROM member_report
WHERE mobile='6299011958'

SELECT*FROM txn_report_accrual_redemption
WHERE mobile='6302117558'
AND frequencyc

