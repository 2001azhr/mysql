-- IMPLEMENTING HIRING SYSTEM INTO MYSQL, criteria: min. bachelor, 1 year experience, and willing to alocate--
-- create new table--
CREATE TABLE `recruitment` (
  `Age` int DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `educationlevel` varchar(20) DEFAULT NULL,
  `ExperienceYears` int DEFAULT NULL,
  `PreviousCompanies` int DEFAULT NULL,
  `DistanceFromCompany` double DEFAULT NULL,
  `InterviewScore` int DEFAULT NULL,
  `SkillScore` int DEFAULT NULL,
  `PersonalityScore` int DEFAULT NULL,
  `RecruitmentStrategy` int DEFAULT NULL,
  `HiringDecision` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Cleansing dan Manipulating Data --
alter table recruitment
modify column gender varchar (10);
update recruitment
set gender = 'female'
where gender = '1';
update recruitment
set gender = 'male'
where gender = '0';
select distinct gender from recruitment;

select distinct educationlevel from recruitment;
alter table recruitment
modify column educationlevel varchar (20);
update recruitment
set educationlevel = 'Bachelor Type 1'
where educationlevel = '1';
update recruitment
set educationlevel = 'Bachelor Type 2'
where educationlevel = '2';
update recruitment
set educationlevel = 'Master'
where educationlevel = '3';
update recruitment
set educationlevel = 'Phd'
where educationlevel = '4';
delete from recruitment
where experienceyears = 0;

-- Skill Score & Personality Score Selection --
select personalityscore, skillscore, (select avg(personalityscore) from recruitment) as avg_personality,
(select avg(SkillScore) from recruitment) as avg_skillscore from recruitment
where personalityscore > (select avg(personalityscore) from recruitment) and
skillscore > (select avg(SkillScore) from recruitment);

select personalityscore, skillscore, (select avg(personalityscore) from recruitment) as avg_personality,
(select avg(SkillScore) from recruitment) as avg_skillscore from recruitment
where personalityscore < (select avg(personalityscore) from recruitment) and
skillscore < (select avg(SkillScore) from recruitment);

CREATE TEMPORARY TABLE temp_recruitment AS
SELECT *
FROM recruitment
WHERE skillscore < (SELECT AVG(skillscore) FROM recruitment)
  AND personalityscore < (SELECT AVG(personalityscore) FROM recruitment);
  
UPDATE recruitment r
JOIN temp_recruitment t
ON r.skillscore = t.skillscore
   AND r.personalityscore = t.personalityscore and
   r.age = t.age and r.gender = t.gender and r.educationlevel = t.educationlevel and
r.ExperienceYears = t.ExperienceYears and
r.PreviousCompanies = t.PreviousCompanies and 
r.DistanceFromCompany = t.DistanceFromCompany and   
r.interviewScore = t.interviewScore and
r.RecruitmentStrategy = t.RecruitmentStrategy and
r.HiringDecision = t.HiringDecision 
SET r.hiringdecision = '0';

drop temporary table temp_recruitment;

SELECT *
FROM recruitment
WHERE skillscore > (SELECT AVG(skillscore) FROM recruitment)
  AND personalityscore > (SELECT AVG(personalityscore) FROM recruitment)
and hiringdecision = '1';

CREATE TEMPORARY TABLE temp_recruitment AS
SELECT *
FROM recruitment
WHERE skillscore > (SELECT AVG(skillscore) FROM recruitment)
  AND personalityscore > (SELECT AVG(personalityscore) FROM recruitment);
  
  UPDATE recruitment r
JOIN temp_recruitment t
ON r.skillscore = t.skillscore
   AND r.personalityscore = t.personalityscore and
   r.age = t.age and r.gender = t.gender and r.educationlevel = t.educationlevel and
r.ExperienceYears = t.ExperienceYears and
r.PreviousCompanies = t.PreviousCompanies and 
r.DistanceFromCompany = t.DistanceFromCompany and   
r.interviewScore = t.interviewScore and
r.RecruitmentStrategy = t.RecruitmentStrategy and
r.HiringDecision = t.HiringDecision 
SET r.hiringdecision = '1';

drop temporary table temp_recruitment;

select * from recruitment
where hiringdecision = '1'
order by skillscore asc; -- to check the score if it does not comply with the assessment requirements

WITH avg_skillscore AS (
    SELECT AVG(skillscore) AS avg_skill
    FROM recruitment
)
UPDATE recruitment
SET hiringdecision = '0'
WHERE skillscore < (SELECT avg_skill FROM avg_skillscore);

select * from recruitment
where hiringdecision = '1'
order by personalityscore asc; -- to check the score if it does not comply with the assessment requirements

WITH avg_personality AS (
    SELECT AVG(personalityscore) AS avg_persona
    FROM recruitment
)
UPDATE recruitment
SET hiringdecision = '0'
WHERE personalityscore < (SELECT avg_persona FROM avg_personality);

SELECT CAST(AVG(personalityscore) AS UNSIGNED) AS avg_personality, cast(avg(skillscore) as unsigned) as avg_skillscore
FROM recruitment; 

-- Interview Selection -- 
select * from recruitment;
select count(hiringdecision) from recruitment
group by hiringdecision; -- ada 339 terpilih

select interviewscore, (select avg(interviewscore) from recruitment) as avg_interview from recruitment
where interviewscore > (select avg(interviewscore) from recruitment) and
hiringdecision = '1';

select interviewscore, (select avg(interviewscore) from recruitment) as avg_interview from recruitment
where interviewscore < (select avg(interviewscore) from recruitment) and
hiringdecision = '0';

WITH avg_interview AS (
    SELECT AVG(interviewscore) AS avg_int_score
    FROM recruitment
)
UPDATE recruitment
SET hiringdecision = '0'
WHERE interviewscore < (SELECT avg_int_score FROM avg_interview);

WITH avg_interview AS (
    SELECT AVG(interviewscore) AS avg_int_score
    FROM recruitment
)
UPDATE recruitment
SET hiringdecision = '1'
WHERE interviewscore > (SELECT avg_int_score FROM avg_interview);

CREATE TEMPORARY TABLE temp_recruitment AS
SELECT *
FROM recruitment
WHERE skillscore > (SELECT AVG(skillscore) FROM recruitment)
  AND personalityscore > (SELECT AVG(personalityscore) FROM recruitment) and
  interviewscore > (SELECT avg(interviewscore) FROM recruitment); 

UPDATE recruitment r
JOIN temp_recruitment t
ON r.skillscore = t.skillscore
   AND r.personalityscore = t.personalityscore and
   r.age = t.age and r.gender = t.gender and r.educationlevel = t.educationlevel and
r.ExperienceYears = t.ExperienceYears and
r.PreviousCompanies = t.PreviousCompanies and 
r.DistanceFromCompany = t.DistanceFromCompany and   
r.interviewScore = t.interviewScore and
r.RecruitmentStrategy = t.RecruitmentStrategy and
r.HiringDecision = t.HiringDecision 
SET r.hiringdecision = '1';

drop temporary table temp_recruitment;

select skillscore, interviewscore, personalityscore, (SELECT AVG(skillscore) FROM recruitment), 
(SELECT AVG(personalityscore) FROM recruitment),
(select avg(interviewscore) from recruitment) as avg_interview from recruitment
where skillscore > (SELECT AVG(skillscore) FROM recruitment)
  AND personalityscore > (SELECT AVG(personalityscore) FROM recruitment) and
interviewscore > (select avg(interviewscore) from recruitment) and
hiringdecision = '1';

SELECT HiringDecision, COUNT(hiringdecision) AS count
FROM recruitment
GROUP BY hiringdecision;

select * from recruitment
where hiringdecision = '1'
order by skillscore, personalityscore, interviewscore asc; -- There is 153 applicant being accepted by HR
