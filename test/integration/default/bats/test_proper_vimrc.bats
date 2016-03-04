#!/usr/bin/env bats

@test "vim plugins installed" {
  export HOME=/home/vagrant
  export CONFIG_HOME=$HOME/.config
  export CACHE_HOME=$HOME/.cache
  export VIMDIR=$HOME/.vim

  vim -E -s \
    -c "source $VIMDIR/vimrc" \
    -c "PluginList" -c qall -V &> /tmp/test-vundle.txt | cat

  cat /tmp/test-vundle.txt
  [ $(cat /tmp/test-vundle.txt | grep "plugins configured" | wc -l) -eq 1 ]
}