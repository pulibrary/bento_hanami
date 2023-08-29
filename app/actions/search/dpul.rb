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
          service = 'dpul'

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
