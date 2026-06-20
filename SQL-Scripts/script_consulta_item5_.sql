-- ITEM 5: Alunos matriculados em cada curso
SELECT
    c.Nome_Curso        AS Curso,
    a.Matricula,
    a.Nome              AS Aluno,
    i.Metodo
FROM Ingressa i
JOIN Aluno a ON i.Matricula = a.Matricula
JOIN Curso c ON i.ID_Curso  = c.ID_Curso
WHERE c.Nome_Curso IN ('Ciencia da Computacao','Fisica','Engenharia Quimica')
ORDER BY c.Nome_Curso, a.Nome;
