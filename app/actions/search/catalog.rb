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
          service = 'catalog'

          response_by_service(request:, response:, service:)
        end

        def service_response(query_terms:, service:)
          blacklight_service_response(query_terms:, service:)
        end

        # Same for Blacklight apps
        def documents(service_response:)
          service_response[:data]
        end

        # Same for Princeton Blacklight apps
        def more_link(query_terms:, service:)
          URI::HTTPS.build(host: "#{service}.princeton.edu", path: '/catalog',
                           query: "q=#{query_terms}&search_field=all_fields")
        end

        # Same for Blacklight apps
        def number(service_response:)
          service_response[:meta][:pages][:total_count]
        end

        # Same for Blacklight apps
        def url(document:)
          # All documents should have a url, so it's ok to raise an error if it's not present
          document[:links][:self]
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
