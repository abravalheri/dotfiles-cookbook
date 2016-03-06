# dotfiles
Custom dotfiles targeting remote terminal access using Chef

## Requirements
This cookbook does not install any package, just manage configuration files. Please ensure the following packages are installed before running this cookbook recipes:

- `vim` with lua support, e.g. `vim-nox` on ubuntu
- `git`
- `xclip`
- `tmux >= 2.1`

### Platforms
Tested on Ubuntu 14.04, Debian and CentOS.

## Recipes

### `dotfiles::default`
Creates `~/.bashrc`, `~/.tmux.conf`,  `~/.config/git/config`, `~/.vim/vimrc` and auxiliary files for all normal users. Also installs Vundle and additional vim plugins.

## Details
`.bashrc` is based on default ubuntu bashrc, but additionally:
- export `{DATA|CONFIG|CACHE}_HOME` (accoding to XDG specification), `VIMDIR` (`~/.vim`)
- configure `PROMPT_COMMAND` to use git-prompt.sh
- start a default `tmux` session named "main" and connect to it

`.tmux.conf` configures:
- a clean and useful design for terminal
- mouse integration
- clipboard integration using `xclip`
- _open in current dir_ behavior for new windows

`~/.config/git/config` sets:
- useful aliases like `git lola` and `git tree`
- simple push
- patient diff
- https credential helper
- invalid user name/email for a shared server (relies on GIT_AUTHOR_* env vars)
- sensible defaults for linux users

`~/.vim/vimrc` minimizes XDG BASE DIRs non-compliant mess and uses Vundle to manage vim plugins, including:
- default molokai theme
- tmux integration
- lightline (for beauty)
- NERDtree
- auto completion
- git support
- enhanced syntax for ruby, es6, coffee-script, css, markdown, html5
- tons of sensible defaults...
