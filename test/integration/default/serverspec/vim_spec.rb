require 'spec_helper'

# check directories that should exist
# including a Vundle installed plugin
%w(
  .vim
  .vim/plugins
  .vim/plugins/Vundle.vim
  .vim/plugins/vimux
  .config/vim
).each do |d|
  describe file("/home/vagrant/#{d}") do
    it { should be_directory }
  end
end

%w(main extras plugins tmuxline).each do |f|
  describe file("/home/vagrant/.config/vim/#{f}.vim") do
    it { should be_file }
  end
end