require 'yaml'

default['tmux'] = node['tmux'].merge(YAML.safe_load(<<~END))
  version: 2.4
  checksum: 757d6b13231d0d9dd48404968fc114ac09e005d475705ad0cd4b7166f799b349
  install_method: source
  session_opts:
    prefix: C-b
END

default['vim'].tap do |v|
  v['install_method'] = 'source'
  v['source'] = v['source'].merge(YAML.safe_load(<<~END))
    version: 8.0
    checksum: 08bd0d1dd30ece3cb9905ccd48b82b2f81c861696377508021265177dc153a61
  END
end
