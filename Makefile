# Makefile

# Caminhos
SWIFTLINT_BIN = $(shell which swiftlint)
POD_BIN = $(shell which pod)
FASTLANE_BIN = $(shell which fastlane)

# Tarefa principal
setup: podfile_setup install_cocoapods install_swiftlint install_fastlane lint

# Instalar CocoaPods
install_cocoapods:
	@if [ -z "$(POD_BIN)" ]; then \
		echo "CocoaPods não encontrado. Instalando..."; \
		sudo gem install cocoapods; \
	fi
	@echo "Instalando dependências do CocoaPods..."
	@pod install

# Instalar SwiftLint
install_swiftlint:
	@if [ -z "$(SWIFTLINT_BIN)" ]; then \
		echo "SwiftLint não encontrado. Instalando..."; \
		brew install swiftlint; \
	fi
	@echo "SwiftLint instalado com sucesso."

# Instalar Fastlane
install_fastlane:
	@if [ -z "$(FASTLANE_BIN)" ]; then \
		echo "Fastlane não encontrado. Instalando..."; \
		sudo gem install fastlane -NV; \
	fi
	@echo "Fastlane instalado com sucesso."

# Configurar e rodar o SwiftLint
lint:
	@echo "Executando SwiftLint..."
	@swiftlint

# Configuração do Podfile
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