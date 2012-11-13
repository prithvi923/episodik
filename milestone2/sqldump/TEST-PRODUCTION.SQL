-- Find all tv show names that are of genre: "drama". --
SELECT distinct name FROM tvshow, genres WHERE genre = 'Drama' AND tvshow.show_id=genres.show_id; 

-- Finds all tv show names given a rating that has an average of at least 4. Sorts the output by rating (The highest rated show is listed first)--
SELECT name, Avg_rating from (SELECT name, tvshow.show_id, AVG(rating) AS Avg_rating FROM tvshow, history WHERE tvshow.show_id=history.show_id GROUP BY show_id) AS joined WHERE Avg_rating>4 ORDER BY Avg_rating DESC;

-- Finds the top 3 rated tv shows (If there are more than 2 tv shows with the same rating then it will display all shows with that rating)--
set @rownum :=0;
SELECT name, Avg_rating, rank FROM (SELECT name, Avg_rating, @rownum := @rownum +1 AS rank
FROM (SELECT name, AVG (rating) Avg_rating FROM tvshow, history WHERE tvshow.show_id=history.show_id GROUP BY tvshow.show_id ORDER BY Avg_rating DESC) AS temp) AS final where rank <=3;

-- Returns the number of tv shows that have more than 1 season for each year.  --
SELECT COUNT(name) AS Num_of_TVshows,year FROM tvshow WHERE seasons>1 GROUP BY year ORDER BY year DESC;

-- Updates the database when the user changes the rating of a show to a 5.--
UPDATE history SET rating= 5 WHERE show_id =1 AND user_id=1;

-- Find all tv show names that are of genre: "drama". --                                                                  
SELECT distinct name FROM tvshow, genres WHERE genre = 'Drama' AND tvshow.show_id=genres.show_id;
