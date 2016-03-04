#!/usr/bin/env bats

@test "bashrc run silently" {
  [ $(source ~/.bashrc 2>&1 | wc -l) -eq 0 ]
}

@test "bashrc configure desired variables" {
  [ -n $CONFIG_HOME ]
  [ -n $CACHE_HOME ]
  [ -n $VIMDIR ]
}