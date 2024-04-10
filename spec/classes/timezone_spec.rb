# frozen_string_literal: true

require 'spec_helper'

describe 'bsys::timezone' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      it {
        is_expected.to contain_package('tzdata')
          .with_ensure('latest')
      }

      it {
        is_expected.to contain_file('/etc/localtime')
          .with(
            ensure: 'link',
            target: '/usr/share/zoneinfo/Europe/Berlin',
            force: true,
          )
      }

      case os
      when %r{^ubuntu}
        it {
          is_expected.to contain_file('/etc/timezone')
            .with(
              ensure: 'file',
              content: "Europe/Berlin\n",
            )
        }
      else
        it {
          is_expected.not_to contain_file('/etc/timezone')
        }
      end
    end
  end
end
