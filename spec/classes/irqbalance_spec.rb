# frozen_string_literal: true

require 'spec_helper'

describe 'bsys::irqbalance' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      context 'with default parameters' do
        it 'does not manage irqbalance package or service' do
          is_expected.not_to contain_package('irqbalance')
          is_expected.not_to contain_service('irqbalance')
        end
      end

      context 'when manage_service is true' do
        let(:params) { { manage_service: true } }

        context 'on virtual system' do
          let(:facts) { os_facts.merge({ is_virtual: true }) }

          it 'removes irqbalance package' do
            is_expected.to contain_package('irqbalance').with_ensure('absent')
          end

          it 'disables and stops irqbalance service' do
            is_expected.to contain_service('irqbalance').with(
              ensure: 'stopped',
              enable: false,
            )
          end
        end

        context 'on non-virtual system' do
          let(:facts) { os_facts.merge({ is_virtual: false }) }

          it 'installs irqbalance package' do
            is_expected.to contain_package('irqbalance').with_ensure('present')
          end

          it 'enables and starts irqbalance service' do
            is_expected.to contain_service('irqbalance').with(
              ensure: 'running',
              enable: true,
            )
          end
        end
      end

      context 'when manage_service is true and disable_service is true' do
        let(:params) { { manage_service: true, disable_service: true } }

        context 'on virtual system' do
          let(:facts) { os_facts.merge({ is_virtual: true }) }

          it 'removes irqbalance package' do
            is_expected.to contain_package('irqbalance').with_ensure('absent')
          end

          it 'disables and stops irqbalance service' do
            is_expected.to contain_service('irqbalance').with(
              ensure: 'stopped',
              enable: false,
            )
          end
        end

        context 'on non-virtual system' do
          let(:facts) { os_facts.merge({ is_virtual: false }) }

          it 'removes irqbalance package' do
            is_expected.to contain_package('irqbalance').with_ensure('absent')
          end

          it 'disables and stops irqbalance service' do
            is_expected.to contain_service('irqbalance').with(
              ensure: 'stopped',
              enable: false,
            )
          end
        end
      end
    end
  end
end
