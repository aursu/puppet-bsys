# Whether an interface name looks like a virtual device rather than a real NIC.
#
# Container and virtual-machine bridges, veth pairs, tunnels and overlay devices
# carry perfectly valid RFC 1918 addresses, so no range check can distinguish
# them from the LAN. They have to be recognised by device name.
#
# This matters when picking the address a service should be reachable on: on a
# Docker host the bridge sorts before the physical NIC alphabetically, so naive
# ordering picks the bridge and the service becomes unreachable.
Puppet::Functions.create_function(:'bsys::is_virtual_iface') do
  # @param name Interface name, as it appears in the networking fact.
  # @return [Boolean] true when the name matches a known virtual device family.
  #
  # @example
  #   bsys::is_virtual_iface('docker0')   # => true
  #   bsys::is_virtual_iface('br-9f2a41') # => true
  #   bsys::is_virtual_iface('lo')        # => true
  #   bsys::is_virtual_iface('eno2')      # => false
  #   bsys::is_virtual_iface('bond0')     # => false, a real aggregate
  dispatch :is_virtual do
    param 'String[1]', :name
    return_type 'Boolean'
  end

  # Memoised rather than a constant: a constant declared in the body of
  # Puppet::Functions.create_function is defined on the loader's namespace and
  # warns "already initialized constant" on every reload.
  #
  # Note what is absent. `bond*` and `team*` are real aggregated links and a
  # service may legitimately be served on them. `eth*`, `en*` and `wl*` are
  # physical. Only devices that exist to carry traffic for something else are
  # listed here.
  def virtual_patterns
    @virtual_patterns ||= [
      %r{\Alo\z},           # loopback
      %r{\Adocker},         # docker0 and friends
      %r{\Abr-},            # docker/podman user-defined bridges
      %r{\Avirbr},          # libvirt
      %r{\Avnet\d},         # libvirt guest taps
      %r{\Aveth},           # container side of a veth pair
      %r{\A(tun|tap)\d},    # tunnels and taps
      %r{\Avxlan},          # overlay
      %r{\A(cni|flannel|cali|weave|kube)},  # kubernetes networking
      %r{\Adummy},
      %r{\A(wg|tailscale|zt)\d*\z},         # wireguard, tailscale, zerotier
      %r{\Avirbr\d+-nic\z},
    ].freeze
  end

  def is_virtual(name)
    virtual_patterns.any? { |pattern| name.match?(pattern) }
  end
end
