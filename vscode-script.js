// === OPTIMISATIONS JavaScript ===

document.addEventListener('DOMContentLoaded', function() {
    let observer; // Garder une référence pour éviter les fuites mémoire

    const checkElement = setInterval(() => {
        const commandDialog = document.querySelector(".quick-input-widget");
        if (commandDialog) {
            // Apply the blur effect immediately if the command dialog is visible
            if (commandDialog.style.display !== "none") {
                runMyScript();
            }

            // ✅ AMÉLIORATION : Éviter les observateurs multiples
            if (observer) observer.disconnect();

            observer = new MutationObserver((mutations) => {
                mutations.forEach((mutation) => {
                    if (mutation.type === 'attributes' && mutation.attributeName === 'style') {
                        if (commandDialog.style.display === 'none') {
                            handleEscape();
                        } else {
                            runMyScript();
                        }
                    }
                });
            });

            observer.observe(commandDialog, { attributes: true });
            clearInterval(checkElement);
        }
    }, 500);

    // ✅ AMÉLIORATION : Éviter les event listeners dupliqués
    document.addEventListener('keydown', function(event) {
        if ((event.metaKey || event.ctrlKey) && event.key === 'p') {
            // ✅ AMÉLIORATION : Ne pas preventDefault sur Ctrl+P (laisse VS Code gérer)
            setTimeout(runMyScript, 50); // Petit délai pour que VS Code ouvre d'abord la palette
        } else if (event.key === 'Escape' || event.key === 'Esc') {
            handleEscape();
        }
    });

    function runMyScript() {
        const targetDiv = document.querySelector(".monaco-workbench");
        if (!targetDiv) return; // ✅ SÉCURITÉ : Vérifier l'existence

        // Remove existing element if it already exists
        const existingElement = document.getElementById("command-blur");
        if (existingElement) {
            existingElement.remove();
        }

        // Create and configure the new element
        const newElement = document.createElement("div");
        newElement.setAttribute('id', 'command-blur');

        // ✅ AMÉLIORATION : Transition smooth
        newElement.style.opacity = '0';
        newElement.addEventListener('click', function() {
            newElement.style.opacity = '0';
            setTimeout(() => newElement.remove(), 200);
        });

        targetDiv.appendChild(newElement);

        // ✅ AMÉLIORATION : Animation d'entrée
        requestAnimationFrame(() => {
            newElement.style.opacity = '1';
        });
    }

    function handleEscape() {
        const element = document.getElementById("command-blur");
        if (element) {
            element.style.opacity = '0';
            setTimeout(() => element.remove(), 200);
        }
    }
});

// === NOUVELLES FONCTIONNALITÉS ===

// ✅ NOUVEAU : Effet de focus sur l'éditeur actif
document.addEventListener('DOMContentLoaded', function() {
    const addEditorFocusEffect = () => {
        const editors = document.querySelectorAll('.monaco-editor');
        editors.forEach(editor => {
            editor.addEventListener('focus', function() {
                this.style.boxShadow = '0 0 0 2px var(--main-accent)';
            });
            editor.addEventListener('blur', function() {
                this.style.boxShadow = 'none';
            });
        });
    };

    // Exécuter immédiatement et sur les changements
    addEditorFocusEffect();
    setInterval(addEditorFocusEffect, 2000);
});

// ✅ NOUVEAU : Amélioration de la navigation par onglets
document.addEventListener('keydown', function(event) {
    if ((event.metaKey || event.ctrlKey) && event.key === 'w') {
        // Ajouter un effet de fermeture smooth
        const activeEditor = document.querySelector('.editor-group-container.active .monaco-editor');
        if (activeEditor) {
            activeEditor.style.transform = 'scale(0.95)';
            activeEditor.style.opacity = '0.5';
        }
    }
});
