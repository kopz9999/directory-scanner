module DirectoryScanner
  module Scanner
    class Base

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
            opt = v.delete(:options)
            if opt.blank?
              self.send k, v
            else
              self.send k, v, opt.to_sym
            end
          end
        end
        unless result_hash['name'].blank?
          result = Directory.new result_hash
          result.apply_settings self
          result
        else
          nil
        end
      end

      # @param [Directory] directory
      # @return [Directory]
      def query_url(directory)
        hash = {}
        uri = URI.parse(self.base_url)
        self.parameters.each do |param_hash|
          properties = Array.wrap(param_hash[:property])
          param_key = param_hash[:key]
          values = []
          properties.each { |prop| values << directory.send(prop) }
          hash[param_key] = values.join(' ')
        end
        if uri.query.nil?
          uri.query = hash.to_query
        else
          uri.query += "&#{hash.to_query}"
        end
        uri.to_s
      end

      def display_name
        @display_name ||= self.settings[:display]
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
