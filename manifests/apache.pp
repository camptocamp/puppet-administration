# == Class administration::apache
#
class administration::apache (
  $sudo_user = undef,
) {

  case $::operatingsystem {
    'Debian': {
      $apache_user = 'apache'
      $apache_service = 'apache2'
      $service_path = '/usr/sbin/service'
      $systemctl_path = '/bin/systemctl'
      $apachectl_path = '/usr/sbin/apachectl'
      $systemd = versioncmp($::operatingsystemmajrelease, '8') >= 0
    }
    'Ubuntu': {
      $apache_user = 'apache'
      $apache_service = 'apache2'
      $service_path = '/usr/sbin/service'
      $systemctl_path = '/usr/bin/systemctl'
      $apachectl_path = '/usr/sbin/apache2ctl'
      $systemd = versioncmp($::operatingsystemmajrelease, '16.04') >= 0
    }
    'RedHat': {
      $apache_user = 'www-data'
      $apache_service = 'httpd'
      $service_path = '/sbin/service'
      $systemctl_path = '/usr/bin/systemctl'
      $apachectl_path = '/usr/sbin/apachectl'
      $systemd = versioncmp($::operatingsystemmajrelease, '7') >= 0
    }
    'CentOS': {
      $apache_user = 'www-data'
      $apache_service = 'httpd'
      $service_path = '/usr/sbin/service'
      $systemctl_path = '/usr/bin/systemctl'
      $apachectl_path = '/usr/sbin/apachectl'
      $systemd = versioncmp($::operatingsystemmajrelease, '7') >= 0
    }
    default: { fail('Unsupported Linux distribution') }
  }

  group { 'apache-admin':
    ensure => present,
    system => true,
  }

  $sudo_group = '%apache-admin'
  $sudo_user_alias = flatten([$sudo_group, $sudo_user])

  $common_sudo_cmnd = "/bin/su ${apache_user}, /bin/su - ${apache_user}, ${service_path} ${apache_service} *"
  $sudo_cmnd = $systemd ? {
    true  => "${systemctl_path} * ${apache_service}, ${apachectl_path} configtest, ${apachectl_path} graceful, ${common_sudo_cmnd}",
    false => "/etc/init.d/${apache_service}, ${apachectl_path} *, ${common_sudo_cmnd}",
  }

  sudo::conf { 'apache-administration':
    ensure  => present,
    content => template('administration/apache/sudoers.erb'),
    require => Group['apache-admin'],
  }

}
