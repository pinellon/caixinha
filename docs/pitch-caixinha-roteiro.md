# Roteiro do pitch — Caixinha

**Duração prevista:** 5 a 6 minutos de fala, mais 2 a 3 minutos para perguntas.  
**Apresentação:** até 7 minutos, conforme a rubrica.

## 1. Capa — 20 segundos

Oi, eu sou Nicolas Pinello Pontes e este é o Caixinha, um controle financeiro para estudantes. A proposta é simples: ajudar a entender quanto ainda dá para gastar durante o mês.

## 2. Problema — 40 segundos

Na faculdade, o dinheiro pode vir de estágio, bolsa, trabalho extra ou ajuda da família. Essas entradas nem sempre chegam no mesmo dia. Ao mesmo tempo, transporte, alimentação, moradia e materiais têm datas e valores diferentes. Quando cada gasto fica anotado em um lugar, a pessoa perde a visão do mês. A pergunta que queremos responder é: quanto ainda posso gastar sem comprometer as próximas contas?

## 3. Solução — 50 segundos

O Caixinha reúne saldo, receitas e despesas em um resumo mensal. As categorias ajudam a perceber para onde o dinheiro está indo. Na área de transações, é possível cadastrar, editar, excluir, buscar e filtrar lançamentos, além de trocar o mês. Os dados ficam salvos localmente. A página de câmbio consulta dólar, euro e libra pela AwesomeAPI e permite converter valores em reais. Aqui estão as telas do protótipo com dados de exemplo.

## 4. Mercado — 40 segundos

O Censo da Educação Superior do Inep registrou 10.226.873 matrículas em cursos de graduação no Brasil em 2024. Esse número mostra o universo potencial, mas não significa que todos precisem do produto ou que pagariam por ele. Nosso público inicial são estudantes com renda curta ou variável que preferem conferir as finanças no computador. O próximo passo é validar a proposta com 30 estudantes de uma turma ou campus.

## 5. Modelo de negócio — 45 segundos

Hoje o protótipo é gratuito e não tem cobrança. Como hipótese para o futuro, propomos manter o controle básico gratuito e testar um plano de 4 reais e 90 centavos por mês para exportação, backup e relatórios ampliados. Esses recursos e o pagamento ainda não existem no aplicativo. Antes de lançar qualquer plano, precisamos testar uso recorrente, custo de suporte e disposição a pagar.

## 6. Concorrência — 45 segundos

Mobills e Organizze são exemplos de aplicativos financeiros gerais com recursos amplos de receitas, despesas, categorias e relatórios. Planilhas e cadernos também resolvem o registro, com preenchimento manual. O espaço que o Caixinha quer ocupar é o de um fluxo mensal mais enxuto, com linguagem e categorias próximas da rotina estudantil. Hoje temos menos recursos que os concorrentes: não há integração bancária, cartão de crédito nem aplicativo móvel.

## 7. Equipe — 20 segundos

O README lista Nicolas Pinello Pontes como integrante. Neste projeto, cuidei do produto, da arquitetura Flutter, da interface, da persistência, da integração de câmbio, dos testes e da documentação.

## 8. O pedido — 35 segundos

Não pedimos investimento externo nesta etapa. Pedimos quatro semanas e acesso a 30 estudantes voluntários. Na primeira semana, observamos o primeiro uso; nas semanas seguintes, acompanhamos se as pessoas voltam; e, na quarta semana, fazemos entrevistas para definir prioridades. Com esses dados, decidimos o que melhorar e se vale investir em versão móvel, backup e modelo pago. Obrigado.

## Perguntas prováveis da banca

**O que diferencia o Caixinha de Mobills ou Organizze?**  
O foco no resumo mensal simples e na rotina estudantil. O protótipo ainda não compete em integração bancária, cartões ou versão móvel.

**Vocês já validaram o preço de R$ 4,90?**  
Não. É uma hipótese de teste, não uma receita atual. O piloto deve indicar se as pessoas usariam os recursos pagos e qual preço faria sentido.

**Como os dados financeiros são protegidos?**  
No protótipo, as transações são armazenadas localmente no dispositivo. Não há integração com bancos nem sincronização em nuvem.

**O que acontece se a internet ou a AwesomeAPI falhar?**  
O estado de erro permite tentar novamente. As transações salvas localmente continuam disponíveis; a cotação depende da conexão e do serviço externo.

**Por que a primeira versão é para computador?**  
O escopo deste projeto foi um aplicativo desktop. A versão móvel aparece como possibilidade futura, depois da validação da necessidade e do uso.

## Fontes do pitch

- Inep, Censo da Educação Superior 2024: <https://www.gov.br/inep/pt-br/relatorio-anual-de-atividades-e-gestao-do-inep-2025/pesquisas-estatisticas-e-indicadores-educacionais/censo-da-educacao-superior>
- Mobills, central de ajuda — apresentação do produto: <https://mobills.zendesk.com/hc/pt-br/articles/1260804135870-O-que-%C3%A9-o-Mobills>
- Organizze, página oficial do produto: <https://www.organizze.com.br/>
