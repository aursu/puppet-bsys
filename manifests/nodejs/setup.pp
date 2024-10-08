# @summary Setup resources for NodeJS
#
# Setup User and Group resources for NodeJS
#
# @example
#   include bsys::nodejs::setup
class bsys::nodejs::setup {
  include bsys::nodejs::params

  group { $bsys::nodejs::params::group:
    ensure    => 'present',
    allowdupe => true,
    gid       => $bsys::nodejs::params::group_id,
  }

  user { $bsys::nodejs::params::user:
    ensure    => 'present',
    allowdupe => true,
    uid       => $bsys::nodejs::params::user_id,
    gid       => $bsys::nodejs::params::group,
    shell     => $bsys::nodejs::params::user_shell,
  }
}
