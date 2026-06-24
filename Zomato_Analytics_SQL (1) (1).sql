-- ZOMATO ANALYTICS (SQL) GROUP no.4-----

Create database Zomato_Analytics;
use zomato_analytics;
show tables;
select * from zomato_data;

-- Q1 ( country maping )
-- Joining the country table with the main table using the country_code
-- queries ----
select z.*,
c.country 
from zomato_data z
join country_table c 
on z.countrycode = c.country_code;

-- Q2 ( Calender Table )
-- Making Calender table having coumn ,year,month,quarter.....
-- to extract time related fields
-- Queries----------

create table Calender_Table as
select 
datekey_opening,
year(datekey_opening) as Year,
month(datekey_opening) as Month_No,
monthname(datekey_opening) as Month_Name,
concat(year(datekey_opening),'-',monthname(datekey_opening)) as yearmonth,
concat('Q',QUARTER(datekey_opening)) as Quarter,
dayofweek(datekey_opening) as Weekday,
dayname(datekey_opening) as Weekday_Name,
case
when month(datekey_opening)=4 then 'FM1'
when month(datekey_opening)=5 then 'FM2'
when month(datekey_opening)=6 then 'FM3'
when month(datekey_opening)=7 then 'FM4'
when month(datekey_opening)=8 then 'FM5'
when month(datekey_opening)=9 then 'FM6'
when month(datekey_opening)=10 then 'FM7'
when month(datekey_opening)=11 then 'FM8'
when month(datekey_opening)=12 then 'FM9'
when month(datekey_opening)=1 then 'FM10'
when month(datekey_opening)=2 then 'FM11'
when month(datekey_opening)=3 then 'FM12'
end as financial_Month
from zomato_Data;

select * from calender_table;

-- Q3---Number of Restaurants Based on City and Country....
-- how many restaurants exists in each city and country
-- concepts used -- group by and count() to aggregate the number of restaurants
-- Queries----
desc zomato_data;
desc country_table;
select 
c.country,
z.city,
count(RestaurantID) AS Total_Restaurants
from zomato_data z
join country_table c
on c.country_code = z.countrycode
group by c.country,z.city
order by Total_Restaurants desc;
------------------------------------------------------------------------------------------------------------------------------------------

-- Q4-- Restaurants Opening based on year / quarter / month
-- restaurants opening changed over time based on year,Quarter,Month_Nmae
-- Time series Analysis
-- Queries
SELECT 
YEAR(datekey_opening) AS Year,
QUARTER(datekey_opening) AS Quarter,
MONTH(datekey_opening) AS Month_No,
MONTHNAME(datekey_opening) AS Month_Name,
COUNT(RestaurantID) AS Total_Restaurants
FROM zomato_data
GROUP BY Year, Quarter, Month_No, Month_Name
ORDER BY Year, Quarter, Month_No;
select * from zomato_data;
select * from calender_table;
-----------------------------------------------------------------------------------------------------------------------------------------
-- Q5 -- Count of Restaurants Based on Average Ratings
-- no.of restaurants counted fall under each rating category
-- Queries---
select Rating,
	count(RestaurantID) as Total_Restaurants
    from Zomato_Data
    group by Rating
    order by Rating;
    -- most ratings are under 3-4
-------------------------------------------------------------------------------------------------------------------------------------------
-- Q6-- Create Price_Buckets----
-- categorize restaurants based on different price ranges
-- concept-- CASE statement
-- Queries----
 -- 1st---Adding Price_Buckets Column in the Zomato_data Table
 
 alter table Zomato_data
 add Price_Buckets varchar(20);
 desc zomato_data;
 
 -- 2nd---now updating the Price_Buckets Column
 
 update zomato_data
 set Price_Buckets=
 case
 when Average_cost_for_two<=200 then '0-200'
 when Average_cost_for_two<=400 then '200-400'
 when Average_cost_for_two<=600 then '400-600'
 when Average_cost_for_two<=800 then '600-800'
 when Average_cost_for_two<=1000 then '800-1000'
 when Average_cost_for_two<=1200 then '1000-1200'
 end;
 
 -- 3rd Now we are going to extract Total Restaurants Based on Pice_Buckets---
 
 select
 Price_Buckets,
 count(RestaurantID) AS Total_Restaurants
 from Zomato_Data
 group by Price_Buckets
 order by total_restaurants desc;
 -----------------------------------------------------------------------------------------------------------------------------------
-- Q7 -- Percentage of Restaurants Based on "Has Table Booking"
-- calculate the percentage of restaurants that has table booking
-- concept-- Percentage Calculation
-- Queries
SELECT 
Has_Table_booking,
COUNT(*) AS Total_Restaurants,
ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM zomato_data),2) AS Percentage
FROM zomato_data
GROUP BY Has_Table_booking;
------------------------------------------------------------------------------------------------------------------------------------------
-- Q8 Restaurants opened based on Year
-- Restaurants Offer online delivery services
SELECT 
Has_Online_delivery,
COUNT(RestaurantID) AS Total_Restaurants,
ROUND(COUNT(RestaurantID) * 100 / (SELECT COUNT(*) FROM zomato_data),2) AS Percentage
FROM zomato_data
GROUP BY Has_Online_delivery;
------------------------------------------------------------------------------------------------------------------------------------------
-- Q9-- Restaurants Based on Cuisines
-- Queries---
SELECT 
Cuisines,
COUNT(RestaurantID) AS Total_Restaurants
FROM zomato_data
GROUP BY Cuisines
ORDER BY Total_Restaurants DESC limit 5;

-- Restaurants Based on City---
SELECT 
City,
COUNT(RestaurantID) AS Total_Restaurants
FROM zomato_data
GROUP BY City
ORDER BY Total_Restaurants desc limit 10;

-- Restaurant Based on Rating---
SELECT 
Rating,
COUNT(RestaurantID) AS Total_Restaurants
FROM zomato_data
GROUP BY Rating
ORDER BY Rating;

-- End Of Project--------------------------------------------------------------------------------------------------------------------------




