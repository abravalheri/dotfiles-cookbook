# # encoding: utf-8

# Inspec test for recipe dotfiles-cookbook::dependencies

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

%w(LANG LC_ALL).each do |var|
  describe os_env(var) { should_not eq nil }
end

{
  'git --version'     => 'git version 2',
  'python -V'         => 'Python 3',
  'thefuck --version' => 'The Fuck',
  'tmux -V'           => 'tmux 2.4',
  'vim -v'            => 'Vi IMproved 8.0',
  'zsh --version'     => 'zsh 5'
}.each do |cmd, output|
  describe bash(cmd) do
    its('stdout') { should include output }
  end
end
