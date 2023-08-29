# auto_register: false
# frozen_string_literal: true

require "hanami/action"

module BentoHanami
  class Action < Hanami::Action
    def response_by_service(request:, response:, service:)
      halt 422, { errors: request.params.errors }.to_json unless request.params.valid?

      query_terms = request.params[:query]

      service_response = service_response(query_terms:, service:)

      response.format = :json
      response.body = our_response(service_response:, query_terms:, service:)
    end

    def our_response(service_response:, query_terms:, service:)
      {
        number: number(service_response:),
        more: more_link(query_terms:, service:),
        records: parsed_records(documents: documents(service_response:))
      }.to_json
    end

    def blacklight_service_response(query_terms:, service:)
      uri = URI::HTTPS.build(host: "#{service}.princeton.edu", path: '/catalog.json',
                             query: "q=#{query_terms}&search_field=all_fields&per_page=3")
      response = Net::HTTP.get(uri)
      JSON.parse(response, symbolize_names: true)
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
  end
end
