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

# This recipe assumes the dotfiles are organized in a single folder `dotfiles`
# inside the `$XDG_CONFIG_DIR` and a
# [dotbot](https://github.com/anishathalye/dotbot) script is used to
# link the files to the correct location.

PERMISSIONS = '0755'.freeze
DOTFILES_DIR = '.config/dotfiles'.freeze
DOTFILES_REPO = 'https://github.com/abravalheri/dotfiles'.freeze
DOTBOT_CONFIG = 'install.conf.yaml'.freeze
REQUIRED_DIRS = ['.config'].freeze # Required directories
LOCAL_DOTFILES = %w(+local.vim).freeze
#  ^ For simplicity let"s use the binary name as extension and as folder

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

# rubocop:disable Style/PerlBackrefs
find_dotbot_links = lambda do |home, iterator|
  # Search for a `instal.conf.yaml` file in the `<path>` directory,
  # and return the links described by it.
  # This file should follow the
  # [dotbot convention](https://github.com/anishathalye/dotbot).

  ruby_block 'find dotfiles links' do
    block do
      require 'yaml'

      expand_env = lambda do |str|
        str.gsub(/\$([a-zA-Z_]+[a-zA-Z0-9_]*)|\$\{(.+)\}/) { ENV[$1 || $2] }
      end

      path = File.expand_path(DOTFILES_DIR, home)
      config = YAML.load_file(File.expand_path(DOTBOT_CONFIG, path))
      links = config.inject(&:merge)['link']

      ENV['HOME'] = home
      ENV['DOTFILES'] = path

      links.each do |dest, src|
        iterator.call(expand_env[dest], expand_env[src])
      end
    end
  end
end
# rubocop:enable Style/PerlBackrefs

# Apply dotfiles
users.each do |username, data|
  home = data['dir']
  gid = data['gid']

  home_path = home_path_[home]
  dotfiles_path = dotfiles_path_[home]
  git_clone = git_clone_[username, gid]
  copy_file = copy_file_[username, gid]
  ensure_dir = ensure_dir_[username, gid]
  ensure_link = ensure_link_[username, gid, home]

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
  find_dotbot_links[home, ensure_link]
end
