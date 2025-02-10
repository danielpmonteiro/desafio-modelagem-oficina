# Oficina Mecânica - Modelo Lógico de Banco de Dados

Este documento descreve o esquema lógico do banco de dados **oficinamecanica** baseado no script SQL. O objetivo é apresentar de forma clara as entidades, colunas, chaves primárias, chaves estrangeiras e os relacionamentos fundamentais entre as tabelas.

---

## 1. **Cliente**
Armazena informações básicas dos clientes da oficina.

| **Coluna**      | **Tipo**        | **Restrições**                             |
|-----------------|-----------------|--------------------------------------------|
| **ClienteID**   | INT             | PRIMARY KEY, AUTO_INCREMENT                |
| **Nome**        | VARCHAR(100)    | NOT NULL                                   |
| **Endereco**    | VARCHAR(255)    | NOT NULL                                   |
| **Telefone**    | VARCHAR(20)     | NULL                                       |

**Observações**:
- Cada cliente pode ter vários veículos (relação *1:N* com a tabela **Veiculo**).
- `Endereco` poderia ser normalizado em outra tabela, caso seja necessária maior granularidade de dados.

---

## 2. **Veiculo**
Armazena as informações de cada veículo atendido pela oficina.

| **Coluna**     | **Tipo**      | **Restrições**                                                        |
|----------------|---------------|-----------------------------------------------------------------------|
| **VeiculoID**  | INT           | PRIMARY KEY, AUTO_INCREMENT                                           |
| **Placa**      | VARCHAR(20)   | NOT NULL                                                              |
| **Modelo**     | VARCHAR(50)   | NOT NULL                                                              |
| **Ano**        | INT           | NOT NULL                                                              |
| **ClienteID**  | INT           | FOREIGN KEY → **Cliente(ClienteID)** (ON DELETE RESTRICT ou CASCADE)  |

**Observações**:
- Associado a um cliente por meio da coluna **ClienteID**.
- O ano do veículo deve ser um valor plausível (pode-se incluir validações adicionais no aplicativo).

---

## 3. **EquipeMecanica**
Identifica cada equipe mecânica da oficina.

| **Coluna**     | **Tipo**      | **Restrições**                                |
|----------------|---------------|-----------------------------------------------|
| **EquipeID**   | INT           | PRIMARY KEY, AUTO_INCREMENT                   |
| **NomeEquipe** | VARCHAR(50)   | NOT NULL                                      |

**Observações**:
- Uma equipe pode ser responsável por várias ordens de serviço (relação *1:N* com **OrdemServico**).
- Possibilidade de adicionar mais colunas no futuro (e.g., localização, capacidade de equipe).

---

## 4. **OrdemServico**
Registra cada ordem de serviço emitida pela oficina.

| **Coluna**            | **Tipo**        | **Restrições**                                                            |
|-----------------------|-----------------|----------------------------------------------------------------------------|
| **OrdemServicoID**    | INT             | PRIMARY KEY, AUTO_INCREMENT                                               |
| **Numero**            | VARCHAR(20)     | NOT NULL (pode ser um identificador único ou sequência interna)           |
| **DataEmissao**       | DATE            | NOT NULL                                                                   |
| **ValorTotal**        | DECIMAL(10,2)   | NULL                                                                      |
| **Status**            | VARCHAR(20)     | NULL (ex.: \"Aberto\", \"Fechado\", \"EmAndamento\", etc.)                 |
| **DataConclusao**     | DATE            | NULL                                                                       |
| **TipoOrdemServico**  | VARCHAR(20)     | NOT NULL (ex.: \"Revisão\", \"Reparo\", \"Garantia\")                      |
| **ClienteAutorizado** | BOOLEAN         | NOT NULL, DEFAULT FALSE (indica se o cliente autorizou o serviço)         |
| **VeiculoID**         | INT             | FOREIGN KEY → **Veiculo(VeiculoID)** (ON DELETE RESTRICT ou CASCADE)       |
| **EquipeID**          | INT             | FOREIGN KEY → **EquipeMecanica(EquipeID)** (ON DELETE RESTRICT ou CASCADE)|

**Observações**:
- Conecta-se a **Veiculo** e **EquipeMecanica** para saber qual veículo está em serviço e qual equipe está designada.
- O campo **ValorTotal** pode ser atualizado conforme serviços e peças são adicionados.

---

## 5. **TabelaMaoObra**
Tabela de referência para mão de obra e valores.

| **Coluna**          | **Tipo**         | **Restrições**                     |
|---------------------|------------------|-------------------------------------|
| **MaoObraID**       | INT              | PRIMARY KEY, AUTO_INCREMENT         |
| **DescricaoServico**| VARCHAR(100)     | NOT NULL                            |
| **Valor**           | DECIMAL(10,2)    | NOT NULL                            |

**Observações**:
- Armazena valores padrão para cada tipo de serviço de mão de obra.
- Pode ser usado na tabela **Servico** para facilitar o cálculo do valor final.

---

## 6. **Servico**
Armazena os serviços executados em cada ordem de serviço.

| **Coluna**         | **Tipo**          | **Restrições**                                                            |
|--------------------|-------------------|---------------------------------------------------------------------------|
| **ServicoID**      | INT              | PRIMARY KEY, AUTO_INCREMENT                                               |
| **Descricao**      | VARCHAR(255)     | NOT NULL                                                                  |
| **Quantidade**     | INT              | NULL (caso seja necessário repetir o mesmo serviço várias vezes)          |
| **ValorCalculado** | DECIMAL(10,2)    | NULL (pode ser derivado de **Quantidade** × valor de mão de obra)         |
| **OrdemServicoID** | INT              | FOREIGN KEY → **OrdemServico(OrdemServicoID)** (ON DELETE RESTRICT/CASCADE)|
| **MaoObraID**      | INT              | FOREIGN KEY → **TabelaMaoObra(MaoObraID)**                                |

**Observações**:
- Permite armazenar tanto uma descrição personalizada quanto um vínculo à **TabelaMaoObra**.
- **ValorCalculado** pode ser calculado via sistema ou preenchido manualmente.

---

## 7. **Peca**
Armazena as peças utilizadas em cada ordem de serviço.

| **Coluna**       | **Tipo**          | **Restrições**                                                         |
|------------------|-------------------|-------------------------------------------------------------------------|
| **PecaID**       | INT              | PRIMARY KEY, AUTO_INCREMENT                                             |
| **Descricao**    | VARCHAR(255)     | NOT NULL                                                                |
| **Quantidade**   | INT              | NULL (quantidade de peças usadas)                                       |
| **ValorUnitario**| DECIMAL(10,2)    | NOT NULL                                                                |
| **OrdemServicoID** | INT            | FOREIGN KEY → **OrdemServico(OrdemServicoID)** (ON DELETE RESTRICT/CASCADE)|

**Observações**:
- Cada registro representa uma peça específica utilizada na ordem de serviço.
- A soma de `Quantidade * ValorUnitario` pode ser adicionada ao valor total da ordem.

---

## 8. **Mecanico**
Registra os mecânicos que trabalham na oficina, vinculados a uma equipe.

| **Coluna**     | **Tipo**       | **Restrições**                                                         |
|----------------|----------------|-------------------------------------------------------------------------|
| **MecanicoID** | INT            | PRIMARY KEY, AUTO_INCREMENT                                             |
| **Codigo**     | VARCHAR(20)    | NOT NULL (código único do mecânico)                                    |
| **Nome**       | VARCHAR(100)   | NOT NULL                                                                |
| **Endereco**   | VARCHAR(255)   | NULL                                                                    |
| **Especialidade** | VARCHAR(50) | NULL (ex.: \"Motor\", \"Funilaria\", \"Elétrica\")                      |
| **EquipeID**   | INT            | FOREIGN KEY → **EquipeMecanica(EquipeID)** (ON DELETE RESTRICT/CASCADE) |

**Observações**:
- Cada mecânico pertence a uma equipe específica.
- `Especialidade` ajuda a direcionar serviços mais complexos.

---

## 🔗 Relacionamentos Principais

1. **Cliente** → **Veiculo** (*1:N*): Um cliente pode ter vários veículos.  
2. **Veiculo** → **OrdemServico** (*1:N*): Um veículo pode ter várias ordens de serviço.  
3. **EquipeMecanica** → **OrdemServico** (*1:N*): Uma equipe pode cuidar de várias ordens de serviço.  
4. **OrdemServico** → **Servico** (*1:N*): Uma ordem de serviço pode ter múltiplos serviços.  
5. **OrdemServico** → **Peca** (*1:N*): Uma ordem de serviço pode usar várias peças.  
6. **TabelaMaoObra** → **Servico** (*1:N*): Um serviço de mão de obra padrão pode ser aplicado a vários registros de serviço.  
7. **EquipeMecanica** → **Mecanico** (*1:N*): Uma equipe pode ter diversos mecânicos.  

---

## ✔️ Observações de Design

1. **Simplicidade**: Cada tabela se concentra em um conceito (Cliente, Veículo, Equipe, etc.).  
2. **Integridade**: Uso de chaves estrangeiras para manter relacionamentos consistentes.  
3. **Facilidade de Calcular Custos**: As tabelas **Servico** e **Peca** permitem obter valores detalhados que somam no **OrdemServico.ValorTotal**.  

---

## 📖 Licença
Este esquema pode ser livremente utilizado e modificado (ex.: licença **MIT** ou outra de sua preferência).

---

📌 **Autor**: [Daniel P Monteiro]
