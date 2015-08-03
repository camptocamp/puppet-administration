# == Class administration::apache
#
class administration::apache (
  $sudo_user = undef,
) {

  $distro_specific_apache_sudo = $::osfamily ? {
    'Debian' => '/usr/sbin/apache2ctl',
    'RedHat' => '/usr/sbin/apachectl, /sbin/service httpd',
  }

  group { 'apache-admin':
    ensure => present,
    system => true,
  }

  # used in erb template
  $wwwpkgname = $::osfamily ? {
    'Debian' => 'apache2',
    'RedHat' => 'httpd',
  }

  $wwwuser    = $::osfamily ? {
    'Debian' => 'www-data',
    'RedHat' => 'apache',
  }

  $sudo_group = '%apache-admin'
  $sudo_user_alias = flatten([$sudo_group, $sudo_user])
  $sudo_cmnd = "/etc/init.d/${wwwpkgname}, /usr/bin/systemctl * ${wwwpkgname}, /bin/systemctl * ${wwwpkgname}, /bin/su ${wwwuser}, /bin/su - ${wwwuser}, ${distro_specific_apache_sudo}"

  sudo::conf { 'apache-administration':
    ensure  => present,
    content => template('administration/apache/sudoers.erb'),
    require => Group['apache-admin'],
  }

}
