-- RDB&SQL Assignment-3

--Discount Effects

--Generate a report including product IDs and discount effects on whether the increase in the discount rate positively impacts the number of orders for the products.

--In this assignment, you are expected to generate a solution using SQL with a logical approach. 

WITH cte AS
(SELECT  product_id, discount,
        COUNT(order_id) AS orders,
        LAG(COUNT(order_id)) OVER (PARTITION BY product_id ORDER BY discount) AS first_orders,
        COALESCE((COUNT(order_id) - LAG(COUNT(order_id)) OVER (PARTITION BY product_id ORDER BY discount)),0) AS RateChange
    FROM sale.order_item 
    GROUP BY product_id, discount, list_price
    HAVING COUNT(product_id)>1)
SELECT cte.product_id, SUM(cte.RateChange) RateDifference,
    CASE 
    WHEN SUM(cte.RateChange) >= 0.05 THEN 'Positive'
    WHEN SUM(cte.RateChange) <= -0.05 THEN 'Nevative'
    ELSE 'Neutral'
  END AS DiscountEffect
FROM cte
GROUP BY cte.product_id;











