# frozen_string_literal: true

require 'spec_helper'

describe 'bsys::internal_ip' do
  let(:docker_host) do
    {
      'ip' => '10.154.5.6',
      'interfaces' => {
        'br-9f2a41' => { 'ip' => '172.20.0.1' },
        'docker0' => { 'ip' => '172.17.0.1' },
        'eno2' => { 'ip' => '10.154.5.6' },
        'lo' => { 'ip' => '127.0.0.1' },
      },
    }
  end

  it 'prefers the primary address when it is private' do
    is_expected.to run.with_params(docker_host).and_return('10.154.5.6')
  end

  context 'when the primary address fact is missing' do
    # The case that broke a real server: br-* and docker0 sort before eno2, so
    # ordering alone picks a container bridge and the service is unreachable.
    let(:no_primary) { docker_host.merge('ip' => nil) }

    it 'skips container bridges and picks the physical interface' do
      is_expected.to run.with_params(no_primary).and_return('10.154.5.6')
    end
  end

  context 'when the primary address is public' do
    let(:public_primary) do
      docker_host.merge('ip' => '203.0.113.10',
                        'interfaces' => docker_host['interfaces'].merge('eno1' => { 'ip' => '203.0.113.10' }))
    end

    it 'falls back to a private address on a real interface' do
      is_expected.to run.with_params(public_primary).and_return('10.154.5.6')
    end
  end

  context 'when nothing qualifies' do
    let(:public_only) do
      { 'ip' => '203.0.113.10',
        'interfaces' => { 'lo' => { 'ip' => '127.0.0.1' }, 'eno1' => { 'ip' => '203.0.113.10' } } }
    end

    # undef rather than a guess: the caller should fail or be told explicitly,
    # not bind whatever happens to be there.
    it { is_expected.to run.with_params(public_only).and_return(nil) }
    it { is_expected.to run.with_params({}).and_return(nil) }
    it { is_expected.to run.with_params({ 'interfaces' => 'not-a-hash' }).and_return(nil) }
  end

  context 'when only bridges have private addresses' do
    let(:bridges_only) do
      { 'ip' => '203.0.113.10',
        'interfaces' => { 'docker0' => { 'ip' => '172.17.0.1' }, 'eno1' => { 'ip' => '203.0.113.10' } } }
    end

    it { is_expected.to run.with_params(bridges_only).and_return(nil) }
  end

  context 'with loopback allowed' do
    let(:loopback_only) { { 'ip' => nil, 'interfaces' => { 'lo' => { 'ip' => '127.0.0.1' } } } }

    # Still nil: lo is excluded by device name regardless, because a service
    # bound there is unreachable.
    it { is_expected.to run.with_params(loopback_only, true).and_return(nil) }
  end

  context 'with a malformed address in the facts' do
    let(:broken) do
      { 'ip' => 'not-an-ip',
        'interfaces' => { 'eno2' => { 'ip' => '10.154.5.6' } } }
    end

    # Sifting facts, not validating a parameter: a malformed entry simply does
    # not win rather than aborting the catalogue.
    it { is_expected.to run.with_params(broken).and_return('10.154.5.6') }
  end
end
