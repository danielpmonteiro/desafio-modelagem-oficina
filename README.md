# desafio-modelagem-oficina
Projeto Conceitual de Banco de Dados – OficinaMecanica

## Descrição do Projeto
Este projeto representa um esquema de banco de dados para um sistema oficina mecânica.

## Funcionalidades Principais
#### Cadastro e Gerenciamento de Clientes e Veículos:
- Permite o registro de clientes e seus veículos, garantindo que cada veículo esteja vinculado ao seu respectivo dono.

#### Emissão e Acompanhamento de Ordens de Serviço:
- Cada OS é registrada com informações como data de emissão, valor total, status (por exemplo, pendente, autorizada ou concluída), tipo de serviço (conserto ou revisão) e data de conclusão. O sistema também armazena se o cliente autorizou a execução dos serviços, possibilitando o controle do fluxo de trabalho.

#### Composição da OS com Serviços e Peças:
- A OS pode conter diversos serviços a serem realizados, cujo valor é calculado com base em uma tabela de mão de obra, bem como peças que serão utilizadas durante o atendimento.

#### Gerenciamento de Equipes e Mecânicos:
- Cada OS é atribuída a uma equipe de mecânicos, composta por profissionais com informações detalhadas (como código, nome, endereço e especialidade), garantindo uma alocação adequada dos recursos técnicos.
