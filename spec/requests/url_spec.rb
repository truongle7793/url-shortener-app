require 'rails_helper'

RSpec.describe "Urls", type: :request do
  describe "post /encode" do
    context 'with valid URL' do
      it 'returns status code 201 and creates shortened URL ' do
        post '/encode', params: { url: 'http://example.com/very/long/path' }

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)

        expect(json['original_url']).to eq('http://example.com/very/long/path')
        expect(json['code']).to be_present
        expect(json['short_url']).to include(json['code'])
      end

      it 'create an URL record in database' do
        expect {
          post '/encode', params: { url: 'http://example.com/very/long/path' }
        }.to change(Url, :count).by(1)
      end

      it 'return the same code for duplicate URL and create only one record' do
        post '/encode', params: { url: 'http://example.com/very/long/path' }
        first_code = JSON.parse(response.body)['code']

        post '/encode', params: { url: 'http://example.com/very/long/path' }
        second_code = JSON.parse(response.body)['code']

        expect(first_code).to eq(second_code)
      end
    end

    context 'with invalid URL' do
      it 'returns 400 when URL parameter is missing' do
        post '/encode', params: {}

        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body)
        expect(json['error']).to eq('URL parameter is required')
      end

      it 'returns 400 when URL parameter is empty' do
        post '/encode', params: { url: '' }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns 422 for wrong format URL' do
        post '/encode', params: { url: 'not-a-valid-url' }

        expect(response).to have_http_status(:unprocessable_content)
        json = JSON.parse(response.body)
        expect(json['error']).to be_present
      end
    end
  end

  describe "post /decode" do
    let!(:url) { Url.create!(original_url: 'http://example.com/very/long/path', code: "abc321") }

    context 'with valid code' do
      it 'return 200 status code with original URL' do
        post '/decode', params: { code: 'abc321' }

        expect(response).to have_http_status(:ok)
        json_data = JSON.parse(response.body)

        expect(json_data['original_url']).to eq('http://example.com/very/long/path')
        expect(json_data['code']).to eq('abc321')
      end

      it 'increase the counter by 1' do
        expect {
          post '/decode', params: { code: 'abc321' }
        }.to change { url.reload.access_count }.by(1)
      end
    end

    context 'with invalid code' do
      it 'return 404 if the code not exist' do
        post '/decode', params: { code: '123abc' }

        expect(response).to have_http_status(:not_found)
        json_data = JSON.parse(response.body)
        expect(json_data['error']).to eq("Url didn't get encoded yet")
      end
    end
  end

  describe 'Integration test' do
    it 'allows encoding and then decoding a URL' do
      # Encode
      post '/encode', params: { url: 'http://example.com/very/long/path/new' }
      expect(response).to have_http_status(:created)
      code = JSON.parse(response.body)['code']

      # Decode
      post '/decode', params: { code: code }
      expect(response).to have_http_status(:ok)
      original_url = JSON.parse(response.body)['original_url']

      expect(original_url).to eq('http://example.com/very/long/path/new')
    end
  end
end
