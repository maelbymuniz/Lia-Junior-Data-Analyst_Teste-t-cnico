# Lia - Junior Data Analyst - Teste Técnico

## Questão 1.
Dadas as 3 tabelas:
- students: (id int, name text, enrolled_at date, course_id int)
- courses: (id int, name text, price numeric, school_id int)
- schools: (id int, name text)
Considere que todos alunos se matricularam nos respectivos cursos e que price
é o valor da matrícula, pago por cada aluno.

a. Escreva uma consulta PostgreSQL para obter, por nome da escola e por dia, a
quantidade de alunos matriculados e o valor total das matrículas, tendo como
restrição os cursos que começam com a palavra “data”. Ordene o resultado do
dia mais recente para o mais antigo.

b.Utilizando a resposta do item a, escreva uma consulta para obter, por escola e
por dia, a soma acumulada, a média móvel 7 dias e a média móvel 30 dias da
quantidade de alunos.

### Resolução

Como não foi passado um arquivo com as tabelas, para resolução dessa questão eu criei um banco 'LIA' e as tabelas 'students', 'courses' e 'schools' seguindo as especificações da questão.
```
CREATE TABLE schools (
	id int PRIMARY KEY,
	name text
);

CREATE TABLE courses (
	id int PRIMARY KEY,
	name text,
	price numeric,
	school_id int,
	FOREIGN KEY (school_id) REFERENCES schools(id)
);

CREATE TABLE students (
	id int PRIMARY KEY,
	name text,
	enrolled_at date,
	course_id int,
	FOREIGN KEY (course_id) REFERENCES courses(id)
);
```

Para povoar o banco, usei o ChatGPT para ganhar tempo. Usei as seguintes Queries:

```

INSERT INTO schools (id, name) VALUES
(1, 'Escola de Dados'),
(2, 'IFPB');


INSERT INTO courses (id, name, price, school_id) VALUES
(1, 'Data Analyst', 800.00, 1),
(2, 'Data Scientist', 1200.00, 1),
(3, 'Machine Learning Basics', 900.00, 1),
(4, 'Data Manager', 1000.00, 2),
(5, 'Project Management', 750.00, 2);

INSERT INTO students (id, name, enrolled_at, course_id) VALUES
(1, 'João Silva', '2025-01-10', 1),    -- Data Analyst
(2, 'Maria Oliveira', '2025-01-15', 1), -- Data Analyst
(3, 'Pedro Santos', '2025-02-01', 2),   -- Data Scientist
(4, 'Ana Costa', '2025-02-05', 2),      -- Data Scientist
(5, 'Lucas Almeida', '2025-02-10', 3),  -- Machine Learning Basics
(6, 'Clara Souza', '2025-02-15', 3),    -- Machine Learning Basics
(7, 'Rafael Lima', '2025-03-01', 4),    -- Data Manager
(8, 'Beatriz Mendes', '2025-03-05', 4), -- Data Manager
(9, 'Thiago Pereira', '2025-03-10', 5), -- Project Management
(10, 'Sofia Rocha', '2025-03-15', 5),   -- Project Management
(11, 'Maelby Muniz', '2025-01-10', 1),    -- Data Analyst
(12, 'Raquel Priscila', '2025-01-10', 1), -- Data Analyst
(13, 'Julia Pereira', '2025-01-15', 1),    -- Data Analyst
(14, 'Mirian Ibiapino', '2025-01-15', 1); -- Data Analyst

```
#### Questão 1 - Problema A

Para responder a pergunta do problema A, usei a seguinte Query

```
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
```

E a tabela resposta foi:  

<img width="498" height="193" alt="image" src="https://github.com/user-attachments/assets/b6b390d7-5bbe-40ad-adcc-1a86459e377f" />  

#### Questão 1 - Problema B

Para o problema B, usei a seguinte Query:

```
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
```

Como deveríamos considerar o resultado da Query anterior, criar uma CTE para poder usá-la na nova consulta.

A tabela resultante foi:  
<img width="659" height="189" alt="image" src="https://github.com/user-attachments/assets/8ec6c2c0-5bcd-4a31-be36-8d2cc2c8ed6e" />



  
  [Arquivo Resposta](https://github.com/maelbymuniz/Lia-Junior-Data-Analyst_Teste-t-cnico/blob/master/Resposta_questao1.sql)

__________________________________

## Questão 2.

Para cada departamento, realize uma consulta em PostgresSQL que mostre o
nome do departamento, a quantidade de empregados, a média salarial, o maior e
o menor salários. Ordene o resultado pela maior média salarial.

Dicas: você pode usar a função COALESCE(value , 0) para substituir um valor
nulo por zero e pode usar a função ROUND(value, 2) para mostrar valores com
duas casas decimais.

No arquivo base_dados_questao2.sql, em anexo no email enviado com o link
deste forms, está o banco de dados. Recomendo rodar localmente para analisar
o conteúdo das tabelas, testar e validar sua consulta.

### Resolução

Sinceramente, essa questão foi muito desafiadora e satisfatória de resolver.
Com ela, percebi "É com isso que quero trabalhar" rsrs

Para resolver, fui por partes:

Na base de dados não tinha o salário de cada funcionário


##### 1ª CTE - Encontrar o salário de cada funcionário

Para encontrar o salário de cada um dos funcionários precisei fazer um LEFT JOIN entre 'vencimento' e 'emp_venc'  
<img width="170" height="540" alt="image" src="https://github.com/user-attachments/assets/2407ead0-e4ed-4191-9b26-58c65a552eb7" /> 
<img width="548" height="370" alt="image" src="https://github.com/user-attachments/assets/493dbd14-c12f-49e5-af6d-41d813d7eae7" />


e um FULL JOIN com a tabela empregado
<img width="1031" height="569" alt="image" src="https://github.com/user-attachments/assets/e8620a98-7ee6-4cb5-874e-c41f187e9d2a" />

A query utilizada foi esta:
```
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
```
Resultado:  
<img width="475" height="568" alt="image" src="https://github.com/user-attachments/assets/7322e28d-3f70-400b-99e7-82aa0ea0987d" />


##### 2ª CTE - Encontrar o desconto de cada funcionário (se tiver)  

No salário do funcionário é incedido um desconto, das seguintes categorias:  
Tabela desconto:  
<img width="504" height="120" alt="image" src="https://github.com/user-attachments/assets/d3aeabca-997d-4fa7-843d-150956a15782" />

Primeiro descobrir o desconto de cada funcinário, usei a seguinte CTE:  
```
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
```
A tabela resultante foi:  
<img width="401" height="601" alt="image" src="https://github.com/user-attachments/assets/3940d0aa-4096-4696-b245-549d8695852a" />


##### 3ª CTE - Retornei os funcionários, separados por departamento com o salário já aplicado o descontro

```
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
```
<img width="604" height="564" alt="image" src="https://github.com/user-attachments/assets/29a2fbb7-73c8-47e9-8a87-eeb088f25630" />

##### Consulta Principal  

Utilizando a tabela da 3ª CTE (dep_func_salarios), retornei o nome do departamento, a quantidade de empregados, a média salarial, o maior e
o menor salários. Ordenando o resultado pela maior média salarial.

```
SELECT  nome_dep,
		COUNT(matr_emp) AS qtde_empregados,
		ROUND(AVG(salario_liquido),2) AS media_salarial,
		MAX(salario_liquido) AS maior_salario,
		MIN(salario_liquido) AS menor_salario
FROM dep_func_salarios
GROUP BY 1
ORDER BY 3 DESC;
```

A tabela final ficou assim:  
<img width="647" height="124" alt="image" src="https://github.com/user-attachments/assets/3a70185b-85e1-4f78-a97c-440d4f6f1b5f" />

[Arquivo Resposta](https://github.com/maelbymuniz/Lia-Junior-Data-Analyst_Teste-t-cnico/blob/master/Resposta_questao2.sql)
