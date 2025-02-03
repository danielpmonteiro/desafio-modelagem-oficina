-- sql
-- Criação do Banco de Dados

DROP DATABASE IF EXISTS oficinamecanica;
CREATE DATABASE oficinamecanica;
use oficinamecanica;

-- Estrutura do Banco de Dados
-- Tabela de Clientes
CREATE TABLE Cliente (
    ClienteID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Endereco VARCHAR(255) NOT NULL,
    Telefone VARCHAR(20)
);

-- Tabela de Veículos
CREATE TABLE Veiculo (
    VeiculoID INT AUTO_INCREMENT PRIMARY KEY,
    Placa VARCHAR(20) NOT NULL,
    Modelo VARCHAR(50) NOT NULL,
    Ano INT NOT NULL,
    ClienteID INT,
    CONSTRAINT FK_Veiculo_Cliente FOREIGN KEY (ClienteID)
        REFERENCES Cliente(ClienteID)
);

-- Tabela de Equipes Mecânicas
CREATE TABLE EquipeMecanica (
    EquipeID INT AUTO_INCREMENT PRIMARY KEY,
    NomeEquipe VARCHAR(50) NOT NULL
);

-- Tabela de Ordens de Serviço
CREATE TABLE OrdemServico (
    OrdemServicoID INT AUTO_INCREMENT PRIMARY KEY,
    Numero VARCHAR(20) NOT NULL,
    DataEmissao DATE NOT NULL,
    ValorTotal DECIMAL(10,2),
    Status VARCHAR(20),
    DataConclusao DATE,
    TipoOrdemServico VARCHAR(20) NOT NULL,
    ClienteAutorizado BOOLEAN NOT NULL DEFAULT FALSE,
    VeiculoID INT,
    EquipeID INT,
    CONSTRAINT FK_OrdemServico_Veiculo FOREIGN KEY (VeiculoID)
        REFERENCES Veiculo(VeiculoID),
    CONSTRAINT FK_OrdemServico_Equipe FOREIGN KEY (EquipeID)
        REFERENCES EquipeMecanica(EquipeID)
);

-- Tabela de Tabela de Mão de Obra
CREATE TABLE TabelaMaoObra (
    MaoObraID INT AUTO_INCREMENT PRIMARY KEY,
    DescricaoServico VARCHAR(100) NOT NULL,
    Valor DECIMAL(10,2) NOT NULL
);

-- Tabela de Serviços (inclusos na Ordem de Serviço)
CREATE TABLE Servico (
    ServicoID INT AUTO_INCREMENT PRIMARY KEY,
    Descricao VARCHAR(255) NOT NULL,
    Quantidade INT,
    ValorCalculado DECIMAL(10,2),
    OrdemServicoID INT,
    MaoObraID INT,
    CONSTRAINT FK_Servico_OrdemServico FOREIGN KEY (OrdemServicoID)
        REFERENCES OrdemServico(OrdemServicoID),
    CONSTRAINT FK_Servico_TabelaMaoObra FOREIGN KEY (MaoObraID)
        REFERENCES TabelaMaoObra(MaoObraID)
);

-- Tabela de Peças (usadas na Ordem de Serviço)
CREATE TABLE Peca (
    PecaID INT AUTO_INCREMENT PRIMARY KEY,
    Descricao VARCHAR(255) NOT NULL,
    Quantidade INT,
    ValorUnitario DECIMAL(10,2) NOT NULL,
    OrdemServicoID INT,
    CONSTRAINT FK_Peca_OrdemServico FOREIGN KEY (OrdemServicoID)
        REFERENCES OrdemServico(OrdemServicoID)
);

-- Tabela de Mecânicos
CREATE TABLE Mecanico (
    MecanicoID INT AUTO_INCREMENT PRIMARY KEY,
    Codigo VARCHAR(20) NOT NULL,
    Nome VARCHAR(100) NOT NULL,
    Endereco VARCHAR(255),
    Especialidade VARCHAR(50),
    EquipeID INT,
    CONSTRAINT FK_Mecanico_Equipe FOREIGN KEY (EquipeID)
        REFERENCES EquipeMecanica(EquipeID)
);
