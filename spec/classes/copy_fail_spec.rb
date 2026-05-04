# frozen_string_literal: true

require 'spec_helper'

describe 'bsys::copy_fail' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      it 'creates the modprobe blacklist config file' do
        is_expected.to contain_file('/etc/modprobe.d/blacklist-algif_aead.conf')
          .with(
            ensure: 'file',
            owner:  'root',
            group:  'root',
            mode:   '0644',
          )
      end

      it 'blacklists algif_aead in the config file' do
        is_expected.to contain_file('/etc/modprobe.d/blacklist-algif_aead.conf')
          .with_content(%r{^blacklist algif_aead$})
      end

      it 'sets install override to /bin/false in the config file' do
        is_expected.to contain_file('/etc/modprobe.d/blacklist-algif_aead.conf')
          .with_content(%r{^install algif_aead /bin/false$})
      end

      it 'includes CVE reference in the config file' do
        is_expected.to contain_file('/etc/modprobe.d/blacklist-algif_aead.conf')
          .with_content(%r{CVE-2026-31431})
      end

      it 'runs rmmod with correct command and onlyif guard' do
        is_expected.to contain_exec('rmmod-algif_aead')
          .with(
            command: 'rmmod algif_aead',
            onlyif:  'cat /proc/modules | grep algif_aead',
          )
      end
    end
  end
end
