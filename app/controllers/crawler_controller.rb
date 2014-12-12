class CrawlerController < ApplicationController

  def index

  end

  def download
    send_file "tmp/#{params[:file_name]}"
  end

  def fetch
    begin
    uri = URI(params[:search])
    Crawler.new.files_save_from_url(uri)
    render :partial => 'download', :locals => {:name => uri.hostname}
    rescue Exception => e
      flash[:notice] = "Bad url. Try another"
      redirect_to root_path
    end
  end

end