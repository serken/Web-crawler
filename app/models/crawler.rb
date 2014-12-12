require 'open-uri'
require 'nokogiri'
require 'archive/tar/external'
include Archive
class Crawler

  def get_html(uri)
    html = Nokogiri::HTML(open(uri))
    html.encoding = 'utf-8'
    {:html => html,:uri => uri }
  end

  def files_save_from_url(uri)
    pages = []
    index = get_html(uri)
    pages << index[:html]
    pages += get_subhtml(index)
    FileUtils::mkdir_p 'tmp/'+uri.hostname
    pages.each_with_index do |page, i|
      File.open("tmp/#{uri.hostname}/#{i.to_s}.html", 'w') { |file| file.write page }
    end
    Tar::External.new("tmp/#{uri.hostname}.tar","tmp/#{uri.hostname}/*.html", 'gzip') if !File.exist?("tmp/#{uri.hostname}.tar.gz")
  end

  def get_subhtml(html)
    htmls = []
    html[:html].xpath("//a/@href").each do |new_html|
      begin
        htmls << get_html(check_link(html[:uri], new_html.value))[:html]
      rescue Exception => e
        htmls << e
      end
    end
    htmls
  end

  def check_link (uri,url)
    new_url = url
    if url.match(/^#{uri.hostname}/)
      new_url = "http://"+url
    else
      if url.match(/^\//)
        new_url = "http://"+uri.hostname+url
      else
        if url.match(/^http:\/\//).nil?
        new_url = "http://"+uri.hostname+"/"+url
        end
      end
    end
    new_url
  end

end