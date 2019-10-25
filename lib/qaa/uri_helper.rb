require 'uri'
require 'net/http'

module Qaa
  class UriHelper
    ALLOWED_HTTP_CODE_RESPONSE ||= ['200', '301']

    def self.get_hostname(url)
      uri = URI(url)
      uri.hostname
    end

    def self.format_uri(url_string)
      url_string = "http://#{url_string}" unless url_string.match(/^http(s|):\/\//)
      URI.parse(url_string)
    end

    def self.check_url_response(uri)
      response = Net::HTTP.get_response(uri)
      raise Net::HTTPError.new("Wrong response from #{uri}: \nresponse code:#{response.code}", response) if (response && !ALLOWED_HTTP_CODE_RESPONSE.include?(response.code))
      if response.is_a? Net::HTTPMovedPermanently
        uri= URI.parse(response['location'])
      end
      uri
    end
  end
end