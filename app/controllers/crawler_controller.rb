class CrawlerController < ApplicationController

  def index

  end

  def fetch
    uri = URI(params[:search])
    Crawler.new.files_save_from_url(uri)
    render :text => "success"
  end

end