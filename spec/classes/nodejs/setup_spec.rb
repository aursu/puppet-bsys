# frozen_string_literal: true

require 'spec_helper'

describe 'bsys::nodejs::setup' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      it {
        is_expected.to contain_group('node')
          .with_gid(1000)
      }

      it {
        is_expected.to contain_user('node')
          .with_uid(1000)
          .with_gid('node')
          .with_shell('/bin/bash')
      }
    end
  end
end
