module DirectoryScanner
  class Manager

    include Singleton

    class UnknownDirectory < StandardError
    end
    class InactiveDirectory < StandardError
    end
    class InvalidDirectory < StandardError
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
    # @param [Symbol] directory_key
    def search(business_local, directory_key)
      assert_scanner directory_key do |scanner|
        scanner.search_business_local business_local
      end
    end

    def configuration_path
      @configuration_path ||= File.join(Rails.root.to_s, 'config', 'scanners')
    end

    private

    def assert_scanner(directory_key)
      directory = self.directories.find{ |dir| dir.key == directory_key }
      if directory.nil?
        raise UnknownDirectory, "Directory #{directory_key} is unknown"
      else
        if directory.active?
          path = File.join(self.configuration_path, "#{directory.name}.yml")
          if File.exist? path
            yield Scanner.build path, directory
          else
            raise(InvalidDirectory,
              "Directory #{directory_key} is not configured")
          end
        else
          raise InactiveDirectory, "Directory #{directory_key} is inactive"
        end
      end
    end

    def init_directories
      directories_arr = self.settings.fetch(:directories)
      self.directories = directories_arr.map{|dh| Directory.new(dh)}
    end

  end
end
