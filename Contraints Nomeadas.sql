/* Conectando a um Banco */
USE EMPRESA 
GO

/* CRIAÇÃO DE TABELAS */
CREATE TABLE ALUNO(
    IDALUNO INT PRIMARY KEY IDENTITY(1,1)
    NOME VARCHAR(30) NOT NULL,
    SEXO CHAR(1) NOT NULL,
    NASCIMENTO DATE NOT NULL,
    EMAIL VARCHAR(30) UNIQUE
)
GO

/* CONTRAINTS */

ALTER TABLE ALUNO 
ADD CONSTRAINT CK_SEXO CHECK (SEXO IN('M','F'))
GO

/* 1X1 */

CREATE TABLE ENDERECO(
    IDENDERECO INT PRIMARY KEY IDENTITY(100,10),
    BAIRRO VARCHAR(30),
    UF CHAR(2) NOT NULL,
    CHECK(UF IN ('RJ', 'SP', 'MG')),
    ID_ALUNO INT UNIQUE
)
GO

/* CRIANDO A FK */
ALTER TABLE ENDERECO 
ADD CONSTRAINT FK_ENDERECO_ALUNO
FOREIGN KEY(ID_ALUNO) REFERENCES ALUNO(IDALUNO)
GO

/* -- COMANDOS DE DESCRIÇÃO -- 
--> PROCEDURES - JÁ CRIADAS E ARMAZENADAS NO SISTEMA 
*/

SP_COLUMNS ALUNO
GO

SP_HELP ALUNO
GO

/* INSERINDO DADOS */
INSERT INTO ALUNO VALUES('ANDRE', 'M', '1981/12/09', 'ANDRE@IG.COM')
INSERT INTO ALUNO VALUES('ANA', 'F', '1978/08/09', 'ANA@IG.COM')
INSERT INTO ALUNO VALUES('RUI', 'M', '1951/07/09', 'RUI@IG.COM')
INSERT INTO ALUNO VALUES('JOAO', 'M', '2002/12/09', 'JOAO@IG.COM')
GO

SELECT * FROM ALUNO 
GO

/* ENDERECO */
INSERT INTO ENDERECO VALUES('SÃO GONÇALO', 'RJ', 1)
INSERT INTO ENDERECO VALUES('MORUMBI', 'SP', 2)
INSERT INTO ENDERECO VALUES('CENTRO', 'MG', 4)
INSERT INTO ENDERECO VALUES('CENTRO', 'SP', 6)
GO

/* CRIANDO A TABELA TELEFONE 1 X N */
CREATE TABLE TELEFONE(
    IDTELEFONE INT PRIMARY KEY IDENTITY,
    TIPO CHAR(3) NOT NULL,
    NUMERO VARCHAR(10) NOT NULL,
    ID_ALUNO INT
)
GO

INSERT INTO TELEFONE VALUES('CEL', '7899889', 1)
INSERT INTO TELEFONE VALUES('RES', '4325444', 1)
INSERT INTO TELEFONE VALUES('COM', '4354354', 2)
INSERT INTO TELEFONE VALUES('CEL', '2344556', 2)
GO

SELECT * FROM ALUNO
GO

/* PEGAR DATA ATUAL */
SELECT GETDATE()
GO

/* CLÁUSULA AMBÍGUA */
SELECT A.NOME, T.TIPO, T.NUMERO, E.BAIRRO, E.UF
FROM ALUNO A
INNER JOIN TELEFONE T /* O 'INNER' TRARÁ SOMENTE OS ALUNOS QUE TEM TELEFONE */
ON A.IDALUNO = T.ID_ALUNO
INNER JOIN ENDERECO E 
ON A.IDALUNO = E.ID_ALUNO
GO

SELECT A.NOME, T.TIPO, T.NUMERO, E.BAIRRO, E.UF
FROM ALUNO A
LEFT JOIN TELEFONE T /* O 'LEFT' TRARÁ TODOS OS ALUNOS, INDEPENDETE SE POSSUIR OU NÃO UM TELEFONE ----- O 'RIGHT' TRARIA TODOS OS TELEFONES*/
ON A.IDALUNO = T.ID_ALUNO
INNER JOIN ENDERECO E 
ON A.IDALUNO = E.ID_ALUNO
GO

/* ISNULL */

SELECT  A.NOME, 
        ISNULL(T.TIPO,'SEM') AS "TIPO", 
        ISNULL(T.NUMERO,'NUMERO') AS , 
        E.BAIRRO, 
        E.UF
FROM ALUNO A
INNER JOIN TELEFONE T /* O 'INNER' TRARÁ SOMENTE OS ALUNOS QUE TEM TELEFONE */
ON A.IDALUNO = T.ID_ALUNO
INNER JOIN ENDERECO E 
ON A.IDALUNO = E.ID_ALUNO
GO

/* DATAS */

SELECT * FROM ALUNO
GO

SELECT NOME, NASCIMENTO 
FROM ALUNO
GO

/* DATEDIFF - CALCULA A DIFERENÇA ENTRE 2 DATAS */

SELECT NOME, GETDATE() AS DIA_HORA FROM ALUNO /* GETDATE - FUNÇÃO QUE RETORNA A DATA E HORA ATUAL */
GO

/* 1º PASSO */

SELECT NOME, DATEDIFF(DAY, NASCIMENTO, GETDATE())
FROM ALUNO 
GO 

/* 2º PASSO */

SELECT NOME, DATEDIFF(DAY, NASCIMENTO, GETDATE()/365) AS "IDADE"
FROM ALUNO 
GO

/* 3º PASSO */

SELECT NOME, DATEDIFF(YEAR, NASCIMENTO, GETDATE()) AS "IDADE"
FROM ALUNO 
GO



