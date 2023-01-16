--Curriculo de Fernando de Oliveira em T-SQL - 09/07/2021

-----------------
--Dados pessoais
-----------------
IF type_id('dbo.TYPE_TBCV_DADOSPESSOAIS') IS NOT NULL
	DROP TYPE dbo.TYPE_TBCV_DADOSPESSOAIS
GO

CREATE TYPE dbo.TYPE_TBCV_DADOSPESSOAIS 
AS TABLE  
(  
	  NOME				    VARCHAR(40) NOT NULL,
    NACIONALIDADE		VARCHAR(20) NOT NULL,
    IDADE				    INT			NOT NULL,
    ESTADOCIVIL			VARCHAR(10) NOT NULL,
    ENDERECO			  VARCHAR(40) NOT NULL,
    BAIRRO				  VARCHAR(30) NOT NULL,
    CIDADE				  VARCHAR(30) NOT NULL,
    UF					    VARCHAR(2)  NOT NULL,
    TELEFEONE			  VARCHAR(20) NOT NULL,
    TIPO_TEL			  VARCHAR(10),
    EMAIL				    VARCHAR(30),
    REDESOCIAL			VARCHAR(50)
 )  

IF object_id('FCCV_IDADE', 'FN') IS NOT NULL
	DROP FUNCTION dbo.FCCV_IDADE
GO

CREATE FUNCTION FCCV_IDADE(@p_DATA DATE)
RETURNS INTEGER
AS
BEGIN
	DECLARE	@iidade INTEGER = 0;

	SET @iidade = FLOOR(DATEDIFF(MONTH,@p_DATA,GETDATE())/12)
    RETURN @iidade
END;
GO

IF object_id('SPCV_DADOSPESSOAIS', 'P') IS NOT NULL
	DROP PROCEDURE dbo.SPCV_DADOSPESSOAIS
GO

CREATE PROCEDURE dbo.SPCV_DADOSPESSOAIS
AS
BEGIN
	  DECLARE		@TBCV_DADOSPESSOAIS TYPE_TBCV_DADOSPESSOAIS 
	  DECLARE		@csql				VARCHAR(512)
	  DECLARE		@NOME				VARCHAR(40)
    DECLARE		@NACIONALIDADE		VARCHAR(20)
    DECLARE		@IDADE				INT
    DECLARE		@ESTADOCIVIL		VARCHAR(10)
    DECLARE		@ENDERECO			VARCHAR(40)
    DECLARE		@BAIRRO				VARCHAR(30)
    DECLARE		@CIDADE				VARCHAR(30)
    DECLARE		@UF					VARCHAR(2)
    DECLARE		@TELEFEONE			VARCHAR(20)
    DECLARE		@TIPO_TEL			VARCHAR(10)
    DECLARE		@EMAIL				VARCHAR(30)
    DECLARE		@REDESOCIAL			VARCHAR(50)

	  INSERT INTO @TBCV_DADOSPESSOAIS VALUES('Fernando Luis Rozario de Oliveira',
											'Brasileiro',
											dbo.FCCV_IDADE(CAST('04/06/1980' AS DATE)),
											'Casado',
											'Rua Paulo de Souza Freire, 250 apto 701',
											'Sao Mateus',
											'Juiz de Fora',
											'MG',
											'(32)99119-7194',
											'TIM/ZAP',
											'mrclarion@hotmail.com',
											'https://www.99freelas.com.br/user/mrclarion')     
    SELECT @NOME = NOME,
		   @NACIONALIDADE = NACIONALIDADE,
		   @IDADE = IDADE,
		   @ESTADOCIVIL = ESTADOCIVIL,
		   @ENDERECO = ENDERECO,
		   @BAIRRO = BAIRRO,
		   @CIDADE = CIDADE,
		   @UF = UF,
		   @TELEFEONE = TELEFEONE,
		   @TIPO_TEL = TIPO_TEL,
		   @EMAIL = EMAIL,
		   @REDESOCIAL = REDESOCIAL
	FROM @TBCV_DADOSPESSOAIS
    
	SET @csql = @NOME + CHAR(13) + CHAR(10) +
				@NACIONALIDADE + ', ' + CAST(@IDADE AS VARCHAR) + ' anos,' + @ESTADOCIVIL + CHAR(13) + CHAR(10) +
				@ENDERECO + ', ' +  @BAIRRO + CHAR(13) + CHAR(10) +
				@CIDADE + '/' + @UF + CHAR(13) + CHAR(10) +
				@TELEFEONE + '(' + @TIPO_TEL + ')' + CHAR(13) + CHAR(10) +
				@EMAIL + CHAR(13) + CHAR(10) + 
				@REDESOCIAL + CHAR(13) + CHAR(10) +  CHAR(13) + CHAR(10)
           
	PRINT @csql
END
GO 

-----------
--Objetivo
-----------
IF object_id('SPCV_OBJETIVO', 'P') IS NOT NULL
	DROP PROCEDURE dbo.SPCV_OBJETIVO
GO

CREATE PROCEDURE SPCV_OBJETIVO AS
BEGIN
	DECLARE		@csql	VARCHAR(256)

	SET @csql = 'OBJETIVO' + CHAR(13) + CHAR(10) +
				'Desenvolver soluções em TI que atendam às expectativas do cliente, seguindo o princípio KISS!' + CHAR(13) + CHAR(10) +
				'(Keep It Simple Stupid!)' +  CHAR(13) + CHAR(10) +  CHAR(13) + CHAR(10)
				             
	PRINT @csql
END 
GO

----------------------
--Perfil Profissional 
----------------------

IF type_id('dbo.TYPE_TBCV_PERFILPRO') IS NOT NULL
	DROP TYPE dbo.TYPE_TBCV_PERFILPRO
GO

CREATE TYPE dbo.TYPE_TBCV_PERFILPRO
AS TABLE  
(  
	 TIPO				VARCHAR(64)  NOT NULL,
   DESCRICAO	VARCHAR(256) NOT NULL
)  
GO

IF type_id('dbo.TYPE_TBCV_HISTPRO') IS NOT NULL
	DROP TYPE dbo.TYPE_TBCV_HISTPRO
GO

CREATE TYPE dbo.TYPE_TBCV_HISTPRO
AS TABLE  
(  
	  DATAINI				DATE NOT NULL,
    DATAFIM				DATE NOT NULL,
    EMPRESA				VARCHAR(40) NOT NULL,
    FUNCAO				VARCHAR(40) NOT NULL,
    DESCRICAO			VARCHAR(512) NOT NULL,
    CIDADE				VARCHAR(30) NOT NULL,
    UF					  VARCHAR(2) NOT NULL
)  
GO

IF object_id('SPCV_PERFILPROFISSIONAL', 'P') IS NOT NULL
	DROP PROCEDURE dbo.SPCV_PERFILPROFISSIONAL
GO

CREATE PROCEDURE SPCV_PERFILPROFISSIONAL AS
BEGIN
	  DECLARE		@csql				      VARCHAR(1024)
	  DECLARE		@TBCV_PERFILPRO		TYPE_TBCV_PERFILPRO
	  DECLARE		@TBCV_HISTPRO		  TYPE_TBCV_HISTPRO
	  DECLARE		@TIPO				      VARCHAR(64)
    DECLARE		@DESCRICAO			  VARCHAR(512)
	  DECLARE		@DATAINI			    DATE
    DECLARE		@DATAFIM			    DATE
    DECLARE		@EMPRESA			    VARCHAR(40)
    DECLARE		@FUNCAO				    VARCHAR(40)
    DECLARE		@CIDADE				    VARCHAR(30)
    DECLARE		@UF					      VARCHAR(2)
  
	  DECLARE cur_formacao CURSOR FOR   
		        SELECT * FROM @TBCV_PERFILPRO

	  DECLARE cur_historico CURSOR FOR
		        SELECT * FROM @TBCV_HISTPRO ORDER BY DATAINI DESC
  
----------------------
-- Formação
----------------------
    INSERT INTO @TBCV_PERFILPRO VALUES('Escolaridade',
									   'Superior completo' + CHAR(13) + CHAR(10) +
									   'Pos-Graduação em Administração de Banco de dados, Faculdade Estácio de Sá' + CHAR(13) + CHAR(10) +
									   '(Juiz de Fora-MG) (2019)')
                                      
	  INSERT INTO @TBCV_PERFILPRO VALUES('Proficiência em idiomas',
									   'Inglês: leitura fluente, escrita intermediária, conversação intermediária');
                                      
	  INSERT INTO @TBCV_PERFILPRO VALUES('Formação escolar e acadêmica',
									   'Superior de Tecnologia em Sistemas para Internet, Instituto Vianna Júnior' + CHAR(13) + CHAR(10) +
									   '(Juiz de Fora-MG) (2009).')
-------------------------
--Histórico Profissional
-------------------------
	  INSERT INTO @TBCV_HISTPRO VALUES(CAST('01/06/2005' AS DATE),
									 GETDATE(),
									'Upsis Tecnologia em Sistemas',
									'Desenvolvedor de Sistemas/Sócio',
									'Desenvolvimento de softwares comerciais, assessoria à empresa Garcia Atacadista LTDA,' + CHAR(13) + CHAR(10) +
									'na manipulação de grande massa de dados em base Oracle, com suporte ao ERP SANKHYA (MGE/Sankhya OM)',
									'Sapucaia',
									'RJ')
                                
	  INSERT INTO @TBCV_HISTPRO VALUES(CAST('02/04/2002' AS DATE),
									 CAST('28/05/2005'AS DATE),
									'Real e Dados Informática',
									'Instrutor de informática',
									'Treinamento em Hardware (Curso de Montagem e manutenção de PCS)',
									'Salvador',
									'BA')
                                
	  INSERT INTO @TBCV_HISTPRO VALUES(CAST('01/06/2001'AS DATE),
									 CAST('30/10/2003'AS DATE),
									'Êxito Informática',
									'Desenvolvedor de Sistemas/Sócio',
									'Desenvolvimento de software de automação comercial Êxito Plus' + CHAR(13) + CHAR(10) +
									'(Estoque, Vendas, Financeiro, Clientes, Fornecedores, PDV) em ambiente Clarion e ' + CHAR(13) + CHAR(10) +
									'base de dados nativa ISAM(TopSpeed).',
									'Salvador',
									'BA')     
                                
	  INSERT INTO @TBCV_HISTPRO VALUES(CAST('19/08/1998' AS DATE),
									 CAST('30/11/2002' AS DATE),
									'Office Cursos e vendas de equipamentos',
									'Instrutor/Técnico de Informática',
									'Treinamento em Hardware (Curso de Montagem e manutenção de PCS);'  + CHAR(13) + CHAR(10) +
									'Responsável técnico pelo funcionamento do parque de equipamentos do curso.',
									'Salvador',
									'BA')
                                
	  INSERT INTO @TBCV_HISTPRO VALUES(CAST('03/08/1996' AS DATE),
								     CAST('20/12/1997' AS DATE),
									'Digimática Cursos de Informática',
									'Instrutor de informática',
									'Treinamento em ambiente Windows e ferramentas do Pacote Office.',
									'Salvador',
									'BA')

	  SET @csql = 'PERFIL PROFISSIONAL' + CHAR(13) + CHAR(10)
	  PRINT @csql		
  
	  SET @csql = 'FORMAÇÃO' + CHAR(13) + CHAR(10)
	  PRINT @csql
           
	  OPEN cur_formacao
	  WHILE 1=1
	  BEGIN  
		      FETCH NEXT FROM cur_formacao   
		      INTO @TIPO, @DESCRICAO 

		      IF @@FETCH_STATUS <> 0
			       BREAK

          SET @csql = @TIPO + CHAR(13) + CHAR(10) + 
					    @DESCRICAO + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)
          PRINT @csql
	  END 
	  CLOSE cur_formacao
	  DEALLOCATE cur_formacao       
  
    SET @csql = 'HISTÓRICO PROFISSIONAL'  + CHAR(13) + CHAR(10)
	  PRINT @csql
  
	  OPEN cur_historico
		 
	WHILE 1=1  
	BEGIN  
		FETCH NEXT FROM cur_historico   
		INTO @DATAINI, @DATAFIM, @EMPRESA, @FUNCAO, @DESCRICAO, @CIDADE, @UF

		IF @@FETCH_STATUS <> 0
			BREAK

		IF @DATAFIM = CAST(GETDATE() AS DATE) 
			SET @csql = 'Desde ' + SUBSTRING(CONVERT(VARCHAR(10),@DATAINI,103),4,7)
        ELSE
            SET @csql = 'De ' + SUBSTRING(CONVERT(VARCHAR(10),@DATAINI,103),4,7) + ' a ' + SUBSTRING(CONVERT(VARCHAR(10),@DATAFIM,103),4,7)
          
        SET @csql = LTRIM(RTRIM(@csql)) + ' - ' + @EMPRESA + CHAR(13) + CHAR(10) +
					@FUNCAO + CHAR(13) + CHAR(10) +
					@DESCRICAO + CHAR(13) + CHAR(10) +
					@CIDADE + '/' + @UF + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)
        PRINT @csql        
	END
	CLOSE cur_historico 
	DEALLOCATE cur_historico
END
GO

---------------------------------
--Cursos e Treinamentos recentes
---------------------------------
IF type_id('dbo.TYPE_TBCV_CURSOS') IS NOT NULL
	DROP TYPE dbo.TYPE_TBCV_CURSOS
GO

CREATE TYPE dbo.TYPE_TBCV_CURSOS
AS TABLE  
(  
	  ANO           INT NOT NULL,
    DESCRICAO     VARCHAR(512) NOT NULL,
    CARGAHORARIA  INT,
    CIDADE        VARCHAR(30) NOT NULL,
    UF            VARCHAR(2) NOT NULL
)  
GO

IF object_id('SPCV_CURSOS', 'P') IS NOT NULL
	  DROP PROCEDURE dbo.SPCV_CURSOS
GO

CREATE PROCEDURE SPCV_CURSOS AS
BEGIN
	DECLARE		@csql			    VARCHAR(512)
	DECLARE		@TBCV_CURSOS	TYPE_TBCV_CURSOS
	DECLARE		@ANO			    INT
	DECLARE		@DESCRICAO		VARCHAR(512)
	DECLARE		@CARGAHORARIA	INT
	DECLARE		@CIDADE			  VARCHAR(30)
	DECLARE		@UF				    VARCHAR(2)
  
  DECLARE cur_curso CURSOR FOR   
	        SELECT * FROM @TBCV_CURSOS ORDER BY ANO DESC
    
	INSERT INTO @TBCV_CURSOS VALUES(2014,
									'Formação essencial em PHP - Tempo Real Eventos',
									32,
									'São Paulo',
									'SP')

	SET @csql = 'CURSOS/TREINAMENTOS RECENTES' + CHAR(13) + CHAR(10)
	PRINT @csql
  
	OPEN cur_curso
	WHILE 1=1
	BEGIN  
		FETCH NEXT FROM cur_curso   
		INTO @ANO, @DESCRICAO,  @CARGAHORARIA, @CIDADE, @UF 

		IF @@FETCH_STATUS <> 0
			BREAK

		SET @csql = @DESCRICAO + ' - ' +
					CASE WHEN @CARGAHORARIA IS NOT NULL THEN ' - CH: ' + CAST(@CARGAHORARIA AS VARCHAR)  + ' hs' ELSE '' END +
					'(' + @CIDADE + '/' + @UF + ') - ' + CAST(@ANO AS VARCHAR) + CHAR(13) + CHAR(10)
		PRINT @csql
	END 
	CLOSE cur_curso
	DEALLOCATE cur_curso   
	
	SET @csql = CHAR(13) + CHAR(10)
	PRINT @csql         
END
GO

----------------------------------------
--Pretensão salarial / Disponibilidade
----------------------------------------
IF object_id('SPCV_PRETENSAO', 'P') IS NOT NULL
	DROP PROCEDURE dbo.SPCV_PRETENSAO
GO

CREATE PROCEDURE SPCV_PRETENSAO AS
BEGIN
	DECLARE		@csql		    VARCHAR(256)
	DECLARE		@nvalor     NUMERIC(7,2) = 2500
	DECLARE		@ihoras     INT = 20
  
  SET @csql = 'PRETENSÃO SALARIAL / DISPONIBILIDADE' + CHAR(13) + CHAR(10)
	PRINT @csql
  
	SET @csql = FORMAT(@nvalor,'#,##0.00') + ' p/ mês em regime Home-office (PJ) em ' + CAST(@ihoras AS VARCHAR) + 
				' horas semanais, com  ' + CHAR(13) + CHAR(10) +
				'disponibilidade de ir até a empresa uma vez por mê para reuniões e alinhamento das tarefas (custos por conta do contratante).' + 
				CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)
    PRINT @csql
END 
GO

-----------------------------
--Informações Complementares
-----------------------------
IF object_id('SPCV_INFOCOMPLEMENTARES', 'P') IS NOT NULL
	  DROP PROCEDURE dbo.SPCV_INFOCOMPLEMENTARES
GO

CREATE PROCEDURE SPCV_INFOCOMPLEMENTARES AS
BEGIN
	DECLARE	@csql	VARCHAR(512)

	SET @csql = 'INFORMAÇÕES COMPLEMENTARES' + CHAR(13) + CHAR(10)
	PRINT @csql
  
	SET @csql = 'Sólidos conhecimentos nos SGDBs:' + CHAR(13) + CHAR(10)
	PRINT @csql
  
	SET @csql = 'Oracle(PL/SQL)' + CHAR(13) + CHAR(10) +
				'SQL Server(Transact-SQL)' + CHAR(13) + CHAR(10) + 
				'PostgreSQL(PL/pgSQL)' + CHAR(13) + CHAR(10) + 
				'MySQL' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)
	PRINT @csql
  
	SET @csql = 'Conhecimento nas seguintes linguagens/ambientes de programação (em ordem decrescente de domínio):' + CHAR(13) + CHAR(10)
	PRINT @csql
  
	SET @csql  = 'Clarion' + CHAR(13) + CHAR(10) + 
				 'ScriptCase/PHP' + CHAR(13) + CHAR(10) +
				 'C#' + CHAR(13) + CHAR(10) + 
				 'ASP (VBScript)' + CHAR(13) + CHAR(10) +
			     'Windev' + CHAR(13) + CHAR(10) + 
				 'Java(Android)' + CHAR(13) + CHAR(10) + 
				 'Delphi' + CHAR(13) + CHAR(10) +  
				 'Softwell Maker' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)
	PRINT @csql
  
	SET @csql = 'Desenvolvimento de emissor de NFe próprio em C#. Apesar de conhecer o UniNFe da Unimake,' + CHAR(13) + CHAR(10) + 
				 'resolvi desenvolver um emissor próprio por presenciar alguns bugs e limitações na ferramenta que ' + CHAR(13) + CHAR(10) + 
				 'geram insegurança ao cliente final;' + CHAR(13) + CHAR(10)
	PRINT @csql    
  
	SET @csql = 'Desenvolvimento de aplicações na plataforma Android (WinDev);' + CHAR(13) + CHAR(10)
	PRINT @csql   
  
	SET @csql = 'Experiência em análise/modelagem, na concepção de MER e DER;' + CHAR(13) + CHAR(10)
	PRINT @csql  
  
	SET @csql = 'Desenvolvimento de rotinas de integração (EDI) para Neogrid, Mtrix e Accera;' + CHAR(13) + CHAR(10) 
	PRINT @csql
  
	SET @csql = 'Habilitação categoria B (veículo próprio).' + CHAR(13) + CHAR(10)
	PRINT @csql
  
	SET @csql = CHAR(13) + CHAR(10) + CONVERT(VARCHAR(10),GETDATE(),103)
	PRINT @csql
END
GO

----------------------
--OUTPUT DO CURRICULO
----------------------
SET NOCOUNT ON
EXEC SPCV_DADOSPESSOAIS
EXEC SPCV_OBJETIVO
EXEC SPCV_PERFILPROFISSIONAL
EXEC SPCV_CURSOS
EXEC SPCV_PRETENSAO
EXEC SPCV_INFOCOMPLEMENTARES
----------------------
--FIM
----------------------
