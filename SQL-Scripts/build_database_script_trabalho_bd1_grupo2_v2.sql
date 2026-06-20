CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON Banco_Universidade.* TO 'admin'@'%';
FLUSH PRIVILEGES;

-- ============================================================
--  BANCO_UNIVERSIDADE — Modelo simplificado (versão correta)
--  Entidades: Aluno, Curso, Disciplina
--  Relacionamentos: Ingressa, Matricula_Se, Oferta
-- ============================================================

CREATE DATABASE IF NOT EXISTS Banco_Universidade
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE Banco_Universidade;

-- ┌──────────────────────────────────────────────────────────┐
-- │  ORDEM DE CRIAÇÃO — regra: "pai antes do filho"          │
-- │                                                          │
-- │  1. CURSO        → sem FK, ninguém depende ainda        │
-- │  2. DISCIPLINA   → sem FK, ninguém depende ainda        │
-- │  3. ALUNO        → sem FK própria na tabela base        │
-- │  4. INGRESSA     → FK de ALUNO + CURSO                  │
-- │  5. OFERTA       → FK de DISCIPLINA + CURSO             │
-- │  6. MATRICULA_SE → FK de ALUNO + DISCIPLINA             │
-- └──────────────────────────────────────────────────────────┘

-- 1. CURSO
CREATE TABLE IF NOT EXISTS Curso (
    ID_Curso   INT          NOT NULL AUTO_INCREMENT,
    Nome_Curso VARCHAR(100) NOT NULL,
    Freq       VARCHAR(30)  DEFAULT 'Presencial',
    PRIMARY KEY (ID_Curso)
);

-- 2. DISCIPLINA
CREATE TABLE IF NOT EXISTS Disciplina (
    ID_Disciplina INT          NOT NULL AUTO_INCREMENT,
    Nome_D        VARCHAR(100) NOT NULL,
    CH            INT          NOT NULL,
    PRIMARY KEY (ID_Disciplina)
);

-- 3. ALUNO  (sem FK aqui — vínculo com Curso fica em INGRESSA)
CREATE TABLE IF NOT EXISTS Aluno (
    Matricula VARCHAR(10)  NOT NULL,
    Nome      VARCHAR(100) NOT NULL,
    CPF       CHAR(11)     NOT NULL UNIQUE,
    Endereco  VARCHAR(200),
    PRIMARY KEY (Matricula)
);

-- 4. INGRESSA  — relaciona Aluno ↔ Curso
--    Atributo próprio: Metodo (SISU / ProUni / FIES / Vestibular)
CREATE TABLE IF NOT EXISTS Ingressa (
    Matricula VARCHAR(10) NOT NULL,
    ID_Curso  INT         NOT NULL,
    Metodo    VARCHAR(30) NOT NULL DEFAULT 'SISU',
    PRIMARY KEY (Matricula, ID_Curso),
    CONSTRAINT fk_ing_aluno FOREIGN KEY (Matricula) REFERENCES Aluno(Matricula),
    CONSTRAINT fk_ing_curso FOREIGN KEY (ID_Curso)  REFERENCES Curso(ID_Curso)
);

-- 5. OFERTA  — relaciona Disciplina ↔ Curso
--    Atributo próprio: Semestre (qual semestre a disciplina é ofertada no curso)
CREATE TABLE IF NOT EXISTS Oferta (
    ID_Disciplina INT         NOT NULL,
    ID_Curso      INT         NOT NULL,
    Semestre      VARCHAR(7)  NOT NULL,
    PRIMARY KEY (ID_Disciplina, ID_Curso, Semestre),
    CONSTRAINT fk_of_disc  FOREIGN KEY (ID_Disciplina) REFERENCES Disciplina(ID_Disciplina),
    CONSTRAINT fk_of_curso FOREIGN KEY (ID_Curso)      REFERENCES Curso(ID_Curso)
);

-- 6. MATRICULA_SE  — relaciona Aluno ↔ Disciplina
--    Atributo próprio: Semestre (1º, 2º, 3º … em qual semestre o aluno cursou)
CREATE TABLE IF NOT EXISTS Matricula_Se (
    Matricula     VARCHAR(10) NOT NULL,
    ID_Disciplina INT         NOT NULL,
    Semestre      VARCHAR(7)  NOT NULL,
    PRIMARY KEY (Matricula, ID_Disciplina, Semestre),
    CONSTRAINT fk_mat_aluno FOREIGN KEY (Matricula)     REFERENCES Aluno(Matricula),
    CONSTRAINT fk_mat_disc  FOREIGN KEY (ID_Disciplina) REFERENCES Disciplina(ID_Disciplina)
);

-- ──────────────────────────────────────────────────────────
-- POPULANDO O BANCO
-- Mesma ordem das tabelas: pai sempre antes do filho
-- ──────────────────────────────────────────────────────────

-- 1. Cursos
INSERT INTO Curso (Nome_Curso, Freq) VALUES
    ('Ciencia da Computacao', 'Presencial'),
    ('Fisica',                'Presencial'),
    ('Engenharia Quimica',    'Presencial');

-- 2. Disciplinas
INSERT INTO Disciplina (Nome_D, CH) VALUES
    ('Calculo 1',      60),
    ('Fisica 1',       60),
    ('Quimica 1',      60),
    ('Algebra Linear', 60),
    ('Bioquimica',     45),
    ('Banco de Dados', 60);

-- 3. Alunos (sem FK aqui)
INSERT INTO Aluno (Matricula, Nome, CPF, Endereco) VALUES
    ('2024001', 'Ana Lima',       '11111111101', 'Rua A, 10 - Brasilia/DF'),
    ('2024002', 'Bruno Souza',    '22222222202', 'Rua B, 20 - Brasilia/DF'),
    ('2024003', 'Carla Mendes',   '33333333303', 'Rua C, 30 - Brasilia/DF'),
    ('2024004', 'Diego Rocha',    '44444444404', 'Rua D, 40 - Goiania/GO'),
    ('2024005', 'Elisa Ferreira', '55555555505', 'Rua E, 50 - Brasilia/DF'),
    ('2024006', 'Felipe Costa',   '66666666606', 'Rua F, 60 - Brasilia/DF'),
    ('2024007', 'Gabriela Nunes', '77777777707', 'Rua G, 70 - Brasilia/DF'),
    ('2024008', 'Henrique Dias',  '88888888808', 'Rua H, 80 - Anapolis/GO'),
    ('2024009', 'Isabela Alves',  '99999999909', 'Rua I, 90 - Brasilia/DF'),
    ('2024010', 'Joao Pereira',   '10101010100', 'Rua J, 100 - Brasilia/DF');

-- 4. Ingressa (FK de Aluno + Curso)
--    4 alunos em Comp (ID 1), 3 em Fisica (ID 2), 3 em Eng.Quim (ID 3)
INSERT INTO Ingressa (Matricula, ID_Curso, Metodo) VALUES
    ('2024001', 1, 'SISU'),
    ('2024002', 1, 'ProUni'),
    ('2024003', 1, 'SISU'),
    ('2024004', 1, 'FIES'),
    ('2024005', 2, 'SISU'),
    ('2024006', 2, 'SISU'),
    ('2024007', 2, 'ProUni'),
    ('2024008', 3, 'SISU'),
    ('2024009', 3, 'FIES'),
    ('2024010', 3, 'SISU');

-- 5. Oferta (FK de Disciplina + Curso)
--    Semestre atual 2025-1 e passado 2024-2
INSERT INTO Oferta (ID_Disciplina, ID_Curso, Semestre) VALUES
    (1, 1, '2025-1'), -- Calculo 1      / Comp
    (4, 1, '2025-1'), -- Algebra Linear / Comp
    (6, 1, '2025-1'), -- Banco de Dados / Comp
    (2, 2, '2025-1'), -- Fisica 1       / Fisica
    (1, 2, '2025-1'), -- Calculo 1      / Fisica
    (3, 3, '2025-1'), -- Quimica 1      / Eng.Quim
    (5, 3, '2025-1'), -- Bioquimica     / Eng.Quim
    (1, 1, '2024-2'), -- Calculo 1      / Comp (semestre passado)
    (4, 1, '2024-2'), -- Algebra Linear / Comp (semestre passado)
    (2, 2, '2024-2'), -- Fisica 1       / Fisica (semestre passado)
    (3, 3, '2024-2'), -- Quimica 1      / Eng.Quim (semestre passado)
    (5, 3, '2024-2'); -- Bioquimica     / Eng.Quim (semestre passado)

-- 6. Matricula_Se (FK de Aluno + Disciplina)
INSERT INTO Matricula_Se (Matricula, ID_Disciplina, Semestre) VALUES
    -- Semestre atual 2025-1
    ('2024001', 1, '2025-1'), -- Ana     → Calculo 1
    ('2024001', 4, '2025-1'), -- Ana     → Algebra Linear
    ('2024001', 6, '2025-1'), -- Ana     → Banco de Dados
    ('2024002', 1, '2025-1'), -- Bruno   → Calculo 1
    ('2024002', 6, '2025-1'), -- Bruno   → Banco de Dados
    ('2024003', 4, '2025-1'), -- Carla   → Algebra Linear
    ('2024004', 1, '2025-1'), -- Diego   → Calculo 1
    ('2024005', 2, '2025-1'), -- Elisa   → Fisica 1
    ('2024005', 1, '2025-1'), -- Elisa   → Calculo 1
    ('2024006', 2, '2025-1'), -- Felipe  → Fisica 1
    ('2024007', 1, '2025-1'), -- Gabriela→ Calculo 1
    ('2024008', 3, '2025-1'), -- Henrique→ Quimica 1
    ('2024008', 5, '2025-1'), -- Henrique→ Bioquimica
    ('2024009', 3, '2025-1'), -- Isabela → Quimica 1
    ('2024010', 5, '2025-1'), -- Joao    → Bioquimica
    -- Semestre passado 2024-2
    ('2024001', 1, '2024-2'),
    ('2024002', 1, '2024-2'),
    ('2024003', 4, '2024-2'),
    ('2024005', 2, '2024-2'),
    ('2024006', 2, '2024-2'),
    ('2024008', 3, '2024-2'),
    ('2024009', 5, '2024-2');
