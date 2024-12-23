-- display all databases available
show databases;

-- work with the sql_and_tableau table
use sql_and_tableau;

-- all tables in the sql_and_tableau database
show tables;

-- display the structure of the career_track_info table
SELECT *
FROM career_track_info;

-- display the structure of the career_track_student_enrollments table
SELECT *
FROM career_track_student_enrollments;

-- query of the new dataset needed for visualization in tableau
SELECT
	a.*,
    CASE
		WHEN days_for_completion IS NULL THEN NULL
        WHEN days_for_completion = 0 THEN 'Same day'
        WHEN days_for_completion <= 7 THEN "1 - 7 days"
        WHEN days_for_completion <= 30 THEN "8 - 30 days"
        WHEN days_for_completion <= 60 THEN "31 - 60 days"
        WHEN days_for_completion <= 90 THEN "61 - 90 days"
        WHEN days_for_completion <= 365 THEN "91 - 365 days"
        ELSE "366+ days" END AS completion_bucket
FROM
	(SELECT
		e.student_id,
		i.track_name,
		e.date_enrolled,
		e.date_completed,
		DATEDIFF(e.date_completed, e.date_enrolled) AS days_for_completion,
		CASE WHEN
			e.date_completed IS NULL THEN 0
			ELSE 1 END AS track_completed,
		ROW_NUMBER() OVER (ORDER BY student_id DESC, track_name DESC) AS student_track_id
	FROM
		career_track_info i
	JOIN
		career_track_student_enrollments e
		ON i.track_id = e.track_id) a;

-- export the result as a .csv file for visualization
