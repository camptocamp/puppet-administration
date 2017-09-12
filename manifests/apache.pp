# == Class administration::apache
#
class administration::apache (
  $sudo_user = undef,
  $service_user = undef,
  $service_name = undef,
) {

  $distro_specific_apache_sudo = $::osfamily ? {
    'Debian' => '/usr/sbin/apache2ctl',
    'RedHat' => '/usr/sbin/apachectl, /sbin/service httpd',
  }

  group { 'apache-admin':
    ensure => present,
    system => true,
  }

  $_service_name = $service_name ? {
    undef => $::osfamily ? {
      'Debian' => 'apache2',
      'RedHat' => 'httpd',
    },
    default => $service_name,
  }

  $_service_user = $service_user ? {
    undef => $::osfamily ? {
      'Debian' => 'www-data',
      'RedHat' => 'apache',
    },
    default => $service_user,
  }

  $sudo_group = '%apache-admin'
  $sudo_user_alias = flatten([$sudo_group, $sudo_user])
  $sudo_cmnd = "/etc/init.d/${_service_name}, /usr/bin/systemctl * ${_service_name}, /bin/systemctl * ${_service_name}, /bin/su ${_service_user}, /bin/su - ${_service_user}, ${distro_specific_apache_sudo}"

  sudo::conf { 'apache-administration':
    ensure  => present,
    content => template('administration/apache/sudoers.erb'),
    require => Group['apache-admin'],
  }

}
