/*
Lena Jia, Prithvi Prabahar, Tim Shih, and Bryan Yang
COMPSCI 316
October 18th, 2012
Milestone 1
*/

/*
SQL statements for changing the tables and testing the constraints.
*/

-- User with existing email address tries to reregister, fails:
INSERT INTO user (email, password) VALUES
    ('devil@duke.edu', 'bluedevilpassword');

-- New user registering:
INSERT INTO user (email, password) VALUES
    ('bluedevil@duke.edu', 'bluedevilpassword');

-- After registration, bluedevil@duke.edu user makes a series of 10 comparisons between TV shows:
INSERT INTO preferences (user_id, hot_sid, not_sid) VALUES
    (9, 1, 7),
    (9, 3, 1),
    (9, 4, 3),
    (9, 5, 4),
    (9, 2, 5),
    (9, 2, 1),
    (9, 5, 1),
    (9, 5, 7),
    (9, 2, 4),
    (9, 2, 7);

-- Invalid preference queries fail:
INSERT INTO preferences (user_id, hot_sid, not_sid) VALUES
    (9, 1, 7); -- Already exists
INSERT INTO preferences (user_id, hot_sid, not_sid) VALUES
    (9, 7, 1); -- Combination already exists
INSERT INTO preferences (user_id, hot_sid, not_sid) VALUES
    (9, 1, 1); -- Both SID's cannot match
INSERT INTO preferences (user_id, hot_sid, not_sid) VALUES
    (6, 1, 1); -- References a user that does not exist
INSERT INTO preferences (user_id, hot_sid, not_sid) VALUES
    (null, 1, 1); -- Null field

-- Invalid TV show queries fail:
INSERT INTO tvshow (name, year, genre, seasons, network, episode_length) VALUES
    ('Lost', 2010, 'Drama', 7, 'ABC', 41); -- Already exists
INSERT INTO tvshow (name, year, genre, seasons, network, episode_length) VALUES
    (null, 2010, 'Drama', 7, 'ABC', 41); -- Null does not work

-- After selecting preferences, user can rate shows he has already seen:
INSERT INTO history (user_id, show_id, rating) VALUES
    (7, 2, 5),
    (7, 7, 0);

-- Invalid history queries fail
INSERT INTO history (user_id, show_id, rating) VALUES
    (7, 2, 6); -- Cannot have 6-star rating
INSERT INTO history (user_id, show_id, rating) VALUES
    (7, 8, 3); -- Cannot reference show_id that does not exist
INSERT INTO history (user_id, show_id, rating) VALUES
    (7, 2, null); -- Cannot have null field
INSERT INTO history (user_id, show_id, rating) VALUES
    (7, 2, 5); -- Already exists

-- Users can update only their password and ratings of tv shows at this time:
UPDATE user
SET password=MD5('newpassword')
WHERE user_id = 9 AND password=MD5('bluedevilpassword');

UPDATE history
SET rating = 3
WHERE user_id = 9 AND show_id = 7;

-- Create a recommendation for user 9 based on simple algorithm
INSERT INTO recommendations (user_id, show_id)
SELECT * FROM
    (SELECT 9, show_id
    FROM tvshow
    WHERE genre = 
        (SELECT genre FROM
            (SELECT * FROM 
            (SELECT hot_sid, COUNT(*) AS count FROM preferences 
            WHERE user_id = 9
            GROUP BY hot_sid) AS groups
            HAVING count = (SELECT MAX(count) FROM (SELECT hot_sid, COUNT(*) AS count FROM preferences 
            WHERE user_id = 9
            GROUP BY hot_sid) AS groups2)
            ) AS popular, tvshow
        WHERE popular.hot_sid = tvshow.show_id)
    ) AS raw
WHERE NOT EXISTS (SELECT * FROM history WHERE show_id = raw.show_id)
AND NOT EXISTS (SELECT * FROM preferences WHERE hot_sid = raw.show_id OR not_sid = raw.show_id);

SELECT * FROM user;
SELECT * FROM tvshow;
SELECT * FROM preferences;
SELECT * FROM history;
SELECT * FROM recommendations;

