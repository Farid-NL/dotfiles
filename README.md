# dotfiles

![custom-terminal](https://gist.githubusercontent.com/Farid-NL/522ee6558294dd4ca3040242bb3c19c4/raw/767c3cf82830448c459de31e898e9ba0eafc6d84/terminal.png)

This repository contains my dotfiles which are shared between my Fedora machines.

I aspire to keep the installation as seamless as possible between all my Fedora machines.

In saying that, this repository definitely has some sharp edges so while you're welcome to take whatever from it, do note that there are no guarantees of anything working or being easy to use.

[Chezmoi](https://www.chezmoi.io/) is my dotfile manager, which both manages files as well as runs some pre and post-installation scripts to install everything that I use day to day.

My shell of choice is ZSH, with [zsh4humans](https://github.com/romkatv/zsh4humans).

## Some details

- Secrets management through [Bitwarden](https://www.chezmoi.io/user-guide/password-managers).
- Installation of password manager through a [chezmoi hook](https://www.chezmoi.io/user-guide/advanced/install-your-password-manager-on-init).
- Use of [scripts](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/#clear-the-state-of-all-run_onchange_-and-run_once_-scripts) to initialize Bitwarden and set up my machine with the help of [sx](https://github.com/Farid-NL/sx) made with [Bashly](https://bashly.dev/).
- Some customizations done with help of [chezmoi externals](https://www.chezmoi.io/user-guide/include-files-from-elsewhere)

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

### zsh

```
sudo dnf install zsh
sudo chsh $USER
# Type the following then press enter
/bin/zsh
# Restart the computer
```

### Configure GPG for signing Git commits

1. Download the public and private GPG keys from _bitwarden_ inside the note called "Git GPG"
2. `cd` into the directory that contain the GPG keys
3. Run the following commands
   ```sh
   gpg --import gpg-pub.asc
   gpg --import gpg-sc.asc
   gpg --edit-key B5845CF2A944868B

   # Inside the GPG tool
   > trust
   > 5
   > y
   > save
   ```

### Fonts

Install them with the font manager GUI

```sh
# JetBrainsMono - Nerd Fonts
wget -q --show-progress "https://www.dropbox.com/scl/fi/fclmxayof9vhfrnrybt3h/JetBrainsMono_NF.zip?rlkey=z3ll2x4p7kqk26jglxayntoh0&st=9d2undww&dl=1" -O "$HOME/Downloads/JetBrainsMono_NF.zip"
```
