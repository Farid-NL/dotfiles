# dotfiles

Personal dotfiles managed by [chezmoi](https://www.chezmoi.io)

## TODOS

- [ ] Add Neovim installation into ansible (precompiled /opt/nvim/)
- [ ] Add bat installation into ansible (deb)
- [ ] Add eza installation into ansible (gpg)
- [ ] Add zoxide installation into ansible (script)
- [ ] Crate script for updating completion
- [ ] Crate script to update completions
  - [ ] _gh
  - [ ] _bw & _bws
  - [ ] _eza
  - [ ] _conda
  - [ ] _delta
  - [ ] _volta
  - [ ] _chezmoi
- [ ] Improve README for better understanding

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
