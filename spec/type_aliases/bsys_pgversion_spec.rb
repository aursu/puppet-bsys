
require 'spec_helper'

describe 'Bsys::PGVersion' do
  it { is_expected.to allow_values('13.20', '13.9', '13.19', '17.4.1') }

  it { is_expected.not_to allow_value('12.22') }
  it { is_expected.not_to allow_value('17') }
  it { is_expected.not_to allow_value('17.') }
end