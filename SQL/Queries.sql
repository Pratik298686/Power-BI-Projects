create database projects_hr;

use projects_hr;

select * from hr;

-- data cleaning and preprocessing --

ALTER TABLE hr
CHANGE column ï»¿id emp_id varchar(20) NULL;

describe hr;

SET sql_safe_updates = 0;

update hr
set birthdate = case
	when birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'),'%Y-%m-%d')
    when birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'),'%Y-%m-%d')
    ELSE null
    END;
    
    ALTER TABLE hr
    MODIFY column birthdate date;
    
    -- change the data format and datatype of birth_date column
    update hr
set hire_date = case
	when hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'),'%Y-%m-%d')
    when hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'),'%Y-%m-%d')
    ELSE null
    END;
    
    alter table hr
    modify column hire_date date;
    
	-- change the data format and datatype of birth_date column
    update hr
    set termdate = date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'))
    where termdate is not null and termdate != '';
    
    update hr
    set termdate = null
    where termdate = '';
    
    -- create age column
ALTER TABLE hr    
    ADD column age INT;
    
    update hr
    SET age = timestampdiff(YEAR, birthdate,curdate())
    
    select min(age), max(age) from hr
    
    -- 1. what is the gender breakdown of employees in the company
    select * from hr
    
    select gender, count(*) as count
    from hr
    where termdate is null
    group by gender;
    
    -- 2. what is the race breakdown of employee in the company
    select race, COUNT(*) as count
    from hr
    where termdate is null
    group by race;
    
    -- 3. what is the age distribution of employees in the company
    select 
    case
    when age>=18 and age<=24 then '18-24'
    when age>=25 and age<=34 then '25-34'
    when age>=35 and age<=44 then '35-44'
    when age>=45 and age<=54 then '45-54'
    when age>=55 and age<=64 then '55-64'
    else '65+'
    end as age_group,
    count(*) as count
    from hr 
    where termdate is null
    group by age_group
    order by age_group;
    
-- 4. how many employeeswork at HQ vs remote
select location, count(*) as count
from hr
where termdate is null
group by location;

-- 5. what is the average length of employment who have been terminated
select round(year(termdate) - year(hire_date),0) as length_of_emp
from hr
where termdate is not null and termdate <= curdate()

-- 6. how does the gender distribution vary across dept and job title
select department, jobtitle,gender, count(*) as count
from hr
where termdate is not null
group by department, jobtitle, gender
order by department, jobtitle, gender;

select department,gender, count(*) as count
from hr
where termdate is not null
group by department,  gender
order by department,  gender;

-- 7. what is the distribution of jobtitle across the comapny
select jobtitle, count(*) as count
from hr
where termdate is null
group by jobtitle;

-- 8. which dept has the higher turnover/termination rate
select * from hr;
select department, count(*) as total_count,
	count( CASE 
			when termdate is not null and termdate <= curdate() then 1
            END) as terminated_count,
            ROUND( (count(CASE
            when termdate is not null and termdate <= curdate() then 1
            END)/count(*))*100,2) as termination_rate
            from hr
            group by department
            order by termination_rate DESC;
            
-- 8. what is the distribution of employees across location state

select location_state, COUNT(*) as count
from hr
where termdate is null
group by location_state

select location_city, COUNT(*) as count
from hr
where termdate is null
group by location_city

-- 10. how has the company employee count changed over time based on hire and termination date
select * from hr

select year,
	   hires,
       terminations,
       hires-terminations as net_change,
       (terminations/hires)*100 as change_percent
	from(
		select YEAR(hire_date) as year,
        COUNT(*) as hires,
        sum(CASE
			when termdate is not null and termdate <= curdate() then 1
           END) as terminations
           from hr
           group by YEAR(hire_date)) as subquery
group by year
order by year;

-- 11. what is tenure distribution for each department.
select department, round(avg(datediff(termdate, hire_date)/365),0) as avg_tenure
from hr
where termdate is not null and termdate < curdate()
group by department
order by department
    

