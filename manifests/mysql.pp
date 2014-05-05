class administration::mysql (
  $sudo_user = undef,
) {

  $sudo_user_alias = flatten(['%mysql-admin', $sudo_user])
  $sudo_cmnd = $::osfamily ? {
    Debian => '/etc/init.d/mysql',
    RedHat => '/etc/init.d/mysqld, /sbin/service mysqld',
  }

  ensure_resource(
    'group',
    'mysql-admin',
    {
      ensure => present,
      system => true,
    }
  )

  sudo::conf { 'mysql-administration':
    ensure  => present,
    content => template('administration/mysql/sudoers.erb'),
    require => Group['mysql-admin'],
  }

}
