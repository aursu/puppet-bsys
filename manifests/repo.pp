# @summary Yum/Apt cache cleanup
#
# Resources for Yum/Apt cache cleanup
#
# @example
#   include bsys::repo
class bsys::repo inherits bsys::params {
  case $bsys::params::osfam {
    'Debian': {
      exec { 'apt-update-9c247b8':
        command     => 'apt update',
        path        => '/bin:/usr/bin',
        refreshonly => true,
      }
    }
    # default is RedHat
    default: {
      $reload_command = $bsys::params::osmaj ? {
        '7'     => 'yum clean all',
        default => 'dnf clean all',
      }

      exec { 'yum-reload-9c247b8':
        command     => $reload_command,
        path        => '/bin:/usr/bin',
        refreshonly => true,
      }
    }
  }
}
