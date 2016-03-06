#
# Cookbook Name:: dotfiles
# Recipe:: default
#
# Author:: Anderson Bravalheri <andersonbravalheri@gmail.com>
# Copyright (c) 2016, Anderson Bravalheri
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

PERMISSIONS = '0755'.freeze

# Select normal user home directories
# information node['etc']['passwd'] is grabbed by Ohio
users = node['etc']['passwd'].select do |_, u|
  u['dir'].match(%r{^/home/}ui) && !u['shell'].match(/null|false|nologin/ui)
end

# If wanted /etc/skel support can be added with root
# users['root'] = { 'dir' => '/etc/skel', 'gid' => 'root' }

# Directories to be created recursively
dirs = (
  %w(bash tmux git vim).map { |d| ".config/#{d}" } +
  %w(undo swap backup).map { |d| ".cache/vim/#{d}" } +
  %w(.vim/plugins)
)

# Dotfiles to be copied int the format: src => dest
dotfiles = {
  'bash/bashrc' => '.bashrc',
  'tmux/tmux.conf' => '.tmux.conf',
  'git/config' => '.config/git/config',
  'vim/vimrc' => '.vim/vimrc'
}

config_files = (
  %w(style clipboard).map { |f| "tmux/#{f}.tmux" } +
  %w(main extras plugins tmuxline).map { |f| "vim/#{f}.vim" }
)

dotfiles.merge!(Hash[config_files.map { |f| [f, ".config/#{f}"] }])

# Apply dotfiles
users.each do |username, data|
  home = data['dir']
  gid = data['gid']

  # Create config dirs
  dirs.each do |dir|
    directory(File.expand_path(dir, home)) do
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
    end
  end

  # Display git info in prompt
  remote_file File.expand_path(".config/bash/git-prompt.sh", home) do
    source <<-EOS.strip
      https://github.com/git/git/raw/master/contrib/completion/git-prompt.sh
    EOS
    owner username
    group gid
    mode PERMISSIONS
  end

  # Install Vundle
  git(File.expand_path('.vim/plugins/Vundle.vim', home)) do
    repository 'https://github.com/VundleVim/Vundle.vim'
    revision 'master'
    action :sync
    group gid
    user username
  end

  execute "install #{username} vim plugins" do
    user username
    group gid
    cwd home

    environment(
      'HOME' => home,
      'VIMDIR' => "#{home}/.vim",
      'CONFIG_HOME' => "#{home}/.config",
      'CACHE_HOME' => "#{home}/.cache"
    )

    command %W(
      vim -E -s
      -c "source #{home}/.vim/vimrc"
      -c "set shortmess=at"
      -c "PluginInstall"
      -c "qa!"
      -V 2>&1 | cat
    ).join(' ')
  end
end
