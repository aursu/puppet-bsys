# frozen_string_literal: true

require 'spec_helper'

describe 'bsys::is_virtual_iface' do
  context 'virtual devices' do
    ['lo', 'docker0', 'br-9f2a41b3c', 'virbr0', 'vnet3', 'veth1a2b3c',
     'tun0', 'tap0', 'vxlan1', 'cni0', 'flannel.1', 'cali1234', 'weave',
     'kube-ipvs0', 'dummy0', 'wg0', 'tailscale0'].each do |name|
      it { is_expected.to run.with_params(name).and_return(true) }
    end
  end

  context 'real interfaces' do
    # bond and team are aggregated links a service may legitimately be served
    # on, so they are deliberately not treated as virtual.
    ['eno1', 'eno2', 'eth0', 'ens192', 'enp3s0', 'wlan0', 'wlp2s0',
     'bond0', 'team0'].each do |name|
      it { is_expected.to run.with_params(name).and_return(false) }
    end
  end

  context 'names that merely start with the same letters' do
    # 'brain0' is not a bridge and 'lodev' is not loopback; the patterns are
    # anchored so a real NIC with an unlucky name is not discarded.
    it { is_expected.to run.with_params('brain0').and_return(false) }
    it { is_expected.to run.with_params('lodev').and_return(false) }
  end
end
