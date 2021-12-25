
/*
Creating the table and loading the dataset
*/
DROP TABLE IF EXISTS ratings;
CREATE TABLE ratings (userid INT, temp1 VARCHAR(10),  movieid INT , temp3 VARCHAR(10),  rating REAL, temp5 VARCHAR(10), timestamp INT);
COPY ratings FROM 'test_data1.txt' DELIMITER ':';
ALTER TABLE ratings DROP COLUMN temp1, DROP COLUMN temp3, DROP COLUMN temp5, DROP COLUMN timestamp;

-- Do not change the above code except the path to the dataset.
-- make sure to change the path back to default provided path before you submit it.

-- Part A
/* Write the queries for Part A*/

select * from ratings where rating<2;   -- Low rated Movies

select * from ratings where rating between 2 and 4; -- Medium rated Movies

select * from ratings where rating between 4 and 5; -- High rated Movies

select * from ratings where rating=5;   -- Top/Highest rated Movies

select * from ratings where rating between 0 and 4; -- Low to medium rated Movies


-- Part B
/* Create the fragmentations for Part B1 */

DROP TABLE IF EXISTS f1;
create table f1 as select * from ratings where rating<3;

DROP TABLE IF EXISTS f2;
create table f2 as select * from ratings where rating<=4 and rating>=2;

DROP TABLE IF EXISTS f3;
create table f3 as select * from ratings where rating>=2;


/* Write reconstruction query/queries for Part B1 */

select * from f1 union select * from f2 union select * from f3;


/* Write your explanation as a comment */

/* 
The horizontal fragments 'f1', 'f2' and 'f3' all have overlapping data which does not satisfy the 'disjointness' property of fragments.
The records with '2 <= rating < 3' (rating greater than or equal to 2 and less than 3) are available in all three fragments and are therefore duplicated.
Also, the fragments f2 and f3 have the records with '3<= rating <= 4' (rating greater than or equal to 3 and less than or equal to 4) duplicated in addition to the former overlap leading to a total overlap of '2 <= rating <= 4' between f2 and f3.

No data points are lost and all the data points are available in atleast one of the fragments thereby satisfying the completeness property of fragments.

The original relation 'ratings', can be reconstructed from the fragments using a single relational expression - by simply combining all three fragments with the Union operation, thereby satisfying reconstruction.
*/

/* Create the fragmentations for Part B2 */

DROP TABLE IF EXISTS f1;
create table f1 as select userid from ratings;

DROP TABLE IF EXISTS f2;
create table f2 as select movieid from ratings;

DROP TABLE IF EXISTS f3;
create table f3 as select rating from ratings;


/* Write your explanation as a comment */

/*
The vertical fragments 'f1', 'f2' and 'f3' all satisfy disjointness as there are no data points (columns) that are duplicated among any of the fragments. 

No data points are lost and all the data points are available in atleast one of the fragments thereby satisifying the completeness property of fragments.

However, reconstructing the original 'ratings' table is not possible since none of the vertical fragments have a common key attribute to be joined on.

*/

/* Create the fragmentations for Part B3 */

DROP TABLE IF EXISTS f1;
create table f1 as select * from ratings where rating<2;

DROP TABLE IF EXISTS f2;
create table f2 as select * from ratings where rating>=2 and rating<4;

DROP TABLE IF EXISTS f3;
create table f3 as select * from ratings where rating>=4;


/* Write reconstruction query/queries for Part B3 */

select * from f1 union select * from f2 union select * from f3;

/* Write your explanation as a comment */

/*
The horizontal fragments 'f1', 'f2' and 'f3' all satisfy disjointness since they are all exclusive and no data points are duplicated among any of the fragments. 

No data points are lost and all the data points are available in atleast one of the fragments thereby satisifying the completeness property of fragments.

The original relation can be reconstructed from the fragments by simply combining all three fragments with the Union operation, thereby satisfying the reconstruction property of fragments.
*/

-- Part C
/* Write the queries for Part C */

with reconstructed_ratings as (select * from f1 union select * from f2 union select * from f3) select * from reconstructed_ratings where rating<2;   -- Low rated Movies

with reconstructed_ratings as (select * from f1 union select * from f2 union select * from f3) select * from reconstructed_ratings where rating between 2 and 4; -- Medium rated Movies

with reconstructed_ratings as (select * from f1 union select * from f2 union select * from f3) select * from reconstructed_ratings where rating between 4 and 5; -- High rated Movies

with reconstructed_ratings as (select * from f1 union select * from f2 union select * from f3) select * from reconstructed_ratings where rating=5;   -- Top/Highest rated Movies

with reconstructed_ratings as (select * from f1 union select * from f2 union select * from f3) select * from reconstructed_ratings where rating between 0 and 4; -- Low to medium rated Movies