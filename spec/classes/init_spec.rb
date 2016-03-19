require 'spec_helper'
describe 'sshkey' do

  context 'with default values for all parameters' do
    it { should contain_class('sshkey') }
  end
end
