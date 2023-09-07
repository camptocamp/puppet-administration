# @summary Manage MySQL administration
# @param sudo_user The user to allow to run mysqladmin
class administration::mysql (
  String $sudo_user = undef,
) {
  $sudo_user_alias = flatten(['%mysql-admin', $sudo_user])
  $sudo_cmnd = $::os['family'] ? {
    'Debian' => '/etc/init.d/mysql, /bin/systemctl * mysql, /bin/systemctl * mariadb',
    'RedHat' => '/etc/init.d/mysqld, /sbin/service mysqld, /usr/bin/systemctl * mysql, /bin/systemctl * mariadb',
  }

  ensure_resource(
    'group',
    'mysql-admin',
    {
      ensure => present,
      system => true,
    }
  )

  sudo::conf { 'mysql-administration' :
    ensure  => present,
    content => template('administration/mysql/sudoers.erb'),
    require => Group['mysql-admin'],
  }
}
