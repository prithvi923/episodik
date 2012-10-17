/*
Lena Jia, Prithvi Prabahar, Tim Shih, and Bryan Yang
COMPSCI 316
October 18th, 2012
Milestone 1
*/

/*
SQL statements for creating and loading the database and its tables.
*/

DROP DATABASE testbase;
CREATE DATABASE testbase;
USE testbase;

CREATE TABLE user(
        user_id INT AUTO_INCREMENT NOT NULL,
        email VARCHAR(50) UNIQUE NOT NULL,
        password VARCHAR(32) NOT NULL,
        PRIMARY KEY (user_id)
)Engine = InnoDB;

CREATE TABLE tvshow(
        show_id INT AUTO_INCREMENT NOT NULL,
        name VARCHAR(100) NOT NULL,
        year INT NOT NULL,
        genre VARCHAR(100) NOT NULL,
        seasons INT NOT NULL,
        network VARCHAR(100) NOT NULL,
        episode_length INT NOT NULL,
        PRIMARY KEY (show_id),
        UNIQUE (name, year)
)Engine = InnoDB;

CREATE TABLE preferences(
        user_id INT NOT NULL,
        hot_sid INT NOT NULL,
        not_sid INT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES user(user_id),
        FOREIGN KEY (hot_sid) REFERENCES tvshow(show_id),
        FOREIGN KEY (not_sid) REFERENCES tvshow(show_id),
        PRIMARY KEY (user_id, hot_sid, not_sid)
)Engine = InnoDB;

CREATE TABLE history(
        user_id INT NOT NULL,
        show_id INT NOT NULL,
        rating INT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES user(user_id),
        FOREIGN KEY (show_id) REFERENCES tvshow(show_id),
        PRIMARY KEY (user_id, show_id)
)Engine = InnoDB;

CREATE TABLE recommendations(
        user_id INT NOT NULL,
        show_id INT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES user(user_id),
        FOREIGN KEY (show_id) REFERENCES tvshow(show_id),
        PRIMARY KEY (user_id, show_id)
)Engine = InnoDB;

-- Trigger to make sure both sid's don't match or combination doesn't already exist
delimiter |
CREATE TRIGGER check_show
BEFORE INSERT ON preferences
FOR EACH ROW BEGIN
IF NEW.hot_sid = NEW.not_sid OR EXISTS (SELECT * FROM preferences WHERE hot_sid = NEW.not_sid AND not_sid = NEW.hot_sid)THEN
signal sqlstate '45000' set message_text = 'The Hot show_id and the Not show_id are not a valid combination';
END IF;
END;
|
delimiter ;

-- Trigger to hash password
delimiter |
CREATE TRIGGER hash_password
BEFORE INSERT ON user
FOR EACH ROW BEGIN
SET NEW.password = MD5(NEW.password);
END;
|
delimiter ;

-- Trigger to check rating
delimiter |
CREATE TRIGGER check_rating
BEFORE INSERT ON history
FOR EACH ROW BEGIN
IF NEW.rating > 5 OR NEW.rating < 0 THEN
signal sqlstate '45000' set message_text = 'Invalid rating';
END IF;
END;
|
delimiter ;

/*
Populate database with sample data
*/
-- Populate user table with 5 users
INSERT INTO user (email, password)  VALUES
	('lena@duke.edu', 'lenapassword'),
	('prithvi@duke.edu', 'prithvipassword'),
	('tim@duke.edu', 'timpassword'),
	('bryan@duke.edu', 'bryanpassword'),
	('devil@duke.edu', 'devilpassword');

-- Populate tvshow table with 5 shows
INSERT INTO tvshow (name, year, genre, seasons, network, episode_length) VALUES
	('Lost', 2010, 'Drama', 7, 'ABC', 41),
	('Modern Family', 2012, 'Comedy', 3, 'ABC', 23),
	('Dexter', 2012, 'Mystery', 6, 'Showtime', 42),
	('White Collar', 2012, 'Drama', 4, 'USA', 41),
	('Breaking Bad', 2012, 'Drama', 6, 'AMC', 41),
        ('The Office', 2012, 'Comedy', 7, 'NBC', 22),
	('Survivor', 2012, 'Reality', 12, 'CBS', 43);

SELECT * FROM user;
SELECT * FROM tvshow;
