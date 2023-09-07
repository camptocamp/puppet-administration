# == Class administration::apache
#
# This class manages sudo access for apache administration.
# @param sudo_user [String] The user to grant sudo access to.
# @param service_user [String] The user that the apache service runs as.
# @param service_name [String] The name of the apache service.
# @param additional_commands [Array] Additional commands to allow sudo access to.
class administration::apache (
  String $sudo_user = undef,
  String $service_user = undef,
  String $service_name = undef,
  String $additional_commands = undef,
) {
  $_additional_commands = $additional_commands ? {
    undef => $::os['family'] ? {
      'Debian' => '/usr/sbin/apache2ctl',
      'RedHat' => '/usr/sbin/apachectl, /sbin/service httpd',
    },
    default => $additional_commands,
  }

  $_service_name = $service_name ? {
    undef => $::os['family'] ? {
      'Debian' => 'apache2',
      'RedHat' => 'httpd',
    },
    default => $service_name,
  }

  $_service_user = $service_user ? {
    undef => $::os['family'] ? {
      'Debian' => 'www-data',
      'RedHat' => 'apache',
    },
    default => $service_user,
  }

  group { 'apache-admin':
    ensure => present,
    system => true,
  }

  $sudo_group = '%apache-admin'
  $sudo_user_alias = flatten([$sudo_group, $sudo_user])
  $sudo_cmnd = "/etc/init.d/${_service_name}, /usr/bin/systemctl * ${_service_name}, /bin/systemctl * ${_service_name}, /bin/su ${_service_user}, /bin/su - ${_service_user}, ${_additional_commands}"

  sudo::conf { 'apache-administration':
    ensure  => present,
    content => template('administration/apache/sudoers.erb'),
    require => Group['apache-admin'],
  }
}
