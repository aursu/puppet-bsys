# @summary
#   Ensures secure configurations for system login by managing the `/etc/login.defs` file.
#
# This class applies security hardening settings related to user login and shadow file management.
# It configures the `/etc/login.defs` file with appropriate settings, ensuring secure defaults
# for login behavior, password expiration, and other user authentication parameters.
#
# @param umask
#   The default umask setting for file creation, which defines default permission bits.
#   This parameter ensures that files created by users have the proper default permissions.
#
# @param login_defs_template
#   The path to the template file that defines the content of `/etc/login.defs`.
#   This template contains secure configurations for login and password policies.
#
# @param pass_max_days
# @param pass_min_days
# @param pass_min_len
# @param pass_warn_age
# @param uid_min
# @param gid_min
#
# @example
#   include bsys::hardening::shadow_utils
#
class bsys::hardening::shadow_utils (
  String $umask = $bsys::hardening::params::umask,
  Integer $pass_max_days = 180,
  Integer $pass_min_days = 0,
  Integer $pass_min_len = 8,
  Integer $pass_warn_age = 14,
  Integer $uid_min = $bsys::hardening::params::uid_min,
  Integer $gid_min = $bsys::hardening::params::gid_min,
  String $login_defs_template = $bsys::hardening::params::login_defs_template,
) inherits bsys::hardening::params {
  file { '/etc/login.defs':
    content => template($login_defs_template),
    group   => 'root',
    mode    => '0644',
    owner   => 'root',
  }
}
