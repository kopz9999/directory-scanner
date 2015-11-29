module DirectoryScanner
  module Scanner
    class Base

      attr_accessor :settings, :directory

      public

      # @param [String] scanner_path
      # @param [DirectoryScanner::Directory] directory
      def initialize(scanner_path, directory)
        conf = YAML::load_file(scanner_path).deep_symbolize_keys!
        self.settings = conf[:settings] || {}
        self.directory = directory
      end

      # @param [BusinessLocal] business_local
      # @return [BusinessLocal]
      def search_business_local(business_local)
        mapping_hash = self.mapping
        build_url = query_url(business_local)
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
        business_name = result_hash['name']
        if !business_name.blank? && business_name == business_local.name
          result = BusinessLocal.new result_hash
          result.apply_settings self.settings
          result
        else
          nil
        end
      end

      # @param [BusinessLocal] business_local
      # @return [BusinessLocal]
      def query_url(business_local)
        hash = {}
        uri = URI.parse(self.base_url)
        self.parameters.each do |param_hash|
          properties = Array.wrap(param_hash[:property])
          param_key = param_hash[:key]
          values = []
          properties.each { |prop| values << business_local.send(prop) }
          hash[param_key] = values.join(' ')
        end
        if uri.query.nil?
          uri.query = hash.to_query
        else
          uri.query += "&#{hash.to_query}"
        end
        uri.to_s
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
