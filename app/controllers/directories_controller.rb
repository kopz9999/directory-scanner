class DirectoriesController < ApplicationController
  def index
    @directory = Directory.new
  end
  def search
    @results = []
    directory = Directory.new(params[:directory])
    configuration_manager.available_scanners.each do |scanner_key|
      result = configuration_manager.search directory, scanner_key
      @results << result unless result.nil?
    end
  end

  protected

  def configuration_manager
    @configuration_manager ||= DirectoryScanner::Manager.new
  end
end
