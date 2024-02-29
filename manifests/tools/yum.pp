# @summary Yum installation
#
# Yum installation (required by Bolt task puppet_agent::install)
#
# @example
#   include bsys::tools::yum
class bsys::tools::yum inherits bsys::params {
  if $bsys::params::redhat and $bsys::params::manage_dnf_module {
    package { 'yum':
      ensure   => 'installed',
      provider => 'dnf',
    }
  }
}
