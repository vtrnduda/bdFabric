# Sistema de Controle e Gerenciamento de Projetos - FABRIC

Este projeto consiste em um sistema especializado para controle e gerenciamento de atividades da Fábrica de Software da Faculdade UniEsquina (FABRIC). O sistema foi desenvolvido para atender às necessidades específicas de cadastro e acompanhamento de projetos, assim como o gerenciamento de informações dos funcionários envolvidos.

## Descrição Geral
A FABRIC atrai discentes para projetos práticos, demandando um sistema capaz de cadastrar projetos, atribuir cargos aos funcionários e manter dados cadastrais atualizados. Existem dois tipos principais de projetos: financeiros e administrativos, cada um com informações distintas a serem registradas. O sistema também é responsável por manter o controle de falhas nos projetos financeiros por meio de testes, além de gerar relatórios com detalhes dos projetos realizados por cada funcionário em seus respectivos setores.

## Regras do Negócio
- Cadastramento de projetos com detalhes como descrição, orçamento, identificação e data de início.
- Atribuição de cargos para os funcionários, mantendo seus dados cadastrais como matrícula, nome, endereço, etc.
- Distinção entre projetos financeiros e administrativos, registrando patrocinadores e verba limite, respectivamente.
- Atualização contínua dos dados cadastrais de projetos e funcionários.
- Registro de falhas nos projetos financeiros através de testes.
- Controle de tempo para conclusão de todos os projetos.
- Acompanhamento da criticidade das falhas dos projetos e 
- Registro e verificação das datas de entrada e saída de cada funcionário em um projeto.
- Geração de relatórios detalhados dos projetos por funcionário e por setor.

## Requisitos Funcionais
- Identificação de funcionários por setor.
- Cadastro de funcionários.
- Cadastro de projetos.
- Validação de cargos.
- Verificação de ajuste salarial.
- Avaliação da gravidade das falhas nos projetos.
- Gerenciamento de funcionários (autorelacionamento).
- Gerenciamento de projetos (administrativos ou financeiros).
- Inclusão de dependentes.
- Registro e verificação de datas de entrada e saída nos projetos.
- Registro e verificação de falhas nos projetos.
- verificação do progresso do projeto.
- Avaliação da senioridade do funcionário.
- Manutenção dos dados cadastrais de funcionários e projetos.

## Requisitos de Dados
- Setor
- Cargo
- Funcionário
- Dependentes
- Projetos
- Teste
- Falhas do projeto