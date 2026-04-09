APP_NAME = ClaudePokemon
BUNDLE_NAME = ClaudePokemon.app
EXECUTABLE = claude-pokemon
BUILD_DIR = build
SRC_DIR = claude-pokemon

SWIFT_FILES = \
	$(SRC_DIR)/App/ClaudePokemonApp.swift \
	$(SRC_DIR)/App/AppDelegate.swift \
	$(SRC_DIR)/Window/ScreenGeometry.swift \
	$(SRC_DIR)/Window/NotchWindow.swift \
	$(SRC_DIR)/Window/NotchContentView.swift \
	$(SRC_DIR)/Views/PokemonSpriteView.swift \
	$(SRC_DIR)/Views/CollapsedNotchView.swift \
	$(SRC_DIR)/Views/ExpandedNotchView.swift \
	$(SRC_DIR)/Pokemon/PokemonCharacter.swift \
	$(SRC_DIR)/Pokemon/SpriteAnimator.swift \
	$(SRC_DIR)/IPC/SessionState.swift \
	$(SRC_DIR)/IPC/SessionManager.swift \
	$(SRC_DIR)/IPC/SocketServer.swift

SWIFT_FLAGS = -O -parse-as-library \
	-framework AppKit \
	-framework SwiftUI \
	-framework Combine

.PHONY: all clean install run

all: $(BUILD_DIR)/$(BUNDLE_NAME)

$(BUILD_DIR)/$(BUNDLE_NAME): $(SWIFT_FILES) $(SRC_DIR)/Info.plist
	@mkdir -p $(BUILD_DIR)/$(BUNDLE_NAME)/Contents/MacOS
	@mkdir -p $(BUILD_DIR)/$(BUNDLE_NAME)/Contents/Resources
	@echo "Compiling..."
	swiftc $(SWIFT_FLAGS) \
		-o $(BUILD_DIR)/$(BUNDLE_NAME)/Contents/MacOS/$(EXECUTABLE) \
		$(SWIFT_FILES)
	@cp $(SRC_DIR)/Info.plist $(BUILD_DIR)/$(BUNDLE_NAME)/Contents/
	@echo "Built $(BUNDLE_NAME) successfully"

clean:
	rm -rf $(BUILD_DIR)

install: $(BUILD_DIR)/$(BUNDLE_NAME)
	@echo "Installing to /Applications..."
	cp -R $(BUILD_DIR)/$(BUNDLE_NAME) /Applications/
	@echo "Installed successfully"

run: $(BUILD_DIR)/$(BUNDLE_NAME)
	@echo "Launching $(APP_NAME)..."
	open $(BUILD_DIR)/$(BUNDLE_NAME)

uninstall:
	@echo "Removing from /Applications..."
	rm -rf /Applications/$(BUNDLE_NAME)
	rm -f /tmp/claude-island.sock
	@echo "Uninstalled"
