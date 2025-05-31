#!/bin/bash

# === CONFIGURATION DU PROFIL ===
PROFILE_NAME="custom-ui"
BASE_DIR="$HOME/.vscode-custom"
USER_DATA_DIR="$BASE_DIR/user-data"
EXTENSIONS_DIR="$BASE_DIR/extensions"
CSS_FILE="$BASE_DIR/custom-vscode.css"
JS_FILE="$BASE_DIR/vscode-script.js"
SETTINGS_SRC="./settings.json"
SETTINGS_DEST="$USER_DATA_DIR/User/settings.json"

# === CRÉATION DES DOSSIERS ===
echo "📁 Création des répertoires du profil..."
mkdir -p "$USER_DATA_DIR/User"
mkdir -p "$EXTENSIONS_DIR"
mkdir -p "$BASE_DIR"

# === COPIE DES FICHIERS CSS / JS ===
echo "🎨 Copie des fichiers CSS et JS..."
cp ./custom-vscode.css "$CSS_FILE"
cp ./vscode-script.js "$JS_FILE"

# === INSTALLATION DE L'EXTENSION Custom CSS and JS Loader ===
echo "📦 Installation de l'extension Custom CSS and JS Loader..."
code --install-extension be5invis.vscode-custom-css --extensions-dir "$EXTENSIONS_DIR"

# === COPIE DES PARAMÈTRES ===
echo "⚙️ Application de settings.json au profil '$PROFILE_NAME'..."
cp "$SETTINGS_SRC" "$SETTINGS_DEST"

# === AJOUT DES CHEMINS CSS/JS ===
echo "🔧 Ajout des imports CSS/JS au fichier settings.json..."
jq \
  --arg css "file://$CSS_FILE" \
  --arg js "file://$JS_FILE" \
  '. + { "vscode_custom_css.imports": [$css, $js] }' \
  "$SETTINGS_DEST" > "$SETTINGS_DEST.tmp" && mv "$SETTINGS_DEST.tmp" "$SETTINGS_DEST"

# === LANCEMENT DE VS CODE AVEC LE PROFIL ===
echo "🚀 Lancement de VS Code avec le profil '$PROFILE_NAME'..."
code --profile "$PROFILE_NAME" \
     --user-data-dir "$USER_DATA_DIR" \
     --extensions-dir "$EXTENSIONS_DIR"

echo "✅ Profil '$PROFILE_NAME' prêt. Dans VS Code, exécute la commande : 'Enable Custom CSS and JS'."
