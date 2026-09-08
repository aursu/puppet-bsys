require 'ipaddr'

# Whether an address belongs to private (non-routable) space.
#
# Written for deciding what a service may bind to or be reached on. Ranges are
# compared with IPAddr rather than string prefixes, because prefix matching gets
# 172.16.0.0/12 wrong: a check for "172." also accepts 172.0-172.15 and
# 172.32-172.255, which are public address space.
Puppet::Functions.create_function(:'bsys::is_private_ip') do
  # @param address IPv4 or IPv6 address, with or without a prefix length.
  # @param include_loopback Count loopback as private. Off by default: loopback is
  #   private in the sense of unreachable, but a service told to bind it is
  #   usually a mistake, so callers that mean it should say so.
  # @return [Boolean] true when the address is in private space.
  #
  # @example RFC 1918
  #   bsys::is_private_ip('10.154.5.6')      # => true
  #   bsys::is_private_ip('172.16.0.1')      # => true
  #   bsys::is_private_ip('172.15.0.1')      # => false, outside 172.16.0.0/12
  #   bsys::is_private_ip('203.0.113.10')    # => false
  #
  # @example Loopback is opt-in
  #   bsys::is_private_ip('127.0.0.1')        # => false
  #   bsys::is_private_ip('127.0.0.1', true)  # => true
  dispatch :is_private do
    param 'String[1]', :address
    optional_param 'Boolean', :include_loopback
    return_type 'Boolean'
  end

  # RFC 1918 for IPv4 and RFC 4193 unique local addresses for IPv6.
  #
  # Deliberately excluded, because neither is a sane thing to serve on and
  # treating them as private invites exactly that: 169.254.0.0/16 and fe80::/10
  # (link-local, present when DHCP failed) and 100.64.0.0/10 (RFC 6598 carrier
  # NAT, which is the provider's space, not ours).
  PRIVATE_RANGES = [
    '10.0.0.0/8',
    '172.16.0.0/12',
    '192.168.0.0/16',
    'fc00::/7',
  ].map { |range| IPAddr.new(range) }.freeze

  LOOPBACK_RANGES = [
    '127.0.0.0/8',
    '::1/128',
  ].map { |range| IPAddr.new(range) }.freeze

  def is_private(address, include_loopback = false)
    begin
      addr = IPAddr.new(address)
    rescue IPAddr::Error => e
      # Raise rather than return false. A malformed address here is a
      # configuration error, and answering "not private" would let it through a
      # check whose whole purpose is to catch it.
      raise Puppet::ParseError, "bsys::is_private_ip: #{address.inspect} is not a valid IP address (#{e.message})"
    end

    ranges = include_loopback ? PRIVATE_RANGES + LOOPBACK_RANGES : PRIVATE_RANGES

    ranges.any? { |range| range.include?(addr) }
  end
end
