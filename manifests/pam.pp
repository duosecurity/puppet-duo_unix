# == Class: duo_unix::pam
#
# Provides duo_unix functionality for SSH via PAM
#
# === Authors
#
# Mark Stanislav <mstanislav@duosecurity.com>
#
class duo_unix::pam inherits duo_unix {
  $aug_pam_path = "/files${duo_unix::pam_file}"
  $aug_match    = "${aug_pam_path}/*/module[. = '${duo_unix::pam_module}']"

  file { '/etc/duo/pam_duo.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('duo_unix/duo.conf.erb'),
    require => Package[$duo_unix::duo_package];
  }

  if $duo_unix::manage_ssh {
    augeas { 'Duo Security SSH Configuration' :
      changes => [
        'set /files/etc/ssh/sshd_config/UsePAM yes',
        'set /files/etc/ssh/sshd_config/UseDNS no',
        'set /files/etc/ssh/sshd_config/ChallengeResponseAuthentication yes'
      ],
      require => Package[$duo_unix::duo_package],
      notify  => Service[$duo_unix::ssh_service];
    }
  }

  if $::osfamily == 'RedHat' {
    augeas { 'PAM Configuration':
      changes => [
        "set ${aug_pam_path}/2/control ${duo_unix::pam_unix_control}",
        "ins 100 after ${aug_pam_path}/2",
        "set ${aug_pam_path}/100/type auth",
        "set ${aug_pam_path}/100/control sufficient",
        "set ${aug_pam_path}/100/module ${duo_unix::pam_module}"
      ],
      require => Package[$duo_unix::duo_package],
      onlyif  => "match ${aug_match} size == 0";
    }

  } else {
    augeas { 'PAM Configuration':
      changes => [
        "set ${aug_pam_path}/1/control ${duo_unix::pam_unix_control}",
        "ins 100 after ${aug_pam_path}/1",
        "set ${aug_pam_path}/100/type auth",
        "set ${aug_pam_path}/100/control '[success=1 default=ignore]'",
        "set ${aug_pam_path}/100/module ${duo_unix::pam_module}"
      ],
      require => Package[$duo_unix::duo_package],
      onlyif  => "match ${aug_match} size == 0";
    }
  }

}
