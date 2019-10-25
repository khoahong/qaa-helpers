class APIHandler

  attr_reader :name, :version, :handler

  class << self
    attr_accessor :api_base_url
  end

  BASE_URL_MISSING_MSG = 'api_base_url has not been provided. Please use APIHandler.api_base_url = your_api_url to set base url'

  def base_url
    raise BASE_URL_MISSING_MSG unless self.class.api_base_url
    self.class.api_base_url
  end

  def initialize(api_name, api_version, api_handler)
    @name     = api_name
    @version  = api_version
    @handler  = api_handler
  end

  def api_post(params)
    uri          = URI.parse(api_handler_url)
    request      = Net::HTTP::Post.new(uri)
    request.body = params.to_json
    send_request(uri, request)
  end

  def api_put(params)
    uri          = URI.parse(api_handler_url)
    request      = Net::HTTP::Put.new(uri)
    request.body = params.to_json
    send_request(uri, request)
  end

  def api_get(params)
    uri        = queried_string_uri(api_handler_url, params)
    request    = Net::HTTP::Get.new(uri)
    send_request(uri, request)
  end

  def api_delete(params)
    uri        = queried_string_uri(api_handler_url, params)
    request    = Net::HTTP::Delete.new(uri)
    send_request(uri, request)
  end

  private

  def queried_string_uri(handler_url, params)
    params_str = ''
    params.each {|k, v|
      if v.is_a? Array
        v.each {|value| params_str << (params_str.empty? ? "?#{k}=#{value}" : "&#{k}=#{value}")}
      else
        params_str << (params_str.empty? ? "?#{k}=#{v}" : "&#{k}=#{v}")
      end
    }
    URI.parse("#{handler_url}#{params_str}")
  end

  def send_request(uri, request)
    conn = Net::HTTP.new(uri.host, uri.port)
    conn.request(request)
  end

  def api_nodes(nodes_url)
    nodes_uri  = URI.parse(nodes_url)
    response   = send_request(nodes_uri, Net::HTTP::Get.new(nodes_uri))
    nodes_list = JSON.parse(response.body, symbolize_names: true)[:node][:nodes]
    nodes_list.reject { |node| node[:value].empty? }
  end

  def api_url(nodes)
    api_urls = nodes.map { |node| node[:value] }
    api_urls.each { |url| url.sub!('-pub', '') }
    api_urls.sample
  end

  def api_handler_url
    nodes_url = "#{base_url}/#{name}/nodes"
    nodes     = api_nodes(nodes_url)
    url       = api_url(nodes)
    "#{url}/#{version}/#{handler}"
  end
end
