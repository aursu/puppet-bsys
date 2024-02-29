# frozen_string_literal: true

require 'spec_helper'

describe 'bsys::tools::yum' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      if os_facts[:os]['family'] == 'RedHat' && ['8', '9'].include?(os_facts[:os]['release']['major'])
        it {
          is_expected.to contain_package('yum')
            .with_ensure('installed')
        }
      else
        it {
          is_expected.not_to contain_package('yum')
        }
      end
    end
  end
end
