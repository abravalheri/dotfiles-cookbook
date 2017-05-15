%w(
  .vim
  .vim/autoload
  .vim/+plugins
  .vim/+plugins/vimux
  .config/vim
).each do |d|
  describe file("/home/vagrant/#{d}") do
    it { should be_directory }
  end
end

%w(init extras plugins style).each do |f|
  describe file("/home/vagrant/.config/vim/#{f}.vim") do
    it { should be_file }
  end
end
