module DirectoryScanner
  class Manager

    class InvalidScanner < StandardError
    end

    # @return [Hash<Symbol,Object>]
    attr_accessor :settings,
      # @return [Hash<Symbol,Object>]
      :available_scanners

    def initialize
      path = File.join(Rails.root.to_s, 'config', 'scanners.yml')
      self.settings = YAML.load_file(path).deep_symbolize_keys!
      self.available_scanners = self.settings.fetch(:scanners)
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
