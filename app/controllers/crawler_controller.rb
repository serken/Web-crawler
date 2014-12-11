class CrawlerController < ApplicationController

  def index

  end

  def fetch
    uri = URI(params[:search])
    #uri = params[:search]
    crawler = Crawler.new
    html = crawler.files_save_from_url(uri)
    render :text => "success"
  end

end