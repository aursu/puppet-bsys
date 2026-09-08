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
  dispatch :virtual? do
    param 'String[1]', :name
    return_type 'Boolean'
  end

  # Memoized to avoid "already initialized constant" warnings during environment
  # reloads. Uses a single extended regular expression for optimal performance.
  #
  # Note what is absent. `bond*` and `team*` are real aggregated links and a
  # service may legitimately be served on them. `eth*`, `en*` and `wl*` are
  # physical. Only devices that exist to carry traffic for something else are
  # listed here.
  #
  # /x ignores literal whitespace, so any future alternative needing a space
  # must escape it.
  def virtual_pattern
    @virtual_pattern ||= %r{
      \A                                # Anchor to start of string
      (?:
        lo\z                            | # loopback
        docker                          | # docker0 and friends
        br-                             | # docker/podman user-defined bridges
        virbr                           | # libvirt (also covers virbrX-nic)
        vnet\d                          | # libvirt guest taps
        veth                            | # container side of a veth pair
        (?:tun|tap)\d                   | # tunnels and taps
        vxlan                           | # overlay
        (?:cni|flannel|cali|weave|kube) | # kubernetes networking
        dummy                           | # dummy interfaces
        (?:wg|tailscale|zt)\d*\z          # wireguard, tailscale, zerotier
      )
    }x.freeze
  end

  def virtual?(name)
    virtual_pattern.match?(name)
  end
end
