SELECT * FROM students WHERE age >= 12;

SELECT * FROM students INNER JOIN enrollment ON students.id = enrollment.student_id
					   INNER JOIN schools ON enrollment.school_id = schools.id;

SELECT  schools.name, COUNT(*) as number_of_students
	FROM students INNER JOIN enrollment ON students.id = enrollment.student_id
					   INNER JOIN schools ON enrollment.school_id = schools.id
	GROUP BY schools.id;

SELECT  schools.name, COUNT(*) as number_of_students
	FROM students INNER JOIN enrollment ON students.id = enrollment.student_id
					   INNER JOIN schools ON enrollment.school_id = schools.id
	WHERE students.age >= 12
	GROUP BY schools.id 
	HAVING number_of_students >= 2;

DROP INDEX "movies_idx_name";
CREATE INDEX "movies_idx_name" ON "movies" ("name");

SELECT * FROM movies WHERE name LIKE 'Car%';

SELECT * FROM movies WHERE year = 1971;

SELECT COUNT(*) FROM movies WHERE year=1982 GROUP BY year;

SELECT * FROM actors WHERE last_name LIKE '%stack%';

SELECT COUNT(*) as number_of_actors, first_name  FROM actors GROUP BY first_name ORDER BY number_of_actors DESC LIMIT 10;

SELECT COUNT(*) as number_of_actors, last_name  FROM actors GROUP BY last_name ORDER BY number_of_actors DESC LIMIT 10;

SELECT actors.first_name, actors.last_name, COUNT(*) as role_count
		FROM actors INNER JOIN roles ON roles.actor_id = actors.id
		GROUP BY roles.actor_id ORDER BY role_count DESC LIMIT 100;

SELECT genre, COUNT(*) as num_movies FROM movies_genres GROUP BY genre ORDER BY num_movies ASC;

SELECT actors.first_name, actors.last_name, roles.role FROM movies INNER JOIN roles ON roles.movie_id = movies.id 
																   INNER JOIN actors ON roles.actor_id = actors.id 
																   WHERE movies.name="Braveheart" AND movies.year=1995 
																   ORDER BY actors.last_name;

SELECT directors.first_name, directors.last_name, movies.name, movies.year FROM movies 
		INNER JOIN movies_genres ON movies.id=movies_genres.movie_id 
			INNER JOIN movies_directors ON movies_genres.movie_id=movies_directors.movie_id
				INNER JOIN directors ON directors.id=movies_directors.director_id
		WHERE movies_genres.genre = "Film-Noir" AND movies.year%4==0;

SELECT kb_movies.kb_movie_name, actors.first_name, actors.last_name FROM
	(SELECT movies.id as kb_movie_id, movies.name as kb_movie_name FROM actors INNER JOIN roles ON roles.actor_id=actors.id
		INNER JOIN movies ON movies.id=roles.movie_id
		WHERE actors.first_name="Kevin" AND actors.last_name="Bacon"
	) kb_movies
	INNER JOIN roles ON roles.movie_id=kb_movies.kb_movie_id
	INNER JOIN actors ON actors.id=roles.actor_id
WHERE actors.first_name!="Kevin" AND actors.last_name!="Bacon";

SELECT actors.first_name, actors.last_name, actors.id FROM 
	(SELECT actors.id AS old_actor_id FROM actors INNER JOIN roles ON roles.actor_id=actors.id
					 		INNER JOIN movies ON movies.id=roles.movie_id
							WHERE movies.year<1900) old_movies
		INNER JOIN actors ON actors.id=old_movies.old_actor_id
		INNER JOIN roles ON roles.actor_id=actors.id
		INNER JOIN movies ON movies.id=roles.movie_id
		WHERE movies.year>2000
		GROUP BY actors.id;

SELECT actors.first_name, actors.last_name, movies.name, movies.year, COUNT(DISTINCT roles.role) AS num_roles_in_movie 
	FROM actors
		INNER JOIN roles ON roles.actor_id=actors.id
		INNER JOIN movies ON movies.id=roles.movie_id
		WHERE movies.year>1990
		GROUP BY actors.id, movies.id
		HAVING num_roles_in_movie > 4;

SELECT movies.year, COUNT(*) AS movies_in_year 
	FROM movies
	WHERE movies.id NOT IN (
		SELECT DISTINCT movies.id
		FROM movies 
		INNER JOIN roles ON roles.movie_id=movies.id
    	INNER JOIN actors 
    		ON roles.actor_id = actors.id 
    		AND actors.gender = 'M'
    )
    AND movies.id IN (
		SELECT DISTINCT movies.id
		FROM movies 
		INNER JOIN roles ON roles.movie_id=movies.id
    	INNER JOIN actors 
    		ON roles.actor_id = actors.id 
    		AND actors.gender = 'F'
    	)
    GROUP BY movies.year;

