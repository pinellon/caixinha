# Caixinha

Aplicativo de computador (Windows, Linux e macOS) em Flutter para controle financeiro de estudantes universitários. O usuário registra receitas e despesas, acompanha o saldo de cada mês, vê para onde o dinheiro está indo por categoria e consulta cotações de moedas em tempo real.

## Problema e proposta

Muitos estudantes vivem com renda curta e variável (estágio, bolsa, freelas) e não sabem quanto sobra no fim do mês. O Caixinha entrega uma visão simples e rápida do mês, sem planilhas.

## Funcionalidades

- Resumo mensal com saldo, total de receitas e total de despesas.
- Barras de progresso com a divisão das despesas por categoria.
- Cadastro, edição e exclusão de transações com validação de formulário.
- Busca por título ou categoria e filtro por receitas e despesas.
- Navegação entre meses.
- Persistência local: os dados continuam salvos ao fechar o app.
- Integração com a AwesomeAPI para cotações de dólar, euro e libra, com conversor rápido de reais.
- Estados de carregamento, erro com botão "Tentar novamente" e lista vazia com atalho para carregar dados de exemplo.

## Tecnologias

- Flutter 3.47.5 ou superior (Dart 3.13 ou superior)
- provider (gerenciamento de estado)
- shared_preferences (persistência local)
- http (consumo de API)
- intl e flutter_localizations (formatação e idioma pt-BR)

## Arquitetura

```
lib/
  main.dart
  app.dart
  core/            tema e formatadores
  data/
    models/        TransactionItem, TransactionCategory, ExchangeRate
    repositories/  TransactionRepository (persistência)
    services/      RatesService (API de câmbio)
  logic/           TransactionController, RatesController (ChangeNotifier)
  ui/
    screens/       HomeScreen (navegação lateral)
    pages/         Resumo, Transações, Câmbio
    widgets/       componentes reutilizáveis
test/              testes unitários
```

## Como executar

Pré-requisitos: Flutter instalado e suporte a desktop habilitado para o seu sistema. No Windows, instale o workload **Desenvolvimento para desktop com C++** e um Windows SDK pelo Visual Studio Installer. As pastas de plataforma Windows, Linux e macOS já estão incluídas.

```bash
git clone https://github.com/pinellon/caixinha.git
cd caixinha
flutter config --enable-windows-desktop
flutter pub get
flutter run -d windows
```

No Windows, habilite o Modo de Desenvolvedor em **Configurações > Sistema > Para desenvolvedores** para permitir os links simbólicos usados pelos plugins Flutter. Troque `windows` por `linux` ou `macos` conforme o seu sistema.

Para uma prévia no navegador, use `flutter run -d chrome`.

Para rodar a análise estática e os testes:

```bash
flutter analyze
flutter test
```

Para gerar o executável Windows:

```bash
flutter build windows
```

O pacote pronto para Windows também está disponível em [caixinha-windows.zip](docs/caixinha-windows.zip). Extraia o arquivo e abra `caixinha.exe`.

## Prints das telas

Capturas da interface em 1440 × 900, usando transações de exemplo:

- [Resumo](docs/prints/resumo.png)
- [Transações](docs/prints/transacoes.png)
- [Câmbio](docs/prints/cambio.png)

## Pitch, roteiro e propaganda

- [Pitch deck completo (PPTX)](docs/pitch-caixinha-final.pptx)
- [Roteiro oral e perguntas da banca](docs/pitch-caixinha-roteiro.md)
- [Vídeo de propaganda (MP4, 56 s)](docs/propaganda-caixinha-final.mp4)
- [Roteiro e locução](docs/propaganda-roteiro.md)

## Integrantes

- Nicolas Pinello Pontes
