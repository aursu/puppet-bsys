# @summary
# Manages system locales for supported operating systems.
#
# This defined type ensures that the specified locale is properly configured on
# the system. It verifies that the locale exists in the system's supported
# list and generates it if necessary. It is primarily designed for Ubuntu systems.
#
# @example
#   bsys::locale { 'en_US.UTF-8': }
#
# @param name
#   The name of the locale to be managed (e.g., 'en_US.UTF-8').
define bsys::locale (
) {
  include bsys::params

  if $bsys::params::osname == 'Ubuntu' {
    include bsys::locale::setup

    exec { "locale-gen ${name}":
      unless  => "validlocale ${name}",
      onlyif  => "grep -w ${name} /usr/share/i18n/SUPPORTED",
      path    => '/usr/bin:/usr/sbin:/bin:/sbin',
      require => Class['bsys::locale::setup'],
    }
  }
}
