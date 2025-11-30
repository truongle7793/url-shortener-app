class UrlsController < ApplicationController
  def encode
    url = params[:url]

    if url.blank?
      render json: { error: "URL parameter is required" }, status: :bad_request
      return
    end

    shortened_url = Url.find_or_create_by_url(url)

    if shortened_url.present? && shortened_url.persisted?
      render json: {
        original_url: shortened_url.original_url,
        code: shortened_url.code,
        short_url: short_url_for(shortened_url.code)
      }, status: :created
    else
      render json: {
        error: "Invalid URL format",
        details: shortened_url.errors.full_messages
      }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: "Internal server error" }, status: :internal_server_error
  end

  def decode
    code = params[:code]

    if code.blank?
      render json: { error: "Code parameter is required" }, status: :bad_request
    end

    url = Url.find_by(code: code)

    if url
      # Access counter can be used later to combat DDos
      url.increment!(:access_count)

      render json: {
        code: url.code,
        original_url: url.original_url
      }, status: :ok
    else
      render json: { error: "Url didn't get encoded yet" }, status: :not_found
    end
  rescue StandardError => e
    render json: { error: "Internal server error" }, status: :internal_server_error
  end

  private
  def short_url_for(code)
    "#{request.base_url}/#{code}"
  end
end
