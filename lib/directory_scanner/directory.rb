module DirectoryScanner
  class Directory
    attr_accessor :name, :display, :active
    def initialize(args = {})
      args.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end
  end
end
