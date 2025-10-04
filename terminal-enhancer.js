// === FONCTIONNALITÉS TERMINAL AVANCÉES ===

class TerminalEnhancer {
    constructor() {
        this.terminalInstances = new Map();
        this.setupTerminalWatcher();
        this.setupCustomCommands();
    }

    // Surveiller les nouveaux terminaux
    setupTerminalWatcher() {
        const observer = new MutationObserver((mutations) => {
            mutations.forEach((mutation) => {
                mutation.addedNodes.forEach((node) => {
                    if (node.classList && node.classList.contains('terminal')) {
                        this.enhanceTerminal(node);
                    }
                });
            });
        });

        observer.observe(document.body, { childList: true, subtree: true });
    }

    // Améliorer un terminal spécifique
    enhanceTerminal(terminalElement) {
        const terminalId = Date.now();
        this.terminalInstances.set(terminalId, terminalElement);

        // Ajouter des classes personnalisées
        terminalElement.classList.add('custom-terminal');

        // Ajouter des boutons personnalisés
        this.addCustomButtons(terminalElement);

        // Ajouter des raccourcis
        this.addTerminalShortcuts(terminalElement);

        // Ajouter des effets visuels
        this.addVisualEffects(terminalElement);

        console.log(`Terminal ${terminalId} amélioré`);
    }

    // Ajouter des boutons personnalisés
    addCustomButtons(terminalElement) {
        const actionsContainer = terminalElement.querySelector('.actions-container');
        if (!actionsContainer) return;

        // Bouton de nettoyage
        const clearButton = this.createButton('🧹', 'Nettoyer le terminal', () => {
            this.clearTerminal(terminalElement);
        });

        // Bouton de plein écran
        const fullscreenButton = this.createButton('⛶', 'Plein écran', () => {
            this.toggleFullscreen(terminalElement);
        });

        // Bouton de copie
        const copyButton = this.createButton('📋', 'Copier la sortie', () => {
            this.copyTerminalOutput(terminalElement);
        });

        actionsContainer.appendChild(clearButton);
        actionsContainer.appendChild(fullscreenButton);
        actionsContainer.appendChild(copyButton);
    }

    // Créer un bouton personnalisé
    createButton(icon, title, onClick) {
        const button = document.createElement('div');
        button.className = 'action-item custom-terminal-button';
        button.innerHTML = icon;
        button.title = title;
        button.addEventListener('click', onClick);
        return button;
    }

    // Ajouter des raccourcis clavier
    addTerminalShortcuts(terminalElement) {
        terminalElement.addEventListener('keydown', (event) => {
            // Ctrl+Shift+L : Nettoyer le terminal
            if (event.ctrlKey && event.shiftKey && event.key === 'L') {
                event.preventDefault();
                this.clearTerminal(terminalElement);
            }

            // Ctrl+Shift+F : Plein écran
            if (event.ctrlKey && event.shiftKey && event.key === 'F') {
                event.preventDefault();
                this.toggleFullscreen(terminalElement);
            }

            // Ctrl+Shift+C : Copier la sortie
            if (event.ctrlKey && event.shiftKey && event.key === 'C') {
                event.preventDefault();
                this.copyTerminalOutput(terminalElement);
            }
        });
    }

    // Ajouter des effets visuels
    addVisualEffects(terminalElement) {
        // Effet de focus
        terminalElement.addEventListener('focus', () => {
            terminalElement.style.boxShadow = '0 0 0 2px var(--main-accent)';
        });

        terminalElement.addEventListener('blur', () => {
            terminalElement.style.boxShadow = '0 8px 32px rgba(0, 0, 0, 0.3)';
        });

        // Animation d'apparition
        terminalElement.style.opacity = '0';
        terminalElement.style.transform = 'translateY(20px)';

        setTimeout(() => {
            terminalElement.style.transition = 'all 0.3s ease';
            terminalElement.style.opacity = '1';
            terminalElement.style.transform = 'translateY(0)';
        }, 100);
    }

    // Fonctions utilitaires
    clearTerminal(terminalElement) {
        const xtermScreen = terminalElement.querySelector('.xterm-screen');
        if (xtermScreen) {
            xtermScreen.innerHTML = '';
            // Émettre une commande de nettoyage
            const event = new KeyboardEvent('keydown', {
                key: 'l',
                ctrlKey: true,
                bubbles: true
            });
            terminalElement.dispatchEvent(event);
        }
    }

    toggleFullscreen(terminalElement) {
        if (terminalElement.classList.contains('fullscreen')) {
            terminalElement.classList.remove('fullscreen');
            terminalElement.style.position = '';
            terminalElement.style.top = '';
            terminalElement.style.left = '';
            terminalElement.style.width = '';
            terminalElement.style.height = '';
            terminalElement.style.zIndex = '';
        } else {
            terminalElement.classList.add('fullscreen');
            terminalElement.style.position = 'fixed';
            terminalElement.style.top = '0';
            terminalElement.style.left = '0';
            terminalElement.style.width = '100vw';
            terminalElement.style.height = '100vh';
            terminalElement.style.zIndex = '10000';
        }
    }

    copyTerminalOutput(terminalElement) {
        const xtermScreen = terminalElement.querySelector('.xterm-screen');
        if (xtermScreen) {
            const text = xtermScreen.textContent;
            navigator.clipboard.writeText(text).then(() => {
                this.showNotification('Sortie du terminal copiée !', 'success');
            });
        }
    }

    showNotification(message, type) {
        // Utiliser le système de notifications existant
        if (window.notificationManager) {
            window.notificationManager.show(message, type);
        } else {
            console.log(`[${type.toUpperCase()}] ${message}`);
        }
    }

    // Commandes personnalisées
    setupCustomCommands() {
        // Ajouter des commandes personnalisées au terminal
        this.customCommands = {
            'theme': () => this.changeTerminalTheme(),
            'blur': () => this.toggleBlurEffect(),
            'rainbow': () => this.enableRainbowMode()
        };
    }

    changeTerminalTheme() {
        const terminals = document.querySelectorAll('.terminal');
        terminals.forEach(terminal => {
            terminal.style.filter = 'hue-rotate(180deg)';
            setTimeout(() => {
                terminal.style.filter = '';
            }, 2000);
        });
    }

    toggleBlurEffect() {
        const terminals = document.querySelectorAll('.terminal');
        terminals.forEach(terminal => {
            if (terminal.style.filter.includes('blur')) {
                terminal.style.filter = '';
            } else {
                terminal.style.filter = 'blur(2px)';
            }
        });
    }

    enableRainbowMode() {
        const terminals = document.querySelectorAll('.terminal');
        terminals.forEach(terminal => {
            let hue = 0;
            const interval = setInterval(() => {
                terminal.style.filter = `hue-rotate(${hue}deg)`;
                hue = (hue + 10) % 360;
            }, 100);

            setTimeout(() => {
                clearInterval(interval);
                terminal.style.filter = '';
            }, 5000);
        });
    }
}

// Initialiser l'améliorateur de terminal
document.addEventListener('DOMContentLoaded', () => {
    window.terminalEnhancer = new TerminalEnhancer();
    console.log('🚀 Terminal Enhancer chargé !');
});

