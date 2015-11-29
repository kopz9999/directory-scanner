require 'directory_scanner/scanner/base'

module DirectoryScanner
  module Scanner

    class << self

      # @param [String] scanner_path
      def build(scanner_path, directory)
        Scanner::Base.new scanner_path, directory
      end

    end

  end
end
