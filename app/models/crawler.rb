require 'open-uri'
require 'nokogiri'
class Crawler

  def get_html(url)
    html = Nokogiri::HTML(open(url))
    html.encoding = 'utf-8'
    html
  end

  def files_save_from_url(url)
    pages = []
    pages << get_html(url)
    pages += get_subhtml(pages.first)
    FileUtils::mkdir_p 'tmp/'+url.hostname
    pages.each_with_index do |page, i|
      File.open("tmp/"+url.hostname+"/"+i.to_s+".html", 'w') { |file| file.write page }
    end
  end

  def get_subhtml(html)
    htmls = []
    html.xpath("//a/@href").each do |new_html|
      begin
        htmls << get_html(new_html.value)
      rescue Exception => e
        htmls << e
      end
    end
    htmls
  end

end