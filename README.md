
# Digio

Este projeto é o aplicativo Digio. Ele é desenvolvido utilizando Swift para iOS e utiliza ferramentas como CocoaPods, Fastlane, e SwiftLint para gerenciamento de dependências, automação de tarefas e análise de código.

## Requisitos

Antes de começar, certifique-se de ter as seguintes ferramentas instaladas:

	• Xcode: Download do Xcode
	• Homebrew: Instruções de instalação
	• CocoaPods: Instalado através do comando gem install cocoapods
	• Fastlane: Instalado através do comando gem install fastlane
	• SwiftLint: Instalado através do comando brew install swiftlint
	• Ruby: Recomenda-se o uso de uma versão gerenciável via rbenv ou RVM.## 


## Configuração do Projeto

Comandos Disponíveis
* Configuração do Ambiente:
* Lint do Código:
* Rodar Testes:
* Gerar Build Local:
* Gerar Documentação:
* Executar Testes e Gerar Relatório:
* Preparar para Release:
* Teste Completo:

## Arquitetura

Arquitetura do Projeto

O projeto Digio segue a arquitetura Clean Architecture, que promove a separação de responsabilidades em camadas distintas, visa seguir os princípios do SOLID, facilitando a manutenção e evolução do código. As principais camadas do projeto são:

	• Domain: Contém as regras de negócio da aplicação.
	• Data: Implementa a lógica de acesso a dados nesse caso, API.
	• Presentation: Contém a lógica de apresentação, como ViewModels e Controllers.
	• Infrastructure: Configurações e integrações com serviços externos.

Essa arquitetura foi escolhida para garantir que o código seja escalável, testável e de fácil manutenção, além de facilitar a reutilização de componentes entre diferentes projetos.

Descrição da arquitetura utilizada no projeto.

Decisões de Projeto

	• Clean Architecture: A escolha pela Clean Architecture foi motivada pela necessidade de manter um código modular e testável, especialmente em projetos de larga escala onde diferentes desenvolvedores trabalham em diferentes partes do sistema.
	• Uso de CocoaPods: Embora existam alternativas como o SPM (Swift Package Manager), o CocoaPods foi escolhido pela necessidade de gerenciar a versão específica da biblioteca do SwiftLint.
	• Automação com Fastlane: Optou-se pelo uso do Fastlane para automatizar processos que são críticos para o desenvolvimento e release contínuos. Isso garante consistência nas entregas e reduz o risco de erros humanos.
   • Para autolayout foi utilizado a biblioteca, TinyConstraints. 

   Estrutura do Projeto

	• digio: Diretório principal do código-fonte do projeto.
	• digio.xcodeproj: Arquivo do projeto Xcode.
	• digio.xcworkspace: Workspace do Xcode configurado com CocoaPods.
	• digioTests: Diretório contendo os testes unitários.
	• fastlane: Diretório contendo as configurações e scripts do Fastlane.
	• Pods: Diretório gerado automaticamente pelo CocoaPods contendo as dependências do projeto.
	• swiftlint.yml: Arquivo de configuração do SwiftLint.

## Bibliotecas Utilizadas e Justificativas

	• CocoaPods: Utilizado para o gerenciamento de dependências. Facilita a inclusão, atualização e manutenção de bibliotecas externas, além de garantir que todas as dependências estejam corretamente configuradas no projeto.
	• Fastlane: Automação de processos, como a geração de builds, gerenciamento de versões, lint e execução de testes. Escolhido por sua integração com o ecossistema iOS e pela vasta gama de funcionalidades que oferece para automação de tarefas comuns.
	• SwiftLint: Ferramenta de linting que garante que o código siga padrões de estilo e boas práticas recomendadas para Swift. Isso melhora a consistência do código e facilita a revisão e manutenção. Ajuda também a manter a consistência do código.
	• TinyConstraints: Biblioteca para facilitar a criação de constraints programaticamente em Swift, tornando o código mais legível e reduzindo a quantidade de boilerplate code necessário para configurar layouts.

## Como Executar o Projeto

1. **Clone o Repositório:**

   ```bash
   git clone https://github.com/seu-usuario/nome-do-repositorio.git
   ```

2. **Instale as Dependências:**

   ```bash
   make setup
   ```

3. **Execute o Lint:**

   ```bash
   make lint
   ```

4. **Faça Build:**

   ```bash
   make build
   ```

5. **Execute os Testes:**

   ```bash
   make test
   ```
6. **Opcional execute todos os Testes:**

   ```bash
   make test_all
   ```
   
## Contribuição

Contribuições são bem-vindas! Para contribuir, siga os passos abaixo:

	1.Fork este repositório.
	2.Crie uma branch para a sua feature (git checkout -b feature/nova-feature).
	3.Commit suas alterações (git commit -m 'Adiciona nova feature').
	4.Push para a branch criada (git push origin feature/nova-feature).
	5.Abra um Pull Request.

## Licença

Este projeto é licenciado sob a Licença MIT.
