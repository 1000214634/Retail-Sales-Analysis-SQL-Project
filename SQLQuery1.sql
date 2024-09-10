--Sql Retail Sales Analysis
select *
from [ Retail_ Sales ]


select count(*)
from [ Retail_ Sales ]

--Data Cleaning
select *
from [ Retail_ Sales ]

where 
      transactions_id is null
	  or
	  sale_date is null
	  or
	  sale_time is null
	  or
	  customer_id is null
	  or
	  gender is null
      or
	  category is null
	  or
	  quantiy is null
	  or
	  price_per_unit is null
	  or 
	  cogs is null
	  or
	  total_sale is null
     
--
Delete from [ Retail_ Sales ]
where
        transactions_id is null
	  or
	  sale_date is null
	  or
	  sale_time is null
	  or
	  customer_id is null
	  or
	  gender is null
      or
	  category is null
	  or
	  quantiy is null
	  or
	  price_per_unit is null
	  or 
	  cogs is null
	  or
	  total_sale is null

--Data Exploration

--How many sales we have
select count(*)FROM [ Retail_ Sales ] AS Total_Sales

--How many unique customers we have
select count(distinct customer_id)from [ Retail_ Sales ] as total_customers

select distinct category from [ Retail_ Sales ]


--Data Analysis & Business Key Proplems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
--method 1
select *
from [ Retail_ Sales ]
where sale_date='2022-11-05'

--method 2
select *
from [ Retail_ Sales ]
where sale_date LIKE '2022-11-05'

--method 3
select *
from [ Retail_ Sales ]
where convert(date,sale_date)='2022-11-05'

--or
select *
from [ Retail_ Sales ]
where cast(sale_date as date)='2022-11-05'

----------------------------------------------------------------------------------------------------------------------------------------------------



-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022.
--Category: You need to filter the transactions where the product category is 'Clothing'.
--Quantity Sold: The quantity of the items sold must be greater than 4.
--Month and Year: You need to filter transactions that occurred in November 2022.

--METHOD 1
select *
from [ Retail_ Sales ]
where 
      category='Clothing'
	  and
	  quantiy>4
	  and 
	  month(sale_date)=11
	  and 
	  year(sale_date)=2022

--METHOD 2(using datepart function)
select *
from [ Retail_ Sales ]
where 
      category='Clothing'
	  and
	  quantiy>4
	  and 
	  DATEPART(month,sale_date)=11
	  and
	  datepart(year,sale_date)=2022


--Method 3(Using FORMAT or LIKE (if sale_date is a string))
select *
from [ Retail_ Sales ]
where 
      category='Clothing'
	  and
	  quantiy>4
	  and
	  sale_date like '11/2022%'

--------------------------------------------------------------------------------------------------------------------------------------------

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
--method 1 (Pivoting)

select category,sum(total_sale)as total_sales
from [ Retail_ Sales ]
group by category
order by category desc

--method 2(Using Subqueries)

select category,total_sales 
from
  ( select
          category,sum(total_sale)as total_sales
		  from [ Retail_ Sales ]
		  group by category)
as subquery


--method 3 Using CTE (Common Table Expression)
with categorysales as ( 
         
		select category,sum(total_sale)as total_sales
		from [ Retail_ Sales ]
		group by category
		
)
select category,total_sales
from categorysales

--method 4(Using ROLLUP for Aggregation)
select 
     category,sum(total_sale)as total_sales
	 from [ Retail_ Sales ]
group by rollup(category)

--ROLLUP provides subtotals and a grand total in addition to the regular groupings.

--method 5(Using Window Functions)
SELECT category,
       total_sale,
       SUM(total_sale) OVER (PARTITION BY category) AS total_sales
FROM [ Retail_ Sales ]
--If you want to calculate total sales within each category and also include other rows for reference, you can use a window function

-------------------------------------------------------------------------------------------------------------------------------------

---- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select 

      avg(age)as average_age
from [ Retail_ Sales ]
where category='Beauty'


------------------------------------------------------------------------------------------------------------
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select *
from [ Retail_ Sales ]
where total_sale>1000


----------------------------------------------------------------------------------------------------
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
--method 1
select category,gender ,count(*)as number_of_transactions
from [ Retail_ Sales ]
group by category,gender


SELECT gender, category, COUNT(transactions_id) AS total_transactions
FROM [ Retail_ Sales ]
GROUP BY gender, category;


--method 2 ( Using Common Table Expressions (CTEs))
with transactioncounts as (
        select category,gender,count(transactions_id) as total_transactions
		from [ Retail_ Sales ]
		group by category,gender

)
select category,gender,total_transactions
from transactioncounts


--method 3(Using Subqueries)
select category ,gender,total_transactions
from 
 (select category,gender,count(transactions_id) as total_transactions
		from [ Retail_ Sales ]
		group by category,gender
)as transactioncounts


--method 4 (Using Pivot Table)

SELECT *
FROM (
    SELECT gender, category, transactions_id
    FROM [ Retail_ Sales ]
) AS SourceTable

PIVOT (
    COUNT(transactions_id)
    FOR gender IN ([Male], [Female])
) AS PivotTable;

--method 5 (Using Window Functions)
select gender,category,count(transactions_id) over(partition by gender,category)as total_transactions
from [ Retail_ Sales ]
group by gender,category



--method 6(Using Conditional Aggregation)
--If you want to split the results by gender into separate columns, you can use conditional aggregation.

SELECT category,
       COUNT(CASE WHEN gender = 'Male' THEN transactions_id END) AS male_transactions,
       COUNT(CASE WHEN gender = 'Female' THEN transactions_id END) AS female_transactions
FROM [ Retail_ Sales ]
GROUP BY category;

-------------------------------------------------------------------------------------------------------------------------
--Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

--the Average Sale for Each Month

select  month(sale_date) as month,
             year(sale_date)as year,
             avg(total_sale) as avg_monthly_sales,
			 rank()over(partition by year(sale_date)order by avg(total_sale)desc)as rank
from [ Retail_ Sales ]
group by month(sale_date),year(sale_date)



--the best selling month in each year
select 
        year,
		month,
		avg_monthly_sales
from
(
select  month(sale_date) as month,
             year(sale_date)as year,
             avg(total_sale) as avg_monthly_sales,
			 rank()over(partition by year(sale_date)order by avg(total_sale)desc)as rank
from [ Retail_ Sales ]
group by month(sale_date),year(sale_date)

)as t1
where rank=1

--order by 2,3 desc


--Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select top 5 customer_id,
      sum(total_sale)as total_sales
from [ Retail_ Sales ]
group by customer_id
order by 2 desc


---- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category,count(distinct(customer_id))as number_of_unique_customers
from [ Retail_ Sales ]
group by category
order by 2 desc


--Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

with hourly_sale as
(

select *,
        case 
		    when datepart(Hour,sale_time)<12 then 'Morning'
			when datepart(Hour,sale_time)between 12 and  17 then 'Afternoon'
			else 'Evening'

		end as time_of_day

from [ Retail_ Sales ]

)
select 
time_of_day,
count(*) as number_of_orders
from hourly_sale
group by time_of_day