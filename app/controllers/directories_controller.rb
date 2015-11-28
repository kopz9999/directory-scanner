class DirectoriesController < ApplicationController
  def index
    @business_local = BusinessLocal.new
  end

  protected

  def configuration_manager
    @configuration_manager ||= DirectoryScanner::Manager.new
  end
end
