-- SQL Retail Sales Project 

--change the db 
use sql_project_p1;

-- imported table directly from excel .
select top(10)* from retail_sales 

--count the total number of rows in the dataset .
select count(*) from retail_sales;

--DATA CLEANING 

select * from retail_sales where age is null;
-- we get 10 records where age is missing .

-- to check for all columns 
select * from retail_sales where 
      sale_date is null
	  or 
	  sale_time is null
	  or 
	  customer_id is null
	  or
	  gender is null
	  or
	  age is null
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
	 ;

	-- deleting our null values 

	delete from retail_sales 
	where 
	sale_date is null
	  or 
	  sale_time is null
	  or 
	  customer_id is null
	  or
	  gender is null
	  or
	  age is null
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
	 ;

-- DATA EXPLORATION 
	-- how many sales we have in total ?
	select count(*) from retail_sales;
    -- 1987 total records ,i.e 13 null values deleted .

	--how many unique customers do we have ?
	select count(distinct customer_id)  from retail_sales;  
	-- we have a total of 155 unique customers 

	-- how many unique category do we have 
	select count(distinct category) from retail_sales ;
	-- we have 3 unique categories in our dataset .

--DATA ANALYSIS


   --Retrive all columns for the sales made on '2022-11-05'
   select count(*) from retail_sales where sale_date = '2022-11-05';
   -- we have a total of 11 entries for the sales made on the said date . 

	--Retrive all transactions where category is clothing & the quantity sold is more than 2 in the month of Nov 2022.
	select * from retail_sales where category = 'clothing' 
	AND (quantiy >= 2) 
	AND CONVERT(varchar,sale_date,120) = '2022-11-22' 
	;

	--Calculate the total sale for each category 
	select category ,SUM(total_sale) as net_sales  from retail_sales group by category;
         
    --Find average age of customers who purchases items from the beauty category .
	select AVG(age) as average_age from retail_sales where category='beauty'; 
	-- average age is 40 .
	
	--find all transactions where total sale > 1000
	select count(transactions_id) as transactions from retail_sales where total_sale > 1000; 


	--find the total number of transactions made by each gender in each category 
	  select category,gender,count(transactions_id) as transactions from retail_sales  group by category,gender;


	  -- find out the average sale for each month , find out the best selling month in each year . 
	  -- use of CTE and rank function . 
	  -- mostly asked in interviews 
	 
	 select 
	  years,
	  months,
	  average_sale
	  from 
	  (
	  select
	  year(sale_date) as years,
	  month(sale_date) as months,
	  AVG(total_sale) as average_sale,
	  rank() over (partition by year(sale_date) order by AVG(total_sale) desc) as rank 
	  from retail_sales 
	  group by year(sale_date) , month(sale_date)
	  ) as t1 where rank = 1;
	 
	 --find top 5 customers based on highest total sales 
	 select top(5) customer_id , sum(total_sale) as total_sales from retail_sales group by customer_id order by sum(total_sale) desc;
	  
	  --find number of unique customers who purchased items from each category.
	  select count(distinct(customer_id)) as customers ,category from retail_sales group by category;

	  -- create shift and number of orders (Morning <=12  Afternoon Between 12 & 17 Evening > 17)

	  with hourly_sale as
	   (
	   select * ,
	      CASE 
	      WHEN Datepart(hour , sale_time) < 12 then 'Morning'
	      when DatePart(hour , sale_time) between 12 and 17 then 'Afternooon'
	      else 'Evening'
	   end as shifts
	  from retail_sales)
   select shifts ,count(*) as total_orders from hourly_sale group by shifts;

   -- end of project . 
