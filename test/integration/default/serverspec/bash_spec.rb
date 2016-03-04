require 'spec_helper'

describe file('/home/vagrant/.config/bash') do
  it { should be_directory }
end

describe file('/home/vagrant/.config/bash/git-prompt.sh') do
  it { should be_file }
end

describe file('/home/vagrant/.bashrc') do
  its(:content) do
    should include 'export CONFIG_HOME=${XDG_CONFIG_HOME:=$HOME/.config}'
  end

  its(:content) do
    should include 'export DATA_HOME=${XDG_DATA_HOME:=$HOME/.local/share}'
  end

  its(:content) do
    should include 'export CACHE_HOME=${XDG_CACHE_HOME:=$HOME/.cache}'
  end

  its(:content) { should include 'export VIMDIR=$HOME/.vim' }
end
