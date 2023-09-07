# @summary Setup varnish administration
# @param sudo_user The user to allow to run varnishadm
class administration::varnish (
  String $sudo_user = undef,
) {
  group { 'varnish-admin':
    ensure => present,
    system => true,
  }

  -> sudo::conf { 'varnish-administration':
    ensure  => present,
    content => template('administration/varnish/sudoers.erb'),
  }
}
