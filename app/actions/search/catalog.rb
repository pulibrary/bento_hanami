# frozen_string_literal: true

require 'net/http'

module BentoHanami
  module Actions
    module Search
      class Catalog < BentoHanami::Action
        params do
          required(:query).filled(:string)
        end

        def handle(request, response)
          halt 422, { errors: request.params.errors }.to_json unless request.params.valid?

          query_terms = request.params[:query]
          catalog_response = catalog_response(query_terms:)
          response.format = :json
          response.body = our_response(catalog_response:, query_terms:)
        end

        def our_response(catalog_response:, query_terms:)
          {
            number: catalog_response[:meta][:pages][:total_count],
            more: more_link(query_terms:),
            records: parsed_records(documents: catalog_response[:data])
          }.to_json
        end

        def catalog_response(query_terms:)
          uri = URI::HTTPS.build(host: 'catalog.princeton.edu', path: '/catalog.json',
                                 query: "q=#{query_terms}&search_field=all_fields&per_page=3")
          response = Net::HTTP.get(uri)
          JSON.parse(response, symbolize_names: true)
        end

        def more_link(query_terms:)
          URI::HTTPS.build(host: 'catalog.princeton.edu', path: '/catalog',
                           query: "q=#{query_terms}&search_field=all_fields")
        end

        def parsed_records(documents:)
          documents.map do |document|
            doc_keys = [:title, :creator, :publisher, :id, :type, :description, :url, :other_fields]
            parsed_record(document:, doc_keys:)
          end
        end

        def parsed_record(document:, doc_keys:)
          doc_hash = {}
          # The method name must match the key name, and must take the keyword argument `document:`
          doc_keys.each do |key|
            val = send(key, document:)
            doc_hash[key] = val if val
          end
          doc_hash
        end

        def title(document:)
          document.dig(:attributes, :title)
        end

        def creator(document:)
          document.dig(:attributes, :author_display, :attributes, :value)&.first
        end

        def publisher(document:)
          document.dig(:attributes, :pub_created_display, :attributes, :value)&.first
        end

        def id(document:)
          # All documents should have an id, so it's ok to raise an error if it's not present
          document[:id]
        end

        def type(document:)
          document.dig(:attributes, :format, :attributes, :value)&.first
        end

        def description(document:)
          # tbd - nothing in the current json that seems relevant
        end

        def url(document:)
          # All documents should have a url, so it's ok to raise an error if it's not present
          document[:links][:self]
        end

        def other_fields(document:)
          doc_keys = [:call_number, :library]
          parsed_record(document:, doc_keys:)
        end

        def first_holding(document:)
          document.dig(:attributes, :holdings_1display, :attributes, :value)&.first&.last
        end

        def call_number(document:)
          first_holding(document:)&.dig(:call_number)
        end

        def library(document:)
          first_holding(document:)&.dig(:library)
        end
      end
    end
  end
end
