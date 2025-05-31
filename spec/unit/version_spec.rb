require 'spec_helper'

RSpec.describe CLAISS::Version do
  let(:version) { described_class.new }
  
  describe '#call' do
    it 'imprime a versão do CLAISS' do
      expect { version.call } 
        .to output(/CLAISS version #{Regexp.escape(CLAISS::VERSION)}/).to_stdout
    end
  end
end
