Cyclistic Case Study - Bike Sharing Company
================
Octave Antoni

2022-05-11

-   [Introduction](#introduction)
-   [Ask](#1.ask)
-   [Prepare](#2.prepare)
-   [Process](#3.process)
-   [Analyze](#4.analyze)
-   [Share](#5.share)
-   [Act](#6.act)


# Introduction
Employed as a Data Analyst since February 2019 in the government,
I have decided to continue my education in order to develop my skills
in open-source and widely-used tools and languages such as SQL, R and Tableau. 

After completing the [Google Analytics Certificate](https://github.com/Faskill)
**NEEDS UPDATE**, this case study puts me in the shoes of a Junior Data Analyst
in charge of providing insights to a Bike Sharing Company about the difference
between 2 types of users : Annual members and casual riders.

Here are the deliverables that I have been tasked to produce :

-   A clear statement of the business task
-   A description of all data sources used
-   Documentation of any cleaning or manipulation of data
-   A summary of your analysis
-   Supporting visualizations and key findings
-   Your top three recommendations based on your analysis

This case study will follow the 6-step data analysis process defined in the 
Google Data Analytics Course :

-   [Ask](#1.ask)
-   [Prepare](#2.prepare)
-   [Process](#3.process)
-   [Analyze](#4.analyze)
-   [Share](#5.share)
-   [Act](#6-act)

Without further ado, let’s get started!

# 1. Ask

The main goal of this phase is to gather all the required information
in order to define a clear business task.

### What is the problem I am trying to solve?

Cyclistic has set in place a very flexible pricing plan including single-ride
passes, full-day passes and annual memberships.
Financial analysts at Cyclistic have concluded that annual members are 
much more profitable than casual riders. 
The director of marketing at Cyclistic believes that maximizing the number
of annual members will be the key to future growth.
The end goal is thus to convert casual riders into annual members.

The main problem I am trying to solve is that Cyclistic needs to understand
how to target the casual riders in order to convert them into annual members.

### How can my insights drive business decisions?

My insight will allow Cyclistic to better understand the habits and
characteristics of the different types of riders.
This will allow Cyclistic to use an efficient digital marketing strategy that 
will aimat influencing casual riders to become annual riders.

### Deliverable : Business Task

**Identify key differences between casual riders and annual members over the
last 12 months and provide insights on how these differences could be used to
increase the conversion rate of casual riders.**

# 2. Prepare

### Introducing the data

The dataset used for this case study is a "live" dataset (updated monthly) of 
trips for the Divvy bike sharing company. 
[Dataset link](https://divvy-tripdata.s3.amazonaws.com/index.html).

#### Dataset Licensing

The data is produced under the following license : 
(https://ride.divvybikes.com/data-license-agreement)[https://ride.divvybikes.com/data-license-agreement]

Contributors willing to use my work will have to comply to the aforementionned
license agreement.

#### Exploring the data

The dataset is composed of zip files containing csv files, with a separate 
folder for MacOS files. I am asked to study the last 12 months of data, and 
there is 1 zipfile per month. A download of the 2 most recent months highlights 
that **each month of data is composed of more than 300.000 rows of data**. 
I quickly estimate that the last 12 month of data will have more than 3 million 
records. Using a spreadsheet software will not be practical for that amount of 
data, so **I will focus in using SQL at this stage.** 

I will import those datasets in BigQuery in order to be able to run interactive 
SQL queries and merge all of these records. Here is a my dataset structure
after importing the 12 tables into BigQuery.

![Dataset structure](img/dataset.jpg)

Here is the schema of each table :

![Schema](img/dataset_schema.jpg)

A quick look at the first 10 rows of data shows that the dataset is dirty.
**None of the first 10 rows of the May 21 dataset is complete.**

```SQL
SELECT * 
FROM cyclistic.trips_05_21 
LIMIT 10
```

|ride_id         |rideable_type|started_at          |ended_at            |start_station_name|start_station_id|end_station_name   |end_station_id|start_lat|start_lng|end_lat           |end_lng            |member_casual|
|----------------|-------------|--------------------|--------------------|------------------|----------------|-------------------|--------------|---------|---------|------------------|-------------------|-------------|
|9EFE36756DF82484|electric_bike|2021-05-26T12:14:15Z|2021-05-26T13:03:21Z|                  |                |                   |              |42.0     |-87.7    |41.93             |-87.78             |casual       |
|073149554B9BB87E|electric_bike|2021-05-25T19:09:15Z|2021-05-25T19:24:12Z|                  |                |                   |              |42.0     |-87.67   |42.0              |-87.67             |casual       |
|F09359E7D380D079|electric_bike|2021-05-01T13:35:00Z|2021-05-01T13:58:24Z|                  |                |Clark St & Grace St|TA1307000127  |42.0     |-87.67   |41.950923666666668|-87.659176166666668|casual       |
|2BD0FC8AD3FF2BDD|electric_bike|2021-05-31T21:00:01Z|2021-05-31T21:06:27Z|                  |                |                   |              |42.0     |-87.66   |41.99             |-87.66             |casual       |
|1ED483D94EE5F058|electric_bike|2021-05-22T13:33:06Z|2021-05-22T13:46:12Z|                  |                |                   |              |42.0     |-87.69   |42.0              |-87.69             |casual       |
|D6B99ADAEDB28DC7|electric_bike|2021-05-14T16:21:00Z|2021-05-14T16:36:58Z|                  |                |                   |              |42.0     |-87.66   |42.0              |-87.69             |casual       |
|30BA8917905A05C4|electric_bike|2021-05-02T16:30:07Z|2021-05-02T16:42:53Z|                  |                |                   |              |42.0     |-87.67   |41.99             |-87.69             |casual       |
|057E55CBF19A5118|electric_bike|2021-05-02T15:53:37Z|2021-05-02T16:06:41Z|                  |                |                   |              |42.0     |-87.69   |42.0              |-87.67             |casual       |
|3970D38E8E45A6C4|electric_bike|2021-05-25T16:34:38Z|2021-05-25T17:10:02Z|                  |                |                   |              |42.0     |-87.71   |42.01             |-87.71             |casual       |
|22295616ED41F83B|electric_bike|2021-05-30T15:47:40Z|2021-05-30T15:58:49Z|                  |                |                   |              |42.0     |-87.69   |42.0              |-87.66             |casual       |

Thorough cleaning will be necessary! But first, let's merge the last 12 months 
of datasets.


### Merging the tables

Luckily, all of the 12 latest datasets (as of 11 MAY 2022, I will thus use all
data from MAY 2021 to APRIL 2022) have the same schema and column names. 
Merging them will be a piece of cake!

After adding the files to my Google Cloud Storage, I could just merge them
by using a URI request in the CREATE TABLE menu in BigQuery to select all the
csv files `cyclistic_data_set/*.csv`. But for the sake of showcasing my SQL 
skills, I will develop a SQL query to do the exact same thing. 

After looking into cursors to iterate over all tables in my Cyclistic dataset
(which is not compatible with BigQuery), I realize that it is possible to 
iterate over BigQuery tables using a wildcard operator. Here's the query to 
merge all of the 12 tables into a single dataset.

```SQL
CREATE TABLE IF NOT EXISTS cyclistic.trips
OPTIONS(
  description="Combined Cyclistic bike trip data from May 2021 to Avril 2022"
)
AS
  SELECT *
  FROM `cyclistic-case-study-349908.cyclistic.*`;
```

The complete dataset has **5757551 rows**. 


### Examining the data

#### Station information

Since we realized that a lot of station names were missing during our exploration
of the data, let's find out how many rows have incomplete station name OR id.
If we have either the station name or the station id, we will be able to
recuperate the lost data by matching the name or id with another row with the
same name or id.

```SQL
SELECT COUNT(*)
FROM cyclistic.trips
WHERE (start_station_name IS NULL AND start_station_id IS NULL)
      OR (end_station_name IS NULL AND end_station_id IS NULL);
```

After running the query, we have **1.141.802 rows** with no easily recuperable
station name or id. 

That being said, we can perhaps recuperate the lost data by matching the 
coordinates with an identified station at the same coordinates.
Let's verify this :

```SQL
SELECT *
FROM cyclistic.trips
WHERE (
      (start_station_name IS NULL AND start_station_id IS NULL) 
        AND (start_lat IS NOT NULL AND start_lng IS NOT NULL)
      )
      OR 
      (
      (end_station_name IS NULL AND end_station_id IS NULL) 
        AND (end_lat IS NOT NULL AND end_lng IS NOT NULL)
      );
```
We have **1.137.036** records where the station name AND id is absent but we
have full coordinates. That leaves us with only 4766 records with no station
information and coordinates. That's a good start!

Let's save this table for further analysis in the Process phase, although it is 
possible that we will not be able to find matching coordinates.

#### Member type information

Let's see if all rows in our member_casual field are either equal to "member" 
(annual members) or "casual" (casual riders).

```SQL
SELECT COUNT(*)
FROM cyclistic.trips
WHERE member_casual != "member" AND member_casual !="casual";
```

This returns 0 row. So at least we won't have to clean this field!

#### Start/End date time information

```SQL
SELECT COUNT(*)
FROM cyclistic.trips
WHERE started_at IS NULL OR ended_at IS NULL;
```

Same result, 0 row without these fields!

Now let's find out if all our datetime information is correct. The dataset I'm 
using starts on May 1st 2021 and Ends on April 30th 2022.

We will run this query : 

```SQL
SELECT 
  MAX(started_at) AS max_start_date,
  MIN(started_at) AS min_start_date,
  MAX(ended_at) AS max_end_date,
  MIN(ended_at) AS min_end_date
FROM cyclistic.trips;
```

| max_start_date |	min_start_date |	max_end_date | min_end_date |
| ------------- |-------------| -----|-----|
| 2022-04-30 23:59:54 UTC | 2021-05-01 00:00:11 UTC | 2022-05-02 00:35:01 UTC | 2021-05-01 00:03:26 UTC

The max_end_date is in May 2022, but it seems that datasets are ordered by 
start_date and not end_date so this quick review shows that the data seems 
coherent.

We will also compute ride length and see if there are any outlandish values in
there. BigQuery uses the DATETIME_DIFF function :

```SQL
SELECT 
  MAX(DATETIME_DIFF(ended_at, started_at, MINUTE)) AS max_length,
  MIN(DATETIME_DIFF(ended_at,started_at, MINUTE)) AS min_length
FROM cyclistic.trips;
```
Here are the results  :

| max_length |	min_length |
|:-------------:|:-------------:|
|55944|-58|


Seems like we have very high values (55944 minutes is 932 hours or about 39 
days). It is either a false value or a person who forgot to bring back his or
her bike. Negative values are obviously bad records.

Both of these types of records will have to be cleaned if we compute ride times 
because they might bias our results.

Let's count the number of rows with
a ride length over a day :

```SQL
SELECT COUNT(*)
FROM cyclistic.trips
WHERE DATETIME_DIFF(ended_at, started_at, HOUR) >= 24
```

We get 4186 records. Those record can probably be removed.

Now let's count the number of rows with a ride length < 0, choosing seconds
as our DATETIME_DIFF argument to be more precise :

```SQL
SELECT COUNT(*)
FROM cyclistic.trips
WHERE DATETIME_DIFF(ended_at, started_at, SECOND) < 0
```

The result is 140. We will be able to clean these records without impacting our data.

#### Ride id and rideable_type information

First, let's see what values are in the rideable_type field.

```SQL
SELECT DISTINCT(rideable_type)
FROM cyclistic.trips
```
Here are our results :

| rideable_type |	
|:-------------:|
|electric_bike|
|classic_bike|
|docked_bike|

Seems like the rideable_type field doesn't contain any error. Now, lets study 
the ride_id.

After counting the disctinct values of ride_id : `SELECT COUNT(DISTINCT(ride_id))
FROM cyclistic.trips` we arrive at the conclusion that there are one distinct 
id per row. We just confirmed that there are no duplicated records!

Let's see if out ride_id values are the same length :

```SQL
SELECT
  MAX(LENGTH(ride_id)),
  MIN(LENGTH(ride_id)),
  COUNT(DISTINCT(LENGTH(ride_id)))

FROM cyclistic.trips
```
This query returns 16/16/1. We've just confirmed that all ride_id values are 
unique 16 characters strings. 

#### Summary

In the **Prepare** phase, we merged the 12 tables and identified which fields have
errors or missing values. We will clean the data during the **Process** phase.


# 3. Process

# 4. Analyze

# 5. Share

# 6. Act

