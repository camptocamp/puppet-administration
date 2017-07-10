# == Class: administration::tomcat
#
# Creates a "tomcat-admin" group and use sudo to allows members of this group
# to:
# - su to the tomcat user (which allows to kill java, remove lockfiles, etc)
# - restart tomcat instances.
#
# Requires:
# - definition sudo::conf from module saz/puppet-sudo
#
# Warning: will overwrite /etc/sudoers !
#
class administration::tomcat (
  $sudo_user = undef,
) {

  $sudo_group = '%tomcat-admin'
  $sudo_user_alias = flatten([$sudo_group, $sudo_user])
  $sudo_cmnd = '/etc/init.d/tomcat-*, /usr/bin/systemctl * tomcat, /bin/systemctl * tomcat, /bin/systemctl * tomcat-*, /bin/su tomcat, /bin/su - tomcat'

  group { 'tomcat-admin':
    ensure => present,
    system => true,
  }

  sudo::conf { 'tomcat-administration':
    ensure  => present,
    content => template('administration/tomcat/sudoers.erb'),
    require => Group['tomcat-admin'],
  }

}
