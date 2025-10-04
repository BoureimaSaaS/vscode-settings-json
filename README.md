# 🎨 VS Code Custom UI Configuration

This repository provides a complete setup to transform the look and feel of Visual Studio Code using custom CSS/JS, organized into a dedicated profile named `custom-ui`.

## ✅ What You Get

- **🎨 Minimalist Interface** : Hidden activity bar and status bar
- **✨ Advanced Blur Effect** : Command palette with `backdrop-filter`
- **🔤 Optimized Typography** : `Geist Mono`, `JetBrains Mono`, `Fira Code`
- **🎯 Visual Effects** : Smooth animations and fluid transitions
- **🔔 Notification System** : Integrated custom notifications
- **⌨️ Custom Shortcuts** : Configurable keyboard shortcuts
- **🎨 Theme Manager** : Multiple themes system
- **💾 Automatic Backup** : Backup and restore system
- **🧪 Automated Tests** : Test suite for validation
- **📁 Isolated Profile** : Separate configuration from your main VS Code

---

## 🚀 Installation

### 1. Prerequisites

Make sure you have the following installed:

- [Visual Studio Code](https://code.visualstudio.com/)
- `jq` (a CLI tool for JSON manipulation):

  ```bash
  brew install jq      # macOS
  sudo apt install jq  # Linux


2. Run the Installer
Download or clone this repository, navigate to the folder, then run:

```bash
chmod +x install-vscode-custom-profile.sh
./install-vscode-custom-profile.sh

```
✨ Enable the Customizations
Once VS Code is launched with the new profile:

Open the Command Palette (⇧⌘P or Ctrl+⇧P)

Search for and execute the command:

```bash
Enable Custom CSS and JS
```
## 🛠️ New Features

### 🎨 Interactive Configuration
```bash
chmod +x configure-ui.sh
./configure-ui.sh
```
Configure colors, fonts and interface settings interactively.

### 🎭 Theme Manager
```bash
chmod +x theme-manager.sh
./theme-manager.sh create my-theme
./theme-manager.sh apply my-theme
./theme-manager.sh list
```
Create and manage multiple custom themes.

### 💾 Backup System
```bash
chmod +x backup-manager.sh
./backup-manager.sh create
./backup-manager.sh restore backup-name
./backup-manager.sh list
```
Backup and restore your configurations.

### 🧪 Automated Tests
```bash
chmod +x test-suite.sh
./test-suite.sh
```
Validate that everything works correctly.

## ⌨️ Custom Shortcuts

- `Ctrl+Shift+T` : Change theme
- `Ctrl+Shift+F` : Focus mode (temporary blur)
- `Ctrl+P` : Command palette with blur effect
- `Escape` : Close blur effects

## 🔄 Reset / Uninstall

To remove the custom configuration, simply run:
```bash
rm -rf ~/.vscode-custom
rm -rf ~/.vscode-custom-backups
````
