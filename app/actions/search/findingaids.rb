# frozen_string_literal: true

require 'net/http'

module BentoHanami
  module Actions
    module Search
      # aka pulfa or pulfalight
      class Findingaids < BentoHanami::Action
        params do
          required(:query).filled(:string)
        end

        def handle(request, response)
          service = 'findingaids'

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

        # Use the collection name as the title?
        def title(document:)
          document.dig(:attributes, :collection_ssm, :attributes, :value)
        end

        def creator(document:)
          document.dig(:attributes, :creator_ssm, :attributes, :value)
        end

        # No sensible field to map to this currently
        def publisher(document:)
          # tbd - nothing in the current json that seems relevant
        end

        # Same for Blacklight apps
        def id(document:)
          # All documents should have an id, so it's ok to raise an error if it's not present
          document[:id]
        end

        def type(document:)
          document[:type]
        end

        # This field may contain html
        def description(document:)
          document.dig(:attributes, :scopecontent_ssm, :attributes, :value)
        end

        def other_fields(document:)
          doc_keys = [:repository, :extent, :access_restriction]
          parsed_record(document:, doc_keys:)
        end

        def repository(document:)
          document.dig(:attributes, :repository_ssm, :attributes, :value)
        end

        def extent(document:)
          document.dig(:attributes, :extent_ssm, :attributes, :value)
        end

        def access_restriction(document:)
          document.dig(:attributes, :accessrestrict_ssm, :attributes, :value)
        end
      end
    end
  end
end
