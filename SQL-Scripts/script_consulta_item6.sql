-- ITEM 6: Alunos por disciplina no semestre atual e passado
SELECT
    ms.Semestre,
    d.Nome_D            AS Disciplina,
    a.Matricula,
    a.Nome              AS Aluno
FROM Matricula_Se ms
JOIN Aluno      a ON ms.Matricula     = a.Matricula
JOIN Disciplina d ON ms.ID_Disciplina = d.ID_Disciplina
WHERE ms.Semestre IN ('2025-1','2024-2')
ORDER BY ms.Semestre DESC, d.Nome_D, a.Nome;
