require 'spec_helper'
describe 'streamcoweb' do
  context 'with default values for all parameters' do
    it { should contain_class('streamcoweb') }
  end
end
