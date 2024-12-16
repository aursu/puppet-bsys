# frozen_string_literal: true

require 'spec_helper'

describe 'bsys::locale' do
  let(:title) { 'en_US.UTF-8' }
  let(:params) do
    {}
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      case os
      when %r{^ubuntu}
        it {
          is_expected.to contain_exec('locale-gen en_US.UTF-8')
            .with(
              unless: 'validlocale en_US.UTF-8',
              onlyif: 'grep -w en_US.UTF-8 /usr/share/i18n/SUPPORTED',
            )
            .that_requires('Package[locales]')
        }
      else
        it {
          is_expected.not_to contain_exec(%r{locale-gen})
        }
      end
    end
  end
end
