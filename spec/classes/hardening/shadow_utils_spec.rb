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
    end
  end
end
