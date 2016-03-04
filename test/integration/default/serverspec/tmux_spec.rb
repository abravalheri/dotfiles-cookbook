require 'spec_helper'

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
    should include 'source-file $CONFIG_HOME/tmux/style.tmux'
  end
end
