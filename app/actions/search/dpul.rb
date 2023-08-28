# frozen_string_literal: true

require 'net/http'

module BentoHanami
  module Actions
    module Search
      class Dpul < BentoHanami::Action
        params do
          required(:query).filled(:string)
        end

        def handle(request, response)
          halt 422, { errors: request.params.errors }.to_json unless request.params.valid?
          service = 'dpul'
          query_terms = request.params[:query]

          service_response = service_response(query_terms:, service:)

          response.format = :json
          response.body = our_response(service_response:, query_terms:, service:)
        end

        def documents(service_response:)
          service_response[:data]
        end

        def service_response(query_terms:, service:)
          uri = URI::HTTPS.build(host: "#{service}.princeton.edu", path: '/catalog.json',
                                 query: "q=#{query_terms}&search_field=all_fields&per_page=3")
          response = Net::HTTP.get(uri)
          JSON.parse(response, symbolize_names: true)
        end

        def more_link(query_terms:, service:)
          URI::HTTPS.build(host: "#{service}.princeton.edu", path: '/catalog',
                           query: "q=#{query_terms}&search_field=all_fields")
        end

        def number(service_response:)
          service_response[:meta][:pages][:total_count]
        end

        def title(document:)
          document.dig(:attributes, :readonly_title_ssim, :attributes, :value)
        end

        def creator(document:)
          document.dig(:attributes, :readonly_creator_ssim, :attributes, :value)
        end

        def publisher(document:)
          document.dig(:attributes, :readonly_publisher_ssim, :attributes, :value)
        end

        def id(document:)
          document[:id]
        end

        def type(document:)
          document.dig(:attributes, :readonly_format_ssim, :attributes, :value)
        end

        def description(document:)
          # tbd - nothing in the current json that seems relevant
        end

        def url(document:)
          document[:links][:self]
        end

        def other_fields(document:)
          doc_keys = [:collection]
          parsed_record(document:, doc_keys:)
        end

        def collection(document:)
          document.dig(:attributes, :readonly_collections_tesim, :attributes, :value)
        end
      end
    end
  end
end
