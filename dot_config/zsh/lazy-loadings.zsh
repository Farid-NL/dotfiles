# sdkman
sdk() {
  unfunction sdk
  [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

  sdk "$@"
}

# miniconda
conda() {
  unfunction conda
  __conda_setup="$("$CONDA_DIR/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "$CONDA_DIR/etc/profile.d/conda.sh" ]; then
          . "$CONDA_DIR/etc/profile.d/conda.sh"
      else
          export PATH="$CONDA_DIR/bin:$PATH"
      fi
  fi
  unset __conda_setup

  conda "$@"
}
