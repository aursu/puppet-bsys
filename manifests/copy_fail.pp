# @summary
#   Immediate mitigation for CVE-2026-31431 by blacklisting and unloading the algif_aead kernel module.
#
# This class blacklists the `algif_aead` kernel module to prevent it from being loaded
# on subsequent boots, and unloads it immediately from the running kernel if currently loaded.
#
# @example
#   include bsys::copy_fail
#
class bsys::copy_fail {
  file { '/etc/modprobe.d/blacklist-algif_aead.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "# CVE-2026-31431 mitigation: blacklist algif_aead\nblacklist algif_aead\ninstall algif_aead /bin/false\n",
  }

  exec { 'rmmod-algif_aead':
    command => 'rmmod algif_aead',
    onlyif  => 'cat /proc/modules | grep algif_aead',
    path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
  }
}
