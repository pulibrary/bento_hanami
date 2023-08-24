# frozen_string_literal: true

require 'net/http'

module BentoHanami
  module Actions
    module Search
      class Catalog < BentoHanami::Action
        params do
          required(:query).value(:string)
        end

        def handle(request, response)
          # Need to handle this gracefully, see docs
          halt 422 unless request.params.valid?

          query_terms = request.params[:query]
          catalog_response = catalog_response(query_terms:)
          response.format = :json
          response.body = our_response(catalog_response:, query_terms:)
        end

        def our_response(catalog_response:, query_terms:)
          {
            number: catalog_response[:meta][:pages][:total_count],
            more: more_link(query_terms:),
            records: parsed_records(records: catalog_response[:data])
          }.to_json
        end

        def catalog_response(query_terms:)
          uri = URI("https://catalog.princeton.edu/catalog.json?q=#{query_terms}&search_field=all_fields")
          response = Net::HTTP.get(uri)
          JSON.parse(response, symbolize_names: true)
        end

        def more_link(query_terms:)
          "https://catalog.princeton.edu/catalog?q=#{query_terms}&search_field=all_fields"
        end

        def parsed_records(records:)
          records.map do |a_record|
            {
              title: a_record[:attributes][:title],
              publisher: a_record[:attributes][:pub_created_display][:attributes][:value].first,
              id: a_record[:id],
              type: a_record[:attributes][:format][:attributes][:value].first,
              url: a_record[:links][:self]
            }
          end
        end
      end
    end
  end
end
