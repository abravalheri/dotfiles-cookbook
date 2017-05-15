describe file('/home/vagrant/.config/tmux') do
  it { should be_directory }
end

%w(clipboard style).each do |f|
  describe file("/home/vagrant/.config/tmux/#{f}.tmux") do
    it { should be_file }
  end
end

describe file('/home/vagrant/.tmux.conf') do
  its(:content) do
    should include 'bind R source-file'
    should include 'tmux reloaded!'
    should include 'tmux source-file "$DOTFILES/tmux/style/$TMUX_STYLE.tmux'
  end
end
