## Título: Consultas SQL para o Banco de Dados oficinamecanica

### Este documento contem consultas SQL úteis para operações comuns no banco de dados da oficina mecânica. As consultas estao organizadas por categoria para facilitar a navegação.

### 1 Consultas Simples
1.1 Listar todos os clientes
Exibe todos os clientes cadastrados no sistema.
```
SELECT * FROM Cliente;
```

1.2 Listar todos os veículos com seus respectivos clientes
Exibe todos os veículos e os clientes aos quais eles pertencem.
```
SELECT
  v.Placa, v.Modelo, v.Ano, c.Nome AS NomeCliente, c.Telefone
FROM
  Veiculo AS v
JOIN
  Cliente AS c ON v.ClienteID = c.ClienteID;
```

1.3 Listar todas as ordens de serviço pendentes
Exibe todas as ordens de serviço que ainda estão pendentes.
```
SELECT
  os.Numero, os.DataEmissao, os.Status, c.Nome AS NomeCliente, v.Placa
FROM
  OrdemServico AS os
JOIN
  Veiculo AS v ON os.VeiculoID = v.VeiculoID
JOIN
  Cliente AS c ON v.ClienteID = c.ClienteID
WHERE os.Status = 'pendente';
```

### 2 Consultas com Filtros (WHERE)

2.1 Listar ordens de serviço concluídas em um periodo específico
Exibe todas as ordens de serviço concluídas dentro de um intervalo de datas.
```
SELECT
  os.Numero, os.DataEmissao, os.DataConclusao, c.Nome AS NomeCliente, v.Placa
FROM
  OrdemServico AS os
JOIN
  Veiculo AS v ON os.VeiculoID = v.VeiculoID
JOIN
  Cliente AS c ON v.ClienteID = c.ClienteID
WHERE
  os.Status = 'concluido'
AND
  os.DataConclusao BETWEEN '2023-01-01' AND '2023-12-31';
```

2.2 Listar veículos de um cliente específico
Exibe todos os veículos associados a um cliente específico.
```
SELECT
  v.Placa, v.Modelo, v.Ano
FROM
  Veiculo AS v
JOIN
  Cliente AS c ON v.ClienteID = c.ClienteID
WHERE
  c.Nome = 'João Silva';
```

### 3 Consultas com Calculos (Expressões Derivadas)

3.1 Calcular o valor total de serviços realizados por uma ordem de serviço
Calcula o valor total dos serviços realizados para cada ordem de serviço.
```
SELECT
  os.Numero AS NumeroOrdem, SUM(s.ValorCalculado) AS TotalServicos
FROM
  OrdemServico AS os
LEFT JOIN
  Servico AS s ON os.OrdemServicoID = s.OrdemServicoID
GROUP BY
  os.Numero;
```

3.2 Calcular o custo total de peças usadas em uma ordem de serviço
Calcula o custo total das peças utilizadas em cada ordem de serviço.
```
SELECT
  os.Numero AS NumeroOrdem, SUM(p.Quantidade * p.ValorUnitario) AS TotalPecas
FROM
  OrdemServico AS os
LEFT JOIN
  Peca p ON os.OrdemServicoID = p.OrdemServicoID
GROUP BY
  os.Numero;
```

### 4 Ordenação (ORDER BY)

4.1 Listar ordens de servico ordenadas pelo valor total (maior para menor)
Exibe as ordens de serviço ordenadas pelo valor total, do maior para o menor.
```
SELECT
  os.Numero, os.ValorTotal, os.Status
FROM
  OrdemServico AS os
ORDER BY
  os.ValorTotal DESC;
```

4.2 Listar mecânicos ordenados por especialidade
Exibe os mecânicos ordenados por sua especialidade.
```
SELECT
  m.Nome, m.Especialidade
FROM
  Mecanico m
ORDER BY
  m.Especialidade ASC;
```

### 5 Agrupamento e Condiçõs de Filtro (GROUP BY e HAVING)

5.1 Contar o numero de veiculos por cliente
Conta quantos veiculos cada cliente possui.
```
SELECT
  c.Nome AS NomeCliente, COUNT(v.VeiculoID) AS TotalVeiculos
FROM
  Cliente AS c
LEFT JOIN
  Veiculo AS v ON c.ClienteID = v.ClienteID
GROUP BY
  c.Nome;
```

5.2 Listar clientes com mais de 2 veiculos cadastrados
Exibe os clientes que possuem mais de dois veiculos cadastrados.
```
SELECT
  c.Nome AS NomeCliente, COUNT(v.VeiculoID) AS TotalVeiculos
FROM
  Cliente AS c
JOIN
  Veiculo AS v ON c.ClienteID = v.ClienteID
GROUP BY
  c.Nome HAVING COUNT(v.VeiculoID) > 2;
```

### 6 Juncoes Complexas

6.1 Listar ordens de serviço com detalhes dos servicos e peças utilizadas
Exibe detalhes completos das ordens de serviço, incluindo os serviço e peças utilizados.
```
SELECT
  os.Numero AS NumeroOrdem, s.Descricao AS DescricaoServico, s.ValorCalculado AS ValorServico,
  p.Descricao AS DescricaoPeca, p.Quantidade AS QuantidadePeca, p.ValorUnitario AS ValorPeca
FROM
  OrdemServico AS os
LEFT JOIN
  Servico AS s ON os.OrdemServicoID = s.OrdemServicoID
LEFT JOIN
  Peca AS p ON os.OrdemServicoID = p.OrdemServicoID;
```

6.2 Listar mecânicos e suas respectivas equipes
Exibe os mecanicos junto com as equipes às quais eles pertencem.
```
SELECT
  m.Nome AS NomeMecanico, m.Especialidade, e.NomeEquipe
FROM
  Mecanico AS m
JOIN
  EquipeMecanica e ON m.EquipeID = e.EquipeID;
```

### 7 Consultas com Subqueries

7.1 Encontrar a ordem de serviço com o maior valor total
Encontra a ordem de serviço com o maior valor total.
```
SELECT
  os.Numero, os.ValorTotal
FROM
  OrdemServico os
WHERE
  os.ValorTotal = (SELECT MAX(ValorTotal) FROM OrdemServico);
```

7.2 Listar clientes que tem veiculos com ano superior a 2020
Exibe os clientes que possuem veiculos fabricados após 2020.
```
SELECT DISTINCT
  c.Nome AS NomeCliente
FROM
  Cliente AS c
JOIN
  Veiculo AS v ON c.ClienteID = v.ClienteID
WHERE
  v.Ano > 2020;
```

### 8 Consultas para Relatorios

8.1 Relatorio de faturamento total por mês
Gera um relatorio de faturamento total por mês.
```
SELECT
  MONTH(os.DataEmissao) AS Mes, YEAR(os.DataEmissao) AS Ano, SUM(os.ValorTotal) AS FaturamentoTotal
FROM
  OrdemServico os
GROUP BY
  YEAR(os.DataEmissao), MONTH(os.DataEmissao)
ORDER BY
  Ano DESC, Mes DESC;
```

8.2 Relatorio de serviços mais realizados
Gera um relatorio dos serviços mais realizados.
```
SELECT
  tmo.DescricaoServico, COUNT(s.ServicoID) AS TotalRealizacoes
FROM
  TabelaMaoObra AS tmo
JOIN
  Servico AS s ON tmo.MaoObraID = s.MaoObraID
GROUP BY
  tmo.DescricaoServico
ORDER BY
  TotalRealizacoes DESC;
```

### 9 Consultas para Insercoes

9.1 Inserir um novo cliente
Insere um novo cliente no sistema.
```
INSERT INTO Cliente (Nome, Endereco, Telefone) VALUES ('Maria Oliveira', 'Rua das Flores, 123', '(11) 98765-4321')
```

9.2 Inserir um novo veiculo
Insere um novo veiculo associado a um cliente existente.
```
INSERT INTO Veiculo (Placa, Modelo, Ano, ClienteID) VALUES ('ABC1D23', 'Fiesta', 2018, 1)
```

### 10 Consultas para Atualizacoes

10.1 Atualizar o status de uma ordem de serviço
Atualiza o status de uma ordem de serviço para "concluido".
```
UPDATE OrdemServico SET Status = 'concluido', DataConclusao = CURDATE() WHERE OrdemServicoID = 1
```

10.2 Atualizar o valor unitario de uma peca
Atualiza o valor unitario de uma peca especifica.
```
UPDATE Peca SET ValorUnitario = 50.00 WHERE PecaID = 5
```

### 11 Consultas para Exclusoes

11.1 Excluir um veiculo especifico
Exclui um veiculo especifico do sistema.
```
DELETE FROM Veiculo WHERE VeiculoID = 5
```

11.2 Excluir todas as ordens de serviço canceladas
Exclui todas as ordens de serviço com status "cancelado".
```
DELETE FROM OrdemServico WHERE Status = 'cancelado'
```

### 12 Consultas Avancadas

12.1 Listar ordens de serviço com valor total calculado
Calcula o valor total de cada ordem de serviço, somando os valores dos serviços e peças.
```
SELECT
  os.Numero AS NumeroOrdem, (COALESCE(SUM(s.ValorCalculado), 0) + COALESCE(SUM(p.Quantidade * p.ValorUnitario), 0)) AS ValorTotalCalculado
FROM
  OrdemServico os
LEFT JOIN
  Servico AS s ON os.OrdemServicoID = s.OrdemServicoID
LEFT JOIN
  Peca AS p ON os.OrdemServicoID = p.OrdemServicoID
GROUP BY
  os.Numero
```
12.2 Listar equipes com mais de 3 mecânicos
Exibe as equipes que possuem mais de 3 mecânicos associados.
```
SELECT
  e.NomeEquipe, COUNT(m.MecanicoID) AS TotalMecanicos
FROM
  EquipeMecanica AS e
JOIN
  Mecanico AS m ON e.EquipeID = m.EquipeID
GROUP BY
  e.NomeEquipe HAVING COUNT(m.MecanicoID) > 3;
```
