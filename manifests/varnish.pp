class administration::varnish(
  $sudo_user = undef,
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
