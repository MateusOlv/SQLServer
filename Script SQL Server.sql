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

SELECT NOME, DATEDIFF(DAY, NASCIMENTO, GETDATE()) AS "IDADE"
FROM ALUNO 
GO

/* 3º PASSO - RETORNO EM INTEIRO + OPERAÇÕES MATEMÁTICAS */

SELECT NOME, (DATEDIFF(DAY, NASCIMENTO, GETDATE())/365) AS "IDADE"
FROM ALUNO 
GO

SELECT NOME, (DATEDIFF(MONTH, NASCIMENTO, GETDATE())/12) AS "IDADE"
FROM ALUNO 
GO

SELECT NOME, DATEDIFF(YEAR, NASCIMENTO, GETDATE()) AS "IDADE"
FROM ALUNO 
GO

/* DATENAME - TRAZ O NOME DA PARTE DA DATA EM QUESTÃO */

SELECT NOME, DATENAME(MONTH, NASCIMENTO)
FROM ALUNO
GO

SELECT NOME, DATENAME(YEAR, NASCIMENTO)
FROM ALUNO
GO

SELECT NOME, DATENAME(WEEKDAY, NASCIMENTO)
FROM ALUNO
GO

/* DATEPART - FAZ A MESMA COISA QUE O DATENAME, PORÉM O RETORNO É UM INTEIRO */

SELECT NOME, DATEPART(MONTH, NASCIMENTO)
FROM ALUNO 
GO

SELECT NOME, DATEPART(MONTH, NASCIMENTO), DATENAME(MONTH, NASCIMENTO)
FROM ALUNO 
GO

/* DATEADD - RETORNA UMA DATA SOMANDO À OUTRA DATA */

SELECT DATEADD(DAY, 365, GETDATE())
GO

SELECT DATEADD(YEAR, 10, GETDATE())
GO

/* CONVERSÃO DE DADOS */

SELECT 1 + '1'
GO

SELECT '1' + '1'
GO

SELECT 'CURSO DE BANCO DE DADOS' + '1'
GO

SELECT 'CURSO DE BANCO DE DADOS' + 1
GO

/* FUNÇÕES DE CONVERSÃO DE DADOS */
SELECT CAST('1' AS INT) + CAST('1' AS INT)
GO

/* CONVERSÃO E CONCATENAÇÃO */

SELECT NOME,
CAST(DAY(NASCIMENTO) AS VARCHAR) + '/' + 
CAST(MONTH(NASCIMENTO) AS VARCHAR) + '/' + 
CAST(YEAR(NASCIMENTO) AS VARCHAR) AS "NASCIMENTO"
FROM ALUNO
GO

/* CHARINDEX - RETORNA UM INTEIRO
    -> CONTAGEM DEFAULT - INICIA EM 01
*/

SELECT NOME, CHARINDEX('A', NOME) AS INDICE
FROM ALUNO 
GO

SELECT NOME, CHARINDEX('A', NOME, 2) AS INDICE
FROM ALUNO 
GO

/* BULK INSERT - IMPORTAÇÃO DE ARQUIVOS */

CREATE TABLE LANCAMENTO_CONTABIL(
    CONTA INT, 
    VALOR INT, 
    DEB_CRED CHAR(1)
)
GO

SELECT * FROM LANCAMENTO_CONTABIL
FROM 'CAMINHO DO ARQUIVO'
WITH
(
    FIRSTROW = 2,
    DATAFILETYPE = 'char',
    FIELDTERMINATOR = '\t',
    ROWTERMINATOR = '\n'
)
GO

SELECT * FROM LANCAMENTO_CONTABIL
GO

/* DESAFIO DO SALDO
QUERY QUE TRAGA O NÚMERO DA CONTA,
SALDO - DEVEDOR / CREDOR
*/

SELECT CONTA, VALOR, DEB_CRED,
CHARINDEX('D', DEB_CRED) AS DEBITO,
CHARINDEX('C', DEB_CRED) AS CREDITO,
CHARINDEX('C', DEB_CRED) * 2 - 1 AS MULTIPLICADOR
FROM LANCAMENTO_CONTABIL
GO

SELECT CONTA,
SUM(VALOR * (CHARINDEX('C', DEB_CRED) * 2 - 1)) AS SALDO
FROM LANCAMENTO_CONTABIL
GROUP BY CONTA
GO

/* TRIGGERS */

CREATE TABLE PRODUTOS(
    IDPRODUTO INT PRIMARY KEY IDENTITY,
    NOME VARCHAR(50) NOT NULL,
    CATEGORIA VARCHAR(50) NOT NULL,
    PRECO NUMERIC(10,2)
)
GO

CREATE TABLE HISTORICO(
    IDOPERACAO INT PRIMARY KEY IDENTITY
    PRODUTO VARCHAR(50) NOT NULL,
    CATEGORIA VARCHAR(50) NOT NULL,
    PRECOANTIGO NUMERIC(10,2) NOT NULL,
    PRECONOVO NUMERIC(10,2) NOT NULL,
    DATA DATETIME,
    USUARIO VARCHAR(30),
    MENSAGEM VARCHAR(100)
)
GO

INSERT INTO PRODUTOS('LIVRO SQL SERVER', 'LIVROS', 98.00)
INSERT INTO PRODUTOS('LIVRO ORACLE', 'LIVROS', 89.90)
INSERT INTO PRODUTOS('SAMSUNG BOOK', 'NOTEBOOK', 3980.00)
INSERT INTO PRODUTOS('JAQUETA DA NIKE', 'ROUPAS', 208.00)
GO

SELECT * FROM PRODUTOS
SELECT * FROM HISTORICO
GO

-- VERIFICANDO O USUÁRIO
SELECT SUSER_NAME()
GO

/* TRIGGER DE DML - DATA MANIPULATION LANGUAGE */

CREATE TRIGGER TRG_ATUALIZA_PRECO
ON DBO.PRODUTOS
FOR UPDATE
AS 
    DECLARE @IDPRODUTO INT 
    DECLARE @PRODUTO VARCHAR(50)
    DECLARE @CATEGORIA VARCHAR(50)
    DECLARE @PRECO NUMERIC(10,2)
    DECLARE @PRECONOVO NUMERIC(10,2)
    DECLARE @DATA DATETIME
    DECLARE @USUARIO VARCHAR(30)
    DECLARE @ACAO VARCHAR(100)

    SELECT @IDPRODUTO = IDPRODUTO FROM inserted
    SELECT @PRODUTO = NOME FROM inserted
    SELECT @CATEGORIA = CATEGORIA FROM inserted
    SELECT @PRECO = PRECO FROM deleted
    SELECT @PRECONOVO = PRECO FROM inserted

    SET @DATA = GETDATE()
    SET @USUARIO = SUSER_NAME()
    SET @ACAO = 'VALOR INSERIDO PELA TRIGGER TRG_ATUALIZA_PRECO'

    INSERT INTO HISTORICO 
    (PRODUTO, CATEGORIA, PRECOANTIGO, PRECONOVO, DATA, USUARIO, MENSAGEM)
    VALUES
    (@IDPRODUTO, @CATEGORIA, @PRECO, @PRECONOVO, @DATA, @USUARIO, @ACAO)

    PRINT ('TRIGGER EXECUTADA COM SUCESSO')
GO

/* EXECUTANDO UM UPDATE */
UPDATE PRODUTOS SET PRECO = 100.00
WHERE IDPRODUTO = 1
GO

SELECT * FROM PRODUTOS
SELECT * FROM HISTORICO
GO

UPDATE PRODUTO SET NOME = 'LIVRO C#'
WHERE IDPRODUTO = 1
GO

/* PROGRAMANDO TRIGGER EM UMA COLUNA */

DROP TRIGGER TRG_ATUALIZA_PRECO
GO

CREATE TRIGGER TRG_ATUALIZA_PRECO
ON DBO.PRODUTOS
FOR UPDATE AS
IF UPDATE(PRECO)
BEGIN 
    DECLARE @IDPRODUTO INT 
    DECLARE @PRODUTO VARCHAR(50)
    DECLARE @CATEGORIA VARCHAR(50)
    DECLARE @PRECO NUMERIC(10,2)
    DECLARE @PRECONOVO NUMERIC(10,2)
    DECLARE @DATA DATETIME
    DECLARE @USUARIO VARCHAR(30)
    DECLARE @ACAO VARCHAR(100)

    SELECT @IDPRODUTO = IDPRODUTO FROM inserted
    SELECT @PRODUTO = NOME FROM inserted
    SELECT @CATEGORIA = CATEGORIA FROM inserted
    SELECT @PRECO = PRECO FROM deleted
    SELECT @PRECONOVO = PRECO FROM inserted

    SET @DATA = GETDATE()
    SET @USUARIO = SUSER_NAME()
    SET @ACAO = 'VALOR INSERIDO PELA TRIGGER TRG_ATUALIZA_PRECO'

    INSERT INTO HISTORICO 
    (PRODUTO, CATEGORIA, PRECOANTIGO, PRECONOVO, DATA, USUARIO, MENSAGEM)
    VALUES
    (@IDPRODUTO, @CATEGORIA, @PRECO, @PRECONOVO, @DATA, @USUARIO, @ACAO)

    PRINT ('TRIGGER EXECUTADA COM SUCESSO')
END
GO

UPDATE PRODUTOS SET PRECO = 300.00
WHERE IDPRODUTO = 2
GO

SELECT * FROM HISTORICO

UPDATE PRODUTOS SET NOME = 'LIVRO JAVA'
WHERE IDPRODUTO = 2
GO

/* VARIÁVEIS COM SELECT */

CREATE TABLE RESULTADO(
    IDRESULTADO INT PRIMARY KEY IDENTITY,
    RESULTADO INT
)
GO

INSERT INTO RESULTADO VALUES((SELECT 10+10))
GO

SELECT * FROM RESULTADO
GO

/* ATRIBUINDO SELECTS A VARIÁVEIS - ANÔNIMO */

DECLARE 
    @RESULTADO INT 
    SET @RESULTADO = (SELECT 50 + 50)
    INSERT INTO REULTADOS VALUES (@RESULTADO)
    GO

DECLARE 
    @RESULTADO INT 
    SET @RESULTADO = (SELECT 50 + 50)
    INSERT INTO REULTADOS VALUES (@RESULTADO)
    PRINT 'VALOR INSERIDO NA TABELA: ' + CAST(@RESULTADO AS VARCHAR)
    GO

/* TRIGGER UPDATE - SIMPLIFICADA */

CREATE TABLE EMPREGADO(
    IDEMP INT PRIMARY KEY,
    NOME VARCHAR(30),
    SALARIO MONEY, -- PONTO FLUTUANTE COM APENAS DUAS CASAS DECIMAIS
    IDGERENTE INT
)

ALTER TABLE EMPREGADO ADD CONSTRAINT FK_GERENTE
FOREIGN KEY (IDGERENTE) REFERENCES EMPREGADO(IDEMPREGADO)
GO

INSERT INTO EMPREGADO VALUES (1, 'CLARA', 3000.00, NULL)
INSERT INTO EMPREGADO VALUES (2, 'MATEUS', 2000.00, 1)
INSERT INTO EMPREGADO VALUES (3, 'FERNANDO', 1500.00, 1)
GO

CREATE TABLE HIST_SALARIO(
    IDEMPREGADO INT,
    ANTIGOSAL MONEY,
    NOVOSAL MONEY,
    DATA DATETIME
)
GO

CREATE TRIGGER TG_SALARIO
ON DBO.EMPREGADO
FOR UPDATE AS 
IF UPDATE(SALARIO)
BEGIN
    INSERT INTO HIST_SALARIO
    (IDEMPREGADO, ANTIGOSAL, NOVOSAL, DATA)
    SELECT D.IDEMP, D.ANTIGOSAL, I.NOVOSAL, GETDATE()
    FROM DELETED D, INSERTED I
    WHERE D.IDEMP = I.IDEMP
END
GO

UPDATE EMPREGADO SET SALARIO = SALARIO * 1.1
GO

SELECT * FROM EMPREGADO
GO

SELECT * FROM HIST_SALARIO
GO

/* TRIGGER DE RANGE */

CREATE TABLE SALARIO_RANGE(
    MINSAL MONEY,
    MAXSAL MONEY
)
GO

INSERT INTO SALARIO_RANGE VALUES(2000.00, 6000.00)
GO

CREATE TRIGGER TG_RANGE
ON DBO.EMPREGADO
FOR INSERT, UPDATE
AS 
    DECLARE 
        @MINSAL MONEY,
        @MAXSAL MONEY,
        @ATUALSAL MONEY
    SELECT @MINSAL = MINSAL, @MAXSAL = MAXSAL FROM SALARIO_RANGE

    SELECT @ATUALSAL = I.SALARIO
    FROM INSERTED I 

    IF(@ATUALSAL < @MINSAL)
    BEGIN
        RAISERROR('SALÁRIO MENOR QUE O PISO!',16,1)
        ROLLBACK TRANSACTION
    END

    IF(@ATUALSAL > @MAXSAL)
    BEGIN
        RAISERROR('SALÁRIO MAIOR QUE O PISO!'.16,1)
        ROLLBACK TRANSACTION
    END
GO

UPDATE EMPREGADO SET SALARIO = 9000.00
WHERE IDEMP = 1
GO

UPDATE EMPREGADO SET SALARIO = 1000.00
WHERE IDEMP = 2
GO

/* PROCEDURES */

CREATE TABLE PESSOA(
    IDPESSOA INT PRIMARY KEY IDENTITY,
    NOME VARCHAR(30) NOT NULL,
    SEXO CHAR(1) NOT NULL CHECK(SEXO IN('M', 'F')),
    NASCIMENTO DATE NOT NULL
)
GO

CREATE TABLE TELEFONE(
    IDTELEFONE INT NOT NULL IDENTITY,
    TIPO CHAR(3) NOT NULL CHECK(TIPO IN('CEL', 'COM')),
    NUMERO CHAR(10) NOT NULL,
    ID_PESSOA INT
)
GO  

ALTER TABLE TELEFONE ADD CONSTRAINT FK_TELEFONE_PESSOA
FOREIGN KEY(ID_PESSOA) REFERENCES PESSOA(IDPESSOA)
ON DELETE CASCADE 
GO

INSERT INTO PESSOA VALUES('ANTONIO', 'M', '1981-02-13')
INSERT INTO PESSOA VALUES('DANIEL', 'M', '1985-03-18')
INSERT INTO PESSOA VALUES('CLEIDE', 'F', '1979-10-13')

INSERT INTO TELEFONE VALUES('CEL', '9879008', 1)
INSERT INTO TELEFONE VALUES('COM', '9720374', 1)
INSERT INTO TELEFONE VALUES('CEL', '9820328', 2)
INSERT INTO TELEFONE VALUES('COM', '9614643', 2)
INSERT INTO TELEFONE VALUES('CEL', '9632145', 3)
INSERT INTO TELEFONE VALUES('COM', '9754862', 3)

-- CRIANDO A PROCEDURE

CREATE PROC SOMA 
AS 
    SELECT 10 + 10 AS SOMA 
GO

-- EXECUÇÃO DA PROCEDURE 

SOMA

EXEC SOMA 
GO

-- DINÂMICAS (COM PARÂMETROS)

CREATE PROC CONTA @NUM1 INT, @NUM2 INT 
AS 
    SELECT @NUM1 + @NUM2
GO

-- EXECUTANDO

EXEC CONTA 90, 78
GO

-- APAGANDO A PROCEDURE 

DROP PROC CONTA
GO

-- PROCEDURES EM TABELAS

SELECT NOME, NUMERO
FROM PESSOA
INNER JOIN TELEFONE
ON IDPESSOA = ID_PESSOA
WHERE TIPO = 'CEL'
GO

-- TRAZER OS TELEFONES DE ACORDO COM O TIPO PASSADO 
CREATE PROC TELEFONES @TIPO CHAR(3)
AS 
    SELECT NOME, NUMERO
    FROM PESSOA
    INNER JOIN TELEFONE
    ON IDPESSOA = ID_PESSOA
    WHERE TIPO = @TIPO
GO

EXEC TELEFONES 'CEL'
GO

EXEC TELEFONES 'COM'
GO

-- PARÂMETROS DE OUTPUT

SELECT TIPO, COUNT(*) AS QUANTIDADE
FROM TELEFONE
GROUP BY TIPO
GO

CREATE PROC GETTIPO @TIPO CHAR(3), @CONTADOR INT OUTPUT
AS
    SELECT @CONTADOR = COUNT(*)
    FROM TELEFONE 
    WHERE TIPO = @TIPO
GO

-- EXECUÇÃO DA PROCEDURE COM PARÂMETRO DE SAÍDA

-- TRANSACTION SQL -> LINGUAGEM QUE O SQL SERVER TRABALHA

DECLARE @SAIDA INT 
EXEC GETTIPO @TIPO = 'CEL', @CONTADOR = @SAIDA OUTPUT
SELECT @SAIDA
GO

DECLARE @SAIDA INT 
EXEC GETTIPO 'CEL', @SAIDA OUTPUT
SELECT @SAIDA
GO

/* PROCEDURES DE CADASTRO */

CREATE PROC CADASTRO @NOME VARCHAR(30), @SEXO CHAR(1), @NASCIMENTO DATE, @TIPO CHAR(3), @NUMERO VARCHAR(10)
AS 
    DECLARE @FK INT 
    
    INSERT INTO PESSOA VALUES(@NOME, @SEXO, @NASCIMENTO) -- GERAR  UM ID

    SET @FK = (SELECT IDPESSOA FROM PESSOA WHERE IDPESSOA = @@IDENTITY)

    INSERT INTO TELEFONE VALUES(@TIPO, @NUMERO, @FK)
GO

CADASTRO 'JORGE', 'M', '1981-01-01', 'CEL', '972738220'
GO

SELECT PESSOA.*, TELEFONE.*
FROM PESSOA
INNER JOIN TELEFONE
ON IDPESSOA = ID_PESSOA
GO

/* TSQL - BLOCO DE PROGRAMAÇÃO */

-- BLOCO DE EXECUÇÃO
BEGIN 
    PRINT 'PRIMEIRO BLOCO'
END
GO

-- BLOCOS DE ATRIBUIÇÃO DE VARIÁVEIS
DECLARE
    @CONTADOR INT 
BEGIN
    SET @CONTADOR = 5
    PRINT @CONTADOR
END
GO

-- NO SQL SERVER CADA COLUNA, VARIÁVEL LOCAL, EXPRESSÃO E PARÂMETRO TEM UM TIPO
DECLARE 
    @V_NUMERO NUMERIC(10,2) = 100.52,
    @V_DATA DATETIME = '20240207'
BEGIN
    PRINT 'VALOR NUMERICO: ' + CAST(@V_NUMERO AS VARCHAR)
    PRINT 'VALOR NUMERICO: ' + CONVERT(VARCHAR, @V_NUMERO)
    PRINT 'VALOR DE DATA: ' + CAST(@V_DATA AS VARCHAR)
    PRINT 'VALOR DE DATA: ' + CONVERT(VARCHAR, @V_DATA, 121)
    PRINT 'VALOR DE DATA: ' + CONVERT(VARCHAR, @V_DATA, 120)
    PRINT 'VALOR DE DATA: ' + CONVERT(VARCHAR, @V_DATA, 105)
END
GO

CREATE TABLE CARROS(
    CARRO VARCHAR(20),
    FABRICANTE VARCHAR(30)
)
GO

INSERT INTO CARROS VALUES('KA, FORD')
INSERT INTO CARROS VALUES('FIESTA, FORD')
INSERT INTO CARROS VALUES('RANGER, FORD')
INSERT INTO CARROS VALUES('PALIO, FIAT')
INSERT INTO CARROS VALUES('CHEVETTE, CHEVROLET')
INSERT INTO CARROS VALUES('458, FERRARI')
INSERT INTO CARROS VALUES('GALLARDO, LAMBORGHINI')
INSERT INTO CARROS VALUES('MUSTANG, FORD')
INSERT INTO CARROS VALUES('GOL, VOLKSWAGEN')
INSERT INTO CARROS VALUES('OPALA, CHEVROLET')

-- ATRIBUINDO RESULTADOS À VARIÁVEIS
DECLARE 
    @V_CONT_FORD INT,
    @V_CONT_FIAT INT
BEGIN
    -- MÉTODO 1 - O SELECT PRECISA RETORNAR UMA SIMPLES COLUNA E UM SÓ RESULTADO
    SET @V_CONT_FORD = (SELECT COUNT(*) FROM CARROS WHERE FABRICANTE = 'FORD')

    PRINT 'QUANTIDADE FORD: ' + CAST(@V_CONT_FORD AS VARCHAR)

    -- MÉTODO 2
    SELECT @V_COUNT_FIAT = COUNT(*) FROM CARROS WHERE FABRICANTE = 'FIAT'

    PRINT 'QUANTIDADE FIAT: ' + CONVERT(VARCHAR, @V_CONT_FIAT)
END
GO

-- ESTRUTURAS CONDICIONAIS
DECLARE 
    @NUMERO INT = 6
BEGIN
    IF @NUMERO = 5 -- EXPRESSÃO BOOLEANA
        PRINT 'O VALOR É VERDADEIRO'
    ELSE
        PRINT 'O VALOR É FALSO'
END
GO

-- CASE
DECLARE 
    @CONTADOR INT 
BEGIN
    SELECT -- O CASE REPRESENTA UMA COLUNA 
    CASE
        WHEN FABRICANTE = 'FIAT' THEN 'FAIXA 1'
        WHEN FABRICANTE = 'CHEVROLET' THEN 'FAIXA 2'
        ELSE 'OUTRAS FAIXAS'
    END AS "INFORMAÇÕES",
    *
    FROM CARROS
END
GO

-- LOOPS WHILE
DECLARE 
    @I INT = 1
BEGIN 
    WHILE(@I < 15)
    BEGIN 
        PRINT 'VALOR DE @I = ' + CAST(@I AS VARCHAR)
    END
END
GO