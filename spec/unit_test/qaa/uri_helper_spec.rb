require 'spec_helper'

describe Qaa::UriHelper do

  describe 'UriHelper.hostname' do
    it 'return the good staging hostname' do
      expect(UriHelper.get_hostname('http://alice-staging.lazada.vn/all-products/?page=10')).to eq('alice-staging.lazada.vn')
    end

    it 'return the good showroom hostname' do
      expect(UriHelper.get_hostname('http://ws-7982.id.russia/all-products/?page=10')).to eq('ws-7982.id.russia')
    end

    it 'return the good live hostname' do
      expect(UriHelper.get_hostname('http://www.lazada.vn/all-products/?page=10')).to eq('www.lazada.vn')
    end

    it 'return the good hostname even on https' do
      expect(UriHelper.get_hostname('https://www.lazada.vn/all-products/?page=10')).to eq('www.lazada.vn')
    end
  end

  describe 'UriHelper.format_uri' do
    it 'throw an exception if the parameter is not a valid url' do
      expect { UriHelper.format_uri('<:/:/:/') }.to raise_exception(URI::InvalidURIError)
    end

    it 'to add http by himself' do
      lzd_uri = URI.parse('http://www.lazada.com')
      expect(UriHelper.format_uri('www.lazada.com')).to eq(lzd_uri)
    end

    it 'can generate http uri' do
      expect(UriHelper.format_uri('http://www.lazada.com').hostname).to eq('www.lazada.com')
    end

    it 'can generate https uri' do
      expect(UriHelper.format_uri('https://www.lazada.com').hostname).to eq('www.lazada.com')
    end
  end

  describe 'UriHelper.check_url_response' do
    it 'call http.response' do
      lzd_uri = URI.parse('http://www.lazada.com')
      expect(Net::HTTP).to receive(:get_response).with(lzd_uri)
      UriHelper.check_url_response(lzd_uri)
    end

    it 'return moved uri' do
      lzd_uri                  = URI.parse('http://lazada.com')
      lzd_response             = Net::HTTPMovedPermanently.new('1.1', '301', 'Moved Permanently')
      lzd_response['location'] = 'http://www.lazada.com'
      lzd_expected_url         = URI.parse('http://www.lazada.com')
      allow(Net::HTTP).to receive(:get_response).and_return(lzd_response)
      expect(UriHelper.check_url_response(lzd_uri)).to eq(lzd_expected_url)
    end

    it 'throw error on bad http response' do
      lzd_uri      = URI.parse('http://www.lazada.com')
      lzd_response = Net::HTTPBadGateway.new('1.1', '501', 'Bad Gateway')
      allow(Net::HTTP).to receive(:get_response).and_return(lzd_response)
      expect { UriHelper.check_url_response(lzd_uri) }.to raise_exception(Net::HTTPError, "Wrong response from http://www.lazada.com: \nresponse code:501")
    end
  end
end
