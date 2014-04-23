define administration::user (
  $ensure = present,
  $from   = undef,
) {
  
  case $ensure {
    'absent': {
      sudo::conf {"sudo-su-${name}":
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
          fail "'from' must be a string or array in administration::user[$name]"
        }
      }

      sudo::conf {"sudo-su-${name}":
        ensure  => $ensure,
        content => "${_from} ALL=(root) NOPASSWD: /bin/su - ${name}\n",
      }
    }

    default: { fail "'ensure' must be 'present' or 'absent' in administration::user[$name]" }
  }

}
