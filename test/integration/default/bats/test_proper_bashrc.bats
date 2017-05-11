#!/usr/bin/env bats

@test "zsh run silently" {
  [ $(source ~/.zshrc 2>&1 | wc -l) -eq 0 ]
}

@test "zshrc configure desired variables" {
  [ -n $ZSH ]
  [ -n $DOTFILES ]
  [ -n $XDG_CONFIG_HOME ]
  [ -n $XDG_CACHE_HOME ]
  [ -n $_Z_DATA ]
}

@test "shell is configured to zsh" {
  [ "$SHELL" = "/bin/zsh" ]
}
