class BusinessLocal

  extend ActiveModel::Naming
  include ActiveModel::Conversion

  # @return [String]
  attr_accessor :name,
    # @return [String]
    :address,
    # @return [String]
    :city,
    # @return [String]
    :state,
    # @return [String]
    :zip,
    # @return [String]
    :full_address,
    # @return [String]
    :phone_number,
    # @return [String]
    :url

  def persisted?
    false
  end

  def initialize(args = {})
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  def small_address
    @small_address||= [self.city, self.state].join(', ')
  end

  def long_address
    @long_address ||= if self.zip.blank?
      self.medium_address
    else
      "#{self.medium_address} #{self.zip}"
    end
  end

  def medium_address
    @medium_address||= [self.address, self.city, self.state].compact.join(', ')
  end

  # @return [Array<BusinessLocalImage>]
  def business_local_images
    @business_local_images ||= []
  end

  # @return [Array<Review>]
  def reviews
    @reviews ||= []
  end

  # TODO: Remove
  def display_address
    self.address || self.full_address
  end

  # @param [Hash<Symbol,Object>] settings
  def apply_settings(settings)
    page_url = settings[:page_url]
    self.url = "#{page_url}#{self.url}" unless page_url.blank?
    if html_fields = settings[:html_fields]
      html_fields.each do |field|
        val = self.send(field)
        results = val.split(/<br\s*[\/]?>/)
        self.send("#{field}=", results.map{ |r| r.squish }.join(', '))
      end
    end
  end

end
