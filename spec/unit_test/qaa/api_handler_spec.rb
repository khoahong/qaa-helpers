require 'spec_helper'

describe APIHandler do
  before (:all) do
    api_base_url ||= {
        staging: {
            id: 'http://10.34.17.10:2379/v2/keys/lazada_api/id/staging',
            my: 'http://10.18.21.40:2379/v2/keys/lazada_api/my/staging',
            ph: 'http://10.18.23.31:2379/v2/keys/lazada_api/ph/staging',
            sg: 'http://10.18.21.16:2379/v2/keys/lazada_api/sg/staging',
            th: 'http://10.18.24.10:2379/v2/keys/lazada_api/th/staging',
            vn: 'http://10.18.20.10:2379/v2/keys/lazada_api/vn/staging'
        },

        live: {
            id: 'http://10.34.25.106:2379/v2/keys/lazada_api/id/live',
            my: 'http://10.18.16.73:2379/v2/keys/lazada_api/my/live',
            ph: 'http://10.2.16.69:2379/v2/keys/lazada_api/ph/live',
            sg: 'http://10.18.16.26:2379/v2/keys/lazada_api/sg/live',
            th: 'http://10.18.18.81:2379/v2/keys/lazada_api/th/live',
            vn: 'http://10.18.16.65:2379/v2/keys/lazada_api/vn/live'
        }
    }
    VENTURE = [:id, :ph, :sg, :th, :vn, :my].sample
    ENVIRONMENT = [:staging, :live].sample
    APIHandler.api_base_url = api_base_url[ENVIRONMENT][VENTURE]
    @ask_api_question = APIHandler.new('ask_api', 'v1', 'question')
    @ask_api_product_info = APIHandler.new('ask_api', 'v1', 'product_info')
    @ask_api_report = APIHandler.new('ask_api', 'v1', 'question')
    @ask_api_answer = APIHandler.new('ask_api', 'v1', 'answer')
    @review_api_approve = APIHandler.new('review_api', 'v3', 'approve')
    @review_api = APIHandler.new('review_api', 'v3', 'reviews')
    @verify_message = "#{VENTURE.to_s}lzd#{ENVIRONMENT==:staging ? 'stg' : 'live'}"
  end

  it 'get method' do
    expect((@ask_api_question.api_get({}).uri).inspect).to include @verify_message
    expect((@ask_api_product_info.api_get({}).uri).to_s).to include @verify_message
    expect((@ask_api_report.api_get({}).uri).to_s).to include @verify_message
    expect((@ask_api_answer.api_get({}).uri).to_s).to include @verify_message
    expect((@review_api_approve.api_get({}).uri).to_s).to include @verify_message
    expect((@review_api.api_get({}).uri).to_s).to include @verify_message
  end

  it 'put method' do
    expect((@ask_api_question.api_put({}).uri).to_s).to include @verify_message
    expect((@ask_api_product_info.api_put({}).uri).to_s).to include @verify_message
    expect((@ask_api_report.api_put({}).uri).to_s).to include @verify_message
    expect((@ask_api_answer.api_put({}).uri).to_s).to include @verify_message
    expect((@review_api_approve.api_put({}).uri).to_s).to include @verify_message
    expect((@review_api.api_put({}).uri).to_s).to include @verify_message
  end

  it 'post method' do
    expect((@ask_api_question.api_post({}).uri).to_s).to include @verify_message
    expect((@ask_api_product_info.api_post({}).uri).to_s).to include @verify_message
    expect((@ask_api_report.api_post({}).uri).to_s).to include @verify_message
    expect((@ask_api_answer.api_post({}).uri).to_s).to include @verify_message
    expect((@review_api_approve.api_post({}).uri).to_s).to include @verify_message
    expect((@review_api.api_post({}).uri).to_s).to include @verify_message
  end

  it 'delete method' do
    expect((@ask_api_question.api_delete({}).uri).to_s).to include @verify_message
    expect((@ask_api_product_info.api_delete({}).uri).to_s).to include @verify_message
    expect((@ask_api_report.api_delete({}).uri).to_s).to include @verify_message
    expect((@ask_api_answer.api_delete({}).uri).to_s).to include @verify_message
    expect((@review_api_approve.api_delete({}).uri).to_s).to include @verify_message
    expect((@review_api.api_delete({}).uri).to_s).to include @verify_message
  end
end