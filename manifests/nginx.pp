# @summary This class installs and configures nginx administration
# @param sudo_user [String] The user that will be allowed to run nginx commands
class administration::nginx (
  String $sudo_user = undef,
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
