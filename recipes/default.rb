#
# Cookbook Name:: dotfiles
# Recipe:: default
#
# Copyright (c) 2016 Anderson Bravalheri, All Rights Reserved.

PERMISSIONS = '0644'.freeze

# Select normal user home directories
# information node['etc']['passwd'] is grabbed by Ohio
users = node['etc']['passwd'].select { |_, u| u['uid'].to_i > 1000 }

# If wanted /etc/skel support can be added with root
# users['root'] = { 'dir' => '/etc/skel', 'gid' => 'root' }

# Directories to be created
dirs = (
  %w(bash).map { |d| ".config/#{d}" }
)

# Dotfiles to be copied int the format: src => dest
dotfiles = {
  'bash/bashrc' => '.bashrc'
}

config_files = %w(
  bash/git-prompt.sh
)

dotfiles.merge!(Hash[config_files.map { |f| [f, ".config/#{f}"] }])

# Apply dotfiles
users.each do |username, data|
  home = data['dir']
  gid = data['gid']

  # Create config dirs
  dirs.each do |dir|
    directory(File.expand_path(dir, home)) do
      source src
      owner username
      group gid
      mode PERMISSIONS
      recursive true
    end
  end

  # Copy dotfiles
  dotfiles.each do |src, dest|
    cookbook_file(File.expand_path(dest, home)) do
      source src
      owner username
      group gid
      mode PERMISSIONS
      action :create_if_missing
    end
  end
end
