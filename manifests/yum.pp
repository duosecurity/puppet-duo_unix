# == Class: duo_unix::yum
#
# Provides duo_unix for a yum-based environment (e.g. RHEL/CentOS)
#
# === Authors
#
# Mark Stanislav <mstanislav@duosecurity.com>
#
class duo_unix::yum {
  $repo_uri = 'http://pkg.duosecurity.com'
  $package_state = $::duo_unix::package_version

  # Map Amazon Linux to RedHat equivalent releases
  # Map RedHat 5 to CentOS 5 equivalent releases
  if $::operatingsystem == 'Amazon' {
    $releasever = $::operatingsystemmajrelease ? {
      '2014'  => '6Server',
      default => undef,
    }
    $os = $::operatingsystem
  } elsif ( $::operatingsystem == 'RedHat' and $::operatingsystemmajrelease == 5 ) {
    $os = 'CentOS'
    $releasever = '$releasever'
  } elsif ( $::operatingsystem == "OracleLinux" ) {
    $os = 'CentOS'
    $releasever = '$releasever'
  } else {
    $os = $::operatingsystem
    $releasever = '$releasever'
  }

  yumrepo { 'duosecurity':
    descr    => 'Duo Security Repository',
    baseurl  => "${repo_uri}/${os}/${releasever}/\$basearch",
    gpgcheck => '1',
    enabled  => '1',
    require  => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-DUO'];
  }

  if $duo_unix::manage_ssh {
    package { 'openssh-server':
      ensure => installed;
    }
  }

  package {  $duo_unix::duo_package:
    ensure  => $package_state,
    require => [ Yumrepo['duosecurity'], Exec['Duo Security GPG Import'] ];
  }

  exec { 'Duo Security GPG Import':
    command => '/bin/rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-DUO',
    unless  => '/bin/rpm -qi gpg-pubkey | grep Duo > /dev/null 2>&1'
  }

}

