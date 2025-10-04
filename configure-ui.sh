#!/bin/bash

# === CONFIGURATEUR INTERACTIF ===
echo "🎨 Configuration Interactive VS Code Custom UI"
echo "=============================================="

# Fonction pour demander une valeur
ask_value() {
    local prompt="$1"
    local default="$2"
    local value

    read -p "$prompt [$default]: " value
    echo "${value:-$default}"
}

# Configuration des couleurs
echo ""
echo "🎨 Configuration des couleurs :"
MAIN_ACCENT=$(ask_value "Couleur accent principale" "#bc9abc")
BACKGROUND_BLUR=$(ask_value "Opacité du flou d'arrière-plan" "0.15")

# Configuration de la typographie
echo ""
echo "📝 Configuration de la typographie :"
FONT_FAMILY=$(ask_value "Famille de police" "Geist Mono, JetBrains Mono, Fira Code")
FONT_SIZE=$(ask_value "Taille de police" "16")
LINE_HEIGHT=$(ask_value "Hauteur de ligne" "32")

# Configuration de l'interface
echo ""
echo "🖥️ Configuration de l'interface :"
HIDE_ACTIVITY_BAR=$(ask_value "Masquer la barre d'activité ? (true/false)" "true")
HIDE_STATUS_BAR=$(ask_value "Masquer la barre de statut ? (true/false)" "true")
SIDEBAR_POSITION=$(ask_value "Position de la sidebar (left/right)" "right")

# Génération du CSS personnalisé
echo ""
echo "🔧 Génération du CSS personnalisé..."

cat > custom-vscode-dynamic.css << EOF
/* === Variables globales générées dynamiquement === */
:root {
  --main-accent: $MAIN_ACCENT;
  --background-blur: rgba(0, 0, 0, $BACKGROUND_BLUR);
  --tooltip-bg: linear-gradient(#3c3c50 0%, #2a2b38 100%);
  --transition: all 0.2s ease-in-out;
  --font-family: '$FONT_FAMILY';
}

/* === Configuration de base === */
EOF

# Ajout des règles conditionnelles
if [ "$HIDE_ACTIVITY_BAR" = "true" ]; then
    echo ".monaco-workbench .activitybar { display: none !important; }" >> custom-vscode-dynamic.css
fi

if [ "$HIDE_STATUS_BAR" = "true" ]; then
    echo ".monaco-workbench .statusbar { display: none !important; }" >> custom-vscode-dynamic.css
fi

echo ""
echo "✅ Configuration terminée !"
echo "📁 Fichier généré : custom-vscode-dynamic.css"
echo "🚀 Exécutez ./install-vscode-custom-profile.sh pour appliquer"

