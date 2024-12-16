# frozen_string_literal: true

require 'spec_helper'

describe 'bsys::locale::setup' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      case os
      when %r{^ubuntu}
        it {
          is_expected.to contain_package('locales')
        }
      else
        it {
          is_expected.not_to contain_package('locales')
        }
      end
    end
  end
end
