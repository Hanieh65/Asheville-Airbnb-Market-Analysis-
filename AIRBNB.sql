-- make a copy 
 CREATE TABLE listings_copy 
    SELECT *
    FROM listings;

select *
from  airbnb.listings;
-- duplicate_finding
select * 
FROM 
    (SELECT *, 
             ROW_NUMBER() OVER (PARTITION BY id,name,host_id,host_name,minimum_nights,number_of_reviews,
                                 last_review
                                 ORDER BY id) AS rn_number
	FROM listings) as listing_2
    WHERE rn_number >1;
    
-- NULL check 
SELECT *
FROM listings_copy
WHERE availability_365 IS NULL;

SELECT COUNT(*),
       COUNT(host_name) AS host_not_null,
       COUNT(neighbourhood) AS neighbourhood_not_null,
       COUNT(price) AS price_not_null,
       COUNT(availability_365) AS availability_365_not_null
FROM listings_copy;

--  most active host and neighbourhood by listing count 
SELECT host_id, host_name , calculated_host_listings_count
FROM listings_copy
GROUP BY host_id,host_name,calculated_host_listings_count
ORDER BY calculated_host_listings_count DESC
LIMIT 10;
-- 10  most popular host by number_of_reviews
SELECT host_name,SUM(number_of_reviews) AS total_review
FROM listings_copy
GROUP BY host_name
ORDER BY total_review DESC 
LIMIT 10;

-- MAX MIN AND AVG prices by host_name and room_type
SELECT host_name,room_type,
       AVG(price) AS avg_price,
       MAX(price) AS max_price,
       MIN(price) AS min_price
FROM listings_copy
WHERE price>0
GROUP BY host_name,room_type
ORDER BY MAX(price) DESC;

-- median 
WITH ordered_prices AS (
       SELECT 
       price,
       ROW_NUMBER() OVER(ORDER BY price) AS row_num,
       COUNT(*) OVER() AS total_rows
	FROM listings_copy
    WHERE price>0
    )
SELECT *,(total_rows/2) AS middle_price
FROM ordered_prices
WHERE row_num IN(
		FLOOR((total_rows +1)/2),
        FLOOR((total_rows+2)/2)
        );
-- popular room_type based on average price and neighbourhood 
SELECT room_type,avg(price) AS avg_price
        , neighbourhood,
        SUM(number_of_reviews) AS total_reviews,
        COUNT(*) AS total_listings,
        AVG(reviews_per_month) AS avg_review_per_month
FROM listings_copy
WHERE price>0
GROUP BY room_type, neighbourhood 
ORDER BY total_reviews DESC;

-- 
SELECT 
       AVG(price) AS avg_price,
       MAX(price) AS max_price,
       MIN(price) AS min_price
FROM listings_copy
WHERE price>0;

    
    


















