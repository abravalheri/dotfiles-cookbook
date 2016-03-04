require 'spec_helper'

describe file('/home/vagrant/.config/git') do
  it { should be_directory }
end

describe file('/home/vagrant/.config/git/config') do
  it { should be_file }

  its(:content) do
    should include %w(
      lola = log --graph --decorate --pretty=oneline
      --abbrev-commit --all --date=local
    ).join(' ')
  end
end
