# == Class: administration::postgresql
#
# This class will create a "postgresql-admin" group and add a couple of rules
# to /etc/sudoers allowing members of this group to administer postgresql
# databases.
#
# Requires:
#  - definition sudo::conf from module saz/puppet-sudo
#
class administration::postgresql (
  $sudo_user = undef,
) {
  $sudo_group = '%postgresql-admin'
  $sudo_user_alias = flatten([$sudo_group, $sudo_user])
  $sudo_cmnd = '/etc/init.d/postgresql, /etc/init.d/postgresql-*, /usr/bin/systemctl * postgresql*, /bin/systemctl * postgresql*, /bin/su postgres, /bin/su - postgres'

  group { 'postgresql-admin':
    ensure => present,
    system => true,
  }

  sudo::conf { 'postgresql-administration':
    ensure  => present,
    content => template('administration/postgresql/sudoers.erb'),
    require => Group['postgresql-admin'],
  }

}

