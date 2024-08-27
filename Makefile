# Variáveis para os binários
SWIFTLINT_BIN = $(shell which swiftlint)
POD_BIN = $(shell which pod)
FASTLANE_BIN = $(shell which fastlane)
BUNDLE_BIN = $(shell which bundle)

# Tarefa principal para configurar o ambiente
setup: podfile_setup install_cocoapods install_swiftlint install_fastlane install_gems lint

# Verifica e instala o CocoaPods se não estiver instalado
install_cocoapods:
	@if [ -z "$(POD_BIN)" ]; then \
		echo "CocoaPods não encontrado. Instalando..."; \
		echo "⚠️  Aviso: Será solicitada a senha de administrador para instalar o CocoaPods."; \
		sudo gem install cocoapods; \
	else \
		echo "CocoaPods já está instalado."; \
	fi
	@echo "Instalando dependências do CocoaPods..."
	@pod install

# Verifica e instala o SwiftLint se não estiver instalado
install_swiftlint:
	@if [ -z "$(SWIFTLINT_BIN)" ]; then \
		echo "SwiftLint não encontrado. Instalando..."; \
		brew install swiftlint; \
	else \
		echo "SwiftLint já está instalado."; \
	fi
	@echo "SwiftLint instalado com sucesso."

# Verifica e instala o Fastlane se não estiver instalado
install_fastlane:
	@if [ -z "$(FASTLANE_BIN)" ]; then \
		echo "Fastlane não encontrado. Instalando..."; \
		echo "⚠️  Aviso: Será solicitada a senha de administrador para instalar o Fastlane."; \
		sudo gem install fastlane -NV; \
	else \
		echo "Fastlane já está instalado."; \
	fi
	@echo "Fastlane instalado com sucesso."

# Verifica e instala o Bundler e as gems do projeto
install_gems:
	@if [ -f Gemfile ]; then \
		echo "Instalando gems com bundle..."; \
		$(BUNDLE_BIN) install; \
	else \
		echo "Gemfile não encontrado. Pulando instalação de gems..."; \
	fi

# Configura o Podfile
podfile_setup:
	@echo "Configurando o Podfile..."
	@echo "platform :ios, '12.0'" > Podfile
	@echo "target 'digio' do" >> Podfile
	@echo "  use_frameworks!" >> Podfile
	@echo "  pod 'SwiftLint', '0.31.0'" >> Podfile
	@echo "  pod 'TinyConstraints'" >> Podfile
	@echo "" >> Podfile
	@echo "  target 'digioTests' do" >> Podfile
	@echo "    inherit! :search_paths" >> Podfile
	@echo "    # Pods for testing" >> Podfile
	@echo "  end" >> Podfile
	@echo "end" >> Podfile

# Limpar a pasta DerivedData
clean_derived_data:
	@echo "Limpando a pasta DerivedData..."
	@echo "⚠️  Aviso: Será solicitada a senha de administrador para limpar a pasta DerivedData."; \
	sudo rm -rf ~/Library/Developer/Xcode/DerivedData

# Rodar o SwiftLint para verificar o código
lint:
	@make clean_derived_data
	@echo "Executando SwiftLint..."
	@cd digio && $(SWIFTLINT_BIN) lint --config ../swiftlint.yml

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

# Gerar documentação
docs:
	@echo "Gerando documentação..."
	@$(FASTLANE_BIN) generate_docs

# Gerar screenshots
screenshots:
	@echo "Gerando screenshots..."
	@$(FASTLANE_BIN) generate_screenshots

# Executar testes e gerar relatório
test_report:
	@make clean_derived_data
	@echo "Executando testes e gerando relatório..."
	@$(FASTLANE_BIN) test_and_report

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
	@make docs
	@make screenshots
	@make test_report
	@make prepareRelease
	@make clean
	@echo "Teste completo finalizado!"