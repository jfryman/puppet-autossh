# Puppet autossh module

[Autossh](http://www.harding.motd.ca/autossh/) is a ssh client monitor that
creates persistent SSH tunnels. This module configures autossh, and thus
enables you to define a SSH tunnel with puppet.

**Please be careful when dealing with SSH. Mistakes can potentially leave your
servers exposed. Always verify that this module did what you *think* it should
have.**.

## Compatibility

This module was originally written for LSB-compliant operating systems and it
works on Debian and Ubuntu. An early alternative startup script for RedHat
(CentOS, RHEL etc) family of operating systems is provided.

Please be advised that on RHEL, autossh is absent from the default yum
repositories, and you may want to add the rpmforge ones, as this module will
attempt to install autossh and fail if it isn't available.

This module is known to work under puppet 3.x, and it is likely it will work
under earlier 2.7+ versions.

## Usage

This module creates a script in `/etc/init.d/autossh-tunnel-<name>` that starts
and stops the tunnel. 

Before using this module, please read the manual for `ssh(1)` and particularly
its `-L` option. Autossh itself has very few command line switches and most of
the arguments are passed to the underlying ssh  directly.

**In order to use autossh, you need to provision system users, a SSH keypair,
host fingerprint authentication (`known_hosts`) and client authorization
(`authorized_keys`). This module does not do any of this.**

The required parameters for `autossh::tunnel` are `user`, `port` and `hostport`. 

The following elaborate example will create a tunnel that forwards the local
port `81` to `127.0.0.1:80` on host `ssh.invalid.org` where SSH is listening
on the port `2222`. Autossh will pick up the private key from local user
`tunnel` and connect as the remote user `tunnels_only`.

```
autossh::tunnel { 'my-shiny-new-tunnel':
                # Autossh will run as this local user
                user => 'tunnel',
                # Remote user to connect as 
                remote_user => 'tunnels_only'
                # SSH server address
                remote_host => 'ssh.invalid.org',
                # SSH server port
                remote_port => '2222',

                # Connections to this port on this node will be forwarded to...
                port => '81',
                # ...this port on localhost on the SSH server
                hostport => '80',

}

```