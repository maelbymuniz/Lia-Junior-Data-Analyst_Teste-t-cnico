-- Retorna o valor do vencimento de cada empregado
WITH vencimento_empregados AS (
	SELECT  emp.matr AS matr_emp,
			emp.nome AS empregado,
			SUM(v.valor) AS valor_vencimento,
			emp.lotacao AS cod_dep
	FROM vencimento v
	LEFT JOIN emp_venc ev ON v.cod_venc = ev.cod_venc
	FULL JOIN empregado emp ON ev.matr = emp.matr
	GROUP BY 1, 2,4
),

-- Retorna o valor de desconto de cada empregado,
-- caso não tenha, é atrubuído 0
empregados_com_desconto AS (
	SELECT  emp.matr AS matr_emp,
			emp.nome AS empregado,
			COALESCE(SUM(d.valor),0) AS valor_desconto
	FROM desconto d
	LEFT JOIN emp_desc ed ON d.cod_desc = ed.cod_desc
	FULL JOIN empregado emp ON ed.matr = emp.matr
	GROUP BY 1, 2
),

dep_func_salarios AS (
	SELECT  dep.cod_dep AS dep,
			dep.nome AS nome_dep,
			ve.matr_emp AS matr_emp,
			ve.empregado AS nome_emp,
			COALESCE(ROUND(ve.valor_vencimento - ecd.valor_desconto, 0),0) AS salario_liquido
	FROM vencimento_empregados ve
	LEFT JOIN empregados_com_desconto ecd ON ecd.matr_emp = ve.matr_emp
	LEFT JOIN departamento dep ON dep.cod_dep = ve.cod_dep
)

SELECT  nome_dep,
		COUNT(matr_emp) AS qtde_empregados,
		ROUND(AVG(salario_liquido),2) AS media_salarial,
		MAX(salario_liquido) AS maior_salario,
		MIN(salario_liquido) AS menor_salario
FROM dep_func_salarios
GROUP BY 1
ORDER BY 3 DESC;