

-- REVENUE IMPACT QUESTIONS

Select * from healthcare_fraud_detection

-- 1. What is our current fraud rate and how much total revenue is at risk from fraudulent claims?

Select
	Round(Sum(Claim_Amount), 0) as Total_Revenue_at_Risk,
		Count(Is_Fraud) as Total_Fraudulent_Claims
			from healthcare_fraud_detection
				where Is_Fraud = 1

-- 2. How much money are we losing monthly to fraud versus how much is being successfully collected?

Select 
    YEAR(Claim_Submission_date) as Years,
    MONTH(Claim_Submission_date) as Months,
    DATENAME(MONTH, Claim_Submission_Date) AS Month_Name,
    Count(*) as Total_Claims,
    ROUND(SUM(CASE WHEN Claim_Status = 'Approved'
                then Claim_Amount
                Else 0 END), 2) as Amount_Collected,
    ROUND(SUM(Case when Claim_Status = 'Rejected'
                then Claim_Amount 
                else 0 END), 2) as Amount_Rejected,
    ROUND(SUM(Case when Is_Fraud = '1'
                then Claim_Amount
                else 0 END), 2) as Fradulent_Amount,
    COUNT(Case when Is_Fraud = 1
                then 1 END) as Total_Fradulent_Claims
from healthcare_fraud_detection
Group by YEAR(Claim_Submission_Date),
         MONTH(Claim_Submission_Date),
         DATENAME(MONTH, Claim_Submission_Date) 
Order by YEAR(Claim_Submission_Date),
         MONTH(Claim_Submission_Date),
         DATENAME(MONTH, Claim_Submission_Date) 


-- 3. What is the financial gap between what we bill and what we actually collect — and how much of
-- that gap is attributable to fraud specifically?
 
select 
ROUND(SUM(Claim_Amount), 0) as Total_Amount_Claimed,
ROUND(SUM(Approved_Amount), 0) as Total_Amount_Approved,
ROUND(SUM(Claim_Amount) - SUM(Approved_Amount),0) as Financial_Gap,
ROUND(SUM(
          Case 
            when Is_Fraud = 1 then Claim_Amount
            else 0
          end
          ), 0
          )AS Fradulent_Claims,
ROUND(SUM(
          Case 
            when Is_Fraud = 1
            then Approved_Amount
            else 0
          end
          ), 0
          )AS Fradulent_Collection,
ROUND(SUM(
          Case 
            when Is_Fraud = 1
            then Claim_Amount - Approved_Amount
            else 0
          end
          ), 0
          )AS Fradulent_Gap
from healthcare_fraud_detection  


-- 4. If we could reduce our fraud rate by just 0.25%
-- how much additional revenue would that recover annually for our lab clients?

Select 
ROUND(SUM(Claim_Amount), 0) AS Total_Fraudulent_Claim,
ROUND(SUM(Approved_Amount), 0) AS Total_Fraudulent_Approvals,
ROUND(SUM(Claim_Amount) - SUM(Approved_Amount), 0)  AS Total_Financial_Gap,
ROUND(SUM(Claim_Amount) - SUM(Approved_Amount), 0)/4  as Financial_Recovery_By_Forth_Percent
From healthcare_fraud_detection
where Is_Fraud = 1

-- Insurance and Payer Questions:

-- 5. Which insurance type has the highest fraud rate
--  and should be prioritized for enhanced scrutiny?

Select Insurance_Type,
       Count(Insurance_Type) as [Total Insurance by Frauds]
from healthcare_fraud_detection
where Is_Fraud = 1
Group by Insurance_Type
Order by [Total Insurance by Frauds] desc

-- 6. Are our fraud losses concentrated in specific
--    providers or distributed evenly across all Providers?

select  
        Provider_ID, 
        COUNT(Provider_ID) as Fradulent_Claims_By_Providers
from healthcare_fraud_detection
where Is_Fraud = 1
Group by Provider_ID
Order by Fradulent_Claims_By_Providers desc

--  7. Which insurance type generates the highest average
--   fraudulent claim amount — meaning where is the highest value fraud occurring?

SELECT 
    Insurance_Type,
    ROUND(AVG(Claim_Amount), 2) AS Avg_Fraudulent_Claim_Amount
FROM healthcare_fraud_detection
WHERE Is_Fraud = 1
GROUP BY Insurance_Type
ORDER BY Avg_Fraudulent_Claim_Amount DESC;

-- Provider Questions:

-- 8. Which provider specialties are most associated
-- with fraudulent claims and need compliance review?

Select 
    Provider_Specialty,
    Count(Provider_Specialty) as Fraud_by_Providers,
    SUM(Claim_Amount) as Total_Amount_Claimed
from healthcare_fraud_detection
where Is_Fraud = 1
Group by Provider_Specialty
Order by Fraud_by_Providers desc

-- 9. Which specific providers have committed fraud three or more times — our repeat offender list
-- for investigation prioritization?

select  
        Provider_ID, 
        COUNT(Provider_ID) as Fradulent_Claims_By_Providers,
        ROUND(SUM(Claim_Amount),0) as Total_Claimed_Amount
from healthcare_fraud_detection
where Is_Fraud = 1
Group by Provider_ID
Having COUNT(Provider_ID) > 3
Order by Fradulent_Claims_By_Providers desc


-- 10. Do high volume providers have lower or higher
-- fraud rates than low volume providers?

with CTE1 as ( select 
Provider_ID, 
Count(Provider_ID) as Providers_by_Volume
from healthcare_fraud_detection
Group by Provider_ID
),

CTE2 as 
(select 
Provider_ID, 
Count(Provider_ID) as [Provider in Fraud]
from healthcare_fraud_detection
where Is_Fraud = 1
Group by Provider_ID
)

select CTE1.Provider_ID, 
       CTE1.Providers_by_Volume, 
       CTE2.[Provider in Fraud]
from CTE1 left join CTE2
on CTE1.Provider_ID = CTE2.Provider_ID
where [Provider in Fraud] > 3
Order by Providers_by_Volume desc


-- Patient and Clinical Questions:

-- 11. Which patient age groups are most frequently
-- associated with fraudulent claims?

select Is_Fraud,
Case when Patient_Age <= 20 then 'Under_20'
     when Patient_Age > 20 AND Patient_Age <= 40 then 'Patients between 21-40'
     when Patient_Age > 40 AND Patient_Age <= 60 then 'Patients between 41-60'
     when Patient_Age > 60 AND Patient_Age <= 90 then 'Patients between 61-90'
     else 'Aged Patients'
end as 'Fraud Rate by Age Groups',
Count(Is_Fraud) as Total_Fraud_Cases
from healthcare_fraud_detection 
where Is_Fraud = 1
Group by 
Is_Fraud,
Case when Patient_Age <= 20 then 'Under_20'
     when Patient_Age > 20 AND Patient_Age <= 40 then 'Patients between 21-40'
     when Patient_Age > 40 AND Patient_Age <= 60 then 'Patients between 41-60'
     when Patient_Age > 60 AND Patient_Age <= 90 then 'Patients between 61-90'
     else 'Aged Patients'
end 
Order by [Fraud Rate by Age Groups] desc


-- 12. Do patients with chronic conditions appear
-- in fraud cases at a higher rate than healthy patients?

select Chronic_Condition_Flag, 
Case
    when Chronic_Condition_Flag = 1 then COUNT(Chronic_Condition_Flag) as 'Chronic Patients in Frauds', 
    when Chronic_Condition_Flag = 0 then COUNT(Chronic_Condition_Flag) as 'Healthy Patients in Frauds'
else 0
end as 'Frauds by patient conditions'
from healthcare_fraud_detection
where Is_Fraud = 1

--
select 
    COUNT(Case when Chronic_Condition_Flag = 1 then 1 end) as 'Fraud_by_Chronic_Patients',
    COUNT(Case when Chronic_Condition_Flag = 0 then 1 end) as 'Fraud_by_Healthy_Patients'
from healthcare_fraud_detection
where Is_Fraud = 1


-- 13. Does the type of visit — inpatient, outpatient,
-- or emergency — predict fraud likelihood?

Select Visit_Type,
    Count(Visit_Type) as Total_Frauds_by_Visit_Types
from healthcare_fraud_detection
where Is_Fraud = 1
Group by Visit_Type


-- Geographic Questions:

-- 14. Which states have the highest fraud case concentration
-- and should be targeted for geographic audit reviews?

Select Patient_State,
       Count(Patient_State) as Fraud_by_State
from healthcare_fraud_detection
where Is_Fraud = 1
Group by Patient_State
Order by Fraud_by_State desc

-- 15. Are there states where fraud amount per case is
-- significantly higher than the national average?

with Above_Average_Claims as (
select 
    Patient_State,
    Claim_Amount,
    AVG(Claim_Amount) over () as Average_Claim_Amount
from healthcare_fraud_detection
where Is_Fraud = 1
)
Select 
    Patient_State,
    Claim_Amount, 
    ROUND(Average_Claim_Amount,0) as Average_Claim
from Above_Average_Claims
where Claim_Amount > Average_Claim_Amount
Order by Claim_Amount desc

-- Operational Questions:

-- 16. Does late claim submission predict fraud — are claims submitted after 30 days more likely to be fraudulent?

Select 
Days_Between_Service_and_Claim,
Case 
     when Days_Between_Service_and_Claim = 0 then 'A'
     when Days_Between_Service_and_Claim = 1 then 'B'
     when Days_Between_Service_and_Claim = 2 then 'C'
     when Days_Between_Service_and_Claim = 3 then 'D'
     when Days_Between_Service_and_Claim = 4 then 'E'
     when Days_Between_Service_and_Claim = 5 then 'F'
     when Days_Between_Service_and_Claim = 6 then 'J'
end as Classification_by_Days,
COUNT(Days_Between_Service_and_Claim) as Total_Fraudulent_Claims_by_Category
from healthcare_fraud_detection
where Is_Fraud = 1
Group by Days_Between_Service_and_Claim
Order by Classification_by_Days

-- 17. What is the profile of a typical fraudulent claim
-- in terms of amount, submission timing, and patient characteristics?

Select 
    Patient_Age,
    Patient_Gender,
    Patient_State,
    Chronic_Condition_Flag,
    Claim_Amount,
    Approved_Amount,
    Days_Between_Service_and_Claim
from healthcare_fraud_detection
where Is_Fraud = 1


-- 18. Which diagnosis and procedure code combinations
-- appear most frequently in fraudulent claims?

with Diagnosis as (
                   select Diagnosis_Code,Provider_Specialty,
                   COUNT(Diagnosis_Code) as Fraudulent_Diagnosis
                   from healthcare_fraud_detection
                   where Is_Fraud = 1
                   Group by Diagnosis_Code, Provider_Specialty
),
Fraudulent_Procedures as (
                   select Procedure_Code, Provider_Specialty,
                   COUNT(Procedure_Code) as Fradulent_Treatments
                   from healthcare_fraud_detection
                   where Is_Fraud = 1
                   Group by Procedure_Code, Provider_Specialty)
select 
    Diagnosis.Provider_Specialty, 
    Diagnosis.Diagnosis_Code, 
    Diagnosis.Fraudulent_Diagnosis,
    Fraudulent_Procedures.Procedure_Code, 
    Fraudulent_Procedures.Fradulent_Treatments
from Diagnosis full join Fraudulent_Procedures 
on Diagnosis.Provider_Specialty = Fraudulent_Procedures.Provider_Specialty
order by Fradulent_Treatments Desc
                    






















