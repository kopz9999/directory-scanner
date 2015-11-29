module DirectoryScanner
  class Directory
    attr_accessor :name, :display, :active
    alias_method :active?, :active
    def initialize(args = {})
      args.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end
    def key
      @key ||= self.name.to_sym
    end
  end
end
