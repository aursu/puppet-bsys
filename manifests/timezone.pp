# @summary Configures system timezone settings
#
# This class sets up system timezone by configuring the necessary package, system links, and files.
#
# @param zonename
#   The timezone name to set, e.g., 'Europe/Berlin', which is the default.
#
# @param package
#   Name of the timezone data package, defaulting to 'tzdata'.
#
# @param directory
#   Location of timezone data on the system, default is '/usr/share/zoneinfo'.
#
# @param local
#   Path to the local timezone file, default is '/etc/localtime'.
#
# @param info
#   Path to the timezone information file, default is '/etc/timezone', optional.
#
# @example
#   include bsys::timezone
class bsys::timezone (
  String $zonename = 'Europe/Berlin',
  String $package = $bsys::params::tz_data,
  Bsys::Unixpath $directory = $bsys::params::tz_directory,
  Bsys::Unixpath $local = $bsys::params::tz_local,
  Optional[Bsys::Unixpath] $info = $bsys::params::tz_info,
)  inherits bsys::params {
  # dnf install tzdata
  # apt install tzdata
  package { $package:
    # autoupdate
    ensure => 'latest',
  }

  # ln -sf ../usr/share/zoneinfo/Europe/Berlin /etc/localtime
  file { $local:
    ensure => 'link',
    target => "${directory}/${zonename}",
    force  => true,
  }

  if $info {
    # echo 'Europe/Berlin' > /etc/timezone
    file { $info:
      ensure  => 'file',
      content => "${zonename}\n",
    }
  }
  # export TZ='Europe/Berlin'
}
