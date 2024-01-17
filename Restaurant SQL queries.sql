-- We need to find out the total visits to all restaurants under all alcohol categories available.

SELECT gp.placeID, COUNT(*) as Total_visits, gp.alcohol  
FROM restaurant.rating_final rf JOIN restaurant.geoplaces2 gp ON rf.placeID = gp.placeID 
GROUP BY gp.alcohol , gp.placeID ORDER BY placeID;

-- find out the average rating according to alcohol and price to understand the rating in respective price categories 

SELECT g.price as price_category, g.alcohol as alcohol_category, AVG(rf.rating) as avg_rating
FROM geoplaces2 g JOIN rating_final rf ON g.placeID = rf.placeID
GROUP BY g.price, g.alcohol
ORDER BY g.price, g.alcohol;

-- quantify what are the parking availability in different alcohol categories along with the total number of restaurants

SELECT
    g.alcohol AS alcohol_category,
    COUNT(DISTINCT g.placeID) AS total_restaurants,
    SUM(CASE WHEN c.parking_lot = 'none' THEN 0 ELSE 1 END) AS restaurants_with_parking
FROM
    Restaurant.geoplaces2 g
LEFT JOIN
    Restaurant.chefmozparking c
ON
    g.placeID = c.placeID
GROUP BY
    g.alcohol;


--


-- let’s take out the average rating of each state

SELECT gp.state, AVG(rf.rating) as Avg_rating  
FROM restaurant.rating_final rf JOIN restaurant.geoplaces2 gp ON rf.placeID = gp.placeID 
GROUP BY gp.state;

-- Tamaulipas' Is the lowest average rated state. Quantify the reason why it is the lowest rated 
-- by providing the summary on the basis of State, alcohol, and Cuisine

WITH StateAvgRating AS (
    SELECT
        g.state AS State,
        AVG(r.Rating) AS AvgRating
    FROM
        geoplaces2 g
    JOIN
        rating_final r ON g.placeID = r.placeID
    GROUP BY
        g.state
    HAVING
        g.state = 'Tamaulipas'
)
SELECT

    g.state,
    g.placeID,
    g.alcohol,
    c.Rcuisine AS Cuisine,
    AVG(r.Rating) AS AvgRating
FROM
    geoplaces2 g
JOIN
    rating_final r ON g.placeID= r.placeID
JOIN
    StateAvgRating sar ON g.state = sar.State
JOIN
    Chefmozcuisine c ON g.placeID = c.placeID
WHERE
    g.state = 'Tamaulipas'
GROUP BY
    g.state,
    g.alcohol,
    c.Rcuisine,
    g.placeID
ORDER BY 
    g.placeID;


-- Find the average weight, food rating, and service rating of the customers 
-- who have visited KFC and tried Mexican or Italian types of cuisine, and also their budget level is low

SELECT
    AVG(u.weight) AS avg_weight,
	AVG(rf.food_rating) AS avg_food_rating,
    AVG(rf.service_rating) AS avg_service_rating
 
FROM
    userprofile u, rating_final rf
WHERE
    u.userID IN (
        SELECT DISTINCT uc.userID
        FROM
            usercuisine uc
        WHERE
            uc.Rcuisine IN ('Mexican', 'Italian')
            AND uc.userID IN (
                SELECT DISTINCT f.userID
                FROM
                    rating_final f
                    JOIN geoplaces2 g ON f.placeID = g.placeID
                WHERE
                    g.name = 'KFC'
            )
    )
    AND u.budget = 'low';