-- $ psql < data.sql 
-- $ psql joins_exercise 

    -- NOTES (until line 99) 
    joins_exercise=# \dt
    --          List of relations
    --  Schema |   Name   | Type  | Owner 
    -- --------+----------+-------+-------
    --  public | owners   | table | dbae
    --  public | vehicles | table | dbae
    -- (2 rows)

    joins_exercise=# \d owners
    --                               Table "public.owners"
    --    Column   |  Type   | Collation | Nullable |              Default               
    -- ------------+---------+-----------+----------+------------------------------------
    --  id         | integer |           | not null | nextval('owners_id_seq'::regclass)
    --  first_name | text    |           |          | 
    --  last_name  | text    |           |          | 
    -- Indexes:
    --     "owners_pkey" PRIMARY KEY, btree (id)
    -- Referenced by:
    --     TABLE "vehicles" CONSTRAINT "vehicles_owner_id_fkey" FOREIGN KEY (owner_id) REFERENCES owners(id)

    joins_exercise=# \d vehicles
    --                              Table "public.vehicles"
    --   Column  |  Type   | Collation | Nullable |               Default                
    -- ----------+---------+-----------+----------+--------------------------------------
    --  id       | integer |           | not null | nextval('vehicles_id_seq'::regclass)
    --  make     | text    |           |          | 
    --  model    | text    |           |          | 
    --  year     | integer |           |          | 
    --  price    | real    |           |          | 
    --  owner_id | integer |           |          | 
    -- Indexes:
    --     "vehicles_pkey" PRIMARY KEY, btree (id)
    -- Foreign-key constraints:
    --     "vehicles_owner_id_fkey" FOREIGN KEY (owner_id) REFERENCES owners(id)

    joins_exercise=# SELECT * FROM owners
    --  id | first_name | last_name 
    -- ----+------------+-----------
    --   1 | Bob        | Hope
    --   2 | Jane       | Smith
    --   3 | Melody     | Jones
    --   4 | Sarah      | Palmer
    --   5 | Alex       | Miller
    --   6 | Shana      | Smith
    --   7 | Maya       | Malarkin
    -- (7 rows)

    joins_exercise=# SELECT * FROM vehicles;
    --  id |  make  |  model  | year |  price   | owner_id 
    -- ----+--------+---------+------+----------+----------
    --   1 | Toyota | Corolla | 2002 |  2999.99 |        1
    --   2 | Honda  | Civic   | 2012 | 12999.99 |        1
    --   3 | Nissan | Altima  | 2016 | 23999.99 |        2
    --   4 | Subaru | Legacy  | 2006 |  5999.99 |        2
    --   5 | Ford   | F150    | 2012 |  2599.99 |        3
    --   6 | GMC    | Yukon   | 2016 | 12999.99 |        3
    --   7 | GMC    | Yukon   | 2014 | 22999.99 |        4
    --   8 | Toyota | Avalon  | 2009 | 12999.99 |        4
    --   9 | Toyota | Camry   | 2013 | 12999.99 |        4
    --  10 | Honda  | Civic   | 2001 |  7999.99 |        5
    --  11 | Nissan | Altima  | 1999 |  1899.99 |        6
    --  12 | Lexus  | ES350   | 1998 |  1599.99 |        6
    --  13 | BMW    | 300     | 2012 | 22999.99 |        6
    --  14 | BMW    | 700     | 2015 | 52999.99 |        6
    -- (14 rows)

-- write your queries here

-- 1. Join the two tables so that every column and record appears, regardless of if there is not an owner_id. 

SELECT * 
FROM owners o 
FULL JOIN vehicles v 
ON o.id = v.owner_id; 

--  id | first_name | last_name | id |  make  |  model  | year |  price   | owner_id 
-- ----+------------+-----------+----+--------+---------+------+----------+----------
--   1 | Bob        | Hope      |  1 | Toyota | Corolla | 2002 |  2999.99 |        1
--   1 | Bob        | Hope      |  2 | Honda  | Civic   | 2012 | 12999.99 |        1
--   2 | Jane       | Smith     |  3 | Nissan | Altima  | 2016 | 23999.99 |        2
--   2 | Jane       | Smith     |  4 | Subaru | Legacy  | 2006 |  5999.99 |        2
--   3 | Melody     | Jones     |  5 | Ford   | F150    | 2012 |  2599.99 |        3
--   3 | Melody     | Jones     |  6 | GMC    | Yukon   | 2016 | 12999.99 |        3
--   4 | Sarah      | Palmer    |  7 | GMC    | Yukon   | 2014 | 22999.99 |        4
--   4 | Sarah      | Palmer    |  8 | Toyota | Avalon  | 2009 | 12999.99 |        4
--   4 | Sarah      | Palmer    |  9 | Toyota | Camry   | 2013 | 12999.99 |        4
--   5 | Alex       | Miller    | 10 | Honda  | Civic   | 2001 |  7999.99 |        5
--   6 | Shana      | Smith     | 11 | Nissan | Altima  | 1999 |  1899.99 |        6
--   6 | Shana      | Smith     | 12 | Lexus  | ES350   | 1998 |  1599.99 |        6
--   6 | Shana      | Smith     | 13 | BMW    | 300     | 2012 | 22999.99 |        6
--   6 | Shana      | Smith     | 14 | BMW    | 700     | 2015 | 52999.99 |        6
--   7 | Maya       | Malarkin  |    |        |         |      |          |         
-- (15 rows)

-- 2. Count the number of cars for each owner. Display the owners first_name, last_name and count of vehicles. The first_name should be ordered in ascending order. 

SELECT first_name, last_name, COUNT(owner_id)
FROM owners o 
JOIN vehicles v 
ON o.id = v.owner_id
GROUP BY (first_name, last_name)
ORDER BY first_name ASC; 

--  first_name | last_name | count 
-- ------------+-----------+-------
--  Alex       | Miller    |     1
--  Bob        | Hope      |     2
--  Jane       | Smith     |     2
--  Melody     | Jones     |     2
--  Sarah      | Palmer    |     3
--  Shana      | Smith     |     4
-- (6 rows)

-- 3. Count the number of cars for each owner and display the average price for each of the cars as integers. Display the owners first_name, last_name, average price and count of vehicles. The first_name should be ordered in descending order. Only display results with more than one vehicle and an average price greater than 10000. 

SELECT first_name, last_name, ROUND(AVG(price)) AS average_price, COUNT(owner_id)
FROM owners o 
JOIN vehicles v 
ON o.id = v.owner_id 
GROUP BY first_name, last_name 
HAVING COUNT(owner_id) > 1 AND ROUND(AVG(price)) > 10000 
ORDER BY first_name DESC; 

--  first_name | last_name | average_price | count 
-- ------------+-----------+---------------+-------
--  Shana      | Smith     |         19875 |     4
--  Sarah      | Palmer    |         16333 |     3
--  Jane       | Smith     |         15000 |     2
-- (3 rows)