require 'net/http'
class Crawler

  def get_html(uri)

      response = Net::HTTP.get_response uri
      response.body
  end

end