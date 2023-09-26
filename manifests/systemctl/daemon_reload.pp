# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include bsys::systemctl::daemon_reload
class bsys::systemctl::daemon_reload {
  exec { 'systemd-reload-35f8a75':
    command     => 'systemctl daemon-reload',
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    refreshonly => true,
  }
}
