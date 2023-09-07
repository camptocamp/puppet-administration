# @summary Configure sudo access for memcached administration
# @param sudo_user The user to grant sudo access to
class administration::memcached (
  String $sudo_user = undef,
) {
  group { 'memcached-admin' :
    ensure => present,
  }

  $sudo_group = '%memcached-admin'
  $sudo_user_alias = flatten([$sudo_group, $sudo_user])
  $sudo_cmnd = '/etc/init.d/memcached, /usr/bin/systemctl * memcached, /bin/systemctl * memcached'

  sudo::conf { 'memcached-administration' :
    ensure  => present,
    content => template('administration/memcached/sudoers.erb'),
    require => Group['memcached-admin'],
  }
}
