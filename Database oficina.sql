create database oficina;
use oficina;

-- criar tabela cliente
create table clients(
	idClient int auto_increment primary key,
    Nome varchar (45) not null,
    Endereço char (3),
    CPF char (11) not null,
    RG varchar (11) not null,
    Telefone varchar (15) not null,
    constraint unique_cpf_client unique (CPF),
    constraint unique_rg_client unique (RG)
);

-- criar tabela veículo
create table veículo(
     idVeiculo int auto_increment primary key,
     idVeiculoClient int,
     Marca varchar (20),
     Modelo varchar (20),
     Ano varchar (4),
     Cor varchar (20),
     Placa varchar (7),
     Tipo varchar (20),
     constraint fk_veiculo_client foreign key (idVeiculoClient) references clients (idClient)
);

-- criar tabela ordem de serviço
create table requisicao(
    idRequisicao int auto_increment primary key,
    idRequisicao_Veiculo int,
    idRequisicao_Cliente int,
    Dia_da_emissão date,
    Dia_da_entrega date,
    Serviço varchar (50),
    Situação varchar (50) default 'Em andamento',
    constraint fk_requisicao_client foreign key (idRequisicao_Cliente) references clients (idClient),
    constraint fk_requisicao_veiculo foreign key (idRequisicao_Veiculo) references veículo (idVeiculo)
);

-- criar tabela autorização de serviço
create table autorizacao(
    idAutorizacao int auto_increment primary key,
    idAutorizacaoRequisicao int,
    idAutorizacaoCliente int,
    dia_da_autorização date,
    constraint fk_autorizacao_requisicao foreign key (idAutorizacaoRequisicao) references requisicao (idRequisicao),
    constraint fk_autorizacao_cliente foreign key (idAutorizacaoCliente) references clients (idClient)
);

-- criar tabela tipo de serviço
create table tiposervico(
    idTipoServico int auto_increment primary key,
    idTipoServicoRequisicao int,
    idTipoServicoAutorizacao int,
    descricao text,
    constraint fk_tiposervico_requisicao foreign key (idTipoServicoRequisicao) references requisicao (idRequisicao),
    constraint fk_tiposervico_autorizacao foreign key (idTipoServicoAutorizacao) references autorizacao (idAutorizacao)
);

-- criar tabela equipe de mecânicos
create table equipe(
    idEquipe int auto_increment primary key,
   nome_equipe varchar(100)
);

-- criar tabela mecânico
create table mecânico(
    idMecanico int auto_increment primary key,
    idEquipeMecanico int,
    nome varchar(100),
    constraint fk_mecanico_equipe foreign key (idEquipeMecanico) references equipe (idEquipe)
);

-- criar tabela peça
create table peca(
    idPeca int auto_increment primary key,
    nome_peca varchar(100),
    valor_unitario numeric (10,2)
);

-- criar tabela lista de peças utilizadas na OS
create table listapecas(
    idListaPecas int auto_increment primary key,
    idPecaLista int,
    idRequisicaoPeca int,
    quantidade int,
    constraint fk_lista_peca foreign key (idPecaLista) references peca (idPeca),
    constraint fk_lista_requisicao foreign key (idRequisicaoPeca) references requisicao (idRequisicao)
);

-- criar tabela referência de mão de obra
create table referenciamaodeobra(
    idReferenciaMaoDeObra int auto_increment primary key,
    idReferenciaTipoServico int,
    valor_mao_de_obra numeric (10,2),
    constraint fk_referencia_tipo_servico foreign key (idReferenciaTipoServico) references tiposervico (idTipoServico)
);

-- criar tabela serviço executado na OS
create table servicoexecutado(
    idServicoExecutado int auto_increment primary key,
    idServicoExecutadoRequisicao int,
    idServicoExecutadoTipoServico int,
    idServicoExecutadoMecanico int,
    data_execucao date,
    constraint fk_servico_executado_requisicao foreign key (idServicoExecutadoRequisicao) references requisicao (idRequisicao),
    constraint fk_servico_executado_tipo_servico foreign key (idServicoExecutadoTipoServico) references tiposervico (idTipoServico),
    constraint fk_servico_executado_mecanico foreign key (idServicoExecutadoMecanico) references mecânico (idMecanico)    
);


-- QUERIES PARA INSERIR DADOS

INSERT INTO clients (Nome, Endereço, CPF, RG, Telefone) VALUES
('João Silva', '101', '12345678901', 'MG1234567', '(31)99999-1111'),
('Maria Souza', '202', '23456789012', 'MG2345678', '(31)98888-2222'),
('Carlos Mendes', '303', '34567890123', 'MG3456789', '(31)97777-3333');

INSERT INTO veículo (idVeiculoClient, Marca, Modelo, Ano, Cor, Placa, Tipo) VALUES
(1, 'Toyota', 'Corolla', '2018', 'Prata', 'ABC1234', 'Sedan'),
(2, 'Volkswagen', 'Gol', '2015', 'Branco', 'DEF5678', 'Hatch'),
(3, 'Ford', 'Fiesta', '2017', 'Preto', 'GHI9012', 'Hatch');

INSERT INTO requisicao (idRequisicao_Veiculo, idRequisicao_Cliente, Dia_da_emissão, Dia_da_entrega, Serviço) VALUES
(1, 1, '2025-04-10', '2025-04-12', 'Troca de óleo e revisão'),
(2, 2, '2025-04-11', '2025-04-13', 'Alinhamento e balanceamento');

INSERT INTO autorizacao (idAutorizacaoRequisicao, idAutorizacaoCliente, dia_da_autorização) VALUES
(1, 1, '2025-04-10'),
(2, 2, '2025-04-11');

INSERT INTO tiposervico (idTipoServicoRequisicao, idTipoServicoAutorizacao, descricao) VALUES
(1, 1, 'Troca de óleo do motor'),
(1, 1, 'Revisão geral'),
(2, 2, 'Alinhamento'),
(2, 2, 'Balanceamento');

INSERT INTO equipe (nome_equipe) VALUES
('Equipe Alfa'),
('Equipe Beta');

INSERT INTO mecânico (idEquipeMecanico, nome) VALUES
(1, 'Pedro Henrique'),
(1, 'Lucas Lima'),
(2, 'Rafael Castro');

INSERT INTO peca (nome_peca, valor_unitario) VALUES
('Filtro de óleo', 45.00),
('Óleo 5W30', 120.00),
('Par de pneus', 600.00);

INSERT INTO listapecas (idPecaLista, idRequisicaoPeca, quantidade) VALUES
(1, 1, 1),
(2, 1, 4),
(3, 2, 1);

INSERT INTO referenciamaodeobra (idReferenciaTipoServico, valor_mao_de_obra) VALUES
(1, 80.00),
(2, 150.00),
(3, 70.00),
(4, 70.00);

INSERT INTO servicoexecutado (idServicoExecutadoRequisicao, idServicoExecutadoTipoServico, idServicoExecutadoMecanico, data_execucao) VALUES
(1, 1, 1, '2025-04-11'),
(1, 2, 2, '2025-04-11'),
(2, 3, 3, '2025-04-12'),
(2, 4, 3, '2025-04-12');

-- RETORNANDO DADOS

-- Listar todas as ordens de serviço com dados do cliente e veículo
SELECT
    r.idRequisicao,
    c.Nome AS Cliente,
    v.Marca,
    v.Modelo,
    r.Dia_da_emissão,
    r.Dia_da_entrega,
    r.Serviço,
    r.Situação
FROM requisicao r
JOIN clients c ON r.idRequisicao_Cliente = c.idClient
JOIN veículo v ON r.idRequisicao_Veiculo = v.idVeiculo;

-- Relatório de mecânicos e serviços executados

SELECT
    m.nome AS Mecanico,
    se.data_execucao,
    ts.descricao AS Servico,
    c.Nome AS Cliente
FROM servicoexecutado se
JOIN mecânico m ON se.idServicoExecutadoMecanico = m.idMecanico
JOIN tiposervico ts ON se.idServicoExecutadoTipoServico = ts.idTipoServico
JOIN requisicao r ON se.idServicoExecutadoRequisicao = r.idRequisicao
JOIN clients c ON r.idRequisicao_Cliente = c.idClient
ORDER BY m.nome, se.data_execucao;

-- Buscar ordens de serviço em andamento

SELECT
    r.idRequisicao,
    c.Nome AS Cliente,
    r.Serviço,
    r.Situação
FROM requisicao r
JOIN clients c ON r.idRequisicao_Cliente = c.idClient
WHERE r.Situação = 'Em andamento';

-- Mostrar custo total por cliente, somente se o total de peças ultrapassar R$ 500

SELECT
    c.Nome AS Cliente,
    SUM(p.valor_unitario * lp.quantidade) AS Total_Pecas
FROM requisicao r
JOIN clients c ON r.idRequisicao_Cliente = c.idClient
JOIN listapecas lp ON r.idRequisicao = lp.idRequisicaoPeca
JOIN peca p ON lp.idPecaLista = p.idPeca
GROUP BY c.Nome
HAVING Total_Pecas > 500;