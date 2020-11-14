require 'spec_helper'

describe 'Facter::Util::Fact' do
  before(:each) do
    Facter.clear
  end

  context 'with monit v5.14 installed' do
    before :each do
      expect(Facter::Util::Resolution).to receive(:exec).with('monit -V 2>&1').and_return("This is Monit version 5.14\nCopyright (C) 2001-2015 Tildeslash Ltd. All Rights Reserved.")
    end
    it 'returns 5.14' do
      expect(Facter.fact(:monit_version).value).to eq('5.14')
    end
  end

  context 'with monit not installed' do
    before :each do
      expect(Facter::Util::Resolution).to receive(:exec).with('monit -V 2>&1').and_return(nil)
    end
    it 'is nil' do
      expect(Facter.fact(:monit_version).value).to be_nil
    end
  end
end
