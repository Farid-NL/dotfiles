# dotfiles

![custom-terminal](https://gist.githubusercontent.com/Farid-NL/522ee6558294dd4ca3040242bb3c19c4/raw/a2671e3e540d65d51e8a51edc8b7d8a22f09aeec/terminal.png)

This repository contains my dotfiles which are shared between my kubuntu machines.

I aspire to keep the installation as seamless as possible between all my kubuntu machines.

In saying that, this repository definitely has some sharp edges so while you're welcome to take whatever from it, do note that there are no guarantees of anything working or being easy to use.

[Chezmoi](https://www.chezmoi.io/) is my dotfile manager, which both manages files as well as runs some pre and post-installation scripts to install everything that I use day to day.

My shell of choice is ZSH, with [zsh4humans](https://github.com/romkatv/zsh4humans).

## Some details

- Secrets management through [Bitwarden](https://www.chezmoi.io/user-guide/password-managers).
- Installation of password manager through a [chezmoi hook](https://www.chezmoi.io/user-guide/advanced/install-your-password-manager-on-init).
- Use of [scripts](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/#clear-the-state-of-all-run_onchange_-and-run_once_-scripts) to initialize Bitwarden and set up my machine with the help of [ansible](https://github.com/Farid-NL/ansible-personal-setup).
- Some customizations done with help of [chezmoi externals](https://www.chezmoi.io/user-guide/include-files-from-elsewhere)

## TODOS

- [ ] Create (bash? or ansible?) script to update completions
  - [ ] _gh
  - [ ] _bw
  - [ ] _eza
  - [ ] _conda
  - [ ] _delta
  - [ ] _volta
  - [ ] _chezmoi
- [ ] Create [orphan branch](https://github.com/twpayne/chezmoi/discussions/1508) for Windows (maybe for WSL too?).

## How to use

### Brand new machine

I use [`get.chezmoi.io/lb`](https://www.chezmoi.io/install/#one-line-binary-install) because I want to install chezmoi in `./.local/bin` instead of `./bin`

> Run in $HOME directory

```sh
sh -c "$(wget -qO- get.chezmoi.io/lb)" -- init --apply Farid-NL
```

### Just another machine

Just follow the steps [here](https://www.chezmoi.io/user-guide/setup) and read the docs.

## Extras to be manually installed or set up

### Appearance

**KDE**

| Configuration           | Store name                                                | Config. name             |
|-------------------------|-----------------------------------------------------------|--------------------------|
| Global theme            |                                                           | _Breeze Dark_            |
| Plasma style            | [Ant-Dracula KDE](https://store.kde.org/p/1370687)        | _Dracula_                |
| Colors                  | [Ant-Dracula KDE](https://store.kde.org/p/1370679)        | _Dracula-purple_         |
| Window Decorations      | [Ant-Dracula KDE](https://store.kde.org/p/1370682)        | _Dracula_                |
| Icons                   | [Dracula Icons](https://store.kde.org/p/1541561)          | _Dracula_                |
| Cursors                 | [Dracula cursors](https://store.kde.org/p/1669262)        | _Dracula-cursors_        |
| Splash screen           | [BeautifulTreeAnimation](https://store.kde.org/p/1433200) | _BeautifulTreeAnimation_ |
| Wallpaper & Lock screen | [Ant-Dracula wallpaper](https://store.kde.org/p/1378234)  | _dracula-purplish_       |
