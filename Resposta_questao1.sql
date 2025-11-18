
-- Resposta da letra A
SELECT  sc.name AS school_name,
		s.enrolled_at AS enrolled_at,
		COUNT(s.enrolled_at) AS total_enrolled,
		SUM(c.price) AS total
FROM students s
JOIN courses c
	ON s.course_id = c.id
JOIN schools sc
	ON c.school_id = sc.id
WHERE UPPER(c.name) LIKE 'DATA%'
GROUP BY 1, 2
ORDER BY 2 DESC;


-- Resposta da letra B
WITH analise AS (
	SELECT  sc.name AS school_name,
			s.enrolled_at AS enrolled_at,
			COUNT(s.enrolled_at) AS total_enrolled,
			SUM(c.price) AS total
	FROM students s
	JOIN courses c
		ON s.course_id = c.id
	JOIN schools sc
		ON c.school_id = sc.id
	WHERE UPPER(c.name) LIKE 'DATA%'
	GROUP BY 1, 2
	ORDER BY 2 DESC
)

SELECT  school_name,
		enrolled_at,
		SUM(total_enrolled) OVER (PARTITION BY school_name ORDER BY enrolled_at) AS cumulative_sum,
		ROUND(AVG(total_enrolled) OVER (
			PARTITION BY school_name
			ORDER BY enrolled_at
			ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS moving_avg_7,
		ROUND(AVG(total_enrolled) OVER (
			PARTITION BY school_name
			ORDER BY enrolled_at
			ROWS BETWEEN 29 PRECEDING AND CURRENT ROW), 2) AS moving_avg_30
FROM analise;