# frozen_string_literal: true

require 'spec_helper'

describe 'bsys::is_private_ip' do
  context 'RFC 1918 IPv4' do
    ['10.0.0.0', '10.154.5.6', '10.255.255.255',
     '192.168.0.1', '192.168.255.254',
     '172.16.0.0', '172.20.10.1', '172.31.255.255'].each do |address|
      it { is_expected.to run.with_params(address).and_return(true) }
    end
  end

  # The boundary that a string prefix check gets wrong. 172.16.0.0/12 covers
  # 172.16 through 172.31 only; everything else in 172/8 is public.
  context 'the 172.16.0.0/12 boundary' do
    it { is_expected.to run.with_params('172.15.255.255').and_return(false) }
    it { is_expected.to run.with_params('172.16.0.0').and_return(true) }
    it { is_expected.to run.with_params('172.31.255.255').and_return(true) }
    it { is_expected.to run.with_params('172.32.0.0').and_return(false) }
  end

  context 'public IPv4' do
    ['203.0.113.10', '8.8.8.8', '1.1.1.1', '172.0.0.1', '11.0.0.1', '192.167.0.1'].each do |address|
      it { is_expected.to run.with_params(address).and_return(false) }
    end
  end

  context 'loopback' do
    # Private in the sense of unreachable, but binding it is usually a mistake,
    # so a caller that means it has to say so.
    it { is_expected.to run.with_params('127.0.0.1').and_return(false) }
    it { is_expected.to run.with_params('127.0.0.1', true).and_return(true) }
    it { is_expected.to run.with_params('::1', true).and_return(true) }
  end

  context 'addresses that are neither private nor safe to treat as such' do
    # Link-local shows up when DHCP failed, and carrier NAT space is the
    # provider's, not ours. Both are excluded on purpose.
    it { is_expected.to run.with_params('169.254.1.1').and_return(false) }
    it { is_expected.to run.with_params('fe80::1').and_return(false) }
    it { is_expected.to run.with_params('100.64.0.1').and_return(false) }
  end

  context 'IPv6 unique local addresses' do
    it { is_expected.to run.with_params('fc00::1').and_return(true) }
    it { is_expected.to run.with_params('fd12:3456:789a::1').and_return(true) }
    it { is_expected.to run.with_params('2001:db8::1').and_return(false) }
  end

  context 'with a prefix length' do
    it { is_expected.to run.with_params('10.154.5.0/24').and_return(true) }
    it { is_expected.to run.with_params('203.0.113.0/24').and_return(false) }
  end

  context 'invalid input' do
    # Raises rather than returning false: answering "not private" for a typo
    # would let it through the very check meant to catch it.
    it { is_expected.to run.with_params('not-an-ip').and_raise_error(Puppet::ParseError, %r{not a valid IP address}) }
    it { is_expected.to run.with_params('10.0.0.256').and_raise_error(Puppet::ParseError, %r{not a valid IP address}) }
  end
end
