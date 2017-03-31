class administration::nginx(
  $sudo_user = undef,
) {
  $nginx_user = $::operatingsystem ? {
    'Debian' => 'www-data',
    'Ubuntu' => 'www-data',
    'RedHat' => 'nginx',
    'Fedora' => 'nginx',
    'CentOS' => 'nginx',
  }

  group { 'nginx-admin':
    ensure => present,
    system => true,
  }

  -> sudo::conf { 'nginx-administration':
    ensure  => present,
    content => template('administration/nginx/sudoers.erb'),
  }

}
