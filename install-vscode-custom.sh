#!/bin/bash

# === CONFIGURABLE ===
CSS_FILE="$HOME/.vscode-custom/custom-vscode.css"
JS_FILE="$HOME/.vscode-custom/vscode-script.js"
SETTINGS_SRC="./settings.json" # path relative to script
VSCODE_SETTINGS_PATH="$HOME/Library/Application Support/Code/User/settings.json" # MacOS
# Linux : VSCODE_SETTINGS_PATH="$HOME/.config/Code/User/settings.json"

# === INSTALL EXTENSION ===
echo "📦 Installation de l'extension Custom CSS and JS Loader..."
code --install-extension be5invis.vscode-custom-css || {
  echo "❌ Erreur lors de l'installation de l'extension."
  exit 1
}

# === COPIE DES FICHIERS CSS / JS ===
echo "📁 Copie des fichiers CSS et JS personnalisés..."
mkdir -p "$(dirname "$CSS_FILE")"
cp ./custom-vscode.css "$CSS_FILE"
cp ./vscode-script.js "$JS_FILE"

# === MISE À JOUR DU settings.json ===
echo "⚙️ Configuration de settings.json..."
if [ -f "$VSCODE_SETTINGS_PATH" ]; then
  cp "$VSCODE_SETTINGS_PATH" "$VSCODE_SETTINGS_PATH.bak"
  echo "🔒 Backup sauvegardé dans $VSCODE_SETTINGS_PATH.bak"
fi

cp "$SETTINGS_SRC" "$VSCODE_SETTINGS_PATH"

# Ajout des imports CSS/JS si non présents
echo "🔧 Ajout des chemins personnalisés dans settings.json..."
jq \
  --arg css "file://$CSS_FILE" \
  --arg js "file://$JS_FILE" \
  '. + { "vscode_custom_css.imports": [$css, $js] }' \
  "$VSCODE_SETTINGS_PATH" > "$VSCODE_SETTINGS_PATH.tmp" && mv "$VSCODE_SETTINGS_PATH.tmp" "$VSCODE_SETTINGS_PATH"

# === LANCEMENT DE VS CODE AVEC LES DROITS NÉCESSAIRES ===
echo "🚀 Lancement de VS Code..."
code --disable-gpu

echo "✅ Installation terminée. Pense à exécuter 'Enable Custom CSS and JS' dans la palette de commande (⇧⌘P)."
