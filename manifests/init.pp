class autossh {
  include stdlib
  include autossh::params

  anchor { 'autossh::begin': }
  -> class { 'autossh::package': }
  -> class { 'autossh::config': }
  -> anchor { 'autossh::end': }
}
