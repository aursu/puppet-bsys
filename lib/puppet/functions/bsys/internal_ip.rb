# The address a service on this host should be reachable on, or undef.
#
# Answers one question that several classes otherwise answer differently: given
# the networking fact, which private address is the real one? Written as a
# function because expressing it in the Puppet language means chained filter/map
# blocks over a nested hash, which is hard to read and harder to test.
#
# Order of preference:
#
#   1. The primary address - the interface carrying the default route - when it
#      is private. This is the honest answer and needs no heuristics.
#   2. Otherwise the first private address on a non-virtual interface, in
#      interface-name order so the result is stable between runs.
#   3. Otherwise undef, leaving the caller to fail or ask explicitly rather than
#      binding something arbitrary.
#
# Virtual devices are excluded by name, not by address: a Docker bridge holds a
# genuine RFC 1918 address, so a range check cannot tell it from the LAN. On a
# Docker host the bridge also sorts first alphabetically, which is how a Puppet
# Server came to be published on 172.20.0.1 instead of its LAN address.
Puppet::Functions.create_function(:'bsys::internal_ip') do
  # @param networking The `networking` fact, or any hash of the same shape.
  # @param include_loopback Treat loopback as acceptable. Off by default; a
  #   service bound to loopback is unreachable, which is usually not the intent.
  # @return [Optional[String]] the chosen address, or undef when there is none.
  #
  # @example
  #   bsys::internal_ip($facts['networking'])
  dispatch :internal_ip do
    param 'Hash', :networking
    optional_param 'Boolean', :include_loopback
    return_type 'Optional[String]'
  end

  def private?(address, include_loopback)
    call_function('bsys::is_private_ip', address.to_s, include_loopback)
  rescue Puppet::ParseError
    # An address the parser rejects is not a candidate. Unlike the predicate
    # itself, which raises so a typo in a parameter is caught, here we are
    # sifting facts and a malformed one should simply not win.
    false
  end

  def virtual?(name)
    call_function('bsys::is_virtual_iface', name.to_s)
  end

  def internal_ip(networking, include_loopback = false)
    primary = networking['ip']
    return primary.to_s if primary && private?(primary, include_loopback)

    interfaces = networking['interfaces']
    return nil unless interfaces.is_a?(Hash)

    name = interfaces.keys.sort.find do |iface|
      next false if virtual?(iface)

      address = interfaces[iface].is_a?(Hash) ? interfaces[iface]['ip'] : nil
      address && private?(address, include_loopback)
    end

    name ? interfaces[name]['ip'].to_s : nil
  end
end
