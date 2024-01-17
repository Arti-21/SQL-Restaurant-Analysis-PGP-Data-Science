-- 1 
-- below query doent work BLOB/TEXT column ‘value’ used in key specification without a key length
ALTER TABLE restaurant.userprofile
ADD PRIMARY KEY (userID);
-- by modifying column datatype
USE restaurant;
CREATE TABLE userprofile_m LIKE userprofile;
INSERT INTO userprofile_m SELECT * FROM userprofile ;
SELECT * FROM userprofile_m;
ALTER TABLE userprofile_m
MODIFY COLUMN userID varchar(5); 
DESC userprofile_m;

-- 2
-- by modifying column datatype
USE restaurant;
CREATE TABLE rating_final_m LIKE rating_final;
INSERT INTO rating_final_m SELECT * FROM rating_final ;
SELECT * FROM rating_final_m;
ALTER TABLE rating_final_m
MODIFY COLUMN userID varchar(5); 
DESC rating_final_m;

-- 3
-- by modifying column datatype
USE restaurant;
CREATE TABLE userpayment_m LIKE userpayment;
INSERT INTO userpayment_m SELECT * FROM userpayment ;
SELECT * FROM userpayment_m;
ALTER TABLE userpayment_m
MODIFY COLUMN userID varchar(5); 
DESC userpayment_m;

-- 4
USE restaurant;
CREATE TABLE usercuisine_cleaned LIKE usercuisine;
INSERT INTO usercuisine_cleaned SELECT * FROM usercuisine ;
set sql_safe_updates = 0;

DELETE FROM usercuisine_cleaned WHERE userID not in (SELECT userID from userprofile_modified);
SELECT * FROM usercuisine_cleaned;

-- 5
ALTER TABLE usercuisine_cleaned
MODIFY COLUMN userID varchar(5); 
DESC usercuisine_cleaned;

-- 6
SELECT COUNT(*) as total_count FROM chefmozhours4 ;
SELECT DISTINCT * FROM chefmozhours4;
USE restaurant;
CREATE TABLE chefmozhours_cleaned LIKE chefmozhours4;
DESC chefmozhours_cleaned;
INSERT INTO chefmozhours_cleaned SELECT DISTINCT * FROM chefmozhours4;
SELECT COUNT(*) as total_count FROM chefmozhours_cleaned ;

-- below doesn't work as mysql doesn't allow updating the table that is already used in an inner select as the update criteria
USE restaurant;
CREATE TABLE chefmozhours_c LIKE chefmozhours4;
DESC chefmozhours_c;
INSERT INTO chefmozhours_c SELECT * FROM chefmozhours4;
SELECT COUNT(*) as total_count FROM chefmozhours_c ;