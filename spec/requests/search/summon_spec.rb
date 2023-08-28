# frozen_string_literal: true

RSpec.describe "GET /search/summon", type: :request do
  let(:response_body) { JSON.parse(last_response.body, symbolize_names: true) }
  let(:search_path) { "/search/summon?query=#{query}" }

  context 'searching for rubix' do
    let(:query) { 'rubix' }
    it 'returns json' do
      pending("Figuring out Summon authentication with Gem")

      get search_path

      expect(last_response).to be_successful
      expect(last_response.content_type).to eq("application/json; charset=utf-8")
    end

    it 'can take a parameter' do
      pending("Figuring out Summon authentication with Gem")

      get search_path

      expect(last_response).to be_successful
      expect(response_body.keys).to match_array([:number, :more, :records])
      expect(response_body[:number]).to eq(414)
      # expect(response_body[:records].first.keys).to match_array([:title, :creator, :publisher, :id, :type, :url,
      #  :other_fields])
      # expect(response_body[:records].first).to match(expected_response[:records].first)
    end
  end

  context 'searching for pangulubalang' do
    let(:query) { 'pangulubalang' }

    it 'has the correct metadata' do
      pending("Figuring out Summon authentication with Gem")

      get search_path
      expect(response_body.keys).to match_array([:number, :more, :records])
      expect(response_body[:number]).to eq(13)
    end
  end
end
