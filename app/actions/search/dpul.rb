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

          query_terms = request.params[:query]

          dpul_response = dpul_response(query_terms:)

          response.format = :json
          response.body = our_response(dpul_response:, query_terms:)
        end

        def our_response(dpul_response:, query_terms:)
          {
            number: dpul_response[:meta][:pages][:total_count],
            more: more_link(query_terms:),
            records: parsed_records(documents: dpul_response[:data])
          }.to_json
        end

        def dpul_response(query_terms:)
          uri = URI::HTTPS.build(host: 'dpul.princeton.edu', path: '/catalog.json',
                                 query: "q=#{query_terms}&search_field=all_fields&per_page=3")
          response = Net::HTTP.get(uri)
          JSON.parse(response, symbolize_names: true)
        end

        def more_link(query_terms:)
          URI::HTTPS.build(host: 'dpul.princeton.edu', path: '/catalog',
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
