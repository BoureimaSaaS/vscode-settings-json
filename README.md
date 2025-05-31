# 🎨 Configuration personnalisée de VS Code (Custom UI)

Ce dépôt propose une configuration complète pour transformer l’interface de Visual Studio Code grâce à des personnalisations CSS/JS, regroupées dans un profil dédié nommé `custom-ui`.

## ✅ Ce que vous obtenez

- Une palette de commandes avec effet de flou (blur)
- Une interface minimaliste (barre d’état et barre latérale masquées)
- Une typographie moderne et soignée (`Geist Mono`, `Fira Code`)
- Un fond décoratif SVG (optionnel)
- Une configuration entièrement isolée dans un profil distinct de votre VS Code principal

---

## 🚀 Installation

### 1. Prérequis

Assurez-vous d’avoir installé :
- [Visual Studio Code](https://code.visualstudio.com/)
- `jq` (outil CLI pour manipuler du JSON) :
  ```bash
  brew install jq  # macOS
  sudo apt install jq  # Linux


  2. Lancer l’installation
Téléchargez ou clonez ce dépôt, placez-vous dans le dossier, puis exécutez :

```bash
chmod +x install-vscode-custom-profile.sh
./install-vscode-custom-profile.sh

```
 ✨ Activation des personnalisations
Une fois VS Code lancé avec le nouveau profil :

Ouvrez la palette de commande (⇧⌘P ou Ctrl+⇧P)

Recherchez et exécutez la commande :
```bash
Enable Custom CSS and JS
```
🔄 Réinitialisation
Pour supprimer la configuration personnalisée :
```bash
rm -rf ~/.vscode-custom
````

