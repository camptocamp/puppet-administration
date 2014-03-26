class administration::mysql (
  $sudo_user = $sudo_mysql_admin_user,
) {

  $sudo_group = '%mysql-admin'
  $sudo_user_alias = flatten([$sudo_group, $sudo_user])
  $sudo_cmnd = $::osfamily ? {
    Debian => '/etc/init.d/mysql',
    RedHat => '/etc/init.d/mysqld, /sbin/service mysqld',
  }

  sudo::conf { 'mysql-administration':
    ensure  => present,
    content => template('administration/mysql/sudoers.erb'),
    require => Group['mysql-admin'],
  }

}
