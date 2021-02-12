-- SQL Queries

-- Basic Queries ---------------------------------------------------------------------------

-- 1 Total number of unique diagnoses
select count(distinct DIAGNOSIS) from admissions;

-- 2 Total number of unique procedures
select count(distinct(ICD9_CODE)) from procedures_icd;

-- 3 Total number of unique drugs
select count(distinct DRUG) from prescriptions;

-- 4 Number of unique diagnoses for each patient.
select subject_id, count(distinct diagnosis) from admissions 
group by(subject_id);

-- 5 Number of unique procedures for each patients
Select subject_id, count(distinct SEQ_NUM) from procedures_icd
group by SUBJECT_ID;
    
-- 6 Number of unique drugs for each patient
Select subject_id, count(distinct Drug) from prescriptions
group by SUBJECT_ID;

-- 7 Number of patients for each diagnosis
select ICD9_Code, count(distinct subject_id) as Number_of_Patients from diagnoses_icd 
group by ICD9_code order by Number_of_Patients;

-- 8 Number of patients for each procedure
select ICD9_Code, count(distinct subject_id) as Number_of_Patients from procedures_icd 
group by ICD9_Code order by ICD9_Code;

-- 9 Number of patients for each drug type
select drug_type, count(distinct subject_id) as Number_of_Patients from prescriptions 
group by drug_type order by drug_type;

-- 10 Number of admissions for each patient.
select count(distinct (hadm_id)) as num_admit
from admissions
group by subject_id;

-- 11 
-- For each number x, report the number of patients who have been admitted x times 
select Num_admissions, Count(subject_ID) as Num_Patients
from (select count(HADM_ID) as Num_admissions, Subject_ID from admissions group by Subject_ID) as N
group by Num_admissions
order by Num_admissions;


-- Advanced Queries -----------------------------------------------------------------------------

-- 1
-- Create views for the following tables, i.e., diagnoses_icd/ prescriptions /procedures_icd, such that only patients 
-- with 5 or more admissions are preserved

-- view for table diagnoses_icd
Create view Diagnoses_icd2 as 
Select ROW_ID, SUBJECT_ID, HADM_ID, SEQ_NUM, ICD9_CODE from diagnoses_icd
where SUBJECT_ID in (Select subject_id as Admission_Count from admissions
group by SUBJECT_ID
having count(HADM_ID)>=5);


-- view for table prescriptions
Create view prescription2 as 
Select ROW_ID, SUBJECT_ID, HADM_ID, ICUSTAY_ID, STARTDATE, ENDDATE, DRUG_TYPE, DRUG, DRUG_NAME_POE, DRUG_NAME_GENERIC, FORMULARY_DRUG_CD,
GSN, NDC, PROD_STRENGTH, DOSE_VAL_RX, DOSE_UNIT_RX, FORM_VAL_DISP, FORM_UNIT_DISP, ROUTE from prescriptions
where SUBJECT_ID in (Select subject_id as Admission_Count from admissions
group by SUBJECT_ID
having count(HADM_ID)>=5);

-- view for table procedure_icd
Create view procedure_icd2 as 
Select ROW_ID, SUBJECT_ID, HADM_ID, SEQ_NUM, ICD9_CODE from procedures_icd
where SUBJECT_ID in (Select subject_id as Admission_Count from admissions
group by SUBJECT_ID
having count(HADM_ID)>=5);

-- 2
-- Create a temporary table T for diagnoses_icd, such that only the first three characters of the diagnosis code are preserved.
create Temporary table T 
select Row_ID, Subject_ID, HADM_ID, SEQ_NUM, LEFT(ICD9_Code, 3) as ICD9_Code
from diagnoses_ICD;

-- count the number of unique diagnoses in T 
select count(distinct ICD9_Code)
from T;

-- count the number of unique diagnoses for each patient in T
select Subject_ID, count(distinct ICD9_Code) as Num_Unique_Diagnoses
from T
group by Subject_ID;

-- 3 Repeat 2 entirely, except preserve the first three digitsin every diagnosis and save in a temporary table T1
create temporary table T1
select Row_ID, Subject_ID, HADM_ID, SEQ_NUM,
case
when ICD9_Code REGEXP '^[a-zA-Z]' then LEFT(ICD9_Code, 4)
else LEFT(ICD9_Code, 3)
end as ICD9_Code
from diagnoses_icd;

-- count the number of unique diagnoses in T 
select count(distinct ICD9_Code)
from T1;

-- count the number of unique diagnoses for each patient in T
select Subject_ID, count(distinct ICD9_Code) as Num_Unique_Diagnoses
from T1
group by Subject_ID;


-- Case Study -------------------------------------------------------------------------------------------------------

-- 1
-- Count patients diagnosed for each ICD-9 code.  Do not count a patient more than once for each ICD-9.
 Select ICD9_CODE, count(distinct SUBJECT_ID) as Total_No_of_patient from diagnoses_icd
 group by ICD9_CODE
 order by Total_No_of_patient desc;
 
 