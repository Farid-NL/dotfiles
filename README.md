# dotfiles

Personal dotfiles managed by [chezmoi](https://www.chezmoi.io)

## TODOS

- [ ] Create init script for setting up Bitwarden, SSH and GPG Keys
- [ ] Create ansible playbook for software installation

## How to use

Remember to backup your config file: `~/.config/chezmoi/chezmoi.yml` in order to use the secrets from Bitwarden

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
