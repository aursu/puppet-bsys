# frozen_string_literal: true

require 'spec_helper'

describe 'bsys::repo::epel' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      case os_facts[:os]['family']
      when 'RedHat'
        it {
          is_expected.to contain_package('epel-release')
            .with_ensure('installed')
        }
      else
        it {
          is_expected.not_to contain_package('epel-release')
        }
      end
    end
  end
end
