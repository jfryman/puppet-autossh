define autossh::tunnel (
  $ensure       = 'present',
  $user,
  $bind_address = 'localhost',
  $port,
  $host         = 'localhost',
  $hostport,
  $remote_host,
  $remote_port  = '22',
  $remote_user  = 'absent',
  $monitor_port = 'absent',
  $gatetime     = 'absent',
  $first_poll   = 'absent',
  $poll         = 'absent',
  $maxstart     = 'absent',
  $maxlifetime  = 'absent',
  $logfile      = 'absent'
) {
  include autossh

  File { 
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  $ssh_remote_port = "-p ${remote_port}"
  
  $real_remote_user = $remote_user ? {
      'absent' => $user,
      default => $remote_user,
  } 

  # According to the autossh documentation, using OpenSSH ServerAlive 
  # options is better than using a monitor port, so we do that by default.
  if ($monitor_port == 'absent') {
    $real_monitor_port = 0
    $ssh_extra_options = "-o ServerAliveInterval=30 -o ServerAliveCountMax=3"
  }
  else {
    $real_monitor_port = $monitor_port
    $ssh_extra_options = ''
  }

  if ($ensure == 'present') {

    $template = $::osfamily ? { 
      'RedHat' => 'autossh/autossh-tunnel-redhat.erb',
      default => 'autossh/autossh-tunnel.erb'
    }

    file { "/etc/init.d/autossh-tunnel-${name}":
      ensure  => file,
      mode    => '0755',
      require => Class['autossh::package'],
      content => template($template),
      notify => Service["autossh-tunnel-${name}"],
    }
    service { "autossh-tunnel-${name}":
      ensure     => 'running',
      hasrestart => 'true',
      hasstatus  => 'true',
      require    => File["/etc/init.d/autossh-tunnel-${name}"],
    }
  }
  else {
    exec { "autossh-tunnel-${name}_stop":
      command => "/etc/init.d/autossh-tunnel-${name} stop",
      path => "/bin:/sbin:/usr/sbin:/usr/bin",
      onlyif => "test -x /etc/init.d/autossh-tunnel-${name} && test -e /var/run/autossh-tunnel-${name}.pid",
    } 
    file { "/etc/init.d/autossh-tunnel-${name}":
      ensure => absent,
      require => Exec["autossh-tunnel-${name}_stop"],
    }
  }
}
