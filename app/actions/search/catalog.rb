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
          service = 'catalog'
          query_terms = request.params[:query]

          service_response = service_response(query_terms:, service:)

          response.format = :json
          response.body = our_response(service_response:, query_terms:, service:)
        end

        def service_response(query_terms:, service:)
          uri = URI::HTTPS.build(host: "#{service}.princeton.edu", path: '/catalog.json',
                                 query: "q=#{query_terms}&search_field=all_fields&per_page=3")
          response = Net::HTTP.get(uri)
          JSON.parse(response, symbolize_names: true)
        end

        def documents(service_response:)
          service_response[:data]
        end

        def more_link(query_terms:, service:)
          URI::HTTPS.build(host: "#{service}.princeton.edu", path: '/catalog',
                           query: "q=#{query_terms}&search_field=all_fields")
        end

        def number(service_response:)
          service_response[:meta][:pages][:total_count]
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
