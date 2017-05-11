name 'dotfiles'
version '0.1.0'
license 'Mozilla Public License, v. 2.0 (http://mozilla.org/MPL/2.0/)'

maintainer 'Anderson Bravalheri'
maintainer_email 'andersonbravalheri@gmail.com'

source_url 'https://github.com/abravalheri/dotfiles-cookbook'
issues_url 'https://github.com/abravalheri/dotfiles-cookbook/issues'

description 'Resources for installing dotfiles from git repos using chef'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))

chef_version '~> 13'

depends 'locale', '~> 2.0.1'

supports 'ubuntu'
supports 'debian'
supports 'centos'
