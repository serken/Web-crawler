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
    links = []
    index = get_html(uri)
    pages << index[:html]
    links << index[:uri]
    subhtmls = get_subhtml(index)
    pages += subhtmls[:html]
    links += subhtmls[:links]
    save_to_tar(pages,uri.hostname)
    save_to_pdf(links)
  end

  def save_to_tar(pages,name)
    FileUtils::mkdir_p 'tmp/'+name
    pages.each_with_index do |page, i|
      File.open("tmp/#{name}/#{i.to_s}.html", 'w') { |file| file.write page }
    end
    Tar::External.new("tmp/#{name}.tar","tmp/#{name}/*.html", 'gzip') if !File.exist?("tmp/#{name}.tar.gz")
  end

  def save_to_pdf(links)
    kit = PDFKit.new(links.first.to_s)
    kit.to_file("tmp/#{links.first.hostname}.pdf")
  end

  def get_subhtml(html)
    htmls = {:html => [],:links => []}
    html[:html].xpath("//a/@href").each do |new_html|
      begin
        htmls[:links] << check_link(html[:uri], new_html.value)
        htmls[:html] << get_html(htmls[:links].last)[:html]
      rescue Exception => e
        htmls[:links] << e
        htmls[:html] << e
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
    URI(new_url)
  end

end