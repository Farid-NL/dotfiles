# dotfiles

Personal dotfiles managed by [chezmoi](https://www.chezmoi.io)

## How to use

Initialize the source directory
```sh
chezmoi init https://github.com/$GITHUB_USERNAME/dotfiles.git
```

Initialize and install the dotfiles on the machine
```sh
# With full link
chezmoi init --apply https://github.com/$GITHUB_USERNAME/dotfiles.git

# With username if the repo is called 'dotfiles'
chezmoi init --apply $GITHUB_USERNAME
```

[Quickstart Guide](https://www.chezmoi.io/quick-start/#start-using-chezmoi-on-your-current-machine)
