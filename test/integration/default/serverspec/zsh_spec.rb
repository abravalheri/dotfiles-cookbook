require 'spec_helper'

describe file('/home/vagrant/.zshrc') do
  its(:content) do
    should include '${XDG_CONFIG_HOME:=$HOME/.config}'
    should include '${XDG_DATA_HOME:=$HOME/.local/share}'
    should include '${XDG_CACHE_HOME:=$HOME/.cache}'
    should include 'export VIMDIR=$HOME/.vim'
    should include 'source $DOTFILES/zsh/extras.zsh'
  end
end
