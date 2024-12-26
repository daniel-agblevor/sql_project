# SQL and Tableau Project: Student Enrollment Data Analysis

This project focuses on analyzing and preparing student enrollment data from a relational database to generate insights and visualizations in Tableau. The SQL script provided includes queries for exploring the database, preparing data, and categorizing student performance.

## Project Goals

1. **Understand the database structure**:
   - Explore available databases and tables.
   - Analyze the structure and contents of key tables.

2. **Prepare the dataset**:
   - Join and transform data from multiple tables.
   - Derive additional fields such as `days_for_completion` and `completion_bucket`.
   - Categorize students' completion times for better insights.

3. **Enable visualization in Tableau**:
   - Export the prepared dataset as a `.csv` file for Tableau integration.

## Features

### Database Exploration
- Display all available databases:
  ```sql
  SHOW DATABASES;
  ```
- Switch to the relevant database:
  ```sql
  USE sql_and_tableau;
  ```
- List all tables:
  ```sql
  SHOW TABLES;
  ```

### Data Inspection
- Display the contents of the `career_track_info` table:
  ```sql
  SELECT * FROM career_track_info;
  ```
- Display the contents of the `career_track_student_enrollments` table:
  ```sql
  SELECT * FROM career_track_student_enrollments;
  ```

### Data Preparation
- Join and transform data to prepare a new dataset:
  ```sql
  SELECT
      a.*,
      CASE
          WHEN days_for_completion IS NULL THEN NULL
          WHEN days_for_completion = 0 THEN 'Same day'
          WHEN days_for_completion <= 7 THEN '1 - 7 days'
          WHEN days_for_completion <= 30 THEN '8 - 30 days'
          WHEN days_for_completion <= 60 THEN '31 - 60 days'
          WHEN days_for_completion <= 90 THEN '61 - 90 days'
          WHEN days_for_completion <= 365 THEN '91 - 365 days'
          ELSE '366+ days'
      END AS completion_bucket
  FROM
      (SELECT
          e.student_id,
          i.track_name,
          e.date_enrolled,
          e.date_completed,
          DATEDIFF(e.date_completed, e.date_enrolled) AS days_for_completion,
          CASE WHEN e.date_completed IS NULL THEN 0 ELSE 1 END AS track_completed,
          ROW_NUMBER() OVER (ORDER BY student_id DESC, track_name DESC) AS student_track_id
      FROM
          career_track_info i
      JOIN
          career_track_student_enrollments e
          ON i.track_id = e.track_id) a;
  ```

### Data Export
- Export the result as a `.csv` file for visualization in Tableau.

## Prerequisites

- SQL database system (e.g., MySQL, PostgreSQL).
- Tableau Desktop or Tableau Public for visualization.

## How to Use

1. Run the SQL script in your database system.
2. Export the query result to a `.csv` file.
3. Load the `.csv` file into Tableau.
4. Create visualizations using fields such as `completion_bucket` and `track_name`.

## Potential Use Cases
- Analyzing student performance trends.
- Understanding enrollment and completion patterns.
- Supporting decision-making for curriculum improvements.

## Acknowledgements

- **Data Source**: Hypothetical datasets for SQL and Tableau training.
- **Tools**: SQL and Tableau for data preparation and visualization.
