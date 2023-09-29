# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include bsys::params
class bsys::params {
  $osfam  = $facts['os']['family']
  $osname = $facts['os']['name']
  $osmaj  = $facts['os']['release']['major']
  $osfull = $facts['os']['release']['full']

  case $osfam {
    'Debian': {
      $oscode = $facts['os']['distro']['codename']

      $pkibase = '/etc/ssl'
      $certbase = '/etc/ssl/certs'
      $keybase  = '/etc/ssl/private'
    }
    'RedHat': {
      if $osname == 'CentOS' {
        # Puppet > 6
        if 'distro' in $facts['os'] {
          # centos stream
          $centos_stream = $osmaj ? {
            '6' => false,
            '7' => false,
            '9' => true,
            default => $facts['os']['distro']['id'] ? {
              'CentOSStream' => true,
              default        => false,
            },
          }
        }
        else {
          $centos_stream = $osfull ? {
            # for CentOS Stream 8 it is just '8' but for CentOS Linux 8 it is 8.x.x
            '8'     => true,
            '9'     => true,
            default => false,
          }
        }

        $repo_gpgkey = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial'
        if $centos_stream {
          $repo_powertools_mirrorlist = 'http://mirrorlist.centos.org/?release=$stream&arch=$basearch&repo=PowerTools&infra=$infra'
          $repo_os_name = 'CentOS Stream'
        }
        else {
          $repo_powertools_mirrorlist = 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=PowerTools&infra=$infra'
          $repo_os_name = 'CentOS Linux'
        }

        $manage_dnf_module = $centos_stream
      }
      else {
        $centos_stream = false
        $repo_gpgkey = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rockyofficial'
        $repo_powertools_mirrorlist = 'https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=PowerTools-$releasever'
        $repo_os_name = 'Rocky Linux'
        $manage_dnf_module = true
      }

      $pkibase = '/etc/pki/tls'
      $certbase = '/etc/pki/tls/certs'
      $keybase  = '/etc/pki/tls/private'
    }
    default: {}
  }
}
