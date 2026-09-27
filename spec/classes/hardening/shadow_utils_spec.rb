# frozen_string_literal: true

require 'spec_helper'

describe 'bsys::hardening::shadow_utils' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      case os
      when %r{^centos-7}
        it {
          is_expected.to contain_file('/etc/login.defs')
            .with_content(%r{UMASK 077})
        }
      else
        it {
          is_expected.to contain_file('/etc/login.defs')
            .with_content(%r{UMASK 022})
        }
      end

      # Rocky 10's own file, so its defaults survive: yescrypt, the EL10
      # subordinate id range, and the password policy lines taken from here.
      if os.start_with?('rocky-10')
        it {
          is_expected.to contain_file('/etc/login.defs')
            .with_content(%r{^ENCRYPT_METHOD YESCRYPT$})
            .with_content(%r{^SUB_UID_MIN\s+524288$})
            .with_content(%r{^PASS_MAX_DAYS 180$})
        }
      end
    end
  end
end
