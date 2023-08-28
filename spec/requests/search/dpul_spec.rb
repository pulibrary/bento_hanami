# frozen_string_literal: true

RSpec.describe "GET /search/dpul", type: :request do
  it 'returns json' do
    get '/search/dpul?query=cats'

    expect(last_response).to be_successful
    expect(last_response.content_type).to eq("application/json; charset=utf-8")
  end

  context 'given a search term' do
    let(:expected_response) do
      { number: 238,
        more: "https://dpul.princeton.edu/catalog?q=cats&search_field=all_fields",
        records: [
          { title: "Robinson Crusoe, The clever cats, &c. : a picture-book for the nursery " \
                   "; containing sixteen coloured illustrations",
            creator: "Defoe, Daniel, 1661?-1731",
            publisher: "London ; Edinburgh ; New York : Thomas Nelson & Sons, [not after 1888]",
            id: "02578b4e2ccf4497f1426a3ab7e11464",
            type: "Book",
            url: "https://dpul.princeton.edu/catalog/9w032853n",
            other_fields: {
              collection: 'Lloyd E. Cotsen'
            } }
        ] }
    end
    it 'can take a parameter' do
      get "/search/dpul?query=cats"

      expect(last_response).to be_successful
      response_body = JSON.parse(last_response.body, symbolize_names: true)

      expect(response_body.keys).to match_array([:number, :more, :records])
      expect(response_body[:number]).to eq(expected_response[:number])
      expect(response_body[:records].first.keys).to match_array([:title, :creator, :publisher, :id, :type, :url,
                                                                 :other_fields])
      expect(response_body[:records].first).to match(expected_response[:records].first)
    end

    it 'only returns the first three records' do
      get "/search/dpul?query=cats"

      response_body = JSON.parse(last_response.body, symbolize_names: true)

      expect(response_body[:records].size).to eq(3)
    end
  end

  context 'without a search term' do
    it "returns a 422 unprocessable response" do
      get "/search/dpul?query="

      expect(last_response).to be_unprocessable

      response_body = JSON.parse(last_response.body, symbolize_names: true)

      expect(response_body).to eq(
        errors: {
          query: ["must be filled"]
        }
      )
    end
  end
end
