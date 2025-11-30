require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'validation' do
    it 'validate presence of original_url' do
      url = Url.new(original_url: nil)
      expect(url).not_to be_valid
      expect(url.errors[:original_url]).to include("can't be blank")
    end

    it 'validates URL format' do
      url = Url.new(original_url: 'wrong--url-format')
      expect(url).not_to be_valid
    end

    it 'accepts valid HTTP URLs' do
      url = Url.new(original_url: 'http://httpwebsite.com')
      expect(url).to be_valid
    end

    it 'accepts valid HTTPS URLs' do
      url = Url.new(original_url: 'https://httpswebsite.com/sample')
      expect(url).to be_valid
    end

    it 'validates uniqueness of code' do
      Url.create!(original_url: 'https://first.com', code: 'abc312')
      duplicate = Url.new(original_url: 'https://second.com', code: 'abc312')
      expect(duplicate).not_to be_valid
    end
  end

  describe '#generate_code' do
    it 'autogenerate a code of 6 chars for url on create' do
      url = Url.create!(original_url: 'https://example.com')
      expect(url.code).to be_present
      expect(url.code.length).to eq(6)
    end

    it 'generate unique codes for different URLs' do
      url1 = Url.create!(original_url: 'https://first.com')
      url2 = Url.create!(original_url: 'https://second.com')
      expect(url1.code).not_to eq(url2.code)
    end

    it 'use only alphanumberic chars' do
      url = Url.create!(original_url: 'https://first.com')
      expect(url.code).to match(/\A[0-9a-zA-Z]+\z/)
    end
  end

  describe '.find_or_create_by_url' do
    it 'create a new URL if it does not exist' do
      expect {
        Url.find_or_create_by_url('https://first.com')
      }.to change(Url, :count).by(1)
    end

    it 'return existing URL if the URL already exist' do
      existing_url = Url.create!(original_url: 'https://existing.com')

      expect {
        new_url = Url.find_or_create_by_url('https://existing.com')
        expect(new_url).to eq existing_url
      }.not_to change(Url, :count)
    end
  end
end
