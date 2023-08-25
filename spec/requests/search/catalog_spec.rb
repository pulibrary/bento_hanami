# frozen_string_literal: true

RSpec.describe "GET /search/catalog", type: :request do
  it 'returns json' do
    get '/search/catalog?query=rubix'

    expect(last_response).to be_successful
    expect(last_response.content_type).to eq("application/json; charset=utf-8")
  end

  context 'given a search term' do
    let(:expected_response) do
      { number: 7,
        more: "https://catalog.princeton.edu/catalog?q=rubix&search_field=all_fields",
        records: [
          { title: "Rub'ix qatinamit = El canto del pueblo : Estudiantina del Instituto Indígena de Santiago " \
                   "/ [Oscar Azmitia, Manuel Salazar].",
            creator: "Azmitia, Oscar",
            publisher: "[Guatemala] : El Instituto, [199-]",
            id: "SCSB-11568989",
            type: "Book",
            url: "https://catalog.princeton.edu/catalog/SCSB-11568989",
            other_fields: {
              call_number: 'ML421.I55 A96 1990z',
              library: 'ReCAP'
            } }
        ] }
    end
    it 'can take a parameter' do
      get "/search/catalog?query=rubix"

      expect(last_response).to be_successful
      response_body = JSON.parse(last_response.body, symbolize_names: true)

      expect(response_body.keys).to match_array([:number, :more, :records])
      expect(response_body[:records].first.keys).to match_array([:title, :creator, :publisher, :id, :type, :url,
                                                                 :other_fields])
      expect(response_body[:records].first).to match(expected_response[:records].first)
    end

    it 'only returns the first three records' do
      get "/search/catalog?query=rubix"

      response_body = JSON.parse(last_response.body, symbolize_names: true)

      expect(response_body[:records].size).to eq(3)
    end
  end

  context 'without a search term' do
    it "returns a 422 unprocessable response" do
      get "/search/catalog?query="

      expect(last_response).to be_unprocessable

      response_body = JSON.parse(last_response.body, symbolize_names: true)

      expect(response_body).to eq(
        errors: {
          query: ["must be filled"]
        }
      )
    end
  end

  context 'without a publisher in records' do
    it 'does not raise the error NoMethodError' do
      get "/search/catalog?query=pangulubalang"

      expect(last_response).to be_successful
    end

    it 'does not include unused keys' do
      get "/search/catalog?query=pangulubalang"

      response_body = JSON.parse(last_response.body, symbolize_names: true)
      expect(response_body[:records].first.keys).to match_array([:title, :id, :type, :url, :other_fields])
    end
  end

  context 'with weird search strings' do
    it 'appropriately escapes the query' do
      get "/search/catalog?query=What if \"I quote\" my search?"

      expect(last_response).to be_successful
      response_body = JSON.parse(last_response.body, symbolize_names: true)
      expect(response_body[:records]).to be_empty
      expect(response_body[:more]).to eq("https://catalog.princeton.edu/catalog?q=What%20if%20%22I%20quote%22%20my%20search?&search_field=all_fields")
    end
  end
end
