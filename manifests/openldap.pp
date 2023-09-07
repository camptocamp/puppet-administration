# @summary Configure OpenLDAP administration
# @param sudo_user The user to allow to run the OpenLDAP administration commands
class administration::openldap (
  String $sudo_user = undef,
) {
  group { 'openldap-admin':
    ensure => present,
    system => true,
  }

  sudo::conf { 'openldap-administration':
    ensure  => present,
    content => template('administration/openldap/sudoers.erb'),
    require => Group['openldap-admin'],
  }
}
