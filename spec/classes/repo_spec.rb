# frozen_string_literal: true

require 'spec_helper'

describe 'bsys::repo' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      case os
      when %r{^ubuntu}
        it {
          is_expected.to contain_exec('apt-update-9c247b8')
            .with_command('apt update')
        }
      when %r{^centos-7}
        it {
          is_expected.to contain_exec('yum-reload-9c247b8')
            .with_command('yum clean all')
        }
      else
        it {
          is_expected.to contain_exec('yum-reload-9c247b8')
            .with_command('dnf clean all')
        }
      end
    end
  end
end
