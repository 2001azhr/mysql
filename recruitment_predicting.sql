-- Because the gender indicator only includes '1' and '0', I changed the data to 'female' and 'male'--
alter table recruitment2
modify column gender varchar (10);
update recruitment2
set gender = 'female'
where gender = '1';
update recruitment2
set gender = 'male'
where gender = '0';
select distinct gender from recruitment2; -- dan berhasil menampilkan data 'female' 'male'

-- Because the education level indicator only includes '1', '2', '3' and '4', I changed the data to text form' --
select distinct educationlevel from recruitment;
alter table recruitment2
modify column educationlevel varchar (20);
update recruitment2
set educationlevel = 'Bachelor Type 1'
where educationlevel = '1';
update recruitment2
set educationlevel = 'Bachelor Type 2'
where educationlevel = '2';
update recruitment2
set educationlevel = 'Master'
where educationlevel = '3';
update recruitment2
set educationlevel = 'Phd'
where educationlevel = '4';

-- Invalid data removed because some applicant work have previous companies, but the experience years is 0 --
delete from recruitment2
where experienceyears = 0;

-- GENERAL QUESTIONS --
-- 1. the relationship between age and hiring decisions
SELECT Age, AVG(HiringDecision) AS AvgHiringDecision
FROM recruitment2
GROUP BY Age;
-- 2. Are there differences in HiringDecision based on candidate gender?
select gender, count(*) as count, avg(hiringdecision) as AvgHiringDecision
from recruitment2
group by gender;
-- 3. How does the distribution of hiring decisions differ between different education levels?
select educationlevel, count(*) as count, avg(hiringdecision) as AvgHiringDecision
from recruitment2
group by educationlevel;
-- 4. Does ExperienceYears or number of PreviousCompanies influence hiring decisions?
select experienceyears, previouscompanies, avg(hiringdecision) as AvgHiringDecision
from recruitment2
group by experienceyears, previouscompanies;
-- 5. How do InterviewScore, SkillScore, and PersonalityScore relate to HiringDecision?
SELECT InterviewScore, SkillScore, PersonalityScore, AVG(HiringDecision) AS AvgHiringDecision
FROM recruitment2
GROUP BY InterviewScore, SkillScore, PersonalityScore;
-- 6. Is there a relationship between DistanceFromCompany and hiring decisions?
SELECT DistanceFromCompany, AVG(HiringDecision) AS AvgHiringDecision
FROM recruitment2
GROUP BY DistanceFromCompany;