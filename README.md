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
trips
for the Divvy bike sharing company. 
[Dataset link](https://divvy-tripdata.s3.amazonaws.com/index.html)

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

Thorough cleaning will be necessary! But first, let's merge the last 12 months of datasets.


### Merging the datasets

Luckily, all of the 12 latest datasets (as of 11 MAY 2022, I will thus use all
data from MAY 2021 to APRIL 2022) have the same schema and column names. 
Merging them will be a piece of cake!

After adding the files to my Google Cloud Storage, I could just merge them
by using a URI request in the CREATE TABLE menu in BigQuery to select all the
csv files `cyclistic_data_set/*.csv` and merge them into a table. But for the
sake of showcasing my SQL skills, I will develop a SQL query to do the exact 
same thing. 

After looking into cursors to iterate over all datasets in my cyclistic, I
realize that you can iterate over BigQuery tables using a wildcard operator.
Here's the query to merge all of the 12 tables into a single dataset.

```SQL
```


# 3. Process

# 4. Analyze

# 5. Share

# 6. Act

