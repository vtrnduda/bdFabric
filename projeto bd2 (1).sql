
--TSI - IFPB - PROJETO DE BANCO DE DADOS RELACIONAIS (POSTGRESQL)

--Discentes: Sammuel Luna e Maria Eduarda Vitorino
--Docentes: Damires Yluska de Souza Fernandes e Thiago Jose Marques Moura






--CRIAÇÃO DAS TABELAS

CREATE TABLE setor (
    id_setor INT NOT NULL PRIMARY KEY,
    sigla VARCHAR(45) NOT NULL
);

CREATE TABLE cargo (
    cod_cargo INT NOT NULL PRIMARY KEY,
    descricao VARCHAR(150) NOT NULL,
    salario INT NOT NULL,
    data_ultimo_ajuste_salarial DATE NOT NULL
);

CREATE TABLE cartao (
    cod_cartao INT NOT NULL PRIMARY KEY,
    data_ult_prog DATE NOT NULL,
    categoria CHAR(1) NOT NULL CHECK (categoria IN ('J', 'S'))
);

CREATE TABLE funcionario (
    matricula SERIAL NOT NULL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sexo CHAR(1) CHECK (sexo IN ('F', 'M')),
    rua VARCHAR(45) NOT NULL,
    numero INT,
    bairro VARCHAR(45) NOT NULL,
    cidade VARCHAR(55) NOT NULL,
    cep CHAR(8) NOT NULL,
    data_nasc DATE NOT NULL CHECK (EXTRACT(YEAR FROM data_nasc) < 2004),
    setor_id INT NOT NULL REFERENCES setor(id_setor),
    cargo_cod_cargo INT NOT NULL REFERENCES cargo(cod_cargo),
    cartao_cod_cartao INT NOT NULL REFERENCES cartao(cod_cartao),
    gerencia INT REFERENCES funcionario(matricula),
    efetivo BOOLEAN NOT NULL
);

CREATE TABLE dependente (
    id_dependente INT NOT NULL,
    nome VARCHAR(150) NOT NULL,
    data_nascimento DATE NOT NULL CHECK (EXTRACT(YEAR FROM data_nascimento) < 2023),
    grau_parentesco VARCHAR(45) NOT NULL,
    funcionario_matricula INT UNIQUE NOT NULL REFERENCES funcionario(matricula),
    PRIMARY KEY (id_dependente, funcionario_matricula)
);

CREATE TABLE telefone (
    telefone VARCHAR(45) NOT NULL,
	funcionario_matricula INT NOT NULL REFERENCES funcionario(matricula),
	PRIMARY KEY (telefone, funcionario_matricula)
);

CREATE TABLE projeto (
    id_projeto INT NOT NULL PRIMARY KEY,
    descricao_projeto VARCHAR(150) NOT NULL,
    orcamento VARCHAR(45) NOT NULL,
    data_inicio DATE NOT NULL
);

CREATE TABLE desenvolve (
    data_entrada DATE NOT NULL,
    data_saida DATE,
    funcionario_matricula INT NOT NULL REFERENCES funcionario(matricula) ON DELETE CASCADE,
    projeto_id_projeto INT NOT NULL REFERENCES projeto(id_projeto),
    PRIMARY KEY (funcionario_matricula, projeto_id_projeto)
);

CREATE TABLE teste (
    financeiro_projeto_id_projeto INT NOT NULL,
    funcionario_matricula INT NOT NULL,
    PRIMARY KEY (financeiro_projeto_id_projeto, funcionario_matricula),
    FOREIGN KEY (financeiro_projeto_id_projeto) REFERENCES projeto(id_projeto),
    FOREIGN KEY (funcionario_matricula) REFERENCES funcionario(matricula) ON DELETE CASCADE
);

CREATE TABLE falhas_do_projeto (
    cod_falha INT PRIMARY KEY,
    descricao_falha VARCHAR(150),
    nivel_falha CHAR(5) CHECK (nivel_falha IN ('baixo', 'medio', 'grave'))
);

CREATE TABLE registra (
    teste_financeiro_projeto_id_projeto INT NOT NULL,
    teste_funcionario_matricula INT NOT NULL,
    falhas_do_projeto_cod_falha INT NOT NULL,
    PRIMARY KEY (teste_financeiro_projeto_id_projeto, teste_funcionario_matricula, falhas_do_projeto_cod_falha),
    FOREIGN KEY (teste_financeiro_projeto_id_projeto, teste_funcionario_matricula) REFERENCES teste(financeiro_projeto_id_projeto, funcionario_matricula) ON DELETE CASCADE,
    FOREIGN KEY (falhas_do_projeto_cod_falha) REFERENCES falhas_do_projeto(cod_falha)
);

CREATE TABLE administrativo (
    verba_limite INT NOT NULL,
    projeto_id_projeto INT NOT NULL PRIMARY KEY,
    FOREIGN KEY (projeto_id_projeto) REFERENCES projeto(id_projeto)
);

CREATE TABLE financeiro (
    patrocinador VARCHAR(150) NOT NULL,
    projeto_id_projeto INT NOT NULL PRIMARY KEY,
    FOREIGN KEY (projeto_id_projeto) REFERENCES projeto(id_projeto)
);






---------------------QUESTÃO 2AI----------------------

INSERT INTO setor (id_setor, sigla) VALUES
    (1, 'Desenvolvimento'),
    (2, 'Qualidade'),
    (3, 'Gerência'),
    (4, 'Infraestrutura'),
    (5, 'Marketing');

INSERT INTO cargo (cod_cargo, descricao, salario, data_ultimo_ajuste_salarial) VALUES
    (1, 'Desenvolvedor FullStack', 6000, '2022-01-01'),
    (2, 'Analista de Qualidade', 5500, '2022-03-15'),
    (3, 'Product Owner', 8000, '2022-02-20'),
    (4, 'Analista de Infraestrutura', 6500, '2022-04-10'),
    (5, 'Especialista de Marketing', 7000, '2022-05-05');

INSERT INTO cartao (cod_cartao, data_ult_prog, categoria) VALUES
    (101, '2022-01-01', 'J'),
    (102, '2022-02-15', 'S'),
    (103, '2022-03-20', 'J'),
    (104, '2022-04-10', 'S'),
    (105, '2022-05-05', 'J'),
	(109, '2022-04-10', 'J'),
	(110, '2022-05-05', 'J');
	
INSERT INTO funcionario (matricula, nome, sexo, rua, numero, bairro, cidade, cep, data_nasc, setor_id, cargo_cod_cargo, cartao_cod_cartao, gerencia, efetivo) VALUES
    (1, 'Maria Santos', 'F', 'Rua A', 100, 'Centro', 'Cidade A', '12345678', '1990-03-12', 1, 1, 101, NULL, true),
    (2, 'João Silva', 'M', 'Rua B', 200, 'Bairro B', 'Cidade B', '23456789', '1985-05-20', 1, 2, 102, NULL, true),
    (3, 'Laura Oliveira', 'F', 'Rua C', 300, 'Bairro C', 'Cidade C', '34567890', '1995-07-10', 3, 3, 103, 1, true),
    (4, 'Pedro Pereira', 'M', 'Rua D', 400, 'Bairro D', 'Cidade D', '45678901', '1988-09-18', 2, 4, 104, 2, true),
    (5, 'Gabriel Ferreira', 'M', 'Rua E', 500, 'Bairro E', 'Cidade E', '56789012', '1993-11-25', 5, 5, 105, 3, true),
	(9, 'Gustavo Ferreira', 'M', 'Rua I', 900, 'Bairro I', 'Cidade I', '90123456', '1990-04-05', 4, 4, 109, NULL, false),
    (10, 'Camila Silva', 'F', 'Rua J', 1000, 'Bairro J', 'Cidade J', '01234567', '1995-12-20', 5, 5, 110, NULL, false);

--update para mudar datas de funcionarios não-efetivos (possíveis estagiários?)
UPDATE funcionario
SET data_nasc = '2001-05-20'
WHERE matricula = 9;

UPDATE funcionario
SET data_nasc = '2003-11-25'
WHERE matricula = 10;
   
INSERT INTO dependente (id_dependente, nome, data_nascimento, grau_parentesco, funcionario_matricula) VALUES
    (1, 'Lucas Santos', '2010-02-28', 'Filho', 1),
    (2, 'Sophia Silva', '2008-06-15', 'Filha', 2),
    (3, 'Davi Oliveira', '2015-08-20', 'Filho', 3),
    (4, 'Lara Pereira', '2012-10-10', 'Filha', 4),
    (5, 'Giovanna Ferreira', '2017-12-05', 'Filha', 5);

INSERT INTO telefone (telefone, funcionario_matricula) VALUES
    ('11111111', 1),
    ('22222222', 2),
    ('33333333', 3),
    ('44444444', 4),
    ('55555555', 5),
	('99999999', 9),
	('10101010', 10);
	
INSERT INTO projeto (id_projeto, descricao_projeto, orcamento, data_inicio) VALUES
    (1, 'Desenvolvimento Sistema de Gestão', '100000', '2022-01-15'),
    (2, 'Implantação de Processos de Qualidade', '150000', '2022-03-20'),
    (3, 'Gestão de Equipes', '80000', '2022-02-10'),
    (4, 'Atualização de Infraestrutura', '120000', '2022-04-05'),
    (5, 'Campanha Publicitária Online', '90000', '2022-05-01'),
	(6, 'Projeto de Inovação Tecnológica', '200000', '2023-07-10'),
    (7, 'Melhoria de Processos Internos', '180000', '2023-08-15'),
    (8, 'Expansão de Mercado Internacional', '250000', '2023-09-20');
    
INSERT INTO teste (financeiro_projeto_id_projeto, funcionario_matricula) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
	(4, 5),
    (1, 4),
    (5, 3);

INSERT INTO falhas_do_projeto (cod_falha, descricao_falha, nivel_falha) VALUES
    (1, 'Bug crítico no sistema', 'grave'),
    (2, 'Problemas de documentação', 'medio'),
    (3, 'Falha na comunicação', 'baixo'),
    (4, 'Dificuldade de implementação', 'grave'),
    (5, 'Desvio de prazos', 'medio');
	
INSERT INTO registra (teste_financeiro_projeto_id_projeto, teste_funcionario_matricula, falhas_do_projeto_cod_falha)
VALUES
    (1, 1, 1),
    (2, 2, 2),
    (3, 3, 3),
    (4, 5, 4),
    (1, 4, 5),
    (5, 3, 1);
	
INSERT INTO desenvolve (data_entrada, data_saida, funcionario_matricula, projeto_id_projeto) VALUES
	('2022-01-15', '2022-05-30', 1, 1),
    ('2022-03-20', '2022-08-15', 2, 2),
    ('2022-02-10', NULL, 3, 3),
    ('2022-04-05', NULL, 4, 4),
    ('2022-05-01', NULL, 5, 5),
	('2022-01-15', '2022-05-30', 2, 1), 
	('2023-07-11', NULL, 9, 6),
	('2023-08-23', NULL, 10, 7),
	('2023-09-28', NULL, 5, 8);
	
INSERT INTO administrativo (verba_limite, projeto_id_projeto) VALUES
    (50000, 6),
    (75000, 7),
    (40000, 8);

INSERT INTO financeiro (patrocinador, projeto_id_projeto) VALUES
    ('ByteMaster Inc.', 1),
    ('TechTudo', 2),
    ('Codezilla', 3),
    ('CyberRocket', 4),
    ('NerdNest', 5);






---------------------QUESTÃO 2AII----------------------

--1 consulta com uma tabela usando operadores básicos de filtro (e.g., IN, between, is null, etc).

SELECT * FROM funcionario
WHERE data_nasc BETWEEN '1985-01-01' AND '1990-12-31';
--seleciona os funcionários que nasceram entre 1985 e 1990



--3 consultas com inner JOIN na cláusula FROM (pode ser self join, caso o
--domínio indique esse uso).

SELECT f.nome AS nome_funcionario, s.sigla AS sigla_setor
FROM funcionario f INNER JOIN setor s on f.setor_id = s.id_setor;
-- retorna todos os funcionários e o nome dos respectivos setores.

SELECT p.descricao_projeto, f.nome AS nome_funcionario
FROM projeto p
INNER JOIN desenvolve d ON p.id_projeto = d.projeto_id_projeto
INNER JOIN funcionario f ON d.funcionario_matricula = f.matricula;
--retorna todos os projetos e os funcionários que estão trabalhando neles.

SELECT f.nome AS nome_funcionario, p.descricao_projeto, fd.descricao_falha
FROM funcionario f
INNER JOIN registra r ON f.matricula = r.teste_funcionario_matricula
INNER JOIN projeto p ON r.teste_financeiro_projeto_id_projeto = p.id_projeto
INNER JOIN falhas_do_projeto fd ON r.falhas_do_projeto_cod_falha = fd.cod_falha;
--retorna o funcionario que registrou a falha, juntamente coom o projeto associado e a descrição da falha



--1 consulta com left/right/full outer join na cláusula FROM

SELECT f.nome AS nome_funcionario, d.nome AS nome_dependente
FROM funcionario f
LEFT JOIN dependente d ON f.matricula = d.funcionario_matricula;
--retorna os funcionários que possuem dependentes, considerando todos os registros da tabela à esquerda, ou seja, mostra também os funcionários que não possuem dependentes.



--2 consultas usando Group By (e possivelmente o having)

SELECT c.descricao AS cargo, AVG(c.salario) AS media_salario FROM cargo c
GROUP BY c.descricao
HAVING AVG(c.salario) > 6500;
--retorna a média de salário por cargo, agrupando pelo cargo e considerando apenas aqueles maiores de 6500 reais.

SELECT setor_id, COUNT(*) AS total_funcionarios
FROM funcionario
GROUP BY setor_id;
--mostra a quantidade de funcionários por setor.



--1 consulta usando alguma operação de conjunto (union, except ou intersect)

SELECT c.cod_cartao, c.categoria, f.nome AS nome_funcionario
FROM cartao c
JOIN funcionario f ON c.cod_cartao = f.cartao_cod_cartao

EXCEPT

SELECT c.cod_cartao, c.categoria, f.nome AS nome_funcionario
FROM cartao c
JOIN funcionario f ON c.cod_cartao = f.cartao_cod_cartao
WHERE c.categoria = 'S';
--retorna funcionários que possuem cartões,m exceto os que sãio da categoria senior.



--2 consultas que usem subqueries.

SELECT COUNT(*) AS num_funcionarios_com_dependentes
FROM (
    SELECT DISTINCT funcionario_matricula
    FROM dependente
) AS funcionarios_com_dependentes;
--retorna o número de funcionários com dependentes.

SELECT f.nome, f.cargo_cod_cargo, c.descricao
FROM funcionario f
JOIN cargo c ON f.cargo_cod_cargo = c.cod_cargo
WHERE f.cargo_cod_cargo IN (
    SELECT cod_cargo
    FROM cargo
    WHERE salario > 6000
);
--retorna o nome do funcionário, o codigo do seu respectivo cargo e a descrição desses cargos cujo salário é maior que 6000






---------------------QUESTÃO 2B----------------------

--1 visão que permita inserção

CREATE OR REPLACE VIEW view_funcionario_efetivo AS
SELECT * FROM funcionario
WHERE efetivo = true;
-- seleciona todas as informações de todos os funcionários nos quais os mesmos sejam efetivos.



--2 visões robustas (e.g., com vários joins) com justificativa semântica, de acordo com os
--requisitos da aplicação.

CREATE OR REPLACE VIEW view_funcionario_detalhes AS
SELECT
    f.matricula AS funcionario_matricula,
    f.nome AS funcionario_nome,
    s.sigla AS setor_sigla,
    c.descricao AS cargo,
    c.salario AS salario,
    car.categoria AS cartao_categoria
FROM funcionario f
JOIN setor s ON f.setor_id = s.id_setor
JOIN cargo c ON f.cargo_cod_cargo = c.cod_cargo
JOIN cartao car ON f.cartao_cod_cartao = car.cod_cartao;
-- seleciona as colunas com detalhes relevantes dos funcionários, tais como seu setor, cargo, salario e categoria de seu respectivo cartão, por meio de joins em tabelas ligadas por fks


CREATE OR REPLACE VIEW view_funcionario_projeto AS
SELECT
    f.matricula AS funcionario_matricula,
    f.nome AS funcionario_nome,
    p.id_projeto, p.descricao_projeto
FROM teste t
JOIN funcionario f ON t.funcionario_matricula = f.matricula
JOIN projeto p ON t.financeiro_projeto_id_projeto = p.id_projeto;
-- lista os funcionários e seus respectivos projetos por meio de um join utilizando das chaves presentes na tabela teste






--------------------QUESTÃO 2C----------------------

CREATE INDEX idx_data_nasc ON funcionario(data_nasc); -- para consultas que filtram por idade ou por data de nascimento. Campos consultados em forma de intervalo são um grande potencial para indice

CREATE INDEX idx_falha ON falhas_do_projeto(descricao_falha); --útil para consultas e filtragens em falhas do projeto

CREATE INDEX idx_funcionario_projeto ON desenvolve(funcionario_matricula, projeto_id_projeto); --útil para verificar a presença de funcinários nos projetos, indicado para consultas com joins






---------------------QUESTÃO 2D----------------------

--Identificar 2 exemplos de consultas dentro do contexto da aplicação (questão 2.a) que
--possam e devam ser melhoradas. Reescrevê-las. Justificar a reescrita.

--Exemplo 1: Consulta utilizando operação de conjunto (except). Versão melhorada:

SELECT f.nome AS nome_funcionario
FROM funcionario f
JOIN cartao c ON f.cartao_cod_cartao = c.cod_cartao
WHERE c.categoria = 'J';
-- Com apenas um JOIN simples, e apenas 4 linhas de código, é possível filtrar pela categoria desejada. Uma consulta mais performática e ágil.



-- Exemplo 2 e 3: Consultas com subqueries. Versões melhoradas:

SELECT COUNT(DISTINCT funcionario_matricula) AS num_funcionarios_com_dependentes
FROM dependente;
--Menos linas de código, maior entendimento e clareza acerca do objetivo da consulta


SELECT f.nome, f.cargo_cod_cargo, c.descricao
FROM funcionario f
JOIN cargo c ON f.cargo_cod_cargo = c.cod_cargo
WHERE c.salario > 6000;
-- Novamente, com apenas um JOIN simples é possível verificar os salarios maiores que 6000 por nome, codigo e cargo. Não é necessário o uso de JOIN + subquery.






---------------------QUESTÃO 2E----------------------

--1 função que use SUM, MAX, MIN, AVG ou COUNT

CREATE OR REPLACE FUNCTION QuantFuncionariosEmProjeto(project_id INT) 
RETURNS INT AS $$
DECLARE
    count INT;
BEGIN
    SELECT COUNT(*)
    INTO count
    FROM desenvolve
    WHERE projeto_id_projeto = project_id
    AND data_saida IS NULL; -- Verifica se a data de saída é nula, o que indica que o funcionário ainda está no projeto

    RETURN count;
END;
$$ LANGUAGE plpgsql;
-- Essa função retorna a quantidade de funcionários ativos naquele projeto, ou seja, funcionários que não possuem a data de saída.

SELECT QuantFuncionariosEmProjeto(2); -- retorna 1,apesar de haver 2 funcionários cadastrados, pois a função leva em conta apenas os funcionários que não encerraram as atividades naquele projeto.


--insert para validar a participação de mais de um funcionário em um projeto
insert into desenvolve (data_entrada, funcionario_matricula, projeto_id_projeto) VALUES 
	('2022-02-20', 1, 2);



--2 funções e 1 procedure com justificativa semântica, conforme os requisitos da aplicação

CREATE OR REPLACE FUNCTION BuscarDependentes(func_id INT)
RETURNS varchar
AS $$
DECLARE
    dep_name varchar(150);
BEGIN
	SELECT nome INTO dep_name
	FROM dependente
	WHERE funcionario_matricula = func_id;
	
	IF NOT FOUND THEN
        RAISE EXCEPTION 'Nenhum dependente encontrado. Verifique o código do funcionário';
    END IF;
	RETURN dep_name;
	EXCEPTION
        WHEN raise_exception THEN
            RETURN SQLERRM;
		WHEN OTHERS THEN
			RETURN 'Erro Desconhecido';
END; 
$$ LANGUAGE plpgsql;


SELECT BuscarDependentes(3);
SELECT BuscarDependentes(9);

--Função que busca o dependente daquele funcionário, Baseando-se no id do funcionário. Essa função trata exceção para caso haja um funcionário sem dependentes, usando o RAISE EXCEPTION e o bloco EXCEPTION para capturar e tratar.


CREATE OR REPLACE FUNCTION BuscarFalhasCriticasPorProjeto(projeto_id INT)
RETURNS TABLE (codigoFalha INT, descricaoFalha VARCHAR(150), nivelFalha CHAR(5))
AS $$
BEGIN
    RETURN QUERY
    SELECT f.cod_falha, f.descricao_falha, f.nivel_falha
    FROM falhas_do_projeto f
    JOIN registra r ON cod_falha = falhas_do_projeto_cod_falha
    WHERE teste_financeiro_projeto_id_projeto = projeto_id AND nivel_falha = 'grave';
END;
$$ LANGUAGE plpgsql;

SELECT BuscarFalhasCriticasPorProjeto(1);
--Essa função retorna todas as falhas críticas do projeto desejado.

/*
->> OPÇÃO PARA BUSCAR TODAS AS FALHAS CRÍTICAS, INDEPENDENTEMENTE DE PROJETO <<--

CREATE OR REPLACE FUNCTION BuscarFalhasCriticas()
RETURNS TABLE (projeto_id INT, cod_falha INT, descricao_falha VARCHAR(150), nivel_falha CHAR(5))
AS $$
BEGIN
    RETURN QUERY
    SELECT r.teste_financeiro_projeto_id_projeto, f.cod_falha, f.descricao_falha, f.nivel_falha
    FROM falhas_do_projeto f
    JOIN registra r ON f.cod_falha = r.falhas_do_projeto_cod_falha
    WHERE f.nivel_falha = 'grave';
END;
$$ LANGUAGE plpgsql;
*/


CREATE OR REPLACE PROCEDURE AtualizarOrcamentoProjeto(projeto_id INT, novo_orcamento VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE projeto
    SET orcamento = novo_orcamento
    WHERE id_projeto = projeto_id;
        
    RAISE NOTICE 'O orçamento do projeto % foi atualizado para %', projeto_id, novo_orcamento;
EXCEPTION
    WHEN others THEN
        RAISE EXCEPTION 'Ocorreu um erro ao atualizar o orçamento do projeto %', projeto_id;
END;
$$;
--A procedure acima atualiza o orçamento do projeto, uma vez que ele pode ser variável no decorrer do tempo.

SELECT * FROM projeto;

CALL AtualizarOrcamentoProjeto(2, '50000');

SELECT * FROM projeto;






---------------------QUESTÃO 2F----------------------

--3 diferentes triggers com justificativa semântica, de acordo com os requisitos da
--aplicação.

CREATE OR REPLACE FUNCTION verifica_criar_cartao()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM cartao WHERE cod_cartao = NEW.cartao_cod_cartao) THEN
        INSERT INTO cartao (cod_cartao, data_ult_prog, categoria)
        VALUES (NEW.cartao_cod_cartao, CURRENT_TIMESTAMP, 'J');
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_criar_cartao
BEFORE INSERT ON funcionario
FOR EACH ROW EXECUTE FUNCTION verifica_criar_cartao();
-- verifica, no momento precedente à inserção de uma linha na tabela de funcionários, a existencia do cartão passado caso não exista, um cartão de categoria Júnior será automaticamente gerado

CREATE OR REPLACE FUNCTION deletar_dependentes()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM dependente
    WHERE funcionario_matricula = OLD.matricula;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_deletar_dependentes
BEFORE DELETE ON funcionario
FOR EACH ROW
EXECUTE FUNCTION deletar_dependentes();
-- após a remoção de um funcionário, seus respectivos dependentes serão buscados e propriamente removidos da tabela dependente

CREATE OR REPLACE FUNCTION deletar_telefones()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM telefone
    WHERE funcionario_matricula = OLD.matricula;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_deletar_telefones
BEFORE DELETE ON funcionario
FOR EACH ROW
EXECUTE FUNCTION deletar_telefones();
-- após a remoção de um funcionário, seus respectivos números de telefone serão buscados e propriamente removidos da tabela telefone

-------------------------