select * from smartphones

-- Average Price across different Brands
select brand_name, avg(price) Avg_Prices from smartphones group by brand_name order by Avg_Prices desc;

-- Highest-rated smartphones across different brands
select brand_name, model, rating from smartphones where rating = 
(select max(rating) from smartphones sub where sub.brand_name = smartphones.brand_name);

-- The price to performance ratio for each smartphone and identify the best value for money
select brand_name, model, price, rating, (price/rating) as PriceperRating from smartphones 
where rating is not null and price is not null order by PriceperRating;

-- Percentage of smartphones that support 5G and how this varies by brand
select brand_name, (count(case when has_5g = 1 then 1 end) * 100/count(*)) as percentage from smartphones group by brand_name;

-- Smartphones with a price below the average price of all smartphones
select brand_name, model, price, rating from smartphones where price < (select avg(price) from smartphones) order by price desc;

-- The percentage of smartphones that have NFC, IR blaster, and extended memory availability by brand
select brand_name,
       (count(case when has_nfc = 1 then 1 end) * 100 / count(*)) as nfc_percentage,
       (count(case when has_ir_blaster = 1 then 1 end) * 100 / count(*)) as ir_blaster_percentage,
       (count(case when extended_memory_available = 1 then 1 end) * 100 / count(*)) as extended_memory_percentage
from smartphones
group by brand_name;

-- A stored procedure that takes a brand name as input and returns the models
create procedure GetSmartphoneModelsByBrand @BrandName varchar(20)
as begin
select brand_name, model, price, rating from smartphones where brand_name = @BrandName order by rating desc;
end;

exec GetSmartphoneModelsByBrand 'Samsung';

-- CTE to calculate the average rating of smartphones in each price range 
with PriceRangeCTE as (
    select brand_name, rating,
    case
        when price < 20000 then 'Low Budget'
        when price between 20000 and 32000 then 'Mid Range'
        when price > 32000 then 'Flagships'
    end as PriceCategory from smartphones
)
select PriceCategory, avg(rating) as AvgPrice from PriceRangeCTE group by PriceCategory order by 
    case 
        when PriceCategory = 'Flagships' then 1
        when PriceCategory = 'Mid Range' then 2
        when PriceCategory = 'Low Budget' then 3
    end;

-- A stored procedure that takes multiple parameters and returns the filtered list of smartphones
create procedure FilterSmartphones 
@BrandName varchar(20),
@MinPrice int,
@MaxPrice int,
@Rating int 
as begin
select brand_name, model, price, rating from smartphones where 
brand_name = @BrandName and
price <= @MaxPrice and
price >= @MinPrice and
rating >= @Rating 
order by price, rating desc;
end;

exec FilterSmartphones 'xiaomi', 40000, 50000, 80;



