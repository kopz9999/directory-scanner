class Api::DirectoriesController < ApplicationController

  rescue_from DirectoryScanner::Manager::UnknownDirectory,
    with: :render_errors
  rescue_from DirectoryScanner::Manager::InactiveDirectory,
    with: :render_errors
  rescue_from DirectoryScanner::Manager::InvalidDirectory,
    with: :render_errors

  def search
    business_local = BusinessLocal.new params[:business_local]
    directory_key = params.fetch(:directory_key).to_sym
    result = DirectoryScanner::Manager.instance.search(business_local,
      directory_key)
    if result.nil?
      render nothing: true, status: :not_found
    else
      render json: result, status: :ok
    end
  end

  protected

  def render_errors(error)
    render json: { errors: { status: [ error.message ] } },
      status: :unprocessable_entity
  end

end
