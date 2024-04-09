#!/usr/bin/env bash

printf 'Updating \033[0;34mBitwarden\033[0m completions\n'
bw completion --shell zsh > ~/.config/zsh/completion/_bw

printf 'Updating \033[0;34mChezmoi\033[0m completions\n'
chezmoi completion zsh --output=~/.config/zsh/completion/_chezmoi

printf 'Updating \033[0;34mConda\033[0m completions\n'
wget -q https://raw.githubusercontent.com/conda-incubator/conda-zsh-completion/master/_conda\
 -O ~/.config/zsh/completion/_conda

printf 'Updating \033[0;34mDelta\033[0m completions\n'
delta --generate-completion zsh > ~/.config/zsh/completion/_delta

printf 'Updating \033[0;34mEza\033[0m completions\n'
wget -q https://raw.githubusercontent.com/eza-community/eza/main/completions/zsh/_eza\
 -O ~/.config/zsh/completion/_eza

printf 'Updating \033[0;34mGitHub CLI\033[0m completions\n'
gh completion -s zsh > ~/.config/zsh/completion/_gh

printf 'Updating \033[0;34mVolta\033[0m completions\n'
volta completions --quiet --force -o ~/.config/zsh/completion/_volta zsh

printf '\n\033[0;34mDone!\033[0m\n'
