# Variáveis para os binários
SWIFTLINT_BIN := $(shell which swiftlint)
POD_BIN := $(shell which pod)
FASTLANE_BIN := $(shell which fastlane)
BUNDLE_BIN := $(shell which bundle)

# Tarefa principal para configurar o ambiente
setup: install_cocoapods install_swiftlint install_fastlane install_gems lint

# Verifica e instala o CocoaPods se não estiver instalado
install_cocoapods:
	@if [ -z "$(POD_BIN)" ]; then \
		echo "CocoaPods não encontrado. Instalando..."; \
		sudo gem install cocoapods; \
	else \
		echo "CocoaPods já está instalado."; \
	fi
	@pod install

# Verifica e instala o SwiftLint se não estiver instalado
install_swiftlint:
	@if [ -z "$(SWIFTLINT_BIN)" ]; then \
		echo "SwiftLint não encontrado. Instalando..."; \
		brew install swiftlint; \
	else \
		echo "SwiftLint já está instalado."; \
	fi

# Verifica e instala o Fastlane se não estiver instalado
install_fastlane:
	@if [ -z "$(FASTLANE_BIN)" ]; then \
		echo "Fastlane não encontrado. Instalando..."; \
		sudo gem install fastlane -NV; \
	else \
		echo "Fastlane já está instalado."; \
	fi

# Verifica e instala o Bundler e as gems do projeto
install_gems:
	@if [ -f Gemfile ]; then \
		$(BUNDLE_BIN) install; \
	else \
		echo "Gemfile não encontrado. Pulando instalação de gems..."; \
	fi

# Limpar a pasta DerivedData
clean_derived_data:
	@echo "Limpando a pasta DerivedData..."; \
	sudo rm -rf ~/Library/Developer/Xcode/DerivedData

# Rodar o SwiftLint para verificar o código
lint:
	@make clean_derived_data
	@echo "Executando SwiftLint..."
	@$(SWIFTLINT_BIN) lint --config swiftlint.yml

# Rodar os testes
test:
	@make clean_derived_data
	@echo "Executando testes..."
	@$(FASTLANE_BIN) clean_and_test

# Gerar build local
build:
	@make clean_derived_data
	@echo "Gerando build local..."
	@$(FASTLANE_BIN) build

# Executar testes e gerar relatório
test_report:
	@make clean_derived_data
	@echo "Executando testes e gerando relatório..."
	@$(FASTLANE_BIN) clean_and_test

# Preparar para release
prepareRelease:
	@echo "Preparando para release..."
	@$(FASTLANE_BIN) prepare_for_release

# Limpeza geral
clean:
	@echo "Limpando build..."
	@xcodebuild clean
	@make clean_derived_data

# Teste completo de todos os comandos
test_all:
	@echo "Iniciando teste completo dos comandos do Makefile..."
	@make setup
	@make test
	@make build
	@make prepareRelease
	@make clean
	@echo "Teste completo finalizado!"