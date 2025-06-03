ZIP_NAME ?= "customDataTypeGND.zip"
PLUGIN_NAME = "custom-data-type-gnd"

# coffescript-files to compile
COFFEE_FILES = CustomDataTypeGND.coffee \
	CustomDataTypeGNDFacet.coffee \
	GNDUtil.coffee

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: build ## build all

build: clean ## clean, compile, copy files to build folder

				npm install --save node-fetch # install needed node-module

				mkdir -p build
				mkdir -p build/$(PLUGIN_NAME)
				mkdir -p build/$(PLUGIN_NAME)/webfrontend
				mkdir -p build/$(PLUGIN_NAME)/updater
				mkdir -p build/$(PLUGIN_NAME)/l10n

				mkdir -p src/tmp # build code from coffee
				cp src/webfrontend/*.coffee src/tmp
				cd src/tmp && coffee -b --compile ${COFFEE_FILES} # bare-parameter is obligatory!
			
				cat src/tmp/CustomDataTypeGND.js >> build/$(PLUGIN_NAME)/webfrontend/customDataTypeGND.js		
				cat src/tmp/CustomDataTypeGNDFacet.js >> build/$(PLUGIN_NAME)/webfrontend/customDataTypeGND.js		
				cat src/tmp/GNDUtil.js >> build/$(PLUGIN_NAME)/webfrontend/customDataTypeGND.js

				cp src/updater/gndUpdater.js build/$(PLUGIN_NAME)/updater/gndUpdater.js # build updater
				cat src/tmp/GNDUtil.js >> build/$(PLUGIN_NAME)/updater/gndUpdater.js
				cp package.json build/$(PLUGIN_NAME)/package.json
				cp -r node_modules build/$(PLUGIN_NAME)/
				rm -rf src/tmp # clean tmp

				cp l10n/custom-data-type-gnd.csv build/$(PLUGIN_NAME)/l10n/customDataTypeGND.csv # copy l10n

				cp src/webfrontend/css/main.css build/$(PLUGIN_NAME)/webfrontend/customDataTypeGND.css # copy css
				cp manifest.master.yml build/$(PLUGIN_NAME)/manifest.yml # copy manifest

clean: ## clean
				rm -rf build

zip: build ## build zip file
			cd build && zip ${ZIP_NAME} -r $(PLUGIN_NAME)/