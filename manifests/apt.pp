# == Class: duo_unix::apt
#
# Provides duo_unix for an apt-based environment (e.g. Debian/Ubuntu)
#
# === Authors
#
# Mark Stanislav <mstanislav@duosecurity.com>
#
class duo_unix::apt {
  $repo_file = '/etc/apt/sources.list.d/duosecurity.list'
  $repo_uri  = 'http://pkg.duosecurity.com'

  if $duo_unix::manage_ssh {
    package { 'openssh-server': 
      ensure => installed;
    }
  }

  package { $duo_unix::duo_package: 
    ensure  => latest,
    require => [ File[$repo_file], Exec['duo-security-apt-update'], Exec['Duo Security GPG Import'] ];
  }

  file { $repo_file:
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "deb ${repo_uri}/${::operatingsystem} ${::lsbdistcodename} main",
    notify  => Exec['duo-security-apt-update'];
  }

  exec { 'duo-security-apt-update':
    command     => '/usr/bin/apt-get update',
    refreshonly => true;
  }

  exec { 'Duo Security GPG Import':
    command => '/usr/bin/apt-key add /etc/apt/DEB-GPG-KEY-DUO',
    unless  => '/usr/bin/apt-key list | grep "Duo Security"';
  }
}
