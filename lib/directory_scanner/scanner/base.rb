module DirectoryScanner
  module Scanner
    class Base

      protected

      attr_accessor :settings

      public

      # @param [String] scanner_path
      def initialize(scanner_path)
        conf = YAML::load_file(scanner_path).deep_symbolize_keys!
        self.settings = conf[:settings] || {}
      end

      # @param [Directory] directory
      # @return [Directory]
      def search_directory(directory)
        mapping_hash = self.mapping
        build_url = query_url(directory)
        result_hash = Wombat.crawl do
          base_url build_url
          path "/"
          mapping_hash.each do |k,v|
            self.send k, v
          end
        end
        Directory.new result_hash
      end

      # @param [Directory] directory
      # @return [Directory]
      def query_url(directory)
        hash = {}
        self.parameters.each do |param_hash|
          hash[ param_hash[:key] ] = directory.send("#{param_hash[:property]}")
        end
        "#{self.base_url}?#{hash.to_query}"
      end

      # @return [String]
      def base_url
        @base_url||= self.settings[:base_url]
      end

      # @return [Array<Hash<Symbol,Object>>]
      def parameters
        @parameters||= self.settings[:parameters]
      end

      # @return [Hash<Symbol,Object>]
      def mapping
        @mapping||= self.settings[:mapping]
      end

    end
  end
end
