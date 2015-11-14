class Directory
  # @return [String]
  attr_accessor :name,
  # @return [String]
    :address,
  # @return [String]
    :phone_number,
  # @return [String]
    :url

  def initialize args
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  # @return [Array<DirectoryImage>]
  def directory_images
    @directory_images ||= []
  end

  # @return [Array<Review>]
  def reviews
    @reviews ||= []
  end

end
