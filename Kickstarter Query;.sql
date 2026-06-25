SELECT COUNT(*) FROM project_sheet;
create database kickstarter_db;
use kickstarter_db;
select count(*) from project_sheet;


-- Querys For the KPI

-- Total Projects
select count(*) as Total_Projects
from project_sheet;

-- Total Backers
select concat(round(sum(backers_count)/1000000,0),'M') as Total_backers
from project_sheet
where state='successful';

-- Total Amount Raised
select concat(round(sum(pledged_usd)/1000000000,1),"B") AS Total_Amount_Raised_Billion
from project_sheet
where state='successful';

-- Success Rate
select
concat(round(count(case when state='successful' then 1 end)*100.0/count(*),1),'%') AS Success_Rate
from project_sheet;

-- Average Successful Days
select concat(round(avg(project_duration),0),' Days') as Average_Successful_Days
from project_sheet 
where state = 'successful';

-- Projects by Outcome

select state,count(*) as total_projects,CONCAT(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM project_sheet), 2),'%') AS Percentage
from project_sheet
group by state
order by total_projects desc;

-- Projects by Location
select l.displayable_name as Location,count(*) as Total_projects from 
project_sheet p
join location l
on p.location_id = l.id
group by l.displayable_name
order by Total_projects desc
limit 10;

-- Projects Trend Over Time
select year(launch_date) as year,
month(launch_date) as month,
count(*) as Total_projects
from project_sheet
group by year(launch_date) , month(launch_date) 
order by year,month;

SELECT
    DATE_FORMAT(launch_date,'%Y-%m') AS Month_Year,
    COUNT(*) AS Total_Projects
FROM project_sheet
GROUP BY DATE_FORMAT(launch_date,'%Y-%m')
ORDER BY Month_Year;

-- Success Rate by Goal Range
SELECT
    goal_range,
    concat(ROUND(COUNT(CASE WHEN state='successful' THEN 1 END) * 100.0/ COUNT(*),2),'%') AS Success_Rate
FROM project_sheet
WHERE goal_range IN ('0-1K','1K-5K','5K-10K','10K-50K','50K+')
GROUP BY goal_range
ORDER BY
CASE goal_range
    WHEN '0-1K' THEN 1
    WHEN '1K-5K' THEN 2
    WHEN '5K-10K' THEN 3
    WHEN '10K-50K' THEN 4
    WHEN '50K+' THEN 5
END;

-- Top Projects by Backers

select name,backers_count
from project_sheet
where state = 'successful' 
order by backers_count desc
limit 10;

-- Top Projects by Amount Raised
select name,concat(round(pledged_usd/1000000,1),'M') as Amount_raised_million
from project_sheet
where state = 'successful' 
order by pledged_usd desc
limit 10;

-- Success % by Category
SELECT c.name AS Category,concat(ROUND(COUNT(CASE WHEN p.state='successful' THEN 1 END) * 100.0/ COUNT(*),2),"%") AS Success_Percentage
FROM project_sheet p
JOIN category c ON p.category_id = c.id
GROUP BY c.name
HAVING COUNT(*) >= 50
ORDER BY Success_Percentage DESC
LIMIT 10;
