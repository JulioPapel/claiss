module CLAISS
    class CLI
      def self.call(*args)
        Dry::CLI.new(CLAISS::Commands).call(*args)
      end
    end
  end