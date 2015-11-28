module DirectoryScanner
  class Manager

    include Singleton

    class InvalidScanner < StandardError
    end

    # @return [Hash<Symbol,Object>]
    attr_accessor :settings,
      # @return [Array<DirectoryScanner::Directory>]
      :directories

    def initialize
      path = File.join(Rails.root.to_s, 'config', 'directories.yml')
      self.settings = YAML.load_file(path).deep_symbolize_keys!
      init_directories
    end

    # @param [BusinessLocal] business_local
    # @param [Symbol] scanner_key
    def search(business_local, scanner_key)
      scanner = Scanner.build File.join(self.configuration_path,
        "#{scanner_key.to_s}.yml")
      unless scanner.nil?
        scanner.search_business_local business_local
      else
        throw InvalidScanner, "Scanner #{scanner_key} not found"
      end
    end

    def configuration_path
      @configuration_path ||= File.join(Rails.root.to_s, 'config', 'scanners')
    end

    private

    def init_directories
      directories_arr = self.settings.fetch(:directories)
      self.directories = directories_arr.map{|dh| Directory.new(dh)}
    end

  end
end
