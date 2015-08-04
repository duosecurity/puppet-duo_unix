# == Class: duo_unix::login
#
# Provides duo_unix functionality for SSH via ForceCommand
#
# === Authors
#
# Mark Stanislav <mstanislav@duosecurity.com>
#
class duo_unix::login inherits duo_unix {

  file { '/etc/duo/login_duo.conf':
    ensure  => present,
    owner   => 'sshd',
    group   => 'root',
    mode    => '0600',
    content => template('duo_unix/duo.conf.erb'),
    require => Package[$duo_unix::duo_package];
  }

  if $duo_unix::manage_ssh {
    augeas { 'Duo Security SSH Configuration' :
      changes => [
        'set /files/etc/ssh/sshd_config/ForceCommand /usr/sbin/login_duo',
        'set /files/etc/ssh/sshd_config/PermitTunnel no',
        'set /files/etc/ssh/sshd_config/AllowTcpForwarding no'
      ],
      require => Package[$duo_unix::duo_package],
      notify  => Service[$duo_unix::ssh_service];
    }
  }

}
