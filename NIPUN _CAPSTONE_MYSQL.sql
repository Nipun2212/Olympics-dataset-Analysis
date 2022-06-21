/* 
Que: Apply appropriate normalization techniques (upto 3 NF) to divide it into multiple tables.
Answer:
- The given dataset with 10 columns are not in 3NF normalized form.
- While creating sql datbase based on the following, the problems are-
	1. Data redundancy [Duplication of Record]
    2. Diffcult to perform various -insertion anomaly, update anomaly & deletion anomaly.

1NF Normalized form:    
- While inspecting the olympics master table, I found that the table is already in 1NF normalized from.
- Here the each column of the table contains atomic values. The table doesnot contains composite or multi-valued attribute.
  so we can conclude that the table is in 1 NF normalized form.

2NF Normalized form:
- The first condition in the 2nd NF is that the table has to be in 1st NF. 
- we have already establised earlier that the table is in 1NF normalized form.
- Also,The table also should not contain partial dependency to be in 2NF normalized form. 
- Here partial dependency means the proper subset of candidate key determines a non-prime attribute.
- In olympics master table, we can see that:
	1. Primary key is  composite of (name, country,date_given, sports) which together give non prime attributes (age,year,gold,silver,bronze,total medals)
    2. but here, there is partial dependency because part of primary key 'name' alone is giving non prime attribute age
    3. Also, there is partial dependency because part of primary key ('name','sports','year') alone is giving non prime attributes (gold,silver,bronze,total medals)
- so we can see that the table is not in 2NF.
- We have to convert olympics master table into 2NF by splitting into multiple tables to get rid of partial dependencies.

3rd Normal Form (3NF):
- The same rule applies as before i.e, the table has to be in 2NF before proceeding to 3NF. 
- As we have already establised earlier that the given olympics master table is not in 2NF, it automatically states that it doesnot follow 3NF.
- Also, there should be no transitive dependency for non-prime attributes. 
- That means non-prime attributes (which doesn’t form a candidate key) should not be dependent on other non-prime attributes in a given table. 
- So a transitive dependency is a functional dependency in which X → Z (X determines Z) indirectly, by virtue of X → Y and Y → Z
- Transitive dependency (gold,silver,bronze → total_medal) like 3 non prime attributes together giving  non prime attribute

For converting the table in 3NF:
- we have to create minimum 5 Tables or more
	1. Athlete
    2. Country
    3. Sports
    4. Event_year
    5. Medals

	Table Name	      Primary Key			Foreign Key
1. 	Athlete			- Ath_ID				None
2.	Country			- Country_ID 			None
3.	Sports			- Sports_ID				None	
4.	Event_year		- Event_ID				None
5.	Medals			- Ath_ID				Country_ID,Sports_ID,Event_ID

*/
Create database if not exists Olympics;		# Creating database with name "customer_churn"

use Olympics; 					# Selecting Database to work

# Create Table-1 Athlete
CREATE TABLE Athlete (
					Athlete_ID 	varchar(11) Primary Key,         
					name 		varchar(50), 
					age 		varchar(50)
                    );

# Create Table-2 Country
CREATE TABLE Country (
					Country_ID 		varchar(11) Primary Key,         
					Country_name 	varchar(50)
                    );
                    
# Create Table-3 Sports
CREATE TABLE Sports (
					Sports_ID 		varchar(11) Primary Key,         
					Sports_name 	varchar(50) 
                    );
	
# Create Table-4 Event_year
CREATE TABLE Event_year (
					Event_ID 	varchar(11) Primary Key,         
					year 		varchar(50),
                    Date_Given	varchar(50)
                    );

# Create Table-5 Medals
CREATE TABLE Medals (
					Athlete_ID 		varchar(11),
                    Country_ID 		varchar(11),
                    Sports_ID 		varchar(11),
                    Event_ID 		varchar(11),
					Gold_medal	 	integer, 
					Silver_medal 	integer,
					Bronze_medal 	integer, 
					FOREIGN KEY (Athlete_ID) REFERENCES Athlete(Athlete_ID),
                    FOREIGN KEY (Country_ID) REFERENCES Country(Country_ID),
                    FOREIGN KEY (Sports_ID) REFERENCES Sports(Sports_ID),
                    FOREIGN KEY (Event_ID) REFERENCES Event_year(Event_ID)
                    );

use Olympics;					# Selecting Database to work

-- Queries:

-- 1. Find the average number of medals won by each country

-- Answer: for geeting the average number of medals won by each country:
-- 		   We need to groupby country to get each country and select average function for getting average medals won by that country.
SELECT country ,AVG(total_medal) as 'Average Medals won' from `olympix_master_2` GROUP BY country;

-- 2. Display the countries and the number of gold medals they have won in decreasing order

-- Answer: we need to use sum function to get total gold medals and groupby on countries to get number of gold medals by that country.
-- 		   also we have to use orderby SUM(gold_medal) DESC to get number of gold medals in decreasing order.
SELECT country ,SUM(gold_medal) as 'Gold Medals won' from `olympix_master_2`
GROUP BY country
ORDER BY SUM(gold_medal) DESC;


-- 3. Display the list of people and the medals they have won in descending order, grouped by their country

-- Answer: we need to use sum function on all medals to get the total medals and groupby on country and name to get list of people and the medals they have won.
-- 		   also we have to use orderby SUM(total_medal) DESC to get medals they have won in descending order. 
SELECT name, country ,
SUM(gold_medal) as 'Gold Medals' ,
SUM(silver_medal) as 'Silver Medals',
SUM(brone_medal) as 'Bronze Medals',
SUM(total_medal) as 'Total Medals' from `olympix_master_2`
GROUP BY country, name
ORDER BY SUM(total_medal) desc;


-- 4. Display the list of people with the medals they have won according to their their age

-- Answer: we need to use sum function on all medals to get the total medals and groupby on name,age to get list of people and the medals they have won with age.
-- 		   also we have to use orderby age and sum(total_medal) DESC to get medals they have won in descending order of age. 
SELECT name, age ,
SUM(gold_medal) as 'Gold Medals' ,
SUM(silver_medal) as 'Silver Medals',
SUM(brone_medal) as 'Bronze Medals',
SUM(total_medal) as 'Total Medals' from `olympix_master_2`
GROUP BY name,age
ORDER BY age desc,SUM(total_medal) desc;

-- 5. Which country has won the most number of medals (cumulative)
-- Answer: for getting the country with maximum number of medals we have to group by country and select sum(total_medal) and 
-- then order by in decreasing order of sum(total_medal) and use limit 1 function to get country has won the most number of medals (cumulative)
select country, sum(total_medal) as max_medal from `olympix_master_2` 
group by country 
order by max_medal desc  limit 1;
