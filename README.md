# 🎨 VS Code Custom UI Configuration

This repository provides a complete setup to transform the look and feel of Visual Studio Code using custom CSS/JS, organized into a dedicated profile named `custom-ui`.

## ✅ What You Get

- A command palette with a blur effect
- A minimalist interface (status bar and sidebar hidden)
- Clean and modern typography (`Geist Mono`, `Fira Code`)
- An optional decorative SVG background
- A fully isolated configuration profile, separate from your main VS Code setup

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
🔄 Reset / Uninstall
To remove the custom configuration, simply run:
```bash
rm -rf ~/.vscode-custom
````
