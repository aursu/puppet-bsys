require 'spec_helper'

describe 'Bsys::PGVersion' do
  it { is_expected.to allow_values('18.6', '17.11', '16.15', '15.19', '14.24', '17.4.1') }

  it { is_expected.not_to allow_value('13.23') }
  it { is_expected.not_to allow_value('12.22') }
  it { is_expected.not_to allow_value('17') }
  it { is_expected.not_to allow_value('17.') }
end
