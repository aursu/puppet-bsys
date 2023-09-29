# @summary Web server parameters on local system
#
# Web server parameters on local system
#
# @example
#   include bsys::webserver::params
class bsys::webserver::params inherits bsys::params {
  $osfam  = $bsys::params::osfam

  # use directory defined by http://nginx.org/packages/
  $user_shell = $osfam ? {
    'RedHat' => '/sbin/nologin',
    default  => '/usr/sbin/nologin',
  }
  $user_home = '/var/www'

  # Try to use static Uid/Gid (official for RedHat is apache/48 and for
  # Debian is www-data/33)
  $user_id = $osfam ? {
    'RedHat' => 48,
    default  => 33,
  }

  $user = $osfam ? {
    'RedHat' => 'apache',
    default  => 'www-data',
  }

  $group_id = $user_id
  $group = $user

  # Client authentication
  $internal_certdir = "${bsys::params::certbase}/internal"
  $internal_cacert = "${internal_certdir}/ca.pem"
}
