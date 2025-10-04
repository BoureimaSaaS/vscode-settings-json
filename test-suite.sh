#!/bin/bash

# === TESTS AUTOMATISÉS ===
TEST_RESULTS_FILE="./test-results.log"
PASSED_TESTS=0
FAILED_TESTS=0

# Fonction pour exécuter un test
run_test() {
    local test_name="$1"
    local test_command="$2"

    echo "🧪 Test: $test_name"

    if eval "$test_command" > /dev/null 2>&1; then
        echo "✅ PASS: $test_name"
        ((PASSED_TESTS++))
        return 0
    else
        echo "❌ FAIL: $test_name"
        ((FAILED_TESTS++))
        return 1
    fi
}

# Fonction pour vérifier les prérequis
test_prerequisites() {
    echo "🔍 Vérification des prérequis..."

    run_test "VS Code installé" "command -v code"
    run_test "jq installé" "command -v jq"
    run_test "Bash disponible" "command -v bash"
    run_test "Permissions d'écriture" "test -w $HOME"
}

# Fonction pour tester les fichiers de configuration
test_configuration_files() {
    echo "📁 Test des fichiers de configuration..."

    run_test "settings.json existe" "test -f ./settings.json"
    run_test "settings2.json existe" "test -f ./settings2.json"
    run_test "custom-vscode.css existe" "test -f ./custom-vscode.css"
    run_test "vscode-script.js existe" "test -f ./vscode-script.js"

    # Test de la validité JSON
    run_test "settings.json valide" "jq empty ./settings.json"
    run_test "settings2.json valide" "jq empty ./settings2.json"
}

# Fonction pour tester les scripts
test_scripts() {
    echo "🔧 Test des scripts..."

    run_test "Script d'installation profil" "bash -n ./install-vscode-custom-profile.sh"
    run_test "Script d'installation direct" "bash -n ./install-vscode-custom.sh"
    run_test "Script de configuration" "bash -n ./configure-ui.sh"
    run_test "Gestionnaire de thèmes" "bash -n ./theme-manager.sh"
    run_test "Gestionnaire de sauvegarde" "bash -n ./backup-manager.sh"
}

# Fonction pour tester les fonctionnalités CSS/JS
test_custom_features() {
    echo "🎨 Test des fonctionnalités personnalisées..."

    # Vérifier que le CSS contient les variables principales
    run_test "Variables CSS définies" "grep -q '--main-accent' ./custom-vscode.css"
    run_test "Effet de flou configuré" "grep -q 'backdrop-filter' ./custom-vscode.css"

    # Vérifier que le JS contient les fonctionnalités principales
    run_test "Gestionnaire de notifications" "grep -q 'CustomNotificationManager' ./vscode-script.js"
    run_test "Gestionnaire de raccourcis" "grep -q 'CustomShortcutManager' ./vscode-script.js"
}

# Fonction pour générer un rapport
generate_report() {
    local total_tests=$((PASSED_TESTS + FAILED_TESTS))
    local success_rate=0

    if [ $total_tests -gt 0 ]; then
        success_rate=$((PASSED_TESTS * 100 / total_tests))
    fi

    echo ""
    echo "📊 RAPPORT DE TESTS"
    echo "=================="
    echo "Tests réussis: $PASSED_TESTS"
    echo "Tests échoués: $FAILED_TESTS"
    echo "Total: $total_tests"
    echo "Taux de réussite: $success_rate%"

    if [ $FAILED_TESTS -eq 0 ]; then
        echo "🎉 Tous les tests sont passés !"
        return 0
    else
        echo "⚠️ Certains tests ont échoué. Vérifiez les erreurs ci-dessus."
        return 1
    fi
}

# Fonction principale
main() {
    echo "🚀 Lancement des tests automatisés VS Code Custom UI"
    echo "=================================================="

    # Exécuter tous les tests
    test_prerequisites
    test_configuration_files
    test_scripts
    test_custom_features

    # Générer le rapport
    generate_report

    # Sauvegarder les résultats
    {
        echo "Test Results - $(date)"
        echo "====================="
        echo "Passed: $PASSED_TESTS"
        echo "Failed: $FAILED_TESTS"
        echo "Total: $((PASSED_TESTS + FAILED_TESTS))"
    } > "$TEST_RESULTS_FILE"

    echo "📄 Résultats sauvegardés dans $TEST_RESULTS_FILE"
}

# Exécuter les tests
main "$@"

