#!/bin/bash

# === GESTIONNAIRE DE THÈMES ===
THEMES_DIR="./themes"
CURRENT_THEME_FILE="$HOME/.vscode-custom/current-theme"

# Fonction pour créer un nouveau thème
create_theme() {
    local theme_name="$1"
    local theme_dir="$THEMES_DIR/$theme_name"

    mkdir -p "$theme_dir"

    echo "🎨 Création du thème '$theme_name'..."

    # Template de base
    cat > "$theme_dir/settings.json" << EOF
{
    "workbench.colorTheme": "Mono Atom",
    "workbench.iconTheme": "eq-material-theme-icons-light",
    "editor.fontFamily": "Geist Mono, JetBrains Mono, Fira Code",
    "editor.fontSize": 16,
    "editor.lineHeight": 32
}
EOF

    # Template CSS
    cat > "$theme_dir/custom-vscode.css" << EOF
/* === Thème: $theme_name === */
:root {
  --main-accent: #bc9abc;
  --background-blur: rgba(0, 0, 0, .15);
  --tooltip-bg: linear-gradient(#3c3c50 0%, #2a2b38 100%);
  --transition: all 0.2s ease-in-out;
  --font-family: 'Geist Mono', 'JetBrains Mono', 'Fira Code', monospace;
}

/* Ajoutez vos styles personnalisés ici */
EOF

    echo "✅ Thème '$theme_name' créé dans $theme_dir"
}

# Fonction pour appliquer un thème
apply_theme() {
    local theme_name="$1"
    local theme_dir="$THEMES_DIR/$theme_name"

    if [ ! -d "$theme_dir" ]; then
        echo "❌ Thème '$theme_name' introuvable"
        return 1
    fi

    echo "🎨 Application du thème '$theme_name'..."

    # Copie des fichiers
    cp "$theme_dir/settings.json" "$HOME/.vscode-custom/settings.json"
    cp "$theme_dir/custom-vscode.css" "$HOME/.vscode-custom/custom-vscode.css"

    # Sauvegarde du thème actuel
    echo "$theme_name" > "$CURRENT_THEME_FILE"

    echo "✅ Thème '$theme_name' appliqué"
}

# Fonction pour lister les thèmes
list_themes() {
    echo "📋 Thèmes disponibles :"
    if [ -d "$THEMES_DIR" ]; then
        for theme in "$THEMES_DIR"/*; do
            if [ -d "$theme" ]; then
                local theme_name=$(basename "$theme")
                local current=""
                if [ -f "$CURRENT_THEME_FILE" ] && [ "$(cat "$CURRENT_THEME_FILE")" = "$theme_name" ]; then
                    current=" (actuel)"
                fi
                echo "  - $theme_name$current"
            fi
        done
    else
        echo "  Aucun thème trouvé"
    fi
}

# Menu principal
case "$1" in
    "create")
        if [ -z "$2" ]; then
            echo "Usage: $0 create <nom_du_thème>"
            exit 1
        fi
        create_theme "$2"
        ;;
    "apply")
        if [ -z "$2" ]; then
            echo "Usage: $0 apply <nom_du_thème>"
            exit 1
        fi
        apply_theme "$2"
        ;;
    "list")
        list_themes
        ;;
    *)
        echo "🎨 Gestionnaire de thèmes VS Code Custom UI"
        echo "Usage:"
        echo "  $0 create <nom>  - Créer un nouveau thème"
        echo "  $0 apply <nom>   - Appliquer un thème"
        echo "  $0 list         - Lister les thèmes disponibles"
        ;;
esac

