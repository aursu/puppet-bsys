# EPEL Yum repository installation
#
# @summary EPEL Yum repository installation
#
# @example
#   include bsys::repo::epel
class bsys::repo::epel {
  if $facts['os']['family'] == 'RedHat' {
    include bsys::repo

    package { 'epel-release':
      ensure => 'installed',
      notify => Class['bsys::repo'],
    }

    file { '/etc/yum.repos.d/epel.repo': }
  }
}
