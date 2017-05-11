#!/usr/bin/env bats

@test "vim plugins installed" {
  export HOME=/home/kitchen
  export CONFIG_HOME=$HOME/.config
  export CACHE_HOME=$HOME/.cache
  export VIMDIR=$HOME/.vim

  vim -E -s \
    -c "source $VIMDIR/vimrc" \
    -c "PlugStatus" -c qall -V &> /tmp/test-plugins.txt | cat

  cat /tmp/test-plugins.txt
  [ $(cat /tmp/test-plugins | grep "0 errors" | wc -l) -eq 1 ]
}
