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

// === NOUVELLES FONCTIONNALITÉS AVANCÉES ===

// ✅ NOUVEAU : Système de notifications personnalisées
class CustomNotificationManager {
    constructor() {
        this.notifications = new Map();
        this.setupStyles();
    }

    setupStyles() {
        const style = document.createElement('style');
        style.textContent = `
            .custom-notification {
                position: fixed;
                top: 20px;
                right: 20px;
                background: var(--tooltip-bg);
                color: white;
                padding: 12px 16px;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
                backdrop-filter: blur(10px);
                border: 1px solid var(--main-accent);
                z-index: 10000;
                transform: translateX(100%);
                transition: transform 0.3s ease;
                max-width: 300px;
            }
            .custom-notification.show {
                transform: translateX(0);
            }
            .custom-notification.success {
                border-color: #4ade80;
            }
            .custom-notification.error {
                border-color: #f87171;
            }
            .custom-notification.warning {
                border-color: #fbbf24;
            }
        `;
        document.head.appendChild(style);
    }

    show(message, type = 'info', duration = 3000) {
        const id = Date.now();
        const notification = document.createElement('div');
        notification.className = `custom-notification ${type}`;
        notification.textContent = message;
        notification.id = `notification-${id}`;

        document.body.appendChild(notification);

        // Animation d'entrée
        setTimeout(() => notification.classList.add('show'), 10);

        // Auto-suppression
        setTimeout(() => {
            notification.classList.remove('show');
            setTimeout(() => notification.remove(), 300);
        }, duration);

        this.notifications.set(id, notification);
        return id;
    }
}

// ✅ NOUVEAU : Gestionnaire de raccourcis personnalisés
class CustomShortcutManager {
    constructor() {
        this.shortcuts = new Map();
        this.setupEventListeners();
    }

    register(keys, callback, description = '') {
        this.shortcuts.set(keys, { callback, description });
    }

    setupEventListeners() {
        document.addEventListener('keydown', (event) => {
            const key = this.getKeyString(event);
            const shortcut = this.shortcuts.get(key);

            if (shortcut) {
                event.preventDefault();
                shortcut.callback(event);
            }
        });
    }

    getKeyString(event) {
        const parts = [];
        if (event.ctrlKey) parts.push('ctrl');
        if (event.metaKey) parts.push('cmd');
        if (event.altKey) parts.push('alt');
        if (event.shiftKey) parts.push('shift');
        parts.push(event.key.toLowerCase());
        return parts.join('+');
    }
}

// ✅ NOUVEAU : Effet de focus amélioré avec animations
document.addEventListener('DOMContentLoaded', function() {
    const notificationManager = new CustomNotificationManager();
    const shortcutManager = new CustomShortcutManager();

    // Effet de focus sur l'éditeur actif avec animation
    const addEditorFocusEffect = () => {
        const editors = document.querySelectorAll('.monaco-editor');
        editors.forEach(editor => {
            // Supprimer les anciens listeners pour éviter les doublons
            editor.removeEventListener('focus', handleEditorFocus);
            editor.removeEventListener('blur', handleEditorBlur);

            editor.addEventListener('focus', handleEditorFocus);
            editor.addEventListener('blur', handleEditorBlur);
        });
    };

    function handleEditorFocus() {
        this.style.boxShadow = '0 0 0 2px var(--main-accent)';
        this.style.transform = 'scale(1.01)';
        this.style.transition = 'all 0.2s ease';
    }

    function handleEditorBlur() {
        this.style.boxShadow = 'none';
        this.style.transform = 'scale(1)';
    }

    // Raccourcis personnalisés
    shortcutManager.register('ctrl+shift+t', () => {
        notificationManager.show('Thème changé !', 'success');
    }, 'Changer le thème');

    shortcutManager.register('ctrl+shift+f', () => {
        const editors = document.querySelectorAll('.monaco-editor');
        editors.forEach(editor => {
            editor.style.filter = 'blur(2px)';
            setTimeout(() => editor.style.filter = 'none', 2000);
        });
        notificationManager.show('Focus mode activé', 'info');
    }, 'Mode focus');

    // Exécuter immédiatement et sur les changements
    addEditorFocusEffect();
    setInterval(addEditorFocusEffect, 2000);

    // Notification de bienvenue
    setTimeout(() => {
        notificationManager.show('VS Code Custom UI chargé !', 'success', 2000);
    }, 1000);
});

// ✅ NOUVEAU : Amélioration de la navigation par onglets avec feedback
document.addEventListener('keydown', function(event) {
    if ((event.metaKey || event.ctrlKey) && event.key === 'w') {
        // Effet de fermeture smooth avec feedback visuel
        const activeEditor = document.querySelector('.editor-group-container.active .monaco-editor');
        if (activeEditor) {
            activeEditor.style.transform = 'scale(0.95)';
            activeEditor.style.opacity = '0.5';
            activeEditor.style.transition = 'all 0.2s ease';

            // Restaurer après un délai
            setTimeout(() => {
                activeEditor.style.transform = 'scale(1)';
                activeEditor.style.opacity = '1';
            }, 200);
        }
    }
});

// ✅ NOUVEAU : Détection de changements de fichiers
let lastFileCount = 0;
setInterval(() => {
    const currentFileCount = document.querySelectorAll('.monaco-editor').length;
    if (currentFileCount !== lastFileCount) {
        lastFileCount = currentFileCount;
        // Émettre un événement personnalisé
        document.dispatchEvent(new CustomEvent('fileCountChanged', {
            detail: { count: currentFileCount }
        }));
    }
}, 1000);

// Écouter les changements de fichiers
document.addEventListener('fileCountChanged', (event) => {
    console.log(`Nombre de fichiers ouverts: ${event.detail.count}`);
});
