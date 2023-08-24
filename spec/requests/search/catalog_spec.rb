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
            publisher: "[Guatemala] : El Instituto, [199-]",
            id: "SCSB-11568989",
            type: "Book",
            url: "https://catalog.princeton.edu/catalog/SCSB-11568989" }
        ] }
    end
    it 'can take a parameter' do
      get "/search/catalog?query=rubix"

      expect(last_response).to be_successful
      response_body = JSON.parse(last_response.body, symbolize_names: true)

      expect(response_body.keys).to match_array(%i[number more records])
      expect(response_body[:records].first).to match(expected_response[:records].first)
    end
  end
end
