# @summary Install the 'locales' package
#
# Install the 'locales' package to configure and manipulate locale settings
#
# @example
#   include bsys::locale::setup
class bsys::locale::setup {
  include bsys::params

  if $bsys::params::osname == 'Ubuntu' {
    package { 'locales':
      ensure => 'installed',
    }
  }
}
