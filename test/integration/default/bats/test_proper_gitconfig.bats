#!/usr/bin/env bats

@test "git configure desired parameters" {
  export HOME=/home/vagrant

  [ $(git config --global user.email) = "not@email.com" ]
  [ $(git config --global push.default) = "simple" ]
  [ $(git config --global core.autocrlf) = "input" ]
  [ $(git config --global core.eol) = "lf" ]
  [ $(git config --global core.whitespace) = "trailing-space,space-before-tab" ]
}