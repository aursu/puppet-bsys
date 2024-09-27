# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include bsys::hardening::params
class bsys::hardening::params inherits bsys::params {
  $osmaj = $bsys::params::osmaj

  case $bsys::params::osname {
    'Ubuntu': {
      $login_defs_template = $bsys::params::oscode ? {
        'focal'     => 'bsys/shadow_utils/login.defs.focal.erb',
        default => 'bsys/shadow_utils/login.defs.jammy.erb',
      }

      $umask = '022'
    }
    'Rocky': {
      $login_defs_template = $osmaj ? {
        '8'     => 'bsys/shadow_utils/login.defs.RL8.erb',
        default => 'bsys/shadow_utils/login.defs.RL9.erb',
      }

      $umask = '022'
    }
    'CentOS': {
      $login_defs_template = $osmaj ? {
        '7'     => 'bsys/shadow_utils/login.defs.EL7.erb',
        default => 'bsys/shadow_utils/login.defs.EL9.erb',
      }

      $umask = $osmaj ? {
        '7'     => '077',
        default => '022',
      }
    }
  }
}
