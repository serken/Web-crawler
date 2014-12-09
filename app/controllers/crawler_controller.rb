class CrawlerController < ActionController::Base

  def index

  end

  def fetch
    uri = URI(params[:search])
    crawler = Crawler.new
    html = crawler.get_html(uri)
    render :text => html
  end

end