module DirectoryScanner
  class Manager

    class InvalidScanner < StandardError
    end

    # @param [Directory] directory
    # @param [Symbol] scanner_key
    def search(directory, scanner_key)
      scanner = Scanner.build File.join(self.configuration_path,
        "#{scanner_key.to_s}.yml")
      unless scanner.nil?
        scanner.search_directory directory
      else
        throw InvalidScanner, "Scanner #{scanner_key} not found"
      end
    end

    def configuration_path
      @configuration_path ||= File.join(Rails.root.to_s, 'config', 'scanners')
    end

  end
end
