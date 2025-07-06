# Coop-farm (Flutter)

Coop-farm é um aplicativo de uma cooperativa de fazendas, desenvolvido em **Flutter** para dispositivos móveis. A ideia é que os usuários registrem e controlem melhor os produtos que estão em produção, que foram colhidos e que estão ja em estoque para venda. O foco está na **simplicidade** e nas funcionalidades essenciais para o gerenciamento ddos produtos.

## Funcionalidades

O sistema possui uma estrutura de login/logout que garante a segurança dos dados do usuário. Além disso:

- **Cadastro de produtos:** permite registrar um produto.
- **Lista de produtos:** O usuário pode consultar todos os produtos cadastrados.
- **Dashboard de vendas:** O usuário tem uma visualização gráfica das das vendas, podendo ordenar pela coluna desejada.
- **Cadastro de vendas:** local para registrar a venda de um produto
- **Gestão de produção:** local para cadastrar o fluxo em que um determinado produto se encontra (ex: colheita)
- **Dashboard de produção:** possibilita a visualização de todos os itens cadastrados na gestão de produção, de forma a mostrar a situação dos produtos de forma sil=mples em tabela
- **Cadastro de metas:** cadastrar meta de venda ou de produção
- **Listagem de metas:** listagem das metas cadastradas e seus status
- **Notificações de metas:** notifica o alcance ou expiração de alguma meta
- **Lazy loading:** Paginação implementada para melhor desempenho em listas longas.

## Tecnologias Utilizadas

- **Framework:** Flutter
- **Linguagem de programação:** Dart
- **Gerenciamento de estado:** Provider / MobX
- **Armazenamento de dados (simulado):** Local Storage
- **Cache:** `shared_preferences`
- **Segurança:** Firebase Auth (login/logout)
- **Lazy loading:** Estrutura de paginação para carregamento eficiente
- **Programação reativa:** foi utilizado o conceito de programaçõ reativa através da biblioteca MobX. A principal ideia por trás da reatividade no app é garantir que a interface do usuário responda automaticamente a mudanças nos dados, sem a necessidade de atualizações manuais.

## Pré-requisitos

Antes de rodar o projeto, é necessário ter o Flutter instalado. Siga as instruções na documentação oficial:

📎 https://docs.flutter.dev/get-started/install

## Instalação
Clone o repositório do projeto:

```bash
git clone https://github.com/eduardasneves18/coop-farm-flutter.git
```
Navegue até a pasta do projeto:

```bash
cd coop-farm-flutter
```
Instale as dependências:

```bash
flutter pub get
```
Execute o aplicativo:

```bash
flutter run
```
O app será iniciado em um emulador Android/iOS ou em um dispositivo físico conectado.

## Licença
Este projeto é de livre uso para fins de estudo e demonstração.
