class autossh::config {
  user { 'autossh':
    ensure  => present,
    comment => 'AutoSSH Daemon User',
    shell   => '/bin/bash',
    uid     => '450',
  }
}
