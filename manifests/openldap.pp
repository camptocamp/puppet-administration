class administration::openldap(
  $sudo_user = undef,
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
