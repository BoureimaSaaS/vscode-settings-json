#!/bin/bash

# === SYSTÈME DE SAUVEGARDE ET RESTAURATION ===
BACKUP_DIR="$HOME/.vscode-custom-backups"
CURRENT_CONFIG_DIR="$HOME/.vscode-custom"

# Fonction pour créer une sauvegarde
create_backup() {
    local backup_name="${1:-$(date +%Y%m%d_%H%M%S)}"
    local backup_path="$BACKUP_DIR/$backup_name"

    echo "💾 Création de la sauvegarde '$backup_name'..."

    mkdir -p "$backup_path"

    # Sauvegarde des fichiers de configuration
    if [ -d "$CURRENT_CONFIG_DIR" ]; then
        cp -r "$CURRENT_CONFIG_DIR"/* "$backup_path/"
        echo "✅ Sauvegarde créée dans $backup_path"
    else
        echo "❌ Aucune configuration trouvée à sauvegarder"
        return 1
    fi

    # Création d'un fichier de métadonnées
    cat > "$backup_path/metadata.json" << EOF
{
    "name": "$backup_name",
    "created": "$(date -Iseconds)",
    "version": "1.0",
    "description": "Sauvegarde automatique VS Code Custom UI"
}
EOF
}

# Fonction pour restaurer une sauvegarde
restore_backup() {
    local backup_name="$1"
    local backup_path="$BACKUP_DIR/$backup_name"

    if [ ! -d "$backup_path" ]; then
        echo "❌ Sauvegarde '$backup_name' introuvable"
        return 1
    fi

    echo "🔄 Restauration de la sauvegarde '$backup_name'..."

    # Sauvegarde de sécurité avant restauration
    if [ -d "$CURRENT_CONFIG_DIR" ]; then
        create_backup "pre_restore_$(date +%Y%m%d_%H%M%S)"
    fi

    # Restauration
    mkdir -p "$CURRENT_CONFIG_DIR"
    cp -r "$backup_path"/* "$CURRENT_CONFIG_DIR/"

    echo "✅ Configuration restaurée depuis $backup_name"
}

# Fonction pour lister les sauvegardes
list_backups() {
    echo "📋 Sauvegardes disponibles :"
    if [ -d "$BACKUP_DIR" ]; then
        for backup in "$BACKUP_DIR"/*; do
            if [ -d "$backup" ]; then
                local backup_name=$(basename "$backup")
                local metadata_file="$backup/metadata.json"
                if [ -f "$metadata_file" ]; then
                    local created=$(jq -r '.created' "$metadata_file" 2>/dev/null || echo "Inconnu")
                    echo "  - $backup_name (créé: $created)"
                else
                    echo "  - $backup_name"
                fi
            fi
        done
    else
        echo "  Aucune sauvegarde trouvée"
    fi
}

# Fonction pour nettoyer les anciennes sauvegardes
cleanup_backups() {
    local keep_count="${1:-5}"

    echo "🧹 Nettoyage des sauvegardes (garde les $keep_count plus récentes)..."

    if [ -d "$BACKUP_DIR" ]; then
        # Trier par date de modification et garder seulement les plus récentes
        find "$BACKUP_DIR" -maxdepth 1 -type d -name "*" | \
        grep -v "^$BACKUP_DIR$" | \
        xargs -I {} sh -c 'echo "$(stat -f "%m %N" "{}" 2>/dev/null || stat -c "%Y %n" "{}" 2>/dev/null)"' | \
        sort -nr | \
        tail -n +$((keep_count + 1)) | \
        cut -d' ' -f2- | \
        while read backup_path; do
            if [ -d "$backup_path" ]; then
                echo "🗑️ Suppression de $(basename "$backup_path")"
                rm -rf "$backup_path"
            fi
        done

        echo "✅ Nettoyage terminé"
    fi
}

# Menu principal
case "$1" in
    "create")
        create_backup "$2"
        ;;
    "restore")
        if [ -z "$2" ]; then
            echo "Usage: $0 restore <nom_de_la_sauvegarde>"
            exit 1
        fi
        restore_backup "$2"
        ;;
    "list")
        list_backups
        ;;
    "cleanup")
        cleanup_backups "$2"
        ;;
    *)
        echo "💾 Système de sauvegarde VS Code Custom UI"
        echo "Usage:"
        echo "  $0 create [nom]     - Créer une sauvegarde"
        echo "  $0 restore <nom>   - Restaurer une sauvegarde"
        echo "  $0 list           - Lister les sauvegardes"
        echo "  $0 cleanup [n]    - Nettoyer les anciennes sauvegardes"
        ;;
esac
