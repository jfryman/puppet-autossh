class autossh::package {
  package { $autossh::params::ah_package:
    ensure => present,
  }
}
