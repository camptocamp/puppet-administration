require 'spec_helper'

describe 'administration::postgresql' do
  let(:facts) { {
    :lsbdistcodename => 'wheezy',
    :operatingsystem => 'Debian',
    :osfamily        => 'Debian',
  } }
  it { should compile.with_all_deps }
end
