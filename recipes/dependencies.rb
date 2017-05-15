#
# Cookbook:: dotfiles-cookbook
# Recipe:: dependencies
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Fix locale issue with ubuntu
if %w(debian ubuntu).include?(node['platform_family'])
  include_recipe 'apt'
  package %w(language-pack-en language-pack-pt)
  # file '/var/lib/locales/supported.d/local'
end

include_recipe 'locale'

# Tools

include_recipe 'git'
include_recipe 'tmux'
include_recipe 'vim'

package %w(zsh python)
python_runtime '2'
python_runtime '3'

python_package 'thefuck'

package 'xclip'
