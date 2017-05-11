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

include_recipe 'locale'

PERMISSIONS = '0755'.freeze
DOTFILES_DIR = '.config/dotfiles'.freeze
DOTFILES_REPO = 'https://github.com/abravalheri/dotfiles'.freeze
REQUIRED_DIRS = ['.config'].freeze # Required directories
LOCAL_DOTFILES = %w(+local.vim).freeze
#  ^ For simplicity let"s use the binary name as extension and as folder
LINKS = {
  '.zshrc' => 'zsh/init.zsh',
  "#{DOTFILES_DIR}/vim/vimrc" => 'vim/init.vim',
  '.config/nvim' => 'vim',
  '.config/vim' => 'vim',
  '.vim' => 'vim',
  '.config/git' => 'git',
  '.tmux.conf' => 'tmux/init.tmux'
}.freeze
# ^ target => original hash map.
#   The target is relative to home, while the original is relative to
#   dotfiles directory

package %w(zsh python)

# Ensure user data is updated
ohai('reload') { action :reload }

# Select normal user home directories
# information node["etc"]["passwd"] is grabbed by Ohio
users = node['etc']['passwd'].select do |_, u|
  u['dir'].match(%r{^/home/}ui) && !u['shell'].match(/null|false|nologin/ui)
end

# If wanted /etc/skel support can be added with root
# users["root"] = { "dir" => "/etc/skel", "gid" => "root" }

# Helpers
home_path_ = ->(home, path) { File.expand_path(path, home) }.curry

dotfiles_path_ = lambda do |home, path|
  File.expand_path(path, home_path_[home, DOTFILES_DIR])
end.curry

git_clone_ = lambda do |username, gid, dest, repo, rev|
  git(dest) do
    repository repo
    revision rev
    enable_submodules true
    action :sync
    group gid
    user username
  end
end.curry

copy_file_ = lambda do |username, gid, src, dest|
  cookbook_file(dest) do
    source src
    owner username
    group gid
    mode PERMISSIONS
  end
end.curry

ensure_dir_ = lambda do |username, gid, path|
  directory(path) do
    owner username
    group gid
    mode PERMISSIONS
    recursive true
  end
end.curry

ensure_link_ = lambda do |username, gid, home, dest, src|
  link(home_path_[home, dest]) do
    to dotfiles_path_[home, src]
    owner username
    group gid
    mode PERMISSIONS
    link_type :symbolic
  end
end.curry

# Apply dotfiles
users.each do |username, data|
  home = data['dir']
  gid = data['gid']

  home_path = home_path_.call(home)
  dotfiles_path = dotfiles_path_.call(home)
  git_clone = git_clone_.call(username, gid)
  copy_file = copy_file_.call(username, gid)
  ensure_dir = ensure_dir_.call(username, gid)
  ensure_link = ensure_link_.call(username, gid, home)

  # Create config dirs
  REQUIRED_DIRS.each { |dir| ensure_dir[home_path[dir]] }

  # Install dotfiles from separated repository
  git_clone[dotfiles_path['.'], DOTFILES_REPO, 'master']

  # Copy deviant dotfiles
  LOCAL_DOTFILES.each do |src|
    ext = File.extname(src).gsub(/^\./, '')
    dest = dotfiles_path["#{ext}/#{src}"]
    copy_file[src, dest]
  end

  # Ensure correct rights to dotfiles
  ensure_dir[dotfiles_path['.']]

  # Change shell to zsh
  user(username) { shell '/bin/zsh' }

  # Ensure dotfiles linked correctly
  LINKS.each { |dest, src| ensure_link[dest, src] }
end
