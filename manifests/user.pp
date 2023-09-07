# @summary Manage sudo access for a user to run 'su - <user>' without a password
# @param name The name of the user
define administration::user (
  String $ensure = present,
  String $from   = undef,
) {
  case $ensure {
    'absent': {
      sudo::conf { "sudo-su-${name}":
        ensure => absent,
      }
    }

    'present': {
      if is_string($from) {
        $_from = $from
      }
      else {
        if is_array($from) {
          $_from = join($from, ',')
        }
        else {
          fail "'from' must be a string or array in administration::user[${name}]"
        }
      }

      sudo::conf { "sudo-su-${name}":
        ensure  => $ensure,
        content => "${_from} ALL=(root) NOPASSWD: /bin/su - ${name}\n",
      }
    }

    default: { fail "'ensure' must be 'present' or 'absent' in administration::user[${name}]" }
  }
}
