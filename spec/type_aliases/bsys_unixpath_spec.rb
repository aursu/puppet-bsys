require 'spec_helper'

describe 'Bsys::Unixpath' do
  it { is_expected.to allow_values('/', '/etc', '/etc/passwd', '/var/lib/') }

  it { is_expected.not_to allow_value('etc/hosts') }
  it { is_expected.not_to allow_value('') }
  it { is_expected.not_to allow_value('//') }
  it { is_expected.not_to allow_value('/etc//fstab') }
end
